# Contributing to Slyrun

Godot 4.7, GL Compatibility, Web export.

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
