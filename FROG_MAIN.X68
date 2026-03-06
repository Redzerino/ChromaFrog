*-----------------------------------------------------------
* Title      : FROG_MAIN (Enhanced)
* Description: Frog movement (A/D), colour cycle (C),
*              GREEN = jump (SPACE), RED = repel red flies,
*              BLUE = absorb blue flies (score),
*              Red flies damage health if not in red mode.
*              Health pips + score + high score on HUD.
*
* Trap 15 tasks used:
*   19  - read multiple keys simultaneously
*   33  - open graphics window (D1=W, D2=H)
*   80  - set pen colour  (D1=$00BBGGRR)
*   81  - set fill colour (D1=$00BBGGRR)
*   87  - draw filled rectangle (D1=LX D2=UY D3=RX D4=LY)
*   88  - draw filled ellipse   (D1=LX D2=UY D3=RX D4=LY)
*   92  - set draw mode (D1=17 enable buffer, D1=4 normal)
*   94  - repaint / flip buffer to screen
*   95  - draw text string at X,Y (A1=str, D1=X, D2=Y)
*   15  - display integer D1 at cursor  (used for score)
*-----------------------------------------------------------

*-----------------------------------------------------------
* Constants
*-----------------------------------------------------------
MOVE_SPEED          equ 3
SCREEN_W            equ 640
SCREEN_H            equ 480
FROG_SPRITE_W       equ 52
FROG_SPRITE_H       equ 36
GROUND_Y            equ 320

COL_GREEN           equ 0
COL_RED             equ 1
COL_BLUE            equ 2

FROG_GREEN_MID_G    equ $0038C100
FROG_GREEN_LIGHT_G  equ $0055DD11
FROG_GREEN_MID_R    equ $00CC0000
FROG_GREEN_LIGHT_R  equ $00FF3300
FROG_GREEN_MID_B    equ $000055FF
FROG_GREEN_LIGHT_B  equ $000099FF

FLY_W               equ 10
FLY_H               equ 8
MAX_HEALTH          equ 5
JUMP_VEL            equ -12
GRAVITY             equ 1

COL_BG              equ $00132213
COL_GROUND          equ $00224422
COL_GROUND_LT       equ $002A5522
COL_RED_FLY         equ $000022FF
COL_BLUE_FLY        equ $00FF6622
COL_WHITE           equ $00FFFFFF
COL_YELLOW          equ $0000EEFF
COL_HP_FULL         equ $004444FF
COL_HP_EMPTY        equ $00111144
COL_SCORE_C         equ $00FFC84D
COL_WING_B          equ $00FFAAAA
COL_WING_R          equ $00AAAAFF
COL_GREEN_FLY       equ $0000CC00
COL_WING_G          equ $0000FF44

*-----------------------------------------------------------
* Variables
*-----------------------------------------------------------
    ORG     $5000
POS_X               DS.L 1
POS_Y               DS.L 1
PLAYER_X            DS.L 1
PLAYER_Y            DS.L 1
PLYR_DIRECTION_X    DS.L 1
IS_FLIPPED          DS.L 1
COLOUR_STATE        DS.L 1
FROG_GREEN_MID      DS.L 1
FROG_GREEN_LIGHT    DS.L 1
PREV_C_STATE        DS.L 1
PREV_SP_STATE       DS.L 1

VEL_Y               DS.L 1
ON_GROUND           DS.L 1

HEALTH              DS.L 1
SCORE               DS.L 1
HIGH_SCORE          DS.L 1
HIT_COOLDOWN        DS.L 1

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

* Green flies: 3 slots (ground level, jump over for points)
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

* Tracks whether frog was above each green fly last frame (for jump-over scoring)
GF0_JUMPED          DS.L 1
GF1_JUMPED          DS.L 1
GF2_JUMPED          DS.L 1

* Red fly vertical velocity (for blast-to-sky)
RF0_DY              DS.L 1
RF1_DY              DS.L 1
RF2_DY              DS.L 1

WING_TIMER          DS.L 1
FRAME_COUNT         DS.L 1
REPEL_TIMER         DS.L 1

COL_FLY_X          DS.L 1
COL_FLY_Y          DS.L 1

*-----------------------------------------------------------
* Entry
*-----------------------------------------------------------
    ORG     $1000
START:
    * Open 640x480 graphics window
    MOVE.L  #640,   D1
    MOVE.L  #480,   D2
    MOVE.B  #33,    D0
    TRAP    #15

    * Enable double buffering
    MOVE.L  #17,    D1
    MOVE.B  #92,    D0
    TRAP    #15

    JSR     RESET_GAME
    JSR     INIT_FLIES

*-----------------------------------------------------------
* GAME LOOP
*-----------------------------------------------------------
GAME_LOOP:
    * Increment counters
    MOVE.L  FRAME_COUNT, D0
    ADD.L   #1, D0
    MOVE.L  D0, FRAME_COUNT

    MOVE.L  WING_TIMER, D0
    ADD.L   #1, D0
    CMP.L   #8, D0
    BLT     WING_OK
    MOVE.L  #0, D0
WING_OK:
    MOVE.L  D0, WING_TIMER

    MOVE.L  HIT_COOLDOWN, D0
    BEQ     NO_CD
    SUB.L   #1, D0
    MOVE.L  D0, HIT_COOLDOWN
NO_CD:

    MOVE.L  REPEL_TIMER, D0
    BEQ     NO_REP
    SUB.L   #1, D0
    MOVE.L  D0, REPEL_TIMER
NO_REP:

    * Read keys: A D C SPACE
    MOVE.L  #'A'<<24|'D'<<16|'C'<<8|' ', D1
    MOVE.B  #19,    D0
    TRAP    #15
    MOVE.L  D1,     D5

    MOVE.L  #0,     PLYR_DIRECTION_X

    * A key (bit 31)
    BTST.L  #31,    D5
    BEQ     CHECK_D
    MOVE.L  #-1,    PLYR_DIRECTION_X
    MOVE.L  PLAYER_X, D0
    SUB.L   #MOVE_SPEED, D0
    BGE     OK_LEFT
    MOVE.L  #0, D0
OK_LEFT:
    MOVE.L  D0, PLAYER_X

CHECK_D:
    BTST.L  #23,    D5
    BEQ     CHECK_C
    MOVE.L  #1,     PLYR_DIRECTION_X
    MOVE.L  PLAYER_X, D0
    ADD.L   #MOVE_SPEED, D0
    MOVE.L  #SCREEN_W-FROG_SPRITE_W, D1
    CMP.L   D1, D0
    BLE     OK_RIGHT
    MOVE.L  D1, D0
OK_RIGHT:
    MOVE.L  D0, PLAYER_X

CHECK_C:
    BTST.L  #15,    D5
    BEQ     C_UP
    TST.L   PREV_C_STATE
    BNE     SKIP_CYCLE

    MOVE.L  COLOUR_STATE, D0
    ADD.L   #1, D0
    CMP.L   #3, D0
    BNE     SAVE_CS
    MOVE.L  #0, D0
SAVE_CS:
    MOVE.L  D0, COLOUR_STATE

    CMP.L   #COL_RED,  D0
    BEQ     DO_RED
    CMP.L   #COL_BLUE, D0
    BEQ     DO_BLUE
DO_GREEN:
    MOVE.L  #FROG_GREEN_MID_G,   FROG_GREEN_MID
    MOVE.L  #FROG_GREEN_LIGHT_G, FROG_GREEN_LIGHT
    BRA     SKIP_CYCLE
DO_RED:
    MOVE.L  #FROG_GREEN_MID_R,   FROG_GREEN_MID
    MOVE.L  #FROG_GREEN_LIGHT_R, FROG_GREEN_LIGHT
    BRA     SKIP_CYCLE
DO_BLUE:
    MOVE.L  #FROG_GREEN_MID_B,   FROG_GREEN_MID
    MOVE.L  #FROG_GREEN_LIGHT_B, FROG_GREEN_LIGHT

SKIP_CYCLE:
    MOVE.L  #1, PREV_C_STATE
    BRA     CHECK_JUMP
C_UP:
    MOVE.L  #0, PREV_C_STATE

CHECK_JUMP:
    * Space pressed?
    BTST.L  #7, D5
    BEQ     SP_NOT_PRESSED

    * --- GREEN: jump (only on ground, edge-triggered) ---
    MOVE.L  COLOUR_STATE, D0
    CMP.L   #COL_GREEN, D0
    BNE     SP_TRY_RED
    TST.L   ON_GROUND
    BEQ     DO_PHYSICS
    TST.L   PREV_SP_STATE
    BNE     DO_PHYSICS          * already held, no repeat jump
    MOVE.L  #JUMP_VEL, VEL_Y
    MOVE.L  #0, ON_GROUND
    BRA     SP_HELD

    * --- RED: blast - repel all red flies, despawn if close ---
SP_TRY_RED:
    CMP.L   #COL_RED, D0
    BNE     SP_TRY_BLUE
    TST.L   PREV_SP_STATE
    BNE     DO_PHYSICS          * hold does nothing, edge only
    JSR     DO_RED_BLAST
    BRA     SP_HELD

    * --- BLUE: attract blue flies toward frog (held) ---
SP_TRY_BLUE:
    JSR     DO_BLUE_ATTRACT

SP_HELD:
    MOVE.L  #1, PREV_SP_STATE
    BRA     DO_PHYSICS

SP_NOT_PRESSED:
    MOVE.L  #0, PREV_SP_STATE

DO_PHYSICS:
    TST.L   ON_GROUND
    BNE     PHYS_SKIP
    MOVE.L  VEL_Y, D0
    ADD.L   #GRAVITY, D0
    MOVE.L  D0, VEL_Y
    MOVE.L  PLAYER_Y, D1
    ADD.L   D0, D1
    CMP.L   #GROUND_Y, D1
    BLE     PHYS_APPLY
    MOVE.L  #GROUND_Y, D1
    MOVE.L  #0, VEL_Y
    MOVE.L  #1, ON_GROUND
PHYS_APPLY:
    MOVE.L  D1, PLAYER_Y
PHYS_SKIP:

    JSR     MAYBE_SPAWN
    JSR     MOVE_ALL_FLIES
    JSR     CHECK_ALL_COL

    * Update high score
    MOVE.L  SCORE, D0
    MOVE.L  HIGH_SCORE, D1
    CMP.L   D1, D0
    BLE     NO_HS
    MOVE.L  D0, HIGH_SCORE
NO_HS:

    * Draw everything to back buffer
    JSR     DRAW_BACKGROUND
    JSR     DRAW_ALL_FLIES
    JSR     DRAW_FROG
    JSR     DRAW_HUD

    * Flip buffer to screen
    MOVE.B  #94,    D0
    TRAP    #15

    * Delay
    MOVE.L  #15000, D1
DLY:
    SUB.L   #1, D1
    BNE     DLY

    * Game over check
    MOVE.L  HEALTH, D0
    BNE     GAME_LOOP

*-----------------------------------------------------------
* GAME OVER
*-----------------------------------------------------------
GAME_OVER:
    JSR     DRAW_BACKGROUND

    MOVE.L  #COL_RED_FLY, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #COL_RED_FLY, D1
    JSR     SET_FILL_COLOR
    MOVE.L  #220, D1
    MOVE.L  #160, D2
    MOVE.L  #420, D3
    MOVE.L  #200, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  #COL_WHITE, D1
    JSR     SET_PEN_COLOR
    LEA     STR_GO, A1
    MOVE.L  #240, D1
    MOVE.L  #170, D2
    MOVE.B  #95, D0
    TRAP    #15

    MOVE.L  #COL_SCORE_C, D1
    JSR     SET_PEN_COLOR
    LEA     STR_SCORE, A1
    MOVE.L  #200, D1
    MOVE.L  #220, D2
    MOVE.B  #95, D0
    TRAP    #15

    * Draw score number as text via task 15 workaround
    * Store score as string - use task 95 with number
    * Easy68K task 15 writes to text console not graphics
    * So we draw score digit boxes instead
    JSR     DRAW_SCORE_GRAPHIC

    MOVE.L  #COL_YELLOW, D1
    JSR     SET_PEN_COLOR
    LEA     STR_BEST, A1
    MOVE.L  #200, D1
    MOVE.L  #250, D2
    MOVE.B  #95, D0
    TRAP    #15

    JSR     DRAW_HISCORE_GRAPHIC

    MOVE.L  #COL_WHITE, D1
    JSR     SET_PEN_COLOR
    LEA     STR_RESTART, A1
    MOVE.L  #175, D1
    MOVE.L  #300, D2
    MOVE.B  #95, D0
    TRAP    #15

    MOVE.B  #94, D0
    TRAP    #15

WAIT_SP:
    MOVE.L  #' '<<24, D1
    MOVE.B  #19, D0
    TRAP    #15
    BTST.L  #31, D1
    BEQ     WAIT_SP

    JSR     RESET_GAME
    JSR     INIT_FLIES
    BRA     GAME_LOOP

*-----------------------------------------------------------
* RESET_GAME
*-----------------------------------------------------------
RESET_GAME:
    MOVE.L  #294,        PLAYER_X
    MOVE.L  #GROUND_Y,   PLAYER_Y
    MOVE.L  #0,          PLYR_DIRECTION_X
    MOVE.L  #0,          IS_FLIPPED
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
    MOVE.L  #0,          REPEL_TIMER
    MOVE.L  #0,          FRAME_COUNT
    MOVE.L  #0,          WING_TIMER
    RTS

*-----------------------------------------------------------
* INIT_FLIES
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
*-----------------------------------------------------------
MAYBE_SPAWN:
    MOVE.L  FRAME_COUNT, D0

    * Spawn red fly every 80 frames
    MOVE.L  D0, D1
    DIVU    #80, D1
    SWAP    D1
    AND.L   #$FFFF, D1
    BNE     CHK_BLUE_SP
    JSR     SPAWN_RED

CHK_BLUE_SP:
    * Spawn blue fly every 100 frames
    MOVE.L  D0, D1
    DIVU    #100, D1
    SWAP    D1
    AND.L   #$FFFF, D1
    BNE     CHK_GREEN_SP
    JSR     SPAWN_BLUE

CHK_GREEN_SP:
    * Spawn green fly every 60 frames
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
*-----------------------------------------------------------
SPAWN_RED:
    TST.L   RF0_ACT
    BNE     TRY_RF1
    MOVE.L  #0,    RF0_X
    MOVE.L  #GROUND_Y,  RF0_Y
    MOVE.L  #3,    RF0_DX
    MOVE.L  #0,    RF0_DY
    MOVE.L  #1,    RF0_ACT
    RTS
TRY_RF1:
    TST.L   RF1_ACT
    BNE     TRY_RF2
    MOVE.L  #0,    RF1_X
    MOVE.L  #GROUND_Y,  RF1_Y
    MOVE.L  #4,    RF1_DX
    MOVE.L  #0,    RF1_DY
    MOVE.L  #1,    RF1_ACT
    RTS
TRY_RF2:
    TST.L   RF2_ACT
    BNE     SPRED_DONE
    MOVE.L  #0,    RF2_X
    MOVE.L  #GROUND_Y,  RF2_Y
    MOVE.L  #3,    RF2_DX
    MOVE.L  #0,    RF2_DY
    MOVE.L  #1,    RF2_ACT
SPRED_DONE:
    RTS

*-----------------------------------------------------------
* SPAWN_BLUE
*-----------------------------------------------------------
SPAWN_BLUE:
    TST.L   BF0_ACT
    BNE     TRY_BF1
    MOVE.L  #0,    BF0_X
    MOVE.L  #GROUND_Y,  BF0_Y
    MOVE.L  #4,    BF0_DX
    MOVE.L  #1,    BF0_ACT
    RTS
TRY_BF1:
    TST.L   BF1_ACT
    BNE     TRY_BF2
    MOVE.L  #0,    BF1_X
    MOVE.L  #GROUND_Y,  BF1_Y
    MOVE.L  #3,    BF1_DX
    MOVE.L  #1,    BF1_ACT
    RTS
TRY_BF2:
    TST.L   BF2_ACT
    BNE     SPBLU_DONE
    MOVE.L  #0,    BF2_X
    MOVE.L  #GROUND_Y,  BF2_Y
    MOVE.L  #4,    BF2_DX
    MOVE.L  #1,    BF2_ACT
SPBLU_DONE:
    RTS

*-----------------------------------------------------------
* SPAWN_GREEN - ground level flies, jump over for points
*-----------------------------------------------------------
SPAWN_GREEN:
    TST.L   GF0_ACT
    BNE     TRY_GF1
    MOVE.L  #0,    GF0_X
    MOVE.L  #GROUND_Y,  GF0_Y
    MOVE.L  #3,    GF0_DX
    MOVE.L  #0,    GF0_ACT
    MOVE.L  #0,    GF0_JUMPED
    MOVE.L  #1,    GF0_ACT
    RTS
TRY_GF1:
    TST.L   GF1_ACT
    BNE     TRY_GF2
    MOVE.L  #0,    GF1_X
    MOVE.L  #GROUND_Y,  GF1_Y
    MOVE.L  #4,    GF1_DX
    MOVE.L  #0,    GF1_JUMPED
    MOVE.L  #1,    GF1_ACT
    RTS
TRY_GF2:
    TST.L   GF2_ACT
    BNE     SPGRN_DONE
    MOVE.L  #0,    GF2_X
    MOVE.L  #GROUND_Y,  GF2_Y
    MOVE.L  #3,    GF2_DX
    MOVE.L  #0,    GF2_JUMPED
    MOVE.L  #1,    GF2_ACT
SPGRN_DONE:
    RTS

*-----------------------------------------------------------
* MOVE_ALL_FLIES
*-----------------------------------------------------------
MOVE_ALL_FLIES:
    * RF0 - move X and Y (DY set when blasted)
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
    CMP.L   #-10, D1            * flew off top of screen
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
    * Green flies
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
    MOVE.L  PLAYER_Y, D0
    MOVE.L  GF0_Y, D1
    CMP.L   D1, D0
    BGE     CAC_GF0_NOJUMP
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
* Edge-triggered on Space in RED mode.
* All active red flies get a strong upward velocity - they
* fly straight off the top of the screen and despawn.
*-----------------------------------------------------------
DO_RED_BLAST:
    TST.L   RF0_ACT
    BEQ     BLAST_RF1
    MOVE.L  #0,    RF0_DX      * stop horizontal movement
    MOVE.L  #-12,  RF0_DY      * shoot upward fast
BLAST_RF1:
    TST.L   RF1_ACT
    BEQ     BLAST_RF2
    MOVE.L  #0,    RF1_DX
    MOVE.L  #-12,  RF1_DY
BLAST_RF2:
    TST.L   RF2_ACT
    BEQ     BLAST_DONE
    MOVE.L  #0,    RF2_DX
    MOVE.L  #-12,  RF2_DY
BLAST_DONE:
    MOVE.L  #30, REPEL_TIMER
    RTS

*-----------------------------------------------------------
* DO_BLUE_ATTRACT
* Called every frame Space is held in BLUE mode.
* Moves each active blue fly 3px toward frog centre X.
* If fly overlaps frog, absorb it for points.
*-----------------------------------------------------------
DO_BLUE_ATTRACT:
    MOVE.L  PLAYER_X, D3
    ADD.L   #26, D3             * frog centre X

    * BF0
    TST.L   BF0_ACT
    BEQ     ATTR_BF1
    MOVE.L  BF0_X, D1
    ADD.L   #5, D1              * fly centre X
    CMP.L   D3, D1
    BEQ     ATTR_BF0_CHECK      * already at centre
    BGT     ATTR_BF0_LEFT       * fly is right of frog, move left
    * fly is left of frog, move right
    MOVE.L  BF0_X, D0
    ADD.L   #3, D0
    MOVE.L  D0, BF0_X
    BRA     ATTR_BF0_CHECK
ATTR_BF0_LEFT:
    MOVE.L  BF0_X, D0
    SUB.L   #3, D0
    MOVE.L  D0, BF0_X
ATTR_BF0_CHECK:
    * Absorb if overlapping frog
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
    BEQ     ATTR_BF1_CHECK
    BGT     ATTR_BF1_LEFT
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
    BEQ     ATTR_BF2_CHECK
    BGT     ATTR_BF2_LEFT
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
*-----------------------------------------------------------
DO_DAMAGE:
    MOVE.L  HIT_COOLDOWN, D0
    BNE     DMG_SKIP
    MOVE.L  HEALTH, D0
    SUB.L   #1, D0
    MOVE.L  D0, HEALTH
    MOVE.L  #60, HIT_COOLDOWN
DMG_SKIP:
    RTS

*-----------------------------------------------------------
* TEST_HIT  uses COL_FLY_X/Y vs PLAYER_X/Y
* Returns D0=1 hit, D0=0 miss
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

*-----------------------------------------------------------
* DRAW_BACKGROUND
* Fills sky and ground into back buffer
*-----------------------------------------------------------
DRAW_BACKGROUND:
    MOVE.L  #COL_BG, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #COL_BG, D1
    JSR     SET_FILL_COLOR
    MOVE.L  #0,   D1
    MOVE.L  #0,   D2
    MOVE.L  #639, D3
    MOVE.L  #GROUND_Y+20, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  #COL_GROUND, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #COL_GROUND, D1
    JSR     SET_FILL_COLOR
    MOVE.L  #0,   D1
    MOVE.L  #GROUND_Y+20, D2
    MOVE.L  #639, D3
    MOVE.L  #479, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  #COL_GROUND_LT, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #COL_GROUND_LT, D1
    JSR     SET_FILL_COLOR
    MOVE.L  #0,   D1
    MOVE.L  #GROUND_Y+20, D2
    MOVE.L  #639, D3
    MOVE.L  #GROUND_Y+26, D4
    MOVE.B  #87, D0
    TRAP    #15
    RTS

*-----------------------------------------------------------
* DRAW_ALL_FLIES
*-----------------------------------------------------------
DRAW_ALL_FLIES:
    MOVE.L  WING_TIMER, D6
    CMP.L   #4, D6
    BLT     DAFW_UP
    MOVE.L  #2, D6
    BRA     DAFW_SET
DAFW_UP:
    MOVE.L  #-2, D6
DAFW_SET:
    TST.L   RF0_ACT
    BEQ     DAF_RF1
    MOVE.L  RF0_X, COL_FLY_X
    MOVE.L  RF0_Y, COL_FLY_Y
    JSR     DRAW_RED_FLY
DAF_RF1:
    TST.L   RF1_ACT
    BEQ     DAF_RF2
    MOVE.L  RF1_X, COL_FLY_X
    MOVE.L  RF1_Y, COL_FLY_Y
    JSR     DRAW_RED_FLY
DAF_RF2:
    TST.L   RF2_ACT
    BEQ     DAF_BF0
    MOVE.L  RF2_X, COL_FLY_X
    MOVE.L  RF2_Y, COL_FLY_Y
    JSR     DRAW_RED_FLY
DAF_BF0:
    TST.L   BF0_ACT
    BEQ     DAF_BF1
    MOVE.L  BF0_X, COL_FLY_X
    MOVE.L  BF0_Y, COL_FLY_Y
    JSR     DRAW_BLUE_FLY
DAF_BF1:
    TST.L   BF1_ACT
    BEQ     DAF_BF2
    MOVE.L  BF1_X, COL_FLY_X
    MOVE.L  BF1_Y, COL_FLY_Y
    JSR     DRAW_BLUE_FLY
DAF_BF2:
    TST.L   BF2_ACT
    BEQ     DAF_GF0
    MOVE.L  BF2_X, COL_FLY_X
    MOVE.L  BF2_Y, COL_FLY_Y
    JSR     DRAW_BLUE_FLY
DAF_GF0:
    TST.L   GF0_ACT
    BEQ     DAF_GF1
    MOVE.L  GF0_X, COL_FLY_X
    MOVE.L  GF0_Y, COL_FLY_Y
    JSR     DRAW_GREEN_FLY
DAF_GF1:
    TST.L   GF1_ACT
    BEQ     DAF_GF2
    MOVE.L  GF1_X, COL_FLY_X
    MOVE.L  GF1_Y, COL_FLY_Y
    JSR     DRAW_GREEN_FLY
DAF_GF2:
    TST.L   GF2_ACT
    BEQ     DAF_DONE
    MOVE.L  GF2_X, COL_FLY_X
    MOVE.L  GF2_Y, COL_FLY_Y
    JSR     DRAW_GREEN_FLY
DAF_DONE:
    RTS

*-----------------------------------------------------------
* DRAW_RED_FLY  reads COL_FLY_X/Y, D6=wing offset
*-----------------------------------------------------------
DRAW_RED_FLY:
    MOVE.L  #COL_WING_R, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #COL_WING_R, D1
    JSR     SET_FILL_COLOR
    * Left wing
    MOVE.L  COL_FLY_X, D1
    SUB.L   #4, D1
    MOVE.L  COL_FLY_Y, D2
    ADD.L   D6, D2
    MOVE.L  COL_FLY_X, D3
    MOVE.L  D2, D4
    ADD.L   #4, D4
    MOVE.B  #87, D0
    TRAP    #15
    * Right wing
    MOVE.L  COL_FLY_X, D1
    ADD.L   #FLY_W, D1
    MOVE.L  COL_FLY_Y, D2
    ADD.L   D6, D2
    MOVE.L  D1, D3
    ADD.L   #4, D3
    MOVE.L  D2, D4
    ADD.L   #4, D4
    MOVE.B  #87, D0
    TRAP    #15
    * Body
    MOVE.L  #COL_RED_FLY, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #COL_RED_FLY, D1
    JSR     SET_FILL_COLOR
    MOVE.L  COL_FLY_X, D1
    MOVE.L  COL_FLY_Y, D2
    MOVE.L  D1, D3
    ADD.L   #FLY_W, D3
    MOVE.L  D2, D4
    ADD.L   #FLY_H, D4
    MOVE.B  #87, D0
    TRAP    #15
    * Eye
    MOVE.L  #COL_WHITE, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #COL_WHITE, D1
    JSR     SET_FILL_COLOR
    MOVE.L  COL_FLY_X, D1
    ADD.L   #1, D1
    MOVE.L  COL_FLY_Y, D2
    ADD.L   #1, D2
    MOVE.L  D1, D3
    ADD.L   #2, D3
    MOVE.L  D2, D4
    ADD.L   #2, D4
    MOVE.B  #87, D0
    TRAP    #15
    RTS

*-----------------------------------------------------------
* DRAW_BLUE_FLY  reads COL_FLY_X/Y, D6=wing offset
*-----------------------------------------------------------
DRAW_BLUE_FLY:
    MOVE.L  #COL_WING_B, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #COL_WING_B, D1
    JSR     SET_FILL_COLOR
    * Left wing
    MOVE.L  COL_FLY_X, D1
    SUB.L   #4, D1
    MOVE.L  COL_FLY_Y, D2
    ADD.L   D6, D2
    MOVE.L  COL_FLY_X, D3
    MOVE.L  D2, D4
    ADD.L   #4, D4
    MOVE.B  #87, D0
    TRAP    #15
    * Right wing
    MOVE.L  COL_FLY_X, D1
    ADD.L   #FLY_W, D1
    MOVE.L  COL_FLY_Y, D2
    ADD.L   D6, D2
    MOVE.L  D1, D3
    ADD.L   #4, D3
    MOVE.L  D2, D4
    ADD.L   #4, D4
    MOVE.B  #87, D0
    TRAP    #15
    * Body
    MOVE.L  #COL_BLUE_FLY, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #COL_BLUE_FLY, D1
    JSR     SET_FILL_COLOR
    MOVE.L  COL_FLY_X, D1
    MOVE.L  COL_FLY_Y, D2
    MOVE.L  D1, D3
    ADD.L   #FLY_W, D3
    MOVE.L  D2, D4
    ADD.L   #FLY_H, D4
    MOVE.B  #87, D0
    TRAP    #15
    * Eye
    MOVE.L  #COL_WHITE, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #COL_WHITE, D1
    JSR     SET_FILL_COLOR
    MOVE.L  COL_FLY_X, D1
    ADD.L   #1, D1
    MOVE.L  COL_FLY_Y, D2
    ADD.L   #1, D2
    MOVE.L  D1, D3
    ADD.L   #2, D3
    MOVE.L  D2, D4
    ADD.L   #2, D4
    MOVE.B  #87, D0
    TRAP    #15
    RTS

*-----------------------------------------------------------
* DRAW_GREEN_FLY  reads COL_FLY_X/Y, D6=wing offset
* Ground-level fly - slightly larger to be visible
*-----------------------------------------------------------
DRAW_GREEN_FLY:
    * Left wing
    MOVE.L  #COL_WING_G, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #COL_WING_G, D1
    JSR     SET_FILL_COLOR
    MOVE.L  COL_FLY_X, D1
    SUB.L   #5, D1
    MOVE.L  COL_FLY_Y, D2
    ADD.L   D6, D2
    MOVE.L  COL_FLY_X, D3
    MOVE.L  D2, D4
    ADD.L   #5, D4
    MOVE.B  #87, D0
    TRAP    #15
    * Right wing
    MOVE.L  COL_FLY_X, D1
    ADD.L   #FLY_W, D1
    MOVE.L  COL_FLY_Y, D2
    ADD.L   D6, D2
    MOVE.L  D1, D3
    ADD.L   #5, D3
    MOVE.L  D2, D4
    ADD.L   #5, D4
    MOVE.B  #87, D0
    TRAP    #15
    * Body
    MOVE.L  #COL_GREEN_FLY, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #COL_GREEN_FLY, D1
    JSR     SET_FILL_COLOR
    MOVE.L  COL_FLY_X, D1
    MOVE.L  COL_FLY_Y, D2
    MOVE.L  D1, D3
    ADD.L   #FLY_W, D3
    MOVE.L  D2, D4
    ADD.L   #FLY_H, D4
    MOVE.B  #87, D0
    TRAP    #15
    * Eye
    MOVE.L  #COL_WHITE, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #COL_WHITE, D1
    JSR     SET_FILL_COLOR
    MOVE.L  COL_FLY_X, D1
    ADD.L   #1, D1
    MOVE.L  COL_FLY_Y, D2
    ADD.L   #1, D2
    MOVE.L  D1, D3
    ADD.L   #2, D3
    MOVE.L  D2, D4
    ADD.L   #2, D4
    MOVE.B  #87, D0
    TRAP    #15
    RTS

*-----------------------------------------------------------
* DRAW_HUD - health pips, score, mode label, controls
*-----------------------------------------------------------
DRAW_HUD:
    * --- Health pips (5 filled ellipses) ---
    MOVE.L  HEALTH, D7

    * Pip 1
    MOVE.L  #COL_HP_EMPTY, D1
    CMP.L   #1, D7
    BLT     H1E
    MOVE.L  #COL_HP_FULL, D1
H1E:
    JSR     SET_PEN_COLOR
    JSR     SET_FILL_COLOR
    MOVE.L  #8,  D1
    MOVE.L  #8,  D2
    MOVE.L  #20, D3
    MOVE.L  #20, D4
    MOVE.B  #88, D0
    TRAP    #15

    * Pip 2
    MOVE.L  #COL_HP_EMPTY, D1
    CMP.L   #2, D7
    BLT     H2E
    MOVE.L  #COL_HP_FULL, D1
H2E:
    JSR     SET_PEN_COLOR
    JSR     SET_FILL_COLOR
    MOVE.L  #24, D1
    MOVE.L  #8,  D2
    MOVE.L  #36, D3
    MOVE.L  #20, D4
    MOVE.B  #88, D0
    TRAP    #15

    * Pip 3
    MOVE.L  #COL_HP_EMPTY, D1
    CMP.L   #3, D7
    BLT     H3E
    MOVE.L  #COL_HP_FULL, D1
H3E:
    JSR     SET_PEN_COLOR
    JSR     SET_FILL_COLOR
    MOVE.L  #40, D1
    MOVE.L  #8,  D2
    MOVE.L  #52, D3
    MOVE.L  #20, D4
    MOVE.B  #88, D0
    TRAP    #15

    * Pip 4
    MOVE.L  #COL_HP_EMPTY, D1
    CMP.L   #4, D7
    BLT     H4E
    MOVE.L  #COL_HP_FULL, D1
H4E:
    JSR     SET_PEN_COLOR
    JSR     SET_FILL_COLOR
    MOVE.L  #56, D1
    MOVE.L  #8,  D2
    MOVE.L  #68, D3
    MOVE.L  #20, D4
    MOVE.B  #88, D0
    TRAP    #15

    * Pip 5
    MOVE.L  #COL_HP_EMPTY, D1
    CMP.L   #5, D7
    BLT     H5E
    MOVE.L  #COL_HP_FULL, D1
H5E:
    JSR     SET_PEN_COLOR
    JSR     SET_FILL_COLOR
    MOVE.L  #72, D1
    MOVE.L  #8,  D2
    MOVE.L  #84, D3
    MOVE.L  #20, D4
    MOVE.B  #88, D0
    TRAP    #15

    * --- Score label ---
    MOVE.L  #COL_SCORE_C, D1
    JSR     SET_PEN_COLOR
    LEA     STR_SCORE, A1
    MOVE.L  #8,  D1
    MOVE.L  #28, D2
    MOVE.B  #95, D0
    TRAP    #15

    JSR     DRAW_SCORE_GRAPHIC

    * --- Best label ---
    MOVE.L  #COL_YELLOW, D1
    JSR     SET_PEN_COLOR
    LEA     STR_BEST, A1
    MOVE.L  #8,  D1
    MOVE.L  #44, D2
    MOVE.B  #95, D0
    TRAP    #15

    JSR     DRAW_HISCORE_GRAPHIC

    * --- Mode label top right ---
    MOVE.L  COLOUR_STATE, D0
    CMP.L   #COL_RED, D0
    BEQ     HUD_SHOW_R
    CMP.L   #COL_BLUE, D0
    BEQ     HUD_SHOW_B
    MOVE.L  #FROG_GREEN_MID_G, D1
    JSR     SET_PEN_COLOR
    LEA     STR_MG, A1
    MOVE.L  #390, D1
    MOVE.L  #8,   D2
    MOVE.B  #95, D0
    TRAP    #15
    BRA     HUD_CTRL
HUD_SHOW_R:
    MOVE.L  #COL_RED_FLY, D1
    JSR     SET_PEN_COLOR
    LEA     STR_MR, A1
    MOVE.L  #390, D1
    MOVE.L  #8,   D2
    MOVE.B  #95, D0
    TRAP    #15
    BRA     HUD_CTRL
HUD_SHOW_B:
    MOVE.L  #COL_BLUE_FLY, D1
    JSR     SET_PEN_COLOR
    LEA     STR_MB, A1
    MOVE.L  #390, D1
    MOVE.L  #8,   D2
    MOVE.B  #95, D0
    TRAP    #15

HUD_CTRL:
    MOVE.L  #COL_WHITE, D1
    JSR     SET_PEN_COLOR
    LEA     STR_CTRL, A1
    MOVE.L  #60,  D1
    MOVE.L  #462, D2
    MOVE.B  #95, D0
    TRAP    #15
    RTS

*-----------------------------------------------------------
* DRAW_SCORE_GRAPHIC
* Draws SCORE value as a bar of 10-pt wide blocks
* Each 10 points = one cyan block, max 20 blocks shown
*-----------------------------------------------------------
DRAW_SCORE_GRAPHIC:
    MOVE.L  SCORE, D5
    MOVE.L  #0, D4          ; block counter
    MOVE.L  #70, D3         ; X start
DS_LOOP:
    CMP.L   #0, D5
    BLE     DS_DONE
    CMP.L   #20, D4
    BGE     DS_DONE
    MOVE.L  #COL_SCORE_C, D1
    JSR     SET_PEN_COLOR
    JSR     SET_FILL_COLOR
    MOVE.L  D3, D1
    MOVE.L  #30, D2
    MOVE.L  D3, D6
    ADD.L   #8, D6
    MOVE.L  D6, D3
    MOVE.L  D1, D6
    MOVE.L  D3, D7
    * D1=left D2=top D3=right D4=bottom
    MOVE.L  D6, D1          ; left
    MOVE.L  #30, D2         ; top
    MOVE.L  D7, D3          ; right (left+8)
    MOVE.L  #40, D4         ; bottom
    MOVE.B  #87, D0
    TRAP    #15
    ADD.L   #10, D3         ; next X
    SUB.L   #10, D5         ; subtract 10 from score
    ADD.L   #1,  D4
    BRA     DS_LOOP
DS_DONE:
    RTS

*-----------------------------------------------------------
* DRAW_HISCORE_GRAPHIC  same style for high score at y=46
*-----------------------------------------------------------
DRAW_HISCORE_GRAPHIC:
    MOVE.L  HIGH_SCORE, D5
    MOVE.L  #0, D4
    MOVE.L  #70, D3
DH_LOOP:
    CMP.L   #0, D5
    BLE     DH_DONE
    CMP.L   #20, D4
    BGE     DH_DONE
    MOVE.L  #COL_YELLOW, D1
    JSR     SET_PEN_COLOR
    JSR     SET_FILL_COLOR
    MOVE.L  D3, D1
    MOVE.L  D3, D6
    ADD.L   #8, D6
    MOVE.L  D1, D1
    MOVE.L  #46, D2
    MOVE.L  D6, D3
    MOVE.L  #56, D4
    MOVE.B  #87, D0
    TRAP    #15
    ADD.L   #10, D3
    SUB.L   #10, D5
    ADD.L   #1,  D4
    BRA     DH_LOOP
DH_DONE:
    RTS

*-----------------------------------------------------------
* SET_PEN_COLOR  (D1 = colour)
*-----------------------------------------------------------
SET_PEN_COLOR:
    MOVE.B  #80, D0
    TRAP    #15
    RTS

*-----------------------------------------------------------
* SET_FILL_COLOR  (D1 = colour)
*-----------------------------------------------------------
SET_FILL_COLOR:
    MOVE.B  #81, D0
    TRAP    #15
    RTS

*-----------------------------------------------------------
* Strings (null terminated for task 95)
*-----------------------------------------------------------
STR_SCORE:   DC.B  'SCORE:',0
STR_BEST:    DC.B  'BEST: ',0
STR_MG:      DC.B  '[GREEN] SPACE=JUMP',0
STR_MR:      DC.B  '[RED] SPACE=BLAST FLIES',0
STR_MB:      DC.B  '[BLUE] SPACE=ATTRACT FLIES',0
STR_CTRL:    DC.B  'A/D=MOVE  C=COLOUR  SPACE=ABILITY  JUMP OVER GREEN FLIES',0
STR_GO:      DC.B  'GAME OVER',0
STR_RESTART: DC.B  'Press SPACE to restart',0

    INCLUDE "FROG_DRAW.X68"

    END     START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
