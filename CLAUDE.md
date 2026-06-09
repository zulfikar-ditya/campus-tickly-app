# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

**Tickly** (`campus_tickly`) — a simple task / to-do app built with Flutter. The repo is currently a fresh Flutter starter (`lib/main.dart` is still the default counter template); the app is being built from scratch against the design in `docs/design.jpg`.

## Commands

```bash
flutter pub get                          # install deps (run after editing pubspec.yaml)
flutter run                              # run on a connected device/emulator
flutter analyze                          # static analysis / lint (rules in analysis_options.yaml)
dart format .                            # format code
flutter test                             # run all tests
flutter test test/widget_test.dart       # run a single test file
flutter test --name "substring"          # run tests whose name matches
```

Dart SDK constraint: `^3.12.1` (see `pubspec.yaml`). Lints come from `package:flutter_lints`.

## Design spec (`docs/design.jpg`)

The design is the source of truth for screens and behavior. It is a very large image — to view it, downscale a copy first (e.g. with `System.Drawing` in PowerShell) since the raw file exceeds the image reader's pixel limit. Key points:

- **Light and dark mode** are both designed; support both.
- **Primary color** is a red/pink accent; surfaces are white (light) / near-black navy (dark).
- **Screens:** Sign in ("Welcome back"), Create account, Forgot password, Reset password, Task list (home), Create Task, Edit Task, Filters.
- **Home / task list:** greeting + "today's progress" bar (`X of Y completed`, %), search field, a horizontal week date strip, a "Today" list of task rows (checkbox, title, category tag, time), and a FAB to add a task. Includes empty and success-toast states.
- **Create/Edit Task fields:** title, category, start/end date, start/end time, description, and an "email reminder" toggle.
- **Categories** seen in the design: Work, Meeting, Backend, Personal.
- **Filters:** by status, category, and date range (Today / Yesterday / Last 7 days) with a calendar picker.

When implementing, match the design rather than inventing new layouts or flows.

## Agent skills

Reusable skills live in `.agents/skills/` and are exposed to Claude Code via `.claude/skills` (a directory junction → `.agents/skills`). `skills-lock.json` tracks installed skill versions. Edit skills in `.agents/skills/`, not through the junction.
