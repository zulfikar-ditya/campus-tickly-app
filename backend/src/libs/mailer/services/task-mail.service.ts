import { sendEmailQueue } from "@bull";
import { getCurrentLocale } from "@i18n";
import { TaskDetail } from "@types";
import { DateToolkit, log } from "@utils";
import dayjs from "dayjs";

// Deterministic job id so a task only ever has one pending reminder; updating or
// deleting the task can cancel/replace it without tracking the id in the DB.
// NB: BullMQ forbids ":" in custom job ids, so use a "-" separator.
const reminderJobId = (taskId: string) => `task-reminder-${taskId}`;

export class TaskMailService {
	/**
	 * Remove any pending reminder email scheduled for a task. Safe to call when
	 * none exists (BullMQ silently ignores unknown job ids).
	 */
	async cancelReminder(taskId: string): Promise<void> {
		try {
			await sendEmailQueue.remove(reminderJobId(taskId));
		} catch (error) {
			log.warn(error, `Failed to cancel reminder for task ${taskId}`);
		}
	}

	/**
	 * Re-sync a task's reminder email: always cancel the existing one, then
	 * schedule a fresh delayed job when the task still wants a future reminder.
	 */
	async syncReminder(task: TaskDetail, recipientEmail: string): Promise<void> {
		await this.cancelReminder(task.id);

		const shouldSchedule =
			task.email_reminder && !task.is_done && task.start_at > new Date();

		if (!shouldSchedule) {
			return;
		}

		const delay = Math.max(0, task.start_at.getTime() - Date.now());
		const lang = getCurrentLocale();

		await sendEmailQueue.add(
			"task-reminder",
			{
				subject: `Reminder: ${task.title}`,
				to: recipientEmail,
				template: "tasks/task-reminder",
				lang,
				variables: {
					task_title: task.title,
					task_category: task.category,
					task_start: DateToolkit.getDateTimeInformative(dayjs(task.start_at)),
					task_end: DateToolkit.getDateTimeInformative(dayjs(task.end_at)),
					task_description: task.description ?? "",
				},
			},
			{
				jobId: reminderJobId(task.id),
				delay,
				removeOnComplete: true,
				attempts: 3,
				backoff: { type: "exponential", delay: 2000 },
			},
		);

		log.info(
			{ taskId: task.id, email: recipientEmail, delay },
			"Task reminder email scheduled",
		);
	}
}
