# Adding a New Learning Mode (Exercise Type)

Step-by-step guide for adding a new learning/exercise mode end-to-end. Follow the existing
modes as templates (FlipCard, De/Het, Write, ManyToMany). File references point at the real
implementations to copy from.

---

## The two-enum model (understand this first)

There are **two** enums with different jobs:

- `ExerciseType` (`lib/domain/types/exercise_type.dart`) — the **user-facing mode** shown as a
  button on the selector. Has `label`, `explanation`, and a `detailedTypes` mapping.
- `ExerciseTypeDetailed` (`lib/domain/types/exercise_type_detailed.dart`) — a **tracked variant**
  that gets its own spaced-repetition schedule and unlock record in the DB. Only modes that need
  independent scheduling/unlocking need one (e.g. `manyToMany` and the plural modes currently have
  **no** detailed type and are not individually scheduled).

**Decide up front:** does the mode need its own SM-2 schedule and unlock gating?
- **Yes** → it needs an `ExerciseTypeDetailed` (Steps 5 and 6 apply).
- **No** (transient practice-only) → skip the detailed type, Steps 5–6 don't apply.

---

## Step 1 — Define the mode enum(s)

In `lib/domain/types/exercise_type.dart`:
- Add a value to `enum ExerciseType`.
- Add a `case` to `label` and `explanation` (these `switch`es are exhaustive — the compiler forces it).
- Add a `case` to `detailedTypes` (return `[]` if untracked, or `[ExerciseTypeDetailed.yourType]` if tracked).

If tracked, in `lib/domain/types/exercise_type_detailed.dart`:
- Add the value to `enum ExerciseTypeDetailed` **at the end** (see Step 2), plus its `label`/`explanation` cases.

---

## Step 2 — DB & regenerating `.g` files

The only DB collection involved is `DbWordProgress` (`lib/core/local_db/entities/db_word_progress.dart`).
It stores progress per `(word, exerciseType)` where `exerciseType` is `@enumerated ExerciseTypeDetailed`.

**You do not edit the entity** to add a mode — only add an enum value. Two critical rules:

1. `@enumerated` serialises by **enum index**, so you must **append** new `ExerciseTypeDetailed` values
   to the end. Reordering or inserting in the middle silently corrupts existing rows.
2. Regenerate the Isar code afterwards. The command (see comments in `lib/main.dart`) is:

   ```
   flutter pub run build_runner build
   ```

   Add `--delete-conflicting-outputs` if it complains about existing outputs. This regenerates
   `db_word_progress.g.dart` and the other `*.g.dart` files.

If the mode needs **new per-word data** (e.g. a plural form), that goes on the word entities
(`DbWord` / `DbWordNounDetails` / `DbWordVerbDetails`), which **is** a real schema change requiring
the same regeneration.

---

## Step 3 — The exercise class + widget

Templates: `lib/pages/learning_session/exercises/flip_card/flip_card_exercise.dart` and
`.../de_het/de_het_pick_exercise.dart`.

Create `lib/pages/learning_session/exercises/<mode>/<mode>_exercise.dart` extending `BaseExercise`
(`lib/pages/learning_session/base/base_exercise.dart`):

- `static const int requiredWords` and `static const ExerciseType type`.
- `static bool isSupportedWord(Word word)` — **the eligibility rule** for the mode (e.g. De/Het requires
  a noun with a de/het article).
- `processAnswer(...)` — updates `answerSummary` (the `ExerciseAnswerSummary` correct/wrong counters).
- `isAnswered()`.
- `generateSummaries()` — returns `ExerciseSummaryDetailed`
  (`.../exercises/shared/exercise_summary_detailed.dart`) carrying `exerciseType` (set `ankiGrade` if
  the mode supports Anki mode).
- `buildWidget(...)` — returns the widget.

Then `<mode>_exercise_widget.dart`, modelled on `flip_card_exercise_widget.dart`: **presentation only**,
manages UI state, calls `widget.exercise.processAnswer(...)`, then `notifyAnsweredExercise(context, true)`
and `await widget.onNextButtonPressed()`. Keep all logic in the exercise class, not the widget.

For modes consuming **multiple words per card**, copy the chunking pattern in
`generateManyToManyExcercises` / `_calculateChunkQuantities` in `exercises_generator.dart`.

---

## Step 4 — Wire into the generator

In `lib/pages/learning_session/exercises/exercises_generator.dart`:
- Add a `generate<Mode>Excercises()` method that returns `[]` if `!exerciseTypes.contains(ExerciseType.yourMode)`,
  filters `words` by `isSupportedWord`, and (if tracked) also by `_isUnlocked(w.id, ExerciseTypeDetailed.yourType)`.
- Add the call into the list in `generateExcercises()`.

---

## Step 5 — Spaced repetition / progress mapping (tracked modes)

**Easy to miss.** In `lib/pages/learning_session/word_progress_service.dart`,
`_mapToDetailedExerciseType` maps `ExerciseType → ExerciseTypeDetailed` and **throws on `default`**.
If the mode is tracked, add its `case` here, otherwise sessions using it crash in `processSessionResults`.
This mapping is what makes the SM-2 logic in `_applySessionOutcome` (easiness factor, interval,
`nextReviewDate`, streaks) run against the right progress record. The SM-2 math in
`spaced_repetition_algorithm.dart` needs no change.

---

## Step 6 — Unlock ordering (gated modes only)

If the detailed type should unlock only after a streak on a prerequisite, add an entry to `triggers`
in `lib/domain/models/exercise_type_order.dart` (use `null` for "always available"). This feeds
`ExerciseUnlockService` (`lib/domain/services/exercise_unlock_service.dart`) and the generator's
`unlockedTypesById`; newly-unlocked types then appear in the session summary.

---

## Step 7 — Auto / quick session eligibility

For the mode to join the automatic daily session and quick practice:
- Add a `case` in `_isSupportedByType` in `lib/domain/services/quick_practice_service.dart`
  (currently-unsupported modes return `false` there).
- Add the type to a quota preset in `lib/domain/models/exercise_mode_quota.dart` (e.g.
  `flipCardAndWriting`) if it should be auto-selected. The quota drives proportional word selection
  and derives `activeDetailedTypes` from `detailedTypes`. Due words are pulled per detailed type via
  `getDueProgressAsync` in `word_progress_batch_repository.dart`.

---

## Step 8 — The mode button (automatic)

The selector (`lib/pages/exercises_selector/exercises_selector_page.dart`) builds its list from
`ExerciseType.values`. **Adding the enum value plus `label`/`explanation` makes the button appear** —
no extra UI work.

---

## Step 9 — Exercise summary (mostly automatic)

`SessionSummary._buildSummariesPerExercise` (`lib/pages/learning_session/summary/session_summary.dart`)
groups `ExerciseSummaryDetailed`s by `exerciseType`, so the mode automatically gets its own
`SingleExerciseTypeSummary` card (words/mistakes/success-rate via `exercise_total_cards_builder.dart`)
as long as `generateSummaries()` stamps the right type. Only touch `_flipCardGroup` to visually merge
the mode with another.

---

## Step 10 — Tests

Per the project's testing philosophy (drive real flows, don't mock results):
- Unit-test `isSupportedWord` and `processAnswer` / summary generation of the exercise class.
- Add/extend a flow test (see `test/session/` and `integration_test/all_tests.dart`) that actually runs
  a session with the new mode against a real temp Isar DB and asserts progress/scheduling/summary.

---

## Checklist / easy-to-miss items

- [ ] **Append-only `ExerciseTypeDetailed`** — never reorder; it's `@enumerated` by index.
- [ ] **Run `build_runner`** after enum/entity changes.
- [ ] **`_mapToDetailedExerciseType` `default: throw`** — add the case or sessions crash (tracked modes).
- [ ] **`_isSupportedByType`** in quick practice returns `false` by default — add the case or the mode never
      appears in auto sessions.
- [ ] Exercises are plain classes — **no DI registration** needed; but a supporting `Service` must be
      registered in the relevant `dependency_injections.dart`.
- [ ] Decide **tracked vs. untracked** early — it determines whether Steps 5 and 6 apply.
- [ ] `word_progress_service.dart` has a known `//todo rewrite with proper ex type` rough edge in the
      type mapping — keep additions consistent with the current pattern.
