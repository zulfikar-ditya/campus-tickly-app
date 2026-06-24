import { relations } from "drizzle-orm";
import {
	boolean,
	index,
	pgEnum,
	pgTable,
	text,
	timestamp,
	uuid,
	varchar,
} from "drizzle-orm/pg-core";

import { users } from "./user";

// Define enum values — mirrors the Flutter app's TaskCategory enum.
export const taskCategoryEnum = pgEnum("task_category", [
	"work",
	"meeting",
	"backend",
	"personal",
]);

// Export enum object for Typebox
export const TaskCategory = {
	WORK: "work",
	MEETING: "meeting",
	BACKEND: "backend",
	PERSONAL: "personal",
} as const;

// Export type
export type TaskCategoryEnum = (typeof TaskCategory)[keyof typeof TaskCategory];

export const tasks = pgTable(
	"tasks",
	{
		id: uuid().primaryKey().defaultRandom(),
		user_id: uuid()
			.notNull()
			.references(() => users.id, { onDelete: "cascade" }),
		title: varchar({ length: 255 }).notNull(),
		category: taskCategoryEnum().default("personal").notNull(),
		description: text(),
		start_at: timestamp().notNull(),
		end_at: timestamp().notNull(),
		email_reminder: boolean().default(false).notNull(),
		is_done: boolean().default(false).notNull(),
		deleted_at: timestamp(),
		created_at: timestamp().defaultNow().notNull(),
		updated_at: timestamp()
			.defaultNow()
			.$onUpdate(() => new Date())
			.notNull(),
	},
	(table) => [
		index("tasks_user_id_deleted_at_index").on(table.user_id, table.deleted_at),
		index("tasks_user_id_start_at_index").on(table.user_id, table.start_at),
	],
);

export const tasksRelations = relations(tasks, ({ one }) => ({
	user: one(users, {
		fields: [tasks.user_id],
		references: [users.id],
	}),
}));
