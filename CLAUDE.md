# Working on the Red Sky archive

Two people restore this archive, each with their own Claude. The work is split by **module**:
each disc or work is one module, checked out by one person at a time, fixed independently, and
handed back when it works. Read this before changing anything.

## Modules

| Module | Folder | Issue |
| --- | --- | --- |
| Red Sky 98 Demo | `redsky98` | #1 |
| Red Sky 97 Demo (Gypsy Wagon) | `gypsy-wagon` | #2 |
| Absolut DJ | `absolut-dj` | #3 |
| Millennium Clock (no player) | `millennium-clock` | #4 |
| Miller Lite Beer Pager | `beer-pager` | #5 |
| Sutter Home MoodMaker | `moodmaker` | #6 |
| Power Rangers DataZord | `datazord` | #7 |
| Spider-Man Teaser | `spider-man` | #8 |

Each module's GitHub issue holds its status (label: `working`, `partly working`, `broken`), its
known problems and who has it (the assignee). The issues are the shared board: read them with
`gh api repos/jolholodeck/redsky/issues?labels=module`.

## What belongs to a module

Everything a module owns can change without affecting any other module:

- `players/<module>/dirplayer.patch` and `players/<module>/FIXES.md`: its own copy of the DirPlayer player.
- `site/players/<module>/dirplayer-polyfill.js.gz`: that player, built. Only this module loads it.
- `site/w/<module>/`: its files as served (gzipped originals, converted video, replacement assets).
- `works/<module>/converted/` and `works/<module>/extracted/`.
- Its entry in `site/works.json` and `site/speeds.json`.

**Shared** files affect every module. Change them only when the module truly needs it, keep the
change switched on for that module alone (test `WORK === '<module>'` or a works.json field), and
say so in the pull request: `site/play.html`, `site/shared/`, `site/beatnik/`, `site/index.html`,
`site/work.html`, `site/site.css`, `tools/`.

**Never edit** `original/`, `decompiled/`, `works/*/original/` or `works/*/decompiled/`. They are the
record of what was received. Replacement assets go beside the originals in `site/w/<module>/`.

## Checking out a module

1. Check the issue isn't assigned to someone else. If it is, stop and tell the person you're working for.
2. Assign it to the person you're working for (`gh api -X POST repos/jolholodeck/redsky/issues/<n>/assignees -f "assignees[]=<login>"`) and comment what you're about to do.
3. `git checkout main && git pull`, then `git checkout -b module/<module>`.

## Fixing a problem

1. Reproduce it: `cd site && python3 -m http.server 8766`, then open `play.html?w=<module>`
   (add `&m=<movie path>` for one piece). The browser console shows `[rs] script error in <script> / <handler>`
   and `[rs] alert:` lines. `tools/try_work.js <module> <movie> <out>` does this headless with screenshots.
   `window.__vm.eval_command('put the frame')` runs Lingo in the running movie.
2. Find the cause in the module's own Lingo (`works/<module>/decompiled/`, or `decompiled/` for redsky98),
   and name the Director feature behind it (a property, command, Xtra call, ink, chunk type...).
3. **Before writing a fix, look for it in the other modules' players.** Search every
   `players/*/FIXES.md` for the feature and the symptom, and compare the other patches with
   `emulator/base.patch` around the code involved (`grep` the handler or property name in
   `players/*/dirplayer.patch`). If another module already fixed it, copy that fix into this
   module's patch, test this module, and record it in FIXES.md as "copied from <module>".
   Tell the person you're working for which module it came from.
4. Otherwise fix it. Player fixes: `tools/player.sh load <module>`, edit the Rust in the DirPlayer
   checkout, `tools/player.sh build <module>`, test, then `tools/player.sh save <module>`. Mark new
   code with a "Red Sky preservation build" comment. Other fixes go in the module's own files above.
5. Add a line to `players/<module>/FIXES.md` (date, who, symptom, Director feature and change), and
   when it changes what a visitor sees, to the module's `changes` in `site/works.json`.
6. Never copy a fix into another module's player unasked. Each module changes only when someone working on it chooses to.

## Handing it back

When the module works (or a fix is worth publishing on its own):

1. Play the module through again, every piece it contains, and check nothing you didn't mean to change has changed.
2. Commit on the branch, push, and open a pull request to `main` that says what was fixed, how it
   was tested, and any shared file touched.
3. Merge it if it touches only this module's files. If it touches a shared file, check the other
   modules still start (`tools/try_work.js` on each), then merge.
4. Update the issue: status label, known problems left, and unassign it if the module is done.
   Merging to `main` publishes the site (GitHub Pages) within a few minutes.

Pull `main` into your branch when the other person merges, so shared files stay current.

## Notes

- `README.md` explains the folders; `emulator/README.md` the player and its toolchain.
- Commit messages and pull requests say what changed in plain words.
