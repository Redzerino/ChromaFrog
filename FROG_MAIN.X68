*-----------------------------------------------------------
* Title      : FROG_MAIN.X68
* Author     : Sarah Crotty
* Date       : 26/02/2026
* Description: This is the main game file. Handles everything that happens
*              while you are actually playing - moving the frog, colour modes,
*              jumping, blasting, attracting, health, score and the flies.
* Known Bugs : If two flies hit you in the same moment you might only lose
*              one health pip instead of two.
*-----------------------------------------------------------

*-----------------------------------------------------------
* Constants
*-----------------------------------------------------------
MOVE_SPEED          equ 3           * how fast the frog walks left or right
SCREEN_W            equ 640         * width of the game window
FROG_SPRITE_W       equ 52          * how wide the frog is, so we stop it going off the right edge
FROG_SPRITE_H       equ 36          * how tall the frog is
GROUND_Y            equ 320         * the Y position of the ground - frog and flies stand here

COL_GREEN           equ 0           * green mode - frog can jump
COL_RED             equ 1           * red mode - frog can blast flies away
COL_BLUE            equ 2           * blue mode - frog can pull blue flies in

* Frog colours change depending on which mode you are in.
* MID is the main body colour, LIGHT is the brighter highlight on top.
* _G = green mode, _R = red mode, _B = blue mode
FROG_GREEN_MID_G    equ $0038C100    * dark green body colour
FROG_GREEN_LIGHT_G  equ $0055DD11    * bright green for the shiny bit on top
FROG_GREEN_MID_B    equ $00CC0000    * dark blue body colour
FROG_GREEN_LIGHT_B  equ $00FF3300    * bright blue for the shiny bit
FROG_GREEN_MID_R    equ $000000FF    * dark red body colour
FROG_GREEN_LIGHT_R  equ $000099FF    * bright red for the shiny bit

FLY_W               equ 10          * how wide a fly is
FLY_H               equ 8           * how tall a fly is
MAX_HEALTH          equ 5           * how many health pips you start with
JUMP_VEL            equ -12         * how fast the frog shoots up when jumping (negative = up on screen)
GRAVITY             equ 1           * pulls the frog back down every frame

COL_BG              equ $00132213    * dark green background colour
COL_GROUND          equ $00224422    * colour of the ground
COL_GROUND_LT       equ $002A5522    * slightly lighter strip at the top of the ground
COL_RED_FLY         equ $000022FF    * red fly colour (Easy68K uses BGR not RGB so this looks red)
COL_BLUE_FLY        equ $00FF6622    * blue fly colour
COL_WHITE           equ $00FFFFFF    * white - used for eyes and text
COL_YELLOW          equ $000088FF    * orangey yellow used for score and labels
COL_HP_FULL         equ $004444FF    * colour of a health pip when you still have it
COL_HP_EMPTY        equ $00111144    * colour of a health pip when its gone
COL_SCORE_C         equ $00FFC84D    * colour used for the score text
COL_WING_B          equ $00FFAAAA    * blue fly wing colour
COL_WING_R          equ $00AAAAFF    * red fly wing colour
COL_GREEN_FLY       equ $0000CC00    * green fly colour
COL_WING_G          equ $0000FF44    * green fly wing colour

*-----------------------------------------------------------
* Variables
*-----------------------------------------------------------
* Copied from FROG_MENU.X68 so this file knows where the name lives in memory
FROG_NAME       equ $4F00

    ORG     $5000
POS_X               DS.L 1          * temp X used by the draw routines
POS_Y               DS.L 1          * temp Y used by the draw routines
PLAYER_X            DS.L 1          * frog X position on screen
PLAYER_Y            DS.L 1          * frog Y position on screen
COLOUR_STATE        DS.L 1          * which colour mode the frog is in (0=green 1=red 2=blue)
FROG_GREEN_MID      DS.L 1          * the frogs main body colour - changes when you press C
FROG_GREEN_LIGHT    DS.L 1          * the frogs highlight colour - changes when you press C
PREV_C_STATE        DS.L 1          * was C held last frame? stops colour changing too fast if you hold C
PREV_SP_STATE       DS.L 1          * was space held last frame? stops jump/blast firing every frame

VEL_Y               DS.L 1          * how fast the frog is moving up or down (negative = going up)
ON_GROUND           DS.L 1          * 1 if the frog is on the ground, 0 if in the air

HEALTH              DS.L 1          * how many health pips are left (hits zero = game over)
SCORE               DS.L 1          * your score for this round
HIGH_SCORE          DS.L 1          * the best score you have gotten this session
HIT_COOLDOWN        DS.L 1          * stops you taking damage again too quickly after getting hit

* Red flies - there are 3 of them. X/Y is where they are, DX is how fast
* they move sideways, DY only matters when blasted (they fly upward), ACT means the fly is alive
RF0_X               DS.L 1
RF0_Y               DS.L 1
RF0_DX              DS.L 1
RF0_ACT             DS.L 1
RF1_X               DS.L 1
RF1_Y               DS.L 1
RF1_DX              DS.L 1
RF1_ACT             DS.L 1
RF2_X               DS.L 1
RF2_Y               DS.L 1
RF2_DX              DS.L 1
RF2_ACT             DS.L 1

* Blue flies - there are 3 of them. They get pulled toward the frog when
* you hold space in blue mode. Touching them in blue mode gives +10 points.
BF0_X               DS.L 1
BF0_Y               DS.L 1
BF0_DX              DS.L 1
BF0_ACT             DS.L 1
BF1_X               DS.L 1
BF1_Y               DS.L 1
BF1_DX              DS.L 1
BF1_ACT             DS.L 1
BF2_X               DS.L 1
BF2_Y               DS.L 1
BF2_DX              DS.L 1
BF2_ACT             DS.L 1

* Green flies - there are 3 of them. They walk along the ground.
* Jump over them for +5 points, or touch them and take damage.
GF0_X               DS.L 1
GF0_Y               DS.L 1
GF0_DX              DS.L 1
GF0_ACT             DS.L 1
GF1_X               DS.L 1
GF1_Y               DS.L 1
GF1_DX              DS.L 1
GF1_ACT             DS.L 1
GF2_X               DS.L 1
GF2_Y               DS.L 1
GF2_DX              DS.L 1
GF2_ACT             DS.L 1

* Remembers if you were already above each green fly so we only score once per jump
GF0_JUMPED          DS.L 1
GF1_JUMPED          DS.L 1
GF2_JUMPED          DS.L 1

* Vertical speed for red flies - only used when you blast them upward with space
RF0_DY              DS.L 1
RF1_DY              DS.L 1
RF2_DY              DS.L 1

WING_TIMER          DS.L 1          * counts up to make fly wings flap up and down
FRAME_COUNT         DS.L 1          * counts every frame, used to decide when to spawn new flies

COL_FLY_X          DS.L 1          * temp X used when checking or drawing a fly
COL_FLY_Y          DS.L 1          * temp Y used when checking or drawing a fly
NUM_BUF            DS.B 12          * temp space to build the score number as text

*-----------------------------------------------------------
* Entry
*-----------------------------------------------------------
* Runs straight on from FROG_MENU.X68
GAME_START:
    * Open the game window
    MOVE.L  #SCREEN_W, D1
    MOVE.L  #480,   D2
    MOVE.B  #33,    D0
    TRAP    #15

    * Turn on double buffering so nothing flickers
    MOVE.L  #17,    D1
    MOVE.B  #92,    D0
    TRAP    #15

    * Stop Easy68K stealing the ESC key so we can use it to quit
    MOVE.L  #1,     D1
    MOVE.B  #24,    D0
    TRAP    #15

    JSR     RESET_GAME
    JSR     INIT_FLIES

*-----------------------------------------------------------
* GAME LOOP
*-----------------------------------------------------------
GAME_LOOP:
    * Increment counters
    MOVE.L  FRAME_COUNT, D0          * grab the frame counter
    ADD.L   #1, D0                  * add 1 every frame
    MOVE.L  D0, FRAME_COUNT          * save it back

    MOVE.L  WING_TIMER, D0          * grab the wing flap counter
    ADD.L   #1, D0                  * tick it up
    CMP.L   #8, D0                  * gone past 8? reset it to make a loop
    BLT     WING_OK
    MOVE.L  #0, D0
WING_OK:
    MOVE.L  D0, WING_TIMER

    MOVE.L  HIT_COOLDOWN, D0        * are we still in the no-damage window after getting hit?
    BEQ     NO_CD                   * no, nothing to do
    SUB.L   #1, D0                  * count down one frame
    MOVE.L  D0, HIT_COOLDOWN
NO_CD:

    * Check which keys are being held right now (A, D, C and Space all at once)
    * Task 19 reads up to 4 keys - each byte is $FF if held, $00 if not
    MOVE.L  #'A'<<24|'D'<<16|'C'<<8|' ', D1
    MOVE.B  #19,    D0
    TRAP    #15
    MOVE.L  D1,     D5              * save the result so we can check each key below

    * Check ESC separately
    MOVE.L  #$1B000000, D1          * ESC key code goes in the high byte
    MOVE.B  #19,    D0
    TRAP    #15
    BTST.L  #31,    D1              * if bit 31 is set, ESC is being held
    BNE     QUIT_GAME               * quit the game

    * Move left if A is held
    BTST.L  #31,    D5              * A is in the top byte, bit 31
    BEQ     CHECK_D                 * not pressed, skip
    MOVE.L  PLAYER_X, D0
    SUB.L   #MOVE_SPEED, D0         * move left
    BGE     OK_LEFT                 * still on screen?
    MOVE.L  #0, D0                  * hit the left wall, stop there
OK_LEFT:
    MOVE.L  D0, PLAYER_X

CHECK_D:
    * Move right if D is held
    BTST.L  #23,    D5              * D is in byte 2, bit 23
    BEQ     CHECK_C                 * not pressed, skip
    MOVE.L  PLAYER_X, D0
    ADD.L   #MOVE_SPEED, D0         * move right
    MOVE.L  #SCREEN_W-FROG_SPRITE_W, D1  * work out where the right wall is
    CMP.L   D1, D0                  * would we go past it?
    BLE     OK_RIGHT                * no, fine
    MOVE.L  D1, D0                  * yes, stop at the right wall
OK_RIGHT:
    MOVE.L  D0, PLAYER_X

CHECK_C:
    * Cycle colour mode if C is pressed
    BTST.L  #15,    D5              * C is in byte 1, bit 15
    BEQ     C_UP                    * not pressed
    TST.L   PREV_C_STATE            * was C already held last frame?
    BNE     SKIP_CYCLE              * yes - dont change mode again until they let go

    MOVE.L  COLOUR_STATE, D0        * get the current mode
    ADD.L   #1, D0                  * go to the next one
    CMP.L   #3, D0                  * gone past the last mode?
    BNE     SAVE_CS
    MOVE.L  #0, D0                  * yes - wrap back around to green
SAVE_CS:
    MOVE.L  D0, COLOUR_STATE

    CMP.L   #COL_RED,  D0
    BEQ     DO_RED
    CMP.L   #COL_BLUE, D0
    BEQ     DO_BLUE
DO_GREEN:
    MOVE.L  #FROG_GREEN_MID_G,   FROG_GREEN_MID    * use green body colour
    MOVE.L  #FROG_GREEN_LIGHT_G, FROG_GREEN_LIGHT  * use green highlight
    BRA     SKIP_CYCLE
DO_RED:
    MOVE.L  #FROG_GREEN_MID_R,   FROG_GREEN_MID    * use red body colour
    MOVE.L  #FROG_GREEN_LIGHT_R, FROG_GREEN_LIGHT  * use red highlight
    BRA     SKIP_CYCLE
DO_BLUE:
    MOVE.L  #FROG_GREEN_MID_B,   FROG_GREEN_MID    * use blue body colour
    MOVE.L  #FROG_GREEN_LIGHT_B, FROG_GREEN_LIGHT  * use blue highlight

SKIP_CYCLE:
    MOVE.L  #1, PREV_C_STATE        * remember C is held so we dont cycle again next frame
    BRA     CHECK_JUMP
C_UP:
    MOVE.L  #0, PREV_C_STATE        * C is not held, reset so next press works

CHECK_JUMP:
    * Space pressed?
    * Check if space is being pressed
    BTST.L  #7, D5                  * space is in byte 0, bit 7
    BEQ     SP_NOT_PRESSED          * not pressed, skip

    * GREEN mode - jump
    MOVE.L  COLOUR_STATE, D0
    CMP.L   #COL_GREEN, D0
    BNE     SP_TRY_RED
    TST.L   ON_GROUND               * can only jump if on the ground
    BEQ     DO_PHYSICS              * in the air already, ignore
    TST.L   PREV_SP_STATE
    BNE     DO_PHYSICS              * space was already held, dont jump again
    MOVE.L  #JUMP_VEL, VEL_Y       * give the frog an upward kick
    MOVE.L  #0, ON_GROUND          * frog is now in the air
    BRA     SP_HELD

    * RED mode - blast
SP_TRY_RED:
    CMP.L   #COL_RED, D0
    BNE     SP_TRY_BLUE
    TST.L   PREV_SP_STATE
    BNE     DO_PHYSICS              * only blast on first press, not while holding
    JSR     DO_RED_BLAST            * shoot all red flies off the top of the screen
    BRA     SP_HELD

    * --- BLUE: attract blue flies toward frog (held) ---
SP_TRY_BLUE:
    JSR     DO_BLUE_ATTRACT         * pull blue flies toward the frog while space is held

SP_HELD:
    MOVE.L  #1, PREV_SP_STATE       * remember space is held
    BRA     DO_PHYSICS

SP_NOT_PRESSED:
    MOVE.L  #0, PREV_SP_STATE       * space not held, reset so next press works

DO_PHYSICS:
    TST.L   ON_GROUND               * already on the ground? skip all this
    BNE     PHYS_SKIP
    MOVE.L  VEL_Y, D0
    ADD.L   #GRAVITY, D0           * gravity pulls the frog down a bit each frame
    MOVE.L  D0, VEL_Y
    MOVE.L  PLAYER_Y, D1
    ADD.L   D0, D1                  * move the frog by its current speed
    CMP.L   #GROUND_Y, D1          * has it hit the ground?
    BLE     PHYS_APPLY              * not yet
    MOVE.L  #GROUND_Y, D1          * yes - snap it to the ground
    MOVE.L  #0, VEL_Y              * stop moving
    MOVE.L  #1, ON_GROUND          * tell the game its landed
PHYS_APPLY:
    MOVE.L  D1, PLAYER_Y
PHYS_SKIP:

    JSR     MAYBE_SPAWN             * maybe add a new fly to the screen
    JSR     MOVE_ALL_FLIES          * move every fly along
    JSR     CHECK_ALL_COL           * check if the frog has touched any fly

    * Save the score if its a new best
    MOVE.L  SCORE, D0               * is the current score better than the best?
    MOVE.L  HIGH_SCORE, D1
    CMP.L   D1, D0
    BLE     NO_HS                   * no, leave it
    MOVE.L  D0, HIGH_SCORE          * yes, save it as the new best
NO_HS:

    * Draw everything
    JSR     DRAW_BACKGROUND
    JSR     DRAW_ALL_FLIES
    * Draw the frog (with or without moustache)
    TST.L   MUSTACHE_FLAG           * did the player type "filip" as their name?
    BNE     DO_MUSTACHE_DRAW        * yes - draw the moustache frog
    JSR     DRAW_FROG               * no - draw the normal frog
    BRA     AFTER_FROG_DRAW
DO_MUSTACHE_DRAW:
    JSR     DRAW_FROG_M             * draw frog with a moustache
AFTER_FROG_DRAW:
    JSR     DRAW_HUD

    * Show everything we just drew
    MOVE.B  #94,    D0              * put what we drew onto the screen
    TRAP    #15


    * Short delay to keep the game running at a reasonable speed
    MOVE.L  #15000, D1
DLY:
    SUB.L   #1, D1
    BNE     DLY

    * Check if the player has run out of health
    MOVE.L  HEALTH, D0              * is the player still alive?
    BNE     GAME_LOOP               * yes, keep going

*-----------------------------------------------------------
* GAME OVER
*-----------------------------------------------------------
GAME_OVER:
    JSR     DRAW_BACKGROUND

    * Dark panel
    MOVE.L  #$00050A05, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #$00050A05, D1
    JSR     SET_FILL_COLOR
    MOVE.L  #100, D1
    MOVE.L  #70,  D2
    MOVE.L  #540, D3
    MOVE.L  #430, D4
    MOVE.B  #87,  D0
    TRAP    #15

    * Red border
    MOVE.L  #COL_RED_FLY, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #$00050A05, D1
    JSR     SET_FILL_COLOR
    MOVE.L  #100, D1
    MOVE.L  #70,  D2
    MOVE.L  #540, D3
    MOVE.L  #430, D4
    MOVE.B  #90,  D0
    TRAP    #15

    * GAME OVER
    MOVE.L  #COL_RED_FLY, D1
    JSR     SET_PEN_COLOR
    LEA     STR_GO, A1
    MOVE.L  #218, D1
    MOVE.L  #88,  D2
    MOVE.B  #95,  D0
    TRAP    #15

    * Divider
    MOVE.L  #COL_RED_FLY, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #COL_RED_FLY, D1
    JSR     SET_FILL_COLOR
    MOVE.L  #115, D1
    MOVE.L  #116, D2
    MOVE.L  #525, D3
    MOVE.L  #118, D4
    MOVE.B  #87,  D0
    TRAP    #15

    * "Well played," in white then name in green
    MOVE.L  #COL_WHITE, D1
    JSR     SET_PEN_COLOR
    LEA     STR_WELLPLAYED, A1
    MOVE.L  #125, D1
    MOVE.L  #135, D2
    MOVE.B  #95,  D0
    TRAP    #15

    MOVE.L  #COL_GREEN_FLY, D1
    JSR     SET_PEN_COLOR
    LEA     FROG_NAME, A1
    MOVE.L  #330, D1
    MOVE.L  #135, D2
    MOVE.B  #95,  D0
    TRAP    #15

    * Score section label + number
    MOVE.L  #COL_SCORE_C, D1
    JSR     SET_PEN_COLOR
    LEA     STR_YRSCORE, A1
    MOVE.L  #125, D1
    MOVE.L  #175, D2
    MOVE.B  #95,  D0
    TRAP    #15
    MOVE.L  SCORE, D0
    JSR     INT_TO_STR
    LEA     NUM_BUF, A1
    MOVE.L  #260, D1
    MOVE.L  #175, D2
    MOVE.B  #95,  D0
    TRAP    #15

    * High score section label + number
    MOVE.L  #COL_YELLOW, D1
    JSR     SET_PEN_COLOR
    LEA     STR_HISCORE, A1
    MOVE.L  #125, D1
    MOVE.L  #210, D2
    MOVE.B  #95,  D0
    TRAP    #15
    MOVE.L  HIGH_SCORE, D0
    JSR     INT_TO_STR
    LEA     NUM_BUF, A1
    MOVE.L  #260, D1
    MOVE.L  #210, D2
    MOVE.B  #95,  D0
    TRAP    #15

    * New high score message
    MOVE.L  SCORE, D0
    MOVE.L  HIGH_SCORE, D1
    CMP.L   D1, D0
    BNE     GO_NO_NHS
    MOVE.L  #COL_YELLOW, D1
    JSR     SET_PEN_COLOR
    LEA     STR_NEWHS, A1
    MOVE.L  #195, D1
    MOVE.L  #290, D2
    MOVE.B  #95,  D0
    TRAP    #15
GO_NO_NHS:

    * Play again box
    MOVE.L  #COL_GREEN_FLY, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #$00081208, D1
    JSR     SET_FILL_COLOR
    MOVE.L  #185, D1
    MOVE.L  #358, D2
    MOVE.L  #455, D3
    MOVE.L  #382, D4
    MOVE.B  #87,  D0
    TRAP    #15
    MOVE.L  #COL_GREEN_FLY, D1
    JSR     SET_PEN_COLOR
    LEA     STR_AGAIN, A1
    MOVE.L  #193, D1
    MOVE.L  #364, D2
    MOVE.B  #95,  D0
    TRAP    #15

    MOVE.B  #94,  D0
    TRAP    #15

GO_WAIT:
    * Wait for space, then go back to the start screen
    MOVE.L  #' '<<24, D1
    MOVE.B  #19, D0
    TRAP    #15
    BTST.L  #31, D1
    BEQ     GO_WAIT                 * keep waiting until SPACE pressed

    * Go back to the start screen
    JMP     SHOW_START

*-----------------------------------------------------------
* RESET_GAME
* Puts everything back to how it was at the start of a round.
*-----------------------------------------------------------
RESET_GAME:
    MOVE.L  #294,        PLAYER_X
    MOVE.L  #GROUND_Y,   PLAYER_Y
    MOVE.L  #0,          COLOUR_STATE
    MOVE.L  #0,          PREV_C_STATE
    MOVE.L  #0,          PREV_SP_STATE
    MOVE.L  #0,          VEL_Y
    MOVE.L  #1,          ON_GROUND
    MOVE.L  #FROG_GREEN_MID_G,   FROG_GREEN_MID
    MOVE.L  #FROG_GREEN_LIGHT_G, FROG_GREEN_LIGHT
    MOVE.L  #MAX_HEALTH, HEALTH
    MOVE.L  #0,          SCORE
    MOVE.L  #0,          HIT_COOLDOWN
    MOVE.L  #0,          FRAME_COUNT
    MOVE.L  #0,          WING_TIMER
    RTS

*-----------------------------------------------------------
* INIT_FLIES
* Clears all the flies off the screen ready for a new round.
*-----------------------------------------------------------
INIT_FLIES:
    MOVE.L  #0, RF0_ACT
    MOVE.L  #0, RF1_ACT
    MOVE.L  #0, RF2_ACT
    MOVE.L  #0, RF0_DY
    MOVE.L  #0, RF1_DY
    MOVE.L  #0, RF2_DY
    MOVE.L  #0, BF0_ACT
    MOVE.L  #0, BF1_ACT
    MOVE.L  #0, BF2_ACT
    MOVE.L  #0, GF0_ACT
    MOVE.L  #0, GF1_ACT
    MOVE.L  #0, GF2_ACT
    MOVE.L  #0, GF0_JUMPED
    MOVE.L  #0, GF1_JUMPED
    MOVE.L  #0, GF2_JUMPED
    RTS

*-----------------------------------------------------------
* MAYBE_SPAWN
* Checks if its time to add a new fly to the screen.
*-----------------------------------------------------------
MAYBE_SPAWN:
    MOVE.L  FRAME_COUNT, D0

    * Spawn a red fly every 80 frames
    MOVE.L  D0, D1
    DIVU    #80, D1
    SWAP    D1
    AND.L   #$FFFF, D1
    BNE     CHK_BLUE_SP
    JSR     SPAWN_RED

CHK_BLUE_SP:
    * Spawn a blue fly every 100 frames
    MOVE.L  D0, D1
    DIVU    #100, D1
    SWAP    D1
    AND.L   #$FFFF, D1
    BNE     CHK_GREEN_SP
    JSR     SPAWN_BLUE

CHK_GREEN_SP:
    * Spawn a green fly every 60 frames
    MOVE.L  D0, D1
    DIVU    #60, D1
    SWAP    D1
    AND.L   #$FFFF, D1
    BNE     SPAWN_DONE
    JSR     SPAWN_GREEN

SPAWN_DONE:
    RTS

*-----------------------------------------------------------
* SPAWN_RED
* Tries to add a red fly. If all 3 slots are taken, does nothing.
*-----------------------------------------------------------
SPAWN_RED:
    JSR     CALC_SPEED
    TST.L   RF0_ACT
    BNE     TRY_RF1
    MOVE.L  #0,         RF0_X
    MOVE.L  #GROUND_Y,  RF0_Y
    MOVE.L  D0,         RF0_DX
    MOVE.L  #0,         RF0_DY
    MOVE.L  #1,         RF0_ACT
    RTS
TRY_RF1:
    TST.L   RF1_ACT
    BNE     TRY_RF2
    MOVE.L  #0,         RF1_X
    MOVE.L  #GROUND_Y,  RF1_Y
    MOVE.L  D0,         RF1_DX
    MOVE.L  #0,         RF1_DY
    MOVE.L  #1,         RF1_ACT
    RTS
TRY_RF2:
    TST.L   RF2_ACT
    BNE     SPRED_DONE
    MOVE.L  #0,         RF2_X
    MOVE.L  #GROUND_Y,  RF2_Y
    MOVE.L  D0,         RF2_DX
    MOVE.L  #0,         RF2_DY
    MOVE.L  #1,         RF2_ACT
SPRED_DONE:
    RTS

*-----------------------------------------------------------
* SPAWN_BLUE
* Tries to add a blue fly. If all 3 slots are taken, does nothing.
*-----------------------------------------------------------
SPAWN_BLUE:
    JSR     CALC_SPEED
    TST.L   BF0_ACT
    BNE     TRY_BF1
    MOVE.L  #0,         BF0_X
    MOVE.L  #GROUND_Y,  BF0_Y
    MOVE.L  D0,         BF0_DX
    MOVE.L  #1,         BF0_ACT
    RTS
TRY_BF1:
    TST.L   BF1_ACT
    BNE     TRY_BF2
    MOVE.L  #0,         BF1_X
    MOVE.L  #GROUND_Y,  BF1_Y
    MOVE.L  D0,         BF1_DX
    MOVE.L  #1,         BF1_ACT
    RTS
TRY_BF2:
    TST.L   BF2_ACT
    BNE     SPBLU_DONE
    MOVE.L  #0,         BF2_X
    MOVE.L  #GROUND_Y,  BF2_Y
    MOVE.L  D0,         BF2_DX
    MOVE.L  #1,         BF2_ACT
SPBLU_DONE:
    RTS

*-----------------------------------------------------------
* SPAWN_GREEN
* Tries to add a green fly. Jump over them for points.
*-----------------------------------------------------------
SPAWN_GREEN:
    JSR     CALC_SPEED
    TST.L   GF0_ACT
    BNE     TRY_GF1
    MOVE.L  #0,         GF0_X
    MOVE.L  #GROUND_Y,  GF0_Y
    MOVE.L  D0,         GF0_DX
    MOVE.L  #0,         GF0_JUMPED
    MOVE.L  #1,         GF0_ACT
    RTS
TRY_GF1:
    TST.L   GF1_ACT
    BNE     TRY_GF2
    MOVE.L  #0,         GF1_X
    MOVE.L  #GROUND_Y,  GF1_Y
    MOVE.L  D0,         GF1_DX
    MOVE.L  #0,         GF1_JUMPED
    MOVE.L  #1,         GF1_ACT
    RTS
TRY_GF2:
    TST.L   GF2_ACT
    BNE     SPGRN_DONE
    MOVE.L  #0,         GF2_X
    MOVE.L  #GROUND_Y,  GF2_Y
    MOVE.L  D0,         GF2_DX
    MOVE.L  #0,         GF2_JUMPED
    MOVE.L  #1,         GF2_ACT
SPGRN_DONE:
    RTS

*-----------------------------------------------------------
* CALC_SPEED
* Figures out how fast flies should move right now.
* Starts slow and gets faster as your score goes up.
*-----------------------------------------------------------
CALC_SPEED:
    * Works out how fast new flies should move based on your score.
    * Starts at speed 3 and goes up by 1 every 50 points, max speed is 8.
    MOVE.L  SCORE, D0
    DIVU    #50, D0             * every 50 points adds 1 to the speed
    AND.L   #$FFFF, D0          * drop the leftover, keep the whole number
    ADD.L   #3, D0              * add the starting speed of 3
    CMP.L   #8, D0              * is it over the limit?
    BLE     CS_DONE
    MOVE.L  #8, D0              * yes, stop it at 8
CS_DONE:
    RTS

*-----------------------------------------------------------
* MOVE_ALL_FLIES
* Moves every active fly along by its speed. Also removes flies
* that have gone off the right side or top of the screen.
*-----------------------------------------------------------
MOVE_ALL_FLIES:
    * Red fly 0 - move it, then remove it if it left the screen
    TST.L   RF0_ACT
    BEQ     MRF1
    MOVE.L  RF0_X, D0
    ADD.L   RF0_DX, D0
    MOVE.L  D0, RF0_X
    MOVE.L  RF0_Y, D1
    ADD.L   RF0_DY, D1
    MOVE.L  D1, RF0_Y
    CMP.L   #660, D0
    BGT     KILL_RF0
    CMP.L   #-10, D1            * gone off the top of the screen
    BGE     MRF1
KILL_RF0:
    MOVE.L  #0, RF0_ACT
    MOVE.L  #0, RF0_DY
MRF1:
    TST.L   RF1_ACT
    BEQ     MRF2
    MOVE.L  RF1_X, D0
    ADD.L   RF1_DX, D0
    MOVE.L  D0, RF1_X
    MOVE.L  RF1_Y, D1
    ADD.L   RF1_DY, D1
    MOVE.L  D1, RF1_Y
    CMP.L   #660, D0
    BGT     KILL_RF1
    CMP.L   #-10, D1
    BGE     MRF2
KILL_RF1:
    MOVE.L  #0, RF1_ACT
    MOVE.L  #0, RF1_DY
MRF2:
    TST.L   RF2_ACT
    BEQ     MBF0
    MOVE.L  RF2_X, D0
    ADD.L   RF2_DX, D0
    MOVE.L  D0, RF2_X
    MOVE.L  RF2_Y, D1
    ADD.L   RF2_DY, D1
    MOVE.L  D1, RF2_Y
    CMP.L   #660, D0
    BGT     KILL_RF2
    CMP.L   #-10, D1
    BGE     MBF0
KILL_RF2:
    MOVE.L  #0, RF2_ACT
    MOVE.L  #0, RF2_DY
MBF0:
    TST.L   BF0_ACT
    BEQ     MBF1
    MOVE.L  BF0_X, D0
    ADD.L   BF0_DX, D0
    MOVE.L  D0, BF0_X
    CMP.L   #660, D0
    BLE     MBF1
    MOVE.L  #0, BF0_ACT
MBF1:
    TST.L   BF1_ACT
    BEQ     MBF2
    MOVE.L  BF1_X, D0
    ADD.L   BF1_DX, D0
    MOVE.L  D0, BF1_X
    CMP.L   #660, D0
    BLE     MBF2
    MOVE.L  #0, BF1_ACT
MBF2:
    TST.L   BF2_ACT
    BEQ     MGF0
    MOVE.L  BF2_X, D0
    ADD.L   BF2_DX, D0
    MOVE.L  D0, BF2_X
    CMP.L   #660, D0
    BLE     MGF0
    MOVE.L  #0, BF2_ACT
    * Green flies - same deal
MGF0:
    TST.L   GF0_ACT
    BEQ     MGF1
    MOVE.L  GF0_X, D0
    ADD.L   GF0_DX, D0
    MOVE.L  D0, GF0_X
    CMP.L   #660, D0
    BLE     MGF1
    MOVE.L  #0, GF0_ACT
MGF1:
    TST.L   GF1_ACT
    BEQ     MGF2
    MOVE.L  GF1_X, D0
    ADD.L   GF1_DX, D0
    MOVE.L  D0, GF1_X
    CMP.L   #660, D0
    BLE     MGF2
    MOVE.L  #0, GF1_ACT
MGF2:
    TST.L   GF2_ACT
    BEQ     MALL_DONE
    MOVE.L  GF2_X, D0
    ADD.L   GF2_DX, D0
    MOVE.L  D0, GF2_X
    CMP.L   #660, D0
    BLE     MALL_DONE
    MOVE.L  #0, GF2_ACT
MALL_DONE:
    RTS

*-----------------------------------------------------------
* CHECK_ALL_COL
* Goes through every fly and checks if the frog is touching it.
*-----------------------------------------------------------
CHECK_ALL_COL:
    MOVE.L  COLOUR_STATE, D6

    TST.L   RF0_ACT
    BEQ     CAC_RF1
    MOVE.L  RF0_X, COL_FLY_X
    MOVE.L  RF0_Y, COL_FLY_Y
    JSR     TEST_HIT
    TST.L   D0
    BEQ     CAC_RF1
    JSR     DO_DAMAGE
    MOVE.L  #0, RF0_ACT

CAC_RF1:
    TST.L   RF1_ACT
    BEQ     CAC_RF2
    MOVE.L  RF1_X, COL_FLY_X
    MOVE.L  RF1_Y, COL_FLY_Y
    JSR     TEST_HIT
    TST.L   D0
    BEQ     CAC_RF2
    JSR     DO_DAMAGE
    MOVE.L  #0, RF1_ACT

CAC_RF2:
    TST.L   RF2_ACT
    BEQ     CAC_BF0
    MOVE.L  RF2_X, COL_FLY_X
    MOVE.L  RF2_Y, COL_FLY_Y
    JSR     TEST_HIT
    TST.L   D0
    BEQ     CAC_BF0
    JSR     DO_DAMAGE
    MOVE.L  #0, RF2_ACT

CAC_BF0:
    CMP.L   #COL_BLUE, D6
    BNE     CAC_DONE
    TST.L   BF0_ACT
    BEQ     CAC_BF1
    MOVE.L  BF0_X, COL_FLY_X
    MOVE.L  BF0_Y, COL_FLY_Y
    JSR     TEST_HIT
    TST.L   D0
    BEQ     CAC_BF1
    MOVE.L  SCORE, D0
    ADD.L   #10, D0
    MOVE.L  D0, SCORE
    MOVE.L  #0, BF0_ACT
CAC_BF1:
    TST.L   BF1_ACT
    BEQ     CAC_BF2
    MOVE.L  BF1_X, COL_FLY_X
    MOVE.L  BF1_Y, COL_FLY_Y
    JSR     TEST_HIT
    TST.L   D0
    BEQ     CAC_BF2
    MOVE.L  SCORE, D0
    ADD.L   #10, D0
    MOVE.L  D0, SCORE
    MOVE.L  #0, BF1_ACT
CAC_BF2:
    TST.L   BF2_ACT
    BEQ     CAC_DONE
    MOVE.L  BF2_X, COL_FLY_X
    MOVE.L  BF2_Y, COL_FLY_Y
    JSR     TEST_HIT
    TST.L   D0
    BEQ     CAC_DONE
    MOVE.L  SCORE, D0
    ADD.L   #10, D0
    MOVE.L  D0, SCORE
    MOVE.L  #0, BF2_ACT
CAC_DONE:
    * --- Green flies: jump over for points, touch = damage ---
    TST.L   GF0_ACT
    BEQ     CAC_GF1
    MOVE.L  GF0_X, COL_FLY_X
    MOVE.L  GF0_Y, COL_FLY_Y
    JSR     TEST_HIT
    TST.L   D0
    BEQ     CAC_GF0_JUMP
    JSR     DO_DAMAGE
    MOVE.L  #0, GF0_ACT
    BRA     CAC_GF1
CAC_GF0_JUMP:
    * Only give points if the frog is close enough horizontally
    MOVE.L  PLAYER_X, D0
    ADD.L   #26, D0             * middle of the frog
    MOVE.L  GF0_X, D1
    SUB.L   D1, D0              * how far apart are they
    BGE     GF0_XOK
    NEG.L   D0
GF0_XOK:
    CMP.L   #40, D0
    BGT     CAC_GF0_NOJUMP      * too far apart to count
    * Also check the frog is actually above the fly
    MOVE.L  PLAYER_Y, D0
    MOVE.L  GF0_Y, D1
    CMP.L   D1, D0
    BGE     CAC_GF0_NOJUMP      * frog is at the same level or below, doesnt count
    TST.L   GF0_JUMPED
    BNE     CAC_GF1
    MOVE.L  #1, GF0_JUMPED
    MOVE.L  SCORE, D0
    ADD.L   #5, D0
    MOVE.L  D0, SCORE
    BRA     CAC_GF1
CAC_GF0_NOJUMP:
    MOVE.L  #0, GF0_JUMPED
CAC_GF1:
    TST.L   GF1_ACT
    BEQ     CAC_GF2
    MOVE.L  GF1_X, COL_FLY_X
    MOVE.L  GF1_Y, COL_FLY_Y
    JSR     TEST_HIT
    TST.L   D0
    BEQ     CAC_GF1_JUMP
    JSR     DO_DAMAGE
    MOVE.L  #0, GF1_ACT
    BRA     CAC_GF2
CAC_GF1_JUMP:
    MOVE.L  PLAYER_X, D0
    ADD.L   #26, D0
    MOVE.L  GF1_X, D1
    SUB.L   D1, D0
    BGE     GF1_XOK
    NEG.L   D0
GF1_XOK:
    CMP.L   #40, D0
    BGT     CAC_GF1_NOJUMP
    MOVE.L  PLAYER_Y, D0
    MOVE.L  GF1_Y, D1
    CMP.L   D1, D0
    BGE     CAC_GF1_NOJUMP
    TST.L   GF1_JUMPED
    BNE     CAC_GF2
    MOVE.L  #1, GF1_JUMPED
    MOVE.L  SCORE, D0
    ADD.L   #5, D0
    MOVE.L  D0, SCORE
    BRA     CAC_GF2
CAC_GF1_NOJUMP:
    MOVE.L  #0, GF1_JUMPED
CAC_GF2:
    TST.L   GF2_ACT
    BEQ     CAC_ALL_DONE
    MOVE.L  GF2_X, COL_FLY_X
    MOVE.L  GF2_Y, COL_FLY_Y
    JSR     TEST_HIT
    TST.L   D0
    BEQ     CAC_GF2_JUMP
    JSR     DO_DAMAGE
    MOVE.L  #0, GF2_ACT
    BRA     CAC_ALL_DONE
CAC_GF2_JUMP:
    MOVE.L  PLAYER_X, D0
    ADD.L   #26, D0
    MOVE.L  GF2_X, D1
    SUB.L   D1, D0
    BGE     GF2_XOK
    NEG.L   D0
GF2_XOK:
    CMP.L   #40, D0
    BGT     CAC_GF2_NOJUMP
    MOVE.L  PLAYER_Y, D0
    MOVE.L  GF2_Y, D1
    CMP.L   D1, D0
    BGE     CAC_GF2_NOJUMP
    TST.L   GF2_JUMPED
    BNE     CAC_ALL_DONE
    MOVE.L  #1, GF2_JUMPED
    MOVE.L  SCORE, D0
    ADD.L   #5, D0
    MOVE.L  D0, SCORE
    BRA     CAC_ALL_DONE
CAC_GF2_NOJUMP:
    MOVE.L  #0, GF2_JUMPED
CAC_ALL_DONE:
    RTS

*-----------------------------------------------------------
* DO_RED_BLAST
* When you press space in red mode, all the red flies
* shoot straight up and disappear off the top of the screen.
*-----------------------------------------------------------
DO_RED_BLAST:
    TST.L   RF0_ACT
    BEQ     BLAST_RF1
    MOVE.L  #0,    RF0_DX      * stop moving sideways
    MOVE.L  #-12,  RF0_DY      * shoot it up fast
BLAST_RF1:
    TST.L   RF1_ACT
    BEQ     BLAST_RF2
    MOVE.L  #0,    RF1_DX      * stop moving sideways
    MOVE.L  #-12,  RF1_DY      * shoot it up fast
BLAST_RF2:
    TST.L   RF2_ACT
    BEQ     BLAST_DONE
    MOVE.L  #0,    RF2_DX      * stop moving sideways
    MOVE.L  #-12,  RF2_DY      * shoot it up fast
BLAST_DONE:
    RTS

*-----------------------------------------------------------
* DO_BLUE_ATTRACT
* While you hold space in blue mode, blue flies slide
* toward the frog. If they reach it they get absorbed for points.
*-----------------------------------------------------------
DO_BLUE_ATTRACT:
    MOVE.L  PLAYER_X, D3
    ADD.L   #26, D3             * middle of the frog

    * BF0
    TST.L   BF0_ACT
    BEQ     ATTR_BF1
    MOVE.L  BF0_X, D1
    ADD.L   #5, D1              * middle of the fly
    CMP.L   D3, D1
    BEQ     ATTR_BF0_CHECK      * fly is already right on the frog
    BGT     ATTR_BF0_LEFT       * fly is to the right, so move it left
    * fly is to the left, move it right
    MOVE.L  BF0_X, D0
    ADD.L   #3, D0
    MOVE.L  D0, BF0_X
    BRA     ATTR_BF0_CHECK
ATTR_BF0_LEFT:
    MOVE.L  BF0_X, D0
    SUB.L   #3, D0
    MOVE.L  D0, BF0_X
ATTR_BF0_CHECK:
    * Check if the fly has reached the frog
    MOVE.L  BF0_X, COL_FLY_X
    MOVE.L  BF0_Y, COL_FLY_Y
    JSR     TEST_HIT
    TST.L   D0
    BEQ     ATTR_BF1
    MOVE.L  SCORE, D0
    ADD.L   #10, D0
    MOVE.L  D0, SCORE
    MOVE.L  #0, BF0_ACT

ATTR_BF1:
    TST.L   BF1_ACT
    BEQ     ATTR_BF2
    MOVE.L  BF1_X, D1
    ADD.L   #5, D1
    CMP.L   D3, D1
    BEQ     ATTR_BF1_CHECK      * already on the frog
    BGT     ATTR_BF1_LEFT       * fly is to the right, move it left
    MOVE.L  BF1_X, D0
    ADD.L   #3, D0
    MOVE.L  D0, BF1_X
    BRA     ATTR_BF1_CHECK
ATTR_BF1_LEFT:
    MOVE.L  BF1_X, D0
    SUB.L   #3, D0
    MOVE.L  D0, BF1_X
ATTR_BF1_CHECK:
    MOVE.L  BF1_X, COL_FLY_X
    MOVE.L  BF1_Y, COL_FLY_Y
    JSR     TEST_HIT
    TST.L   D0
    BEQ     ATTR_BF2
    MOVE.L  SCORE, D0
    ADD.L   #10, D0
    MOVE.L  D0, SCORE
    MOVE.L  #0, BF1_ACT

ATTR_BF2:
    TST.L   BF2_ACT
    BEQ     ATTR_DONE
    MOVE.L  BF2_X, D1
    ADD.L   #5, D1
    CMP.L   D3, D1
    BEQ     ATTR_BF2_CHECK      * already on the frog
    BGT     ATTR_BF2_LEFT       * fly is to the right, move it left
    MOVE.L  BF2_X, D0
    ADD.L   #3, D0
    MOVE.L  D0, BF2_X
    BRA     ATTR_BF2_CHECK
ATTR_BF2_LEFT:
    MOVE.L  BF2_X, D0
    SUB.L   #3, D0
    MOVE.L  D0, BF2_X
ATTR_BF2_CHECK:
    MOVE.L  BF2_X, COL_FLY_X
    MOVE.L  BF2_Y, COL_FLY_Y
    JSR     TEST_HIT
    TST.L   D0
    BEQ     ATTR_DONE
    MOVE.L  SCORE, D0
    ADD.L   #10, D0
    MOVE.L  D0, SCORE
    MOVE.L  #0, BF2_ACT

ATTR_DONE:
    RTS

*-----------------------------------------------------------
* DO_DAMAGE
* Takes away one health pip when the frog gets hit.
* Has a short cooldown so one touch doesnt drain all your health.
*-----------------------------------------------------------
DO_DAMAGE:
    MOVE.L  HIT_COOLDOWN, D0        * are we still in the brief no-damage window after last hit?
    BNE     DMG_SKIP                * yes - ignore this hit
    MOVE.L  HEALTH, D0
    SUB.L   #1, D0                  * lose one health pip
    MOVE.L  D0, HEALTH
    MOVE.L  #10, HIT_COOLDOWN      * wait 10 frames before taking damage again
DMG_SKIP:
    RTS

*-----------------------------------------------------------
* TEST_HIT
* Checks if the frog is touching a fly.
* Uses the positions in COL_FLY_X/Y and PLAYER_X/Y.
* Returns D0=1 if touching, D0=0 if not.
*-----------------------------------------------------------
TEST_HIT:
    MOVE.L  COL_FLY_X, D1
    ADD.L   #FLY_W, D1
    MOVE.L  PLAYER_X, D2
    ADD.L   #10, D2
    CMP.L   D2, D1
    BLT     TH_MISS
    MOVE.L  COL_FLY_X, D1
    MOVE.L  PLAYER_X, D2
    ADD.L   #FROG_SPRITE_W-10, D2
    CMP.L   D2, D1
    BGT     TH_MISS
    MOVE.L  COL_FLY_Y, D1
    ADD.L   #FLY_H, D1
    MOVE.L  PLAYER_Y, D2
    ADD.L   #6, D2
    CMP.L   D2, D1
    BLT     TH_MISS
    MOVE.L  COL_FLY_Y, D1
    MOVE.L  PLAYER_Y, D2
    ADD.L   #FROG_SPRITE_H, D2
    CMP.L   D2, D1
    BGT     TH_MISS
    MOVE.L  #1, D0
    RTS
TH_MISS:
    MOVE.L  #0, D0
    RTS

    INCLUDE "FROG_DRAW_FLIES.X68"
    INCLUDE "FROG_DRAW_HUD.X68"
    INCLUDE "FROG_DRAW.X68"
    INCLUDE "FROG_DRAW_MUSTACHE.X68"

*-----------------------------------------------------------
* QUIT_GAME
* ESC was pressed, shut everything down.
*-----------------------------------------------------------
QUIT_GAME:
    MOVE.B  #9, D0
    TRAP    #15

* No END here - this file is included by FROG_MENU.X68 which has the entry point


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
