# Mac OS 9 reference setup

The reference is the original Mac CD running under Mac OS 9, recorded piece by piece.

## The CD image

`RedSky98_Mac.iso` (not stored in git: 196 MB) is a plain HFS volume named "Red Sky 98".
It holds every file from `original/Red Sky/` with its Mac resource fork and Finder
type/creator restored from `original/__MACOSX/`: 103 files, 55 with resource forks,
including the PowerPC/68k projector "Red Sky 98" and the Mac Xtras (FileIO, FileXtra, MIX Services).

Rebuild it:

    python3 -I tools/make_hfs.py original "Red Sky" RedSky98_Mac.iso "Red Sky 98" 196

(needs hfsutils: `apt install hfsutils`)

## Running it in UTM (Apple Silicon or Intel Mac)

1. Install UTM (mac.getutm.app) and download the "Mac OS 9.2.1" VM from the UTM gallery. Open the `.utm` file.
2. With the VM stopped, edit it: Drives > New > Removable, interface IDE, type CD/DVD. Save.
3. Start the VM. Use the CD/DVD button in the UTM toolbar to choose `RedSky98_Mac.iso`.
4. In Mac OS 9: Apple menu > Control Panels > Monitors > 256 colors, 640 x 480 or larger.
   The CD refuses to run at other color depths.
5. Open the "Red Sky 98" CD and double-click the "Red Sky 98" projector.
6. Record the UTM window with macOS screen recording (Shift-Cmd-5).

Click inside the VM to capture the mouse; Ctrl-Option releases it.

## Sound

UTM's PowerPC machine often has no sound. If recordings are silent, use SheepShaver
(Mac OS 9 with sound) instead: it needs a "New World" Mac ROM file and a Mac OS 9 install.
The same .iso mounts in SheepShaver as a CD.

## What to record

One recording per piece, starting with the front door: startup logo, the Entertainment
cowboy (let the intro play without skipping), Ctrl-W to the Work menu, each list.
Note the Mac OS 9 machine speed setting used, because "as fast as possible" frames depend on it.
