# ChromaFrog

*Dodge. Jump. Absorb. Survive.*

ChromaFrog is a colour-switching arcade game written entirely in **Motorola 68000 assembly** and built in the **Easy68K** simulator. You play as a frog that changes colour to deal with swarms of flies, where each colour gives the frog a different ability. Touch a fly while you're the wrong colour and you take damage.

▶️ **[Watch the trailer](https://youtu.be/a0visPmAKsA)**

## How to play

| Frog colour | Space does... | Points |
|---|---|---|
| 🟢 Green | Jump over green flies | +5 each |
| 🔴 Red | Blast red flies straight into the sky | — |
| 🔵 Blue | Pull blue flies towards you | +10 each |

You start with 5 health pips. Your score and session high score are shown on the HUD, and a new best is saved at the end of each round.

### Controls

| Key | Action |
|---|---|
| A / D | Move left / right |
| C | Change colour |
| Space | Use the current colour's ability |
| Esc | Quit |

Before playing, you name your frog (Shift + Enter to confirm, Backspace to delete).

## Running it

1. Install [Easy68K](http://www.easy68k.com/).
2. Clone or download this repo, keeping all files in the same folder (the sound files are loaded by name).
3. Open `FROG_MENU.X68` in the Easy68K editor and assemble it (F9). It includes all the other source files.
4. Run the program in the simulator.

## Project structure

| File | Purpose |
|---|---|
| `FROG_MENU.X68` | Entry point: title screen, instructions, frog naming, sound loading |
| `FROG_MAIN.X68` | Main game loop: movement, colour modes, jumping, blasting, attracting, health, score and flies |
| `FROG_DRAW.X68` | Frog sprite drawing |
| `FROG_DRAW_FLIES.X68` | Fly sprites |
| `FROG_DRAW_HUD.X68` | Health, score and labels |
| `FROG_DRAW_MUSTACHE.X68` | Easter egg sprite variant |
| `bugs_and_fixes.txt` | Log of the errors I hit while building the game and how I fixed them |
| `ChromaFrog_Data_Storage.xlsx` | Memory and data planning |
| `*.wav` | Music and sound effects |

## Technical highlights

- **Multi-key input** using Easy68K trap task 19, reading A, D, C and Space in the same frame so you can move and act at once.
- **Simple physics**: jump velocity and gravity applied every frame.
- **Custom integer-to-string routine** using repeated `DIVU #10` so the score draws in the graphics window rather than the text console.
- **Shared memory layout**: the menu and game share variables (like the frog's name) at fixed addresses, after working through `ORG` and duplicate-symbol conflicts between the files.
- **Sound**: background music plus jump and hit effects.

The full development log, including the assembler errors and how each was solved, is in [`bugs_and_fixes.txt`](bugs_and_fixes.txt).

## Easter egg

Try naming your frog **Filip** 🥸

## About

Built by Sarah Crotty as a Year 2 Assembly Language project for the BA (Hons) Software Development at SETU Carlow, and defended in a verbal viva covering all routines, game mechanics and design decisions.
