# Contributing to Slyrun

Godot 4.7, GL Compatibility, Web export.

## Running the game

Install Godot 4.7.x, the standard build (not .NET), from https://godotengine.org/download or the [GitHub releases](https://github.com/godotengine/godot/releases). On macOS the binary is inside the app bundle:

```sh
GODOT=/Applications/Godot.app/Contents/MacOS/Godot
```

From the repo root:

| What | Command |
| --- | --- |
| Import assets (first run after cloning, or after adding files) | `$GODOT --headless --path . --import` |
| Error check: run about 5 s with no window, read the output | `$GODOT --headless --path . --quit-after 300` |
| Play in a window | `$GODOT --path .` |
| Open the editor | `$GODOT --path . -e` |

The error check should print only the Godot version line. Any `ERROR` or `WARNING` means something is broken. Fix it before merging.

After any of these, `git status` should show only the changes you meant to make. If Godot generated new `.uid` or `.import` files for files you added, commit them.

## Branches

- Branch off `main` with your owner prefix: `p1/gap-controller`, `p2/run-setup`, `p3/sly-run-cycle`.
- Keep branches short-lived. Merge to `main` at least every few hours.
- Before merging, pull `main`, press Play, and check that the game still launches and reaches the run. `main` must always be playable.

## Moving and renaming files

**Only move, rename or delete files in the Godot FileSystem dock.** Never use Finder, `git mv`, or an editor or AI to rewrite paths.

Scenes refer to scripts and assets by `uid://` and `res://` paths. Godot updates those references only when it does the move itself. Paths written as strings in code (for example `load("res://...")`) are not updated, so grep for them after a move.

Commit the `.uid` and `.import` files Godot generates next to your scripts and assets. Without them, a teammate's editor generates new ids and every scene that uses the file shows up as changed.

## Folder ownership

| Folder | Owner | What lives there |
| --- | --- | --- |
| `src/core/` | P2 | Autoloads: `Config`, `GameState`, `SaveData`, `Router` |
| `src/typing/` | P2 | Word bank, typing input, WPM tracking, word display |
| `src/menus/` | P2 | Title, calibration, run setup, end screen, settings |
| `src/run/` | P1 | Run scene, gap controller, countdown, HUD |
| `src/actors/` | P1 (code), P3 (sprites) | Sly and the Hollow |
| `src/world/` | P1 (code), P3 (art) | Parallax layers, danger effects |
| `assets/` | P3 | Art, audio, fonts |
| `data/words/`, `tools/` | P3 | Word banks and the script that builds them |
| `data/tuning.tres` | Anyone | All tuning numbers. Tell the team when you change one |

## Scene files (`.tscn`)

- **Never edit a `.tscn` you don't own.** `.tscn` merge conflicts can't be fixed safely by hand.
- To add to someone else's scene, either ask the owner, or build your piece as its own scene in your folder and have the owner instance it.
- If you get a `.tscn` conflict anyway, keep the owner's version (`git checkout --theirs` or `--ours` as appropriate) and redo your change in the editor.

## Scene changes and tuning

- Only `Router` (`src/core/router.gd`) calls `change_scene_to_*`.
- Put tuning numbers in `data/tuning.tres`, not in scripts.
