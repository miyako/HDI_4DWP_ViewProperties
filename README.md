![version](https://img.shields.io/badge/version-21.1%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)

# HDI_4DWP_ViewProperties

A 4D **HDI** (How Do I) example demonstrating that a single 4D Write Pro document can be displayed by more than one form area at once, with each area keeping its own independent **view properties** (zoom, rulers, page frames, hidden characters, etc.) — no synchronisation code required. Originally published by 4D as a binary `.4DB` example for **4D v16**; converted to the modern `.4DProject` architecture so it runs on current 4D releases.

## Origin

This project started as a binary `.4DB` example database originally distributed with 4D v16. It was converted to the modern project architecture (`.4DProject`) using 4D 21's built-in binary-to-project conversion tool, then modernised (syntax, localisation, dark mode) with the help of **GitHub Copilot**.

- **Blog post:** https://blog.4d.com/view-properties-in-4d-write-pro/
- **Original download:** https://download.4d.com/Demos/4D_v16/HDI_4DWP_ViewProperties.zip

## What it demonstrates

- Two 4D Write Pro areas (`WriteProArea1` and `WParea`) bound to the **same** object variable (`vDoc`) — editing the document in one area is reflected in the other instantly, with no explicit refresh/sync code.
- Each area configures a completely independent set of **view properties**:
  - `WriteProArea1` — a small (162×219), read-only, zoomed-out (`"zoom": 25`) thumbnail-style preview that shows page frames (`showPageFrames`) and disables dragging/dropping/context menu.
  - `WParea` — a large, embedded, editable area zoomed in to 150% (`"zoom": 150`), showing hidden characters (`showHiddenChars`) and hiding the page background (`showBackground: false`).
- A second, independent Write Pro document (`vInfos`) shown read-only on the "Infos" tab, loaded from a bundled `.4wp` file — illustrating that view properties are per-area, not per-document.
- `WP Import document`, loading `.4wp` sample documents (`HDI_Infos.4wp`, `Argentina.4wp`) into object variables at startup.
- A splash screen that gates the demo behind a minimum 4D version and a valid 4D Write license before opening the main form.

## Key commands

| Command | Used for |
|---|---|
| `WP Import document` | Loading the bundled `HDI_Infos.4wp` / `Argentina.4wp` sample documents into `vInfos` / `vDoc` (`HDI_Init`) |
| `Application version` | Gating the demo behind a minimum 4D version on the splash screen |
| `Is license available` | Checking for a valid 4D Write license (`4D Write license`) before allowing the demo to run |
| `OBJECT Get pointer` | Resolving the Write Pro area object by name in `WParea`'s object method |
| `WP Selection range` | Capturing the current text selection to keep an (unused in this build) companion widget in sync |

## How it works

`00_Start` opens the `HDI` splash form. Its form method (`On Load`) checks the 4D version and 4D Write license and sets `Form.quit` accordingly, swapping in the appropriate warning text and re-labelling the button. The `BtnDemo` object method either returns to design mode (`Form.quit = True`) or opens the `HDI2` demo form.

`HDI2` loads on `On Load` by calling `HDI_Init`, which imports the two sample `.4wp` documents into `vInfos` (bound to the read-only "Infos" tab's Write Pro area) and `vDoc` (bound to both Write Pro areas on the "Demo" tab). Because `WriteProArea1` and `WParea` share the same `vDoc` variable, 4D Write Pro keeps them showing the same content automatically — only their **view** properties (zoom, rulers, selection, page frames, background) differ, and those are set independently per area in the form JSON.

## Points of interest

- **View properties vs. document content** — this HDI's whole point is the distinction between a Write Pro *document* (the data, `vDoc`) and a Write Pro *area*'s *view* of it (zoom, rulers, hidden characters, page frames, selection visibility, scrollbars). The same variable can be rendered completely differently by two areas simultaneously.
- **No manual refresh code** — there is no explicit "update the other area" logic anywhere in the project; binding both areas to the same object variable is sufficient for 4D Write Pro to keep them in sync.
- **`WParea.4dm` references a companion widget that doesn't exist on this form** — the object method looks up an object named `"WPwidget"` (intended to mirror the area's selection into a status/toolbar widget), but no such object is defined on `HDI2`. The pointer resolves to nil, so the method just `BEEP`s and does nothing; it's a harmless leftover from a more elaborate template form and was left in place rather than removed, since it isn't the subject of this modernisation pass.
- Startup uses the modern splash pattern: window-reuse detection, `CALL WORKER`, non-blocking `DIALOG(...;*)`, and `Form.quit`/`BtnDemo` object method instead of interprocess variables and `QUIT 4D`.
- Full XLIFF localisation covers the menu and both forms' text/labels via `:xliff:` references and `Localized string(...)`.
- The one button on the splash form (`BtnDemo`) is sized via `form-theme` CSS media queries (27px Liquid Glass / 23px classic) rather than a hardcoded `height`, so it stays correctly rounded under macOS Tahoe.
- No listboxes are used anywhere in this project, so the usual `truncateMode`/`resizingMode` listbox defaults don't apply here.

## Project structure

```
Project/Sources/
  Forms/HDI/              Splash/startup form (version + license gate) and its BtnDemo object method
  Forms/HDI2/              Main demo form: Infos/Demo tabs, the two linked Write Pro areas
  Methods/                 Startup (00_Start), HDI_Init (loads the sample documents)
  styleSheets*.css         Dark mode + Liquid Glass button sizing
Resources/
  HDI_Infos.4wp            Sample document shown read-only on the "Infos" tab
  Argentina.4wp            Sample document shared by both Write Pro areas on the "Demo" tab
  en.lproj/                XLIFF localisation (English source)
```

## Requirements

- 4D 21.1 or later (project `compatibilityVersion: 2101`)
- A valid 4D Write license to pass the splash screen's license check

## Modernisation notes

| Branch | Description | Guidance |
|--------|-------------|----------|
| [`miyako-modernize-4d-hdi-project`](../../tree/miyako-modernize-4d-hdi-project) | Full modernisation: XLIFF localisation, `var`/`#DECLARE` syntax, a standard `"action": "quit"` menu item (removing the `m_Quit` wrapper), method visibility, a rebuilt startup dialog (window reuse, `CALL WORKER`, `BtnDemo` object method with `Form.quit`), and dark mode/Liquid Glass CSS. No listboxes exist in this project, so the listbox-defaults task was not applicable. | [`4dlocalise`](https://github.com/miyako/skills/tree/main/4d-skills/skills/4dlocalise), [`4dmodernise`](https://github.com/miyako/skills/tree/main/4d-skills/skills/4dmodernise), [`4dproject`](https://github.com/miyako/skills/tree/main/4d-skills/skills/4dproject), [`4dmethods`](https://github.com/miyako/skills/tree/main/4d-skills/skills/4dmethods), [`4dstartup`](https://github.com/miyako/skills/tree/main/4d-skills/skills/4dstartup), [hdi.startup.instructions.md](.github/instructions/hdi.startup.instructions.md), [`4dcss`](https://github.com/miyako/skills/tree/main/4d-skills/skills/4dcss), [`4dform`](https://github.com/miyako/skills/tree/main/4d-skills/skills/4dform) |

## References

- [4D blog: view properties in 4D Write Pro](https://blog.4d.com/view-properties-in-4d-write-pro/)
- [`WP Import document`](https://developer.4d.com/docs/commands/wp-import-document)
- [4D Write Pro area view properties](https://developer.4d.com/docs/FormObjects/wp_overview)
- [4D CSS stylesheets (dark mode, Liquid Glass)](https://developer.4d.com/docs/FormEditor/stylesheets)
- [Original download](https://download.4d.com/Demos/4D_v16/HDI_4DWP_ViewProperties.zip)
