# Tickly

A simple, good-looking task / to-do app built with **Flutter**, supporting
**light and dark mode**. Tickly is a frontend-only app right now — tasks live
in memory (no backend), so it's a clean starting point for wiring up real auth
and storage later.

## Design Figma
> [Figma](https://www.figma.com/design/0RHKf9rnC2E3UewGewrmRY/Cakyu---Tickly?node-id=0-1&t=HXl42D19lVIKX9AO-1)

## Features

- **Authentication screens** — Sign in, Create account, Forgot password, Reset
  password (form validation only; no real auth yet).
- **Home / task list** — greeting + daily progress card (`X of Y completed`,
  %), search, a centered week date strip, and today's tasks with category tags
  and times.
- **Create / Edit task** — title, category, start/end date, start/end time,
  description, and an email-reminder toggle, with inline validation.
- **Filters** — bottom sheet to filter by category and date range
  (Today / Yesterday / Last 7 days / Custom date via a calendar).
- **Light & dark theme** that follows the system setting.

> The design lives in `docs/design.jpg` and is the source of truth for screens
> and behavior.

## Requirements

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `^3.12.1`)
- A device or emulator (Android / iOS), or Chrome / desktop for web/desktop.

Verify your setup:

```bash
flutter doctor
```

## Getting started

```bash
# 1. Install dependencies
flutter pub get

# 2. Run on a connected device / emulator
flutter run
```

To pick a specific target:

```bash
flutter devices          # list available devices
flutter run -d chrome    # run in the browser
flutter run -d windows   # run as a desktop app
```

## Using the app

1. **Sign in** on the "Welcome back" screen (any valid-looking email + a
   password of 6+ characters passes validation), or tap **Sign up** to create
   an account. Both lead to the home screen.
2. On **Home**, you'll see today's progress and tasks. Tap a task's checkbox to
   mark it done — the progress bar updates live.
3. Use the **week strip** to switch days; the selected day stays centered.
4. Tap the **search** field to filter tasks by title. Tap anywhere outside an
   input to dismiss the keyboard.
5. Tap the **filter button** (next to search) to open Filters. Choose a
   category and/or date range, then **Show results**. The dashboard date
   follows your selection. **Reset** clears the filters.
6. Tap the **+ button** to create a task. Fill in the details and tap
   **Create Task**. Use the **edit** / **delete** icons on a task row to modify
   or remove it.

## Common commands

```bash
flutter pub get                     # install deps (after editing pubspec.yaml)
flutter run                         # run on a connected device/emulator
flutter analyze                     # static analysis / lint
dart format .                       # format code
flutter test                        # run all tests
flutter test test/home_test.dart    # run a single test file
```

## Project structure

```
lib/
  main.dart            # entry point
  app.dart             # MaterialApp: themes, routes, global tap-to-unfocus
  theme/               # palette, semantic colors (light/dark), spacing, typography
  models/              # Task, TaskCategory, FilterSelection
  mock/                # in-memory sample tasks
  routing/             # named route constants
  utils/               # formatters, validators
  widgets/             # reusable UI: buttons, fields, chips, task card, calendar, etc.
  features/
    auth/              # sign in, create account, forgot/reset password
    tasks/             # home screen, create/edit task form
  foundation_preview.dart  # dev-only component gallery (not routed)

test/                  # widget tests (auth flow, home, smoke)
docs/design.jpg        # design spec (source of truth)
```

## Notes

- **Frontend only:** there is no backend or persistence — tasks reset on
  restart. Auth screens validate input but don't authenticate.
- Theming is token-driven via an `AppColors` theme extension; read colors with
  `context.colors` so both light and dark modes stay consistent.
