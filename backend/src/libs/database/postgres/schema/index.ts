import {
	emailVerifications,
	emailVerificationsRelations,
} from "./email-verification";
import {
	passwordResetTokenRelations,
	passwordResetTokens,
} from "./password-reset-token";
import {
	permissions,
	permissionsRelations,
	rolePermissionRelations,
	rolePermissions,
	roles,
	rolesRelations,
	userRoleRelations,
	userRoles,
} from "./rbac";
import { tasks, tasksRelations } from "./task";
import { users, usersRelations } from "./user";

export * from "./email-verification";
export * from "./password-reset-token";
export * from "./rbac";
export * from "./task";
export * from "./user";

export const schema = {
	// Tables
	users,
	roles,
	permissions,
	rolePermissions,
	userRoles,
	emailVerifications,
	passwordResetTokens,
	tasks,

	// Relations
	usersRelations,
	rolesRelations,
	permissionsRelations,
	rolePermissionRelations,
	userRoleRelations,
	emailVerificationsRelations,
	passwordResetTokenRelations,
	tasksRelations,
};
