# Tickly — Frontend Slicing TODO

Slicing the design (`docs/design.jpg`) into a Flutter **frontend-only** app.
Bottom-up: **foundation → atoms → molecules → organisms → screens → states**.
No backend / persistence yet — use in-memory mock data and dummy navigation.

Light **and** dark mode are both designed → every widget must be theme-driven (no hardcoded colors).

---

## 0. Project setup & foundation ✅

- [x] Replace default `lib/main.dart` counter template with `TicklyApp` root (`lib/app.dart`)
- [x] Folder structure in place:
  - `lib/theme/` — `app_palette`, `app_colors` (ThemeExtension), `app_spacing`, `app_typography`, `app_theme`
  - `lib/models/` — `Task`, `TaskCategory`
  - `lib/mock/` — `mock_tasks.dart`
  - `lib/routing/` — `app_routes.dart` (route name constants)
  - `lib/widgets/` — _(to add as components are built)_
  - `lib/features/<auth|tasks|filters>/` — _(to add as screens are built)_
- [x] Temporary `FoundationPreview` home (swap for SignIn later)
- [ ] Wire named routes into `MaterialApp` (deferred until screens exist; constants ready in `app_routes.dart`)
- [ ] `pubspec.yaml`: add fonts only if needed (currently using default Roboto)

### Theme ✅ (done first — everything depends on it)
- [x] Color tokens sampled from design — accent `#F43F5E` (rose-500), slate neutrals, dark bg slate-900/800, success emerald, error red; semantic `AppColors` for light + dark via `context.colors`
- [x] `ThemeData` for light + dark (color scheme, text theme, input decoration, filled/text buttons, FAB, switch, divider)
- [x] Typography scale (`AppTypography.textTheme`)
- [x] Spacing / radius constants (`AppSpacing`, `AppRadius`)

> Verified: `flutter analyze` clean, smoke test passes. Run `flutter run` to eyeball light/dark via `FoundationPreview`.

---

## 1. Atoms (smallest reusable widgets) ✅

- [x] **AppLogo** (`app_logo.dart`) — rounded red square w/ check icon + "Tickly" wordmark
- [x] **PrimaryButton** (`primary_button.dart`) — full-width filled red button; normal / disabled / loading
- [x] **TextLink** (`text_link.dart`) — inline red tappable text
- [x] **AppTextField** (`app_text_field.dart`) — label (+required `*`) + bordered input, leading icon, trailing widget, multiline, inline error
- [x] **PasswordField** (`password_field.dart`) — AppTextField w/ obscure eye toggle
- [x] **AppAvatar** (`app_avatar.dart`) — circle with user initial (tinted bg)
- [x] **AppCheckbox** (`app_checkbox.dart`) — circular (checked = filled red w/ check, unchecked = outline)
- [x] **CategoryTag** (`category_tag.dart`) — colored dot + label pill per category
- [x] **SelectableChip** (`selectable_chip.dart`) — pill, selected vs unselected (Filters)
- [x] **AppSwitch** (`app_switch.dart`) — labeled toggle row ("Email reminder")
- [x] **AppProgressBar** (`app_progress_bar.dart`) — rounded determinate bar (overridable colors for the red card)

---

## 2. Molecules ✅

- [x] **SearchField** (`search_field.dart`) — rounded search input w/ magnifier icon
- [x] **FilterIconButton** (`filter_icon_button.dart`) — primary square button beside search
- [x] **PickerField** (`picker_field.dart`) — shared read-only tappable field (label/icon/value/trailing/error); base for date/time/category
- [x] **DateField / TimeField** (`date_time_fields.dart`) — calendar/clock icon + formatted value
- [x] **CategoryDropdown** (`category_dropdown.dart`) — "Select category" → bottom-sheet picker
- [x] **DateCell** (`date_cell.dart`) — week-strip day cell; default / selected (filled red)
- [x] **SectionHeader** (`section_header.dart`) — title + right-aligned count
- [x] **FieldLabel** (`field_label.dart`) — label + optional required `*` (shared by fields)
- [x] **AuthFooter** (`auth_footer.dart`) — centered prompt + link
- [x] **Formatters** (`utils/formatters.dart`) — `formatDate`, `weekdayLabel`, `formatClock`
- [ ] **DescriptionField** — _not a separate widget; use `AppTextField(maxLines: 4)`_

> Verified: `flutter analyze` clean, smoke test passes. All atoms/molecules are exercised in `FoundationPreview` (component gallery) — run `flutter run` to view in light/dark.

---

## 3. Organisms ✅

- [x] **ProgressCard** (`progress_card.dart`) — red gradient card: "Today's progress", "X of Y completed", big %, white progress bar; handles 0 of 0 / 0%
- [x] **WeekDateStrip** (`week_date_strip.dart`) — horizontal DateCell row; `WeekDateStrip.week()` helper builds 7 days
- [x] **TaskCard** (`task_card.dart`) — checkbox + title + CategoryTag + time + edit/delete; completed style (strikethrough, muted)
- [x] **TaskList** (`task_list.dart`) — vertical list of TaskCard with per-task toggle/edit/delete callbacks
- [x] **EmptyState** (`empty_state.dart`) — tinted icon badge + dashed skeleton placeholder rows (custom dashed-border painter)
- [x] **AppToast** (`app_toast.dart`) — `AppToast.success` / `AppToast.error` floating snackbars
- [x] **ErrorBanner** (`error_banner.dart`) — inline tinted form banner
- [x] **AppFab** (`app_fab.dart`) — floating "+" add-task button
- [x] **AppCalendar** (`app_calendar.dart`) — month grid w/ selected day + highlighted range band + month nav
- [x] **FiltersSheet** (`filters_sheet.dart`) — `showFiltersSheet()` modal: handle, title + Reset, Date chips, calendar, Type chips, "Show results"; returns `FilterSelection`

> Filters: design sheet shows **Date** + **Type** sections (matched). `FilterSelection` model (`models/filter_selection.dart`) holds dateRange + customDate + category. Status filter (mentioned in CLAUDE.md) is **not** in the design sheet, so omitted — revisit if needed.
>
> Verified: `flutter analyze` clean, smoke test passes. All organisms exercised in `FoundationPreview`.

---

## 4. Screens — Auth

- [ ] **SignIn ("Welcome back")** — logo, title, subtitle, email, password (eye), "Forgot password?", Sign In button, footer → Create account
- [ ] **CreateAccount** — Full name, Email, Password, Confirm password, Sign Up, footer → Sign in
- [ ] **ForgotPassword** — back button, title, subtitle, email, "Send reset link", footer → Back to sign in
- [ ] **ResetPassword** — back button, title, subtitle, New password, Confirm password, "Save new password", footer

---

## 5. Screens — Tasks

- [ ] **Home / Task List** — greeting ("Good morning" + name) + Avatar, ProgressCard, SearchField + FilterIconButton, WeekDateStrip, SectionHeader, TaskList, FAB
  - [ ] populated state (mock tasks)
  - [ ] empty state (0 of 0, EmptyState placeholder)
  - [ ] success toast state (after creating a task)
  - [ ] checkbox toggle updates progress card
- [ ] **Create Task** — back, Title, CategoryDropdown, Start/End DateField, Start/End TimeField, DescriptionField, Email reminder AppSwitch, "Create Task" button
  - [ ] validation error state (ErrorBanner + inline field errors + "required" / "End date must be after start date" + error toast)
- [ ] **Edit Task** — same layout prefilled with task data, "Save changes" button

---

## 6. Screens — Filters

- [ ] **Filters** — present FiltersSheet as modal bottom sheet from Home filter button
  - [ ] status filter, category filter, date-range chips + calendar custom range
  - [ ] Reset clears selections; Show results closes sheet & filters list

---

## 7. Polish & verification

- [ ] Verify both light & dark themes match design on every screen
- [ ] Wire up navigation between all screens
- [ ] Consistent spacing/radius/typography pass vs design
- [ ] `flutter analyze` clean
- [ ] `dart format .`
- [ ] Basic widget tests for key components (optional)

---

### Categories & their colors (from design)
`Work`, `Meeting`, `Backend`, `Personal` — each rendered as a distinct colored CategoryTag.

### Notes
- Status bar mock (9:41 + icons) is just the device frame in the design — use the real device status bar.
- Frontend only: dates/times via native pickers, tasks held in memory, no API calls.
