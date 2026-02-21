# DutchFlutterApp

Dutch vocabulary trainer with local storage, word collections, and practice sessions.

## Features
- Word editor with part-of-speech aware tabs (noun/verb forms, metadata).
- Online translation/grammar search to prefill word details.
- Collections list with search, multi-select actions, and word details/editing.
- Import/export collections and words as JSON files.
- Practice sessions with selectable exercise modes and session summaries.
- Spaced-repetition progress tracking per word/exercise.
- Settings for theme and session behavior.

## Layers
- UI: `lib/pages`, `lib/reusable_widgets`, `lib/styles`
- Domain: `lib/domain` (models, types, services, notifiers)
- Data: `lib/core` (local DB, repositories, IO import/export)

## Design patterns
- Provider + ChangeNotifier for state and DI (`MultiProvider`, notifiers).
- Repository pattern for persistence and IO boundaries.
- Service layer for session flow, spaced repetition, and batch operations.
- Feature-based modules under `lib/pages` (editor, collections, sessions).

## Reusability
- Shared UI pieces in `lib/reusable_widgets` and `lib/styles`.
- Common dialogs and list row widgets reused across collections workflows.
