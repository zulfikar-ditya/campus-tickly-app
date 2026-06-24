import { db, DbTransaction, TaskCategoryEnum, tasks } from "@database";
import { defaultSort } from "@default";
import {
	DatatableType,
	PaginationResponse,
	SortDirection,
	TaskCreate,
	TaskDetail,
	TaskList,
	TaskUpdate,
} from "@types";
import { and, asc, desc, eq, gte, ilike, isNull, lte, SQL } from "drizzle-orm";
import { NotFoundError } from "elysia";

const taskColumns = {
	id: true,
	title: true,
	category: true,
	description: true,
	start_at: true,
	end_at: true,
	email_reminder: true,
	is_done: true,
	created_at: true,
	updated_at: true,
} as const;

export const TaskRepository = () => {
	const dbInstance = db;

	return {
		db: dbInstance,
		getDb: (tx?: DbTransaction) => tx || dbInstance,

		findAll: async (
			userId: string,
			queryParam: DatatableType,
			tx?: DbTransaction,
		): Promise<PaginationResponse<TaskList>> => {
			const database = tx || dbInstance;

			const page: number = queryParam.page || 1;
			const limit: number = queryParam.perPage || 10;
			const search: string | null = queryParam.search || null;
			const orderBy: string = queryParam.sort ? queryParam.sort : defaultSort;
			const orderDirection: SortDirection = queryParam.sortDirection
				? queryParam.sortDirection
				: "desc";
			const filter: Record<string, boolean | string | Date> | null =
				queryParam.filter || null;
			const offset = (page - 1) * limit;

			// Tasks are always scoped to the owning user and exclude soft-deleted rows.
			let whereCondition: SQL | undefined = and(
				eq(tasks.user_id, userId),
				isNull(tasks.deleted_at),
			);

			if (search) {
				whereCondition = and(whereCondition, ilike(tasks.title, `%${search}%`));
			}

			if (filter) {
				if (filter.category) {
					whereCondition = and(
						whereCondition,
						eq(tasks.category, filter.category as TaskCategoryEnum),
					);
				}

				if (typeof filter.is_done === "boolean") {
					whereCondition = and(
						whereCondition,
						eq(tasks.is_done, filter.is_done),
					);
				}

				// Date-range filters apply to the task's start time.
				if (filter.date_from instanceof Date) {
					whereCondition = and(
						whereCondition,
						gte(tasks.start_at, filter.date_from),
					);
				}

				if (filter.date_to instanceof Date) {
					whereCondition = and(
						whereCondition,
						lte(tasks.start_at, filter.date_to),
					);
				}
			}

			const validateOrderBy = {
				id: tasks.id,
				title: tasks.title,
				category: tasks.category,
				start_at: tasks.start_at,
				end_at: tasks.end_at,
				is_done: tasks.is_done,
				created_at: tasks.created_at,
				updated_at: tasks.updated_at,
			};

			type OrderableKey = keyof typeof validateOrderBy;
			const normalizedOrderBy: OrderableKey = (
				Object.keys(validateOrderBy) as OrderableKey[]
			).includes(orderBy as OrderableKey)
				? (orderBy as OrderableKey)
				: "start_at";

			const orderColumn = validateOrderBy[normalizedOrderBy];

			const [data, totalCount] = await Promise.all([
				database.query.tasks.findMany({
					where: whereCondition,
					orderBy:
						orderDirection === "asc" ? asc(orderColumn) : desc(orderColumn),
					limit,
					offset,
					columns: taskColumns,
				}),
				database.$count(tasks, whereCondition),
			]);

			return {
				data,
				meta: {
					page,
					limit,
					totalCount,
				},
			};
		},

		create: async (
			userId: string,
			data: TaskCreate,
			tx?: DbTransaction,
		): Promise<TaskDetail> => {
			const database = tx || dbInstance;

			const inserted = await database
				.insert(tasks)
				.values({
					user_id: userId,
					title: data.title,
					category: data.category,
					description: data.description ?? null,
					start_at: data.start_at,
					end_at: data.end_at,
					email_reminder: data.email_reminder ?? false,
				})
				.returning();

			const task = inserted[0];
			if (!task) {
				throw new NotFoundError("Failed to create task");
			}

			return {
				id: task.id,
				title: task.title,
				category: task.category,
				description: task.description,
				start_at: task.start_at,
				end_at: task.end_at,
				email_reminder: task.email_reminder,
				is_done: task.is_done,
				created_at: task.created_at,
				updated_at: task.updated_at,
			};
		},

		getDetail: async (
			userId: string,
			taskId: string,
			tx?: DbTransaction,
		): Promise<TaskDetail> => {
			const database = tx || dbInstance;
			const task = await database.query.tasks.findFirst({
				where: and(
					eq(tasks.id, taskId),
					eq(tasks.user_id, userId),
					isNull(tasks.deleted_at),
				),
				columns: taskColumns,
			});

			if (!task) {
				throw new NotFoundError("Task not found");
			}

			return task;
		},

		update: async (
			userId: string,
			taskId: string,
			data: TaskUpdate,
			tx?: DbTransaction,
		): Promise<TaskDetail> => {
			const database = tx || dbInstance;

			const existing = await database.query.tasks.findFirst({
				where: and(
					eq(tasks.id, taskId),
					eq(tasks.user_id, userId),
					isNull(tasks.deleted_at),
				),
			});

			if (!existing) {
				throw new NotFoundError("Task not found");
			}

			await database
				.update(tasks)
				.set({
					title: data.title,
					category: data.category,
					description: data.description ?? null,
					start_at: data.start_at,
					end_at: data.end_at,
					email_reminder: data.email_reminder ?? false,
					is_done: data.is_done ?? existing.is_done,
				})
				.where(and(eq(tasks.id, taskId), eq(tasks.user_id, userId)));

			return await TaskRepository().getDetail(userId, taskId, tx);
		},

		setDone: async (
			userId: string,
			taskId: string,
			isDone: boolean,
			tx?: DbTransaction,
		): Promise<TaskDetail> => {
			const database = tx || dbInstance;

			const existing = await database.query.tasks.findFirst({
				where: and(
					eq(tasks.id, taskId),
					eq(tasks.user_id, userId),
					isNull(tasks.deleted_at),
				),
			});

			if (!existing) {
				throw new NotFoundError("Task not found");
			}

			await database
				.update(tasks)
				.set({ is_done: isDone })
				.where(and(eq(tasks.id, taskId), eq(tasks.user_id, userId)));

			return await TaskRepository().getDetail(userId, taskId, tx);
		},

		delete: async (
			userId: string,
			taskId: string,
			tx?: DbTransaction,
		): Promise<void> => {
			const database = tx || dbInstance;

			const existing = await database.query.tasks.findFirst({
				where: and(
					eq(tasks.id, taskId),
					eq(tasks.user_id, userId),
					isNull(tasks.deleted_at),
				),
			});

			if (!existing) {
				throw new NotFoundError("Task not found");
			}

			await database
				.update(tasks)
				.set({ deleted_at: new Date() })
				.where(and(eq(tasks.id, taskId), eq(tasks.user_id, userId)));
		},
	};
};
