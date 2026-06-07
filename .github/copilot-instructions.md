# Dutch App — Copilot Project Guide

A Flutter (Dart) app for learning Dutch vocabulary with spaced repetition, exercises,
word collections and an offline-first local database. Use this guide for architecture,
conventions and code style when generating or modifying code.

> Companion file: [Widget Catalog](./widgets.md). Before building any UI, consult it and
> **reuse existing widgets instead of creating new ones**.
>
> Companion file: [Adding a New Learning Mode](./adding-learning-mode.md). Follow it end-to-end
> when adding a new exercise/learning mode (enums, DB regeneration, scheduling, unlock, summary).

---

## Architecture

The codebase is organised in clear layers under `lib/`. Respect the dependency direction:
`pages` → `domain` → `core`. Lower layers must never import from higher layers.

| Layer | Path | Responsibility |
| --- | --- | --- |
| **Core** | `lib/core/` | Infrastructure only: local DB (Isar), repositories, entity mapping, seeding, HTTP clients, file IO, audio. No UI, no business rules. |
| **Domain** | `lib/domain/` | Business logic: `services/`, plain `models/`, `converters/`, `functions/`, `types/` (enums), and `notifiers/` (ChangeNotifier state). |
| **Pages** | `lib/pages/` | Feature UI. One folder per feature (e.g. `learning_session/`, `word_editor/`, `word_collections/`, `settings/`). Page-local widgets live next to their page. |
| **Reusable Widgets** | `lib/reusable_widgets/` | Cross-feature, presentation-only widgets. See the Widget Catalog. |
| **Styles** | `lib/styles/` | Centralised theming via static classes (`ContainerStyles`, `TextStyles`, `BorderStyles`, `ButtonStyles`, `IconStyles`, `BaseStyles`). |

### Key concepts

- **Repositories** (`lib/core/local_db/repositories/`) wrap Isar access. DB `entities/`
  (prefixed `Db*`) are mapped to/from domain `models/` via `mapping/`. UI and services
  work with domain models, never with `Db*` entities directly.
- **Services** (`lib/domain/services/`) hold all non-trivial logic — spaced repetition,
  exercise unlocking, batch operations, session state, settings persistence, etc.
- **Notifiers** (`lib/domain/notifiers/`) are `ChangeNotifier`s used for cross-widget
  events/state. Fire and read them through the helpers in
  `lib/domain/notifiers/notifier_tools.dart` rather than calling `Provider.of` inline.

### Dependency injection

DI uses the `provider` package. Each layer exposes provider lists from a
`dependency_injections.dart` file (`databaseProviders()`, `serviceProviders()`,
`notifierProviders()`, `coordinatorProviders()`). These are composed in a `MultiProvider`
in `lib/main.dart`. When you add a service/repository/notifier, register it in the
appropriate `dependency_injections.dart` and resolve dependencies with `context.read<T>()`.

---

## Widgets vs. business logic — keep them separate

This is a core rule of the project:

- **Widgets must be small, focused and presentation-only.** They lay out UI, wire up
  callbacks, and read styles. They should contain little or no logic.
- **Complex processing belongs in services** (or notifiers / repositories), not inside
  `build()` methods or widget state. If a widget starts computing, transforming, sorting,
  validating or persisting data, extract that into a `Service` in `lib/domain/services/`
  and inject it.
- A widget should be understandable at a glance: inputs in, layout out, events delegated.
- Stateful widgets manage only **UI state** (selection, controllers, animation). Domain
  state lives in services and notifiers.

When asked to add a feature, decide first: what is presentation (a widget) and what is
behaviour (a service). Build the service, test it, then build a thin widget on top.

---

## Code style & conventions

- Follows `flutter_lints` (see `analysis_options.yaml`). Keep code lint-clean.
- **Async methods are suffixed `Async`** (e.g. `getSettingsAsync`, `seedAsync`).
- **Wrapper widgets are prefixed `My`** when they wrap a Material widget to apply app
  defaults (`MyAppBar`, `MyCheckbox`, `MyBottomAppBarItem`).
- Generic, reusable widgets use type parameters (`GenericDropdownMenu<T>`,
  `OptionalToggleButtons<T>`).
- **Never hardcode colors, paddings, borders or text styles.** Always pull them from the
  `lib/styles/` classes, e.g. `ContainerStyles.sectionColor(context)`,
  `ContainerStyles.defaultPaddingAmount`, `BorderStyles.defaultBorderRadius`. Colors are
  context-/theme-aware via `BaseStyles.getColorScheme(context)`.
- Use `const` constructors wherever possible.
- Prefer named parameters; mark required ones `required`.
- Keep imports as `package:dutch_app/...` (absolute), not relative, in `lib/`.
- Feature pages use named routes registered in `lib/main.dart` (`/settings`,
  `/wordeditor`, `/wordcollections`, `/exerciseselector`, `/home`).

---

## Testing

Two tiers, both run from the terminal:

- **Unit tests** — `test/`. Run with `flutter test`. Used for services and pure logic.
  `mockito` is available and used here to mock **repositories/dependencies at the
  boundary** so a service's logic can be exercised in isolation.
- **Integration tests** — `integration_test/`. Run on a real target, e.g.
  `flutter test integration_test/all_tests.dart -d windows`. On Windows a second app
  process cannot be launched mid-run, so all IT files are aggregated and run through
  `integration_test/all_tests.dart`.

### Testing philosophy — mimic actions, don't mock results

- **Tests exercise full flows, not isolated stubs.** Prefer tests that drive the real
  behaviour end-to-end: real Isar DB (opened in a temp dir per test, torn down after),
  real widget tree, real navigation, real services.
- **Mimic the user's / system's actions rather than mocking their results.** Instead of
  stubbing a service to return a canned value, perform the actual sequence of steps
  (tap, enter text, save, navigate) and assert on the real outcome. For example, the
  create-verb flow actually creates a word, navigates to the list, edits it and verifies
  persistence — it does not fake any step.
- Reserve mocking for true external boundaries that are impractical to run for real
  (e.g. network in a unit test). Within the app's own layers, run the real thing.
- When adding behaviour, add/extend a flow test that walks through it the way a user
  would.

---

## When adding features

1. Check the [Widget Catalog](./widgets.md) and **reuse existing widgets**.
2. Put logic in a service (`lib/domain/services/`); keep the widget thin.
3. Register new services/repositories/notifiers in the relevant
   `dependency_injections.dart`.
4. Use `lib/styles/` for all styling.
5. Add unit tests for the service and a flow-style test for the behaviour.
6. If you create a new reusable widget, **add it to [widgets.md](./widgets.md)**.
