CREATE TYPE "public"."task_category" AS ENUM('work', 'meeting', 'backend', 'personal');--> statement-breakpoint
CREATE TABLE "tasks" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"title" varchar(255) NOT NULL,
	"category" "task_category" DEFAULT 'personal' NOT NULL,
	"description" text,
	"start_at" timestamp NOT NULL,
	"end_at" timestamp NOT NULL,
	"email_reminder" boolean DEFAULT false NOT NULL,
	"is_done" boolean DEFAULT false NOT NULL,
	"deleted_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "tasks" ADD CONSTRAINT "tasks_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "tasks_user_id_deleted_at_index" ON "tasks" USING btree ("user_id","deleted_at");--> statement-breakpoint
CREATE INDEX "tasks_user_id_start_at_index" ON "tasks" USING btree ("user_id","start_at");