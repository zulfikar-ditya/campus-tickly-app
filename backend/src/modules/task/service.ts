import { BadRequestError } from "@errors";
import { TaskMailService } from "@mailer";
import { TaskRepository } from "@repositories";
import {
	DatatableType,
	PaginationResponse,
	TaskCreate,
	TaskDetail,
	TaskList,
	TaskUpdate,
} from "@types";

const taskMailService = new TaskMailService();

const ensureValidDateRange = (start: Date, end: Date): void => {
	if (end.getTime() < start.getTime()) {
		throw new BadRequestError("Validation error", [
			{
				field: "end_at",
				message: "End date must be after start date",
			},
		]);
	}
};

export const TaskService = {
	findAll: async (
		userId: string,
		queryParam: DatatableType,
	): Promise<PaginationResponse<TaskList>> => {
		return await TaskRepository().findAll(userId, queryParam);
	},

	findOne: async (userId: string, id: string): Promise<TaskDetail> => {
		return await TaskRepository().getDetail(userId, id);
	},

	create: async (
		userId: string,
		userEmail: string,
		data: TaskCreate,
	): Promise<TaskDetail> => {
		ensureValidDateRange(data.start_at, data.end_at);

		const task = await TaskRepository().create(userId, data);
		await taskMailService.syncReminder(task, userEmail);

		return task;
	},

	update: async (
		userId: string,
		userEmail: string,
		id: string,
		data: TaskUpdate,
	): Promise<TaskDetail> => {
		ensureValidDateRange(data.start_at, data.end_at);

		const task = await TaskRepository().update(userId, id, data);
		await taskMailService.syncReminder(task, userEmail);

		return task;
	},

	setDone: async (
		userId: string,
		userEmail: string,
		id: string,
		isDone: boolean,
	): Promise<TaskDetail> => {
		const task = await TaskRepository().setDone(userId, id, isDone);
		// Completing a task cancels its reminder; re-opening reschedules it.
		await taskMailService.syncReminder(task, userEmail);

		return task;
	},

	remove: async (userId: string, id: string): Promise<void> => {
		// Verify ownership before cancelling the reminder, then soft-delete.
		await TaskRepository().getDetail(userId, id);
		await taskMailService.cancelReminder(id);
		await TaskRepository().delete(userId, id);
	},
};
