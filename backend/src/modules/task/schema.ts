import { TaskCategory } from "@database";
import { t } from "elysia";

export const TaskCategorySchema = t.Enum(TaskCategory);

export const TaskItemSchema = t.Object({
	id: t.String({ format: "uuid", description: "Task unique identifier" }),
	title: t.String({
		description: "Task title",
		examples: ["Finish the design review"],
	}),
	category: t.Enum(TaskCategory, {
		description: "Task category",
		examples: ["work"],
	}),
	description: t.Nullable(
		t.String({
			description: "Optional task description",
			examples: ["Review the latest Figma export with the team"],
		}),
	),
	start_at: t.Date({ description: "Task start date and time" }),
	end_at: t.Date({ description: "Task end date and time" }),
	email_reminder: t.Boolean({
		description: "Whether an email reminder is scheduled at the start time",
		examples: [true],
	}),
	is_done: t.Boolean({
		description: "Whether the task is completed",
		examples: [false],
	}),
	created_at: t.Date({ description: "Creation date" }),
	updated_at: t.Date({ description: "Last update date" }),
});

export const TaskCreateSchema = t.Object({
	title: t.String({
		minLength: 1,
		maxLength: 255,
		description: "Task title",
		examples: ["Finish the design review"],
	}),
	category: t.Enum(TaskCategory, {
		description: "Task category",
		examples: ["work"],
	}),
	description: t.Optional(
		t.Nullable(
			t.String({
				description: "Optional task description",
				examples: ["Review the latest Figma export with the team"],
			}),
		),
	),
	start_at: t.Date({
		description: "Task start date and time (ISO 8601)",
		examples: ["2026-06-24T09:00:00.000Z"],
	}),
	end_at: t.Date({
		description: "Task end date and time (ISO 8601)",
		examples: ["2026-06-24T10:00:00.000Z"],
	}),
	email_reminder: t.Optional(
		t.Boolean({
			default: false,
			description: "Schedule an email reminder at the start time",
			examples: [true],
		}),
	),
});

export const TaskUpdateSchema = t.Object({
	title: t.String({
		minLength: 1,
		maxLength: 255,
		description: "Task title",
		examples: ["Finish the design review"],
	}),
	category: t.Enum(TaskCategory, {
		description: "Task category",
		examples: ["work"],
	}),
	description: t.Optional(
		t.Nullable(
			t.String({
				description: "Optional task description",
				examples: ["Review the latest Figma export with the team"],
			}),
		),
	),
	start_at: t.Date({
		description: "Task start date and time (ISO 8601)",
		examples: ["2026-06-24T09:00:00.000Z"],
	}),
	end_at: t.Date({
		description: "Task end date and time (ISO 8601)",
		examples: ["2026-06-24T10:00:00.000Z"],
	}),
	email_reminder: t.Optional(
		t.Boolean({
			default: false,
			description: "Schedule an email reminder at the start time",
			examples: [true],
		}),
	),
	is_done: t.Optional(
		t.Boolean({
			description: "Whether the task is completed",
			examples: [false],
		}),
	),
});

export const TaskToggleSchema = t.Object({
	is_done: t.Boolean({
		description: "New completion state for the task",
		examples: [true],
	}),
});

export const TaskListQuerySchema = t.Object({
	page: t.Optional(
		t.Number({ default: 1, description: "Page number (1-based)" }),
	),
	perPage: t.Optional(t.Number({ default: 10, description: "Items per page" })),
	search: t.Optional(
		t.String({ description: "Search by task title", examples: ["review"] }),
	),
	sort: t.Optional(
		t.String({
			default: "start_at",
			description:
				"Sort column: start_at, end_at, title, category, is_done, created_at, updated_at",
		}),
	),
	sortDirection: t.Optional(
		t.Union([t.Literal("asc"), t.Literal("desc")], {
			default: "asc",
			description: "Sort direction",
		}),
	),
	category: t.Optional(
		t.Enum(TaskCategory, {
			description: "Filter by category",
			examples: ["work"],
		}),
	),
	is_done: t.Optional(
		t.Boolean({ description: "Filter by completion state", examples: [false] }),
	),
	date_from: t.Optional(
		t.Date({
			description: "Filter tasks starting on/after this date-time (ISO 8601)",
			examples: ["2026-06-24T00:00:00.000Z"],
		}),
	),
	date_to: t.Optional(
		t.Date({
			description: "Filter tasks starting on/before this date-time (ISO 8601)",
			examples: ["2026-06-24T23:59:59.000Z"],
		}),
	),
});
