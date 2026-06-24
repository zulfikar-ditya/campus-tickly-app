import { TaskCategoryEnum } from "@database";

export type TaskList = {
	id: string;
	title: string;
	category: TaskCategoryEnum;
	description: string | null;
	start_at: Date;
	end_at: Date;
	email_reminder: boolean;
	is_done: boolean;
	created_at: Date;
	updated_at: Date;
};

export type TaskDetail = TaskList;

export type TaskCreate = {
	title: string;
	category: TaskCategoryEnum;
	description?: string | null;
	start_at: Date;
	end_at: Date;
	email_reminder?: boolean;
};

export type TaskUpdate = TaskCreate & {
	is_done?: boolean;
};
