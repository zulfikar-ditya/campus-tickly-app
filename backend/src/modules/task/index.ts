import { AuthPlugin } from "@plugins";
import { DatatableType } from "@types";
import {
	commonPaginatedResponse,
	commonResponse,
	ResponseToolkit,
} from "@utils";
import Elysia, { t } from "elysia";

import {
	TaskCreateSchema,
	TaskItemSchema,
	TaskListQuerySchema,
	TaskToggleSchema,
	TaskUpdateSchema,
} from "./schema";
import { TaskService } from "./service";

export const TaskModule = new Elysia({
	prefix: "/tasks",
	detail: {
		tags: ["Tasks"],
		description:
			"APIs for managing the authenticated user's tasks. Every task is scoped to its owner.",
	},
})
	.use(AuthPlugin)

	// ============================================
	// LIST TASKS
	// ============================================
	.get(
		"",
		async ({ query, user }) => {
			const filter: Record<string, boolean | string | Date> = {};
			if (query.category) filter.category = query.category;
			if (typeof query.is_done === "boolean") filter.is_done = query.is_done;
			if (query.date_from) filter.date_from = query.date_from;
			if (query.date_to) filter.date_to = query.date_to;

			const queryParam: DatatableType = {
				page: query.page ?? 1,
				perPage: query.perPage ?? 10,
				search: query.search,
				sort: query.sort ?? "start_at",
				sortDirection: query.sortDirection ?? "desc",
				filter: Object.keys(filter).length > 0 ? filter : undefined,
			};

			const result = await TaskService.findAll(user.id, queryParam);

			return ResponseToolkit.success(
				result,
				"Tasks retrieved successfully",
				200,
			);
		},
		{
			query: TaskListQuerySchema,
			detail: {
				summary: "List tasks",
				description:
					"Retrieve the authenticated user's tasks. Supports search (title) and filters: category, is_done, date_from, date_to (against start time), plus page/perPage/sort/sortDirection.",
			},
			response: commonPaginatedResponse(TaskItemSchema, {
				include: [200, 400, 401, 500],
			}),
		},
	)

	// ============================================
	// CREATE TASK
	// ============================================
	.post(
		"",
		async ({ body, user, set }) => {
			const task = await TaskService.create(user.id, user.email, body);

			set.status = 201;
			return ResponseToolkit.created(task, "Task created successfully");
		},
		{
			body: TaskCreateSchema,
			detail: {
				summary: "Create a task",
				description:
					"Create a task for the authenticated user. When email_reminder is enabled and the start time is in the future, a reminder email is scheduled.",
			},
			response: commonResponse(TaskItemSchema, {
				include: [201, 400, 401, 422, 500],
			}),
		},
	)

	// ============================================
	// GET TASK DETAIL
	// ============================================
	.get(
		"/:id",
		async ({ params, user }) => {
			const task = await TaskService.findOne(user.id, params.id);

			return ResponseToolkit.success(task, "Task retrieved successfully", 200);
		},
		{
			params: t.Object({ id: t.String({ format: "uuid" }) }),
			detail: {
				summary: "Get task details",
				description: "Retrieve a single task owned by the authenticated user.",
			},
			response: commonResponse(TaskItemSchema, {
				include: [200, 401, 404, 500],
			}),
		},
	)

	// ============================================
	// UPDATE TASK
	// ============================================
	.patch(
		"/:id",
		async ({ params, body, user }) => {
			const task = await TaskService.update(
				user.id,
				user.email,
				params.id,
				body,
			);

			return ResponseToolkit.success(task, "Task updated successfully", 200);
		},
		{
			params: t.Object({ id: t.String({ format: "uuid" }) }),
			body: TaskUpdateSchema,
			detail: {
				summary: "Update a task",
				description:
					"Update a task owned by the authenticated user. The email reminder is rescheduled to match the new start time and settings.",
			},
			response: commonResponse(TaskItemSchema, {
				include: [200, 400, 401, 404, 422, 500],
			}),
		},
	)

	// ============================================
	// TOGGLE COMPLETION
	// ============================================
	.patch(
		"/:id/complete",
		async ({ params, body, user }) => {
			const task = await TaskService.setDone(
				user.id,
				user.email,
				params.id,
				body.is_done,
			);

			return ResponseToolkit.success(
				task,
				"Task completion updated successfully",
				200,
			);
		},
		{
			params: t.Object({ id: t.String({ format: "uuid" }) }),
			body: TaskToggleSchema,
			detail: {
				summary: "Toggle task completion",
				description:
					"Mark a task as completed or re-open it. Completing a task cancels its pending reminder.",
			},
			response: commonResponse(TaskItemSchema, {
				include: [200, 400, 401, 404, 500],
			}),
		},
	)

	// ============================================
	// DELETE TASK
	// ============================================
	.delete(
		"/:id",
		async ({ params, user }) => {
			await TaskService.remove(user.id, params.id);

			return ResponseToolkit.success(null, "Task deleted successfully", 200);
		},
		{
			params: t.Object({ id: t.String({ format: "uuid" }) }),
			detail: {
				summary: "Delete a task",
				description:
					"Soft-delete a task owned by the authenticated user and cancel any pending reminder.",
			},
			response: commonResponse(t.Null(), {
				include: [200, 401, 404, 500],
			}),
		},
	);
