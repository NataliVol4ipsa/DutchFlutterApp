# Widget Catalog

Reference of reusable, presentation-only widgets in `lib/reusable_widgets/`. **Reuse these
before creating new widgets.** They are theme-aware (they read from `lib/styles/`), small
and contained — keep business logic out of them.

> **Maintenance rule:** Whenever you add a new reusable widget to `lib/reusable_widgets/`,
> add a row for it in this file. Keep this catalog in sync with the codebase.

---

## App structure / chrome

| Widget | File | Purpose |
| --- | --- | --- |
| `MyAppBar` | `my_app_bar_widget.dart` | Themed `AppBar` (implements `PreferredSizeWidget`). Auto-appends a settings button (suppress with `disableSettingsButton`). Use as every page's app bar. |
| `SectionContainer` | `section_container_widget.dart` | Themed `Container` for grouping content into a rounded "section" card. Full width by default; accepts padding/margin/decoration overrides. |
| `LayeredBottom` | `layered_bottom_widget.dart` | Bottom overlay panel that covers what's beneath it and shows `contentBuilder` content (e.g. action bars over a scroll view). |

## Bottom app bar

| Widget | File | Purpose |
| --- | --- | --- |
| `MyBottomAppBarItem` | `bottom_app_bar/my_bottom_app_bar_item_widget.dart` | A single icon+label tappable item for a bottom app bar, with enabled/disabled icon + color states. |
| `MoreActionsBottomAppBar` | `bottom_app_bar/more_actions_bottom_app_bar_widget.dart` | A "More" item that opens a `MenuAnchor` popup of extra actions. Pass `actions`; supports enable/disable and vertical offset. |

## Inputs & form controls

| Widget | File | Purpose |
| --- | --- | --- |
| `MyCheckbox` | `my_checkbox.dart` | Compact (20×20) themed `Checkbox` wrapper exposing the full Checkbox API. |
| `InputLabel` | `input_label.dart` | Italic field label with optional red `*` required marker and trailing colon. Use above form inputs. |
| `InputIcons` | `input_icons.dart` | Static catalog of `IconData` for word fields (collection, dutchWord, englishWord, wordType, synonyms, verb tenses, etc.). Use these for consistent field icons. |
| `OptionalToggleButtons<T>` | `optional_toggle_buttons.dart` | Single-select toggle button group where the selected item can be **deselected** (returns `null`). Build items with `ToggleButtonItem<T>`. |
| `ToggleButtonItem<T>` | `models/toggle_button_item.dart` | Model (`label` + `value`) for `OptionalToggleButtons`. |

## Dropdowns

| Widget | File | Purpose |
| --- | --- | --- |
| `GenericDropdownMenu<T>` | `dropdowns/generic_dropdown_menu.dart` | Generic themed dropdown. Provide `dropdownValues`, `displayStringFunc`, `onValueChanged`; optional prefix icon, arrow color and per-option color generator. Base for the specialised dropdowns below. |
| `WordCollectionDropdown` | `dropdowns/word_collection_dropdown.dart` | Dropdown of word collections (loads + sorts collections, honours permissions). Use when picking a collection. |
| `WordTypeDropdown` | `dropdowns/word_type_dropdown.dart` | Dropdown of `PartOfSpeech` word types, greying the `unspecified` option. |

## Modals / dialogs

| Widget | File | Purpose |
| --- | --- | --- |
| `ConfirmationModal` | `modals/confirmation_modal_widget.dart` | `AlertDialog` with title/description and confirm/cancel actions. `onConfirmPressed` is async. Use for destructive or confirm-required actions. |
| `TextInputModal` | `modals/text_input_modal_widget.dart` | `AlertDialog` prompting for a single text value with optional validation + error message. `onConfirmPressed(context, input)` is async. Use for rename/create-by-name flows. |

## Feedback

| Widget / helper | File | Purpose |
| --- | --- | --- |
| `SnackbarShower` | `snackbar_shower.dart` | Construct with a `BuildContext`, then call `show(message)` to display a snackbar. Captures the `ScaffoldMessenger` up front so it can be shown after async gaps. |

---

## Related (not in `reusable_widgets/` but commonly reused)

| Widget | File | Purpose |
| --- | --- | --- |
| `FormTextInput` | `pages/word_editor/inputs/generic/form_text_input_widget.dart` | Labeled themed text form field used across the word editor and in `TextInputModal`. Reuse for labeled text entry. |

---

## Styling primitives (use instead of hardcoding)

Not widgets, but always prefer these over literals when building UI:

- `ContainerStyles` — colors (`sectionColor`, `section2Color`, `backgroundColor`, …),
  paddings (`defaultPaddingAmount`, `smallPaddingAmount`), decorations.
- `TextStyles`, `BorderStyles`, `ButtonStyles`, `IconStyles` — text, borders, buttons, icons.
- `BaseStyles.getColorScheme(context)` — the source of theme-aware colors.
