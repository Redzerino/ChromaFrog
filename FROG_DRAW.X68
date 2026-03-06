*-----------------------------------------------------------
* Title      : SBR_DRAW_FROG
* Description: Frog player sprite - coords traced from pixel
*              grid tool, 2x scaled.
* Subroutines:
*   DRAW_FROG           ; Entry / direction check
*   DRAW_FROG_LEFT      ; Draw frog (base)
*   DRAW_FROG_FLIP      ; Draw frog (mirrored)
*   FLIP_X              ; Mirror x coords around sprite width
*   SET_PEN_COLOR       ; D1 -> pen color
*   SET_FILL_COLOR      ; D1 -> fill color
*-----------------------------------------------------------

FROG_BLACK          equ $00000000
FROG_YELLOW_BELLY   equ $0000FFFF
FROG_EYE_WHITE      equ $00FFFFFF
FROG_W              equ 52

*-----------------------------------------------------------
* Variables
*-----------------------------------------------------------

*-----------------------------------------------------------
* Entry
*-----------------------------------------------------------

*-----------------------------------------------------------
* DRAW_FROG - direction check
*-----------------------------------------------------------
DRAW_FROG:
    MOVE.L  PLAYER_X, POS_X
    MOVE.L  PLAYER_Y, POS_Y
    TST.L   IS_FLIPPED
    BEQ     FROG_WAS_LEFT
    BGT     FROG_WAS_FLIP
FROG_WAS_LEFT:
    TST.L   PLYR_DIRECTION_X
    BLE     DRAW_FROG_LEFT
    BGT     DRAW_FROG_FLIP
    RTS
FROG_WAS_FLIP:
    TST.L   PLYR_DIRECTION_X
    BGE     DRAW_FROG_FLIP
    BLT     DRAW_FROG_LEFT
    RTS

*-----------------------------------------------------------
* DRAW_FROG_LEFT
*-----------------------------------------------------------
DRAW_FROG_LEFT:
    MOVE.L  #0, IS_FLIPPED

*=== LAYER 1: BLACK ===
    MOVE.L  #FROG_BLACK, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #FROG_BLACK, D1
    JSR     SET_FILL_COLOR

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #6, D2
    MOVE.L  POS_X, D3
    ADD.L   #20, D3
    MOVE.L  POS_Y, D4
    ADD.L   #8, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #32, D1
    MOVE.L  POS_Y, D2
    ADD.L   #6, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #8, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #14, D1
    MOVE.L  POS_Y, D2
    ADD.L   #8, D2
    MOVE.L  POS_X, D3
    ADD.L   #16, D3
    MOVE.L  POS_Y, D4
    ADD.L   #10, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #20, D1
    MOVE.L  POS_Y, D2
    ADD.L   #8, D2
    MOVE.L  POS_X, D3
    ADD.L   #22, D3
    MOVE.L  POS_Y, D4
    ADD.L   #10, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #30, D1
    MOVE.L  POS_Y, D2
    ADD.L   #8, D2
    MOVE.L  POS_X, D3
    ADD.L   #32, D3
    MOVE.L  POS_Y, D4
    ADD.L   #10, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #36, D1
    MOVE.L  POS_Y, D2
    ADD.L   #8, D2
    MOVE.L  POS_X, D3
    ADD.L   #38, D3
    MOVE.L  POS_Y, D4
    ADD.L   #10, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #12, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #14, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #22, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #30, D3
    MOVE.L  POS_Y, D4
    ADD.L   #12, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #38, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #40, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #12, D2
    MOVE.L  POS_X, D3
    ADD.L   #20, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #32, D1
    MOVE.L  POS_Y, D2
    ADD.L   #12, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #10, D1
    MOVE.L  POS_Y, D2
    ADD.L   #14, D2
    MOVE.L  POS_X, D3
    ADD.L   #12, D3
    MOVE.L  POS_Y, D4
    ADD.L   #20, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #40, D1
    MOVE.L  POS_Y, D2
    ADD.L   #14, D2
    MOVE.L  POS_X, D3
    ADD.L   #42, D3
    MOVE.L  POS_Y, D4
    ADD.L   #20, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #14, D1
    MOVE.L  POS_Y, D2
    ADD.L   #16, D2
    MOVE.L  POS_X, D3
    ADD.L   #16, D3
    MOVE.L  POS_Y, D4
    ADD.L   #18, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #36, D1
    MOVE.L  POS_Y, D2
    ADD.L   #16, D2
    MOVE.L  POS_X, D3
    ADD.L   #38, D3
    MOVE.L  POS_Y, D4
    ADD.L   #18, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #18, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #20, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #12, D1
    MOVE.L  POS_Y, D2
    ADD.L   #20, D2
    MOVE.L  POS_X, D3
    ADD.L   #14, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #38, D1
    MOVE.L  POS_Y, D2
    ADD.L   #20, D2
    MOVE.L  POS_X, D3
    ADD.L   #40, D3
    MOVE.L  POS_Y, D4
    ADD.L   #26, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #6, D1
    MOVE.L  POS_Y, D2
    ADD.L   #24, D2
    MOVE.L  POS_X, D3
    ADD.L   #12, D3
    MOVE.L  POS_Y, D4
    ADD.L   #26, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #24, D2
    MOVE.L  POS_X, D3
    ADD.L   #18, D3
    MOVE.L  POS_Y, D4
    ADD.L   #30, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #40, D1
    MOVE.L  POS_Y, D2
    ADD.L   #24, D2
    MOVE.L  POS_X, D3
    ADD.L   #46, D3
    MOVE.L  POS_Y, D4
    ADD.L   #26, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #4, D1
    MOVE.L  POS_Y, D2
    ADD.L   #26, D2
    MOVE.L  POS_X, D3
    ADD.L   #6, D3
    MOVE.L  POS_Y, D4
    ADD.L   #30, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #46, D1
    MOVE.L  POS_Y, D2
    ADD.L   #26, D2
    MOVE.L  POS_X, D3
    ADD.L   #48, D3
    MOVE.L  POS_Y, D4
    ADD.L   #30, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #18, D1
    MOVE.L  POS_Y, D2
    ADD.L   #28, D2
    MOVE.L  POS_X, D3
    ADD.L   #20, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #6, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #10, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #20, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #22, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #42, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #46, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #6, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #8, D3
    MOVE.L  POS_Y, D4
    ADD.L   #36, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #14, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #18, D3
    MOVE.L  POS_Y, D4
    ADD.L   #36, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #22, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #24, D3
    MOVE.L  POS_Y, D4
    ADD.L   #36, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #44, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #46, D3
    MOVE.L  POS_Y, D4
    ADD.L   #36, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #8, D1
    MOVE.L  POS_Y, D2
    ADD.L   #34, D2
    MOVE.L  POS_X, D3
    ADD.L   #14, D3
    MOVE.L  POS_Y, D4
    ADD.L   #36, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #18, D1
    MOVE.L  POS_Y, D2
    ADD.L   #34, D2
    MOVE.L  POS_X, D3
    ADD.L   #22, D3
    MOVE.L  POS_Y, D4
    ADD.L   #36, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #24, D1
    MOVE.L  POS_Y, D2
    ADD.L   #34, D2
    MOVE.L  POS_X, D3
    ADD.L   #44, D3
    MOVE.L  POS_Y, D4
    ADD.L   #36, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #34, D1
    MOVE.L  POS_Y, D2
    ADD.L   #24, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #30, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #38, D1
    MOVE.L  POS_Y, D2
    ADD.L   #26, D2
    MOVE.L  POS_X, D3
    ADD.L   #40, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #32, D1
    MOVE.L  POS_Y, D2
    ADD.L   #28, D2
    MOVE.L  POS_X, D3
    ADD.L   #34, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #30, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #32, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #28, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #30, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #34, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #38, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    MOVE.B  #87, D0
    TRAP    #15

*=== LAYER 2: LIGHT GREEN ===
    MOVE.L  FROG_GREEN_LIGHT, D1
    JSR     SET_PEN_COLOR
    MOVE.L  FROG_GREEN_LIGHT, D1
    JSR     SET_FILL_COLOR

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #8, D2
    MOVE.L  POS_X, D3
    ADD.L   #20, D3
    MOVE.L  POS_Y, D4
    ADD.L   #10, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #32, D1
    MOVE.L  POS_Y, D2
    ADD.L   #8, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #10, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #14, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #16, D3
    MOVE.L  POS_Y, D4
    ADD.L   #12, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #20, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #22, D3
    MOVE.L  POS_Y, D4
    ADD.L   #12, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #30, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #32, D3
    MOVE.L  POS_Y, D4
    ADD.L   #12, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #36, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #38, D3
    MOVE.L  POS_Y, D4
    ADD.L   #12, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #22, D1
    MOVE.L  POS_Y, D2
    ADD.L   #12, D2
    MOVE.L  POS_X, D3
    ADD.L   #30, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #12, D1
    MOVE.L  POS_Y, D2
    ADD.L   #14, D2
    MOVE.L  POS_X, D3
    ADD.L   #14, D3
    MOVE.L  POS_Y, D4
    ADD.L   #16, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #38, D1
    MOVE.L  POS_Y, D2
    ADD.L   #14, D2
    MOVE.L  POS_X, D3
    ADD.L   #40, D3
    MOVE.L  POS_Y, D4
    ADD.L   #16, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #14, D1
    MOVE.L  POS_Y, D2
    ADD.L   #20, D2
    MOVE.L  POS_X, D3
    ADD.L   #16, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #36, D1
    MOVE.L  POS_Y, D2
    ADD.L   #20, D2
    MOVE.L  POS_X, D3
    ADD.L   #38, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #6, D1
    MOVE.L  POS_Y, D2
    ADD.L   #26, D2
    MOVE.L  POS_X, D3
    ADD.L   #12, D3
    MOVE.L  POS_Y, D4
    ADD.L   #28, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #40, D1
    MOVE.L  POS_Y, D2
    ADD.L   #26, D2
    MOVE.L  POS_X, D3
    ADD.L   #46, D3
    MOVE.L  POS_Y, D4
    ADD.L   #28, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #18, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #34, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    MOVE.B  #87, D0
    TRAP    #15

*=== LAYER 3: EYE WHITE ===
    MOVE.L  #FROG_EYE_WHITE, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #FROG_EYE_WHITE, D1
    JSR     SET_FILL_COLOR

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #20, D3
    MOVE.L  POS_Y, D4
    ADD.L   #12, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #32, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #12, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #14, D1
    MOVE.L  POS_Y, D2
    ADD.L   #12, D2
    MOVE.L  POS_X, D3
    ADD.L   #16, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #20, D1
    MOVE.L  POS_Y, D2
    ADD.L   #12, D2
    MOVE.L  POS_X, D3
    ADD.L   #22, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #30, D1
    MOVE.L  POS_Y, D2
    ADD.L   #12, D2
    MOVE.L  POS_X, D3
    ADD.L   #32, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #36, D1
    MOVE.L  POS_Y, D2
    ADD.L   #12, D2
    MOVE.L  POS_X, D3
    ADD.L   #38, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    MOVE.B  #87, D0
    TRAP    #15

*=== LAYER 4: MID GREEN ===
    MOVE.L  FROG_GREEN_MID, D1
    JSR     SET_PEN_COLOR
    MOVE.L  FROG_GREEN_MID, D1
    JSR     SET_FILL_COLOR

    MOVE.L  POS_X, D1
    ADD.L   #14, D1
    MOVE.L  POS_Y, D2
    ADD.L   #14, D2
    MOVE.L  POS_X, D3
    ADD.L   #38, D3
    MOVE.L  POS_Y, D4
    ADD.L   #16, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #12, D1
    MOVE.L  POS_Y, D2
    ADD.L   #16, D2
    MOVE.L  POS_X, D3
    ADD.L   #14, D3
    MOVE.L  POS_Y, D4
    ADD.L   #20, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #16, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #18, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #38, D1
    MOVE.L  POS_Y, D2
    ADD.L   #16, D2
    MOVE.L  POS_X, D3
    ADD.L   #40, D3
    MOVE.L  POS_Y, D4
    ADD.L   #20, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #14, D1
    MOVE.L  POS_Y, D2
    ADD.L   #18, D2
    MOVE.L  POS_X, D3
    ADD.L   #16, D3
    MOVE.L  POS_Y, D4
    ADD.L   #20, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #36, D1
    MOVE.L  POS_Y, D2
    ADD.L   #18, D2
    MOVE.L  POS_X, D3
    ADD.L   #38, D3
    MOVE.L  POS_Y, D4
    ADD.L   #20, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #6, D1
    MOVE.L  POS_Y, D2
    ADD.L   #28, D2
    MOVE.L  POS_X, D3
    ADD.L   #12, D3
    MOVE.L  POS_Y, D4
    ADD.L   #30, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #40, D1
    MOVE.L  POS_Y, D2
    ADD.L   #28, D2
    MOVE.L  POS_X, D3
    ADD.L   #46, D3
    MOVE.L  POS_Y, D4
    ADD.L   #30, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #10, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #12, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #40, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #42, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #8, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #10, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #12, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #14, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #18, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #22, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #24, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #28, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #30, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #34, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #38, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #40, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #42, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #44, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    MOVE.B  #87, D0
    TRAP    #15

*=== LAYER 5: YELLOW BELLY ===
    MOVE.L  #FROG_YELLOW_BELLY, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #FROG_YELLOW_BELLY, D1
    JSR     SET_FILL_COLOR

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #20, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #24, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #18, D1
    MOVE.L  POS_Y, D2
    ADD.L   #24, D2
    MOVE.L  POS_X, D3
    ADD.L   #34, D3
    MOVE.L  POS_Y, D4
    ADD.L   #28, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #20, D1
    MOVE.L  POS_Y, D2
    ADD.L   #28, D2
    MOVE.L  POS_X, D3
    ADD.L   #32, D3
    MOVE.L  POS_Y, D4
    ADD.L   #30, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #22, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #30, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    MOVE.B  #87, D0
    TRAP    #15

    RTS


*-----------------------------------------------------------
* DRAW_FROG_FLIP - same layers, each rect through FLIP_X
*-----------------------------------------------------------
DRAW_FROG_FLIP:
    MOVE.L  #1, IS_FLIPPED

*=== LAYER 1: BLACK ===
    MOVE.L  #FROG_BLACK, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #FROG_BLACK, D1
    JSR     SET_FILL_COLOR

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #6, D2
    MOVE.L  POS_X, D3
    ADD.L   #20, D3
    MOVE.L  POS_Y, D4
    ADD.L   #8, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #32, D1
    MOVE.L  POS_Y, D2
    ADD.L   #6, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #8, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #14, D1
    MOVE.L  POS_Y, D2
    ADD.L   #8, D2
    MOVE.L  POS_X, D3
    ADD.L   #16, D3
    MOVE.L  POS_Y, D4
    ADD.L   #10, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #20, D1
    MOVE.L  POS_Y, D2
    ADD.L   #8, D2
    MOVE.L  POS_X, D3
    ADD.L   #22, D3
    MOVE.L  POS_Y, D4
    ADD.L   #10, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #30, D1
    MOVE.L  POS_Y, D2
    ADD.L   #8, D2
    MOVE.L  POS_X, D3
    ADD.L   #32, D3
    MOVE.L  POS_Y, D4
    ADD.L   #10, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #36, D1
    MOVE.L  POS_Y, D2
    ADD.L   #8, D2
    MOVE.L  POS_X, D3
    ADD.L   #38, D3
    MOVE.L  POS_Y, D4
    ADD.L   #10, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #12, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #14, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #22, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #30, D3
    MOVE.L  POS_Y, D4
    ADD.L   #12, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #38, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #40, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #12, D2
    MOVE.L  POS_X, D3
    ADD.L   #20, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #32, D1
    MOVE.L  POS_Y, D2
    ADD.L   #12, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #10, D1
    MOVE.L  POS_Y, D2
    ADD.L   #14, D2
    MOVE.L  POS_X, D3
    ADD.L   #12, D3
    MOVE.L  POS_Y, D4
    ADD.L   #20, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #40, D1
    MOVE.L  POS_Y, D2
    ADD.L   #14, D2
    MOVE.L  POS_X, D3
    ADD.L   #42, D3
    MOVE.L  POS_Y, D4
    ADD.L   #20, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #14, D1
    MOVE.L  POS_Y, D2
    ADD.L   #16, D2
    MOVE.L  POS_X, D3
    ADD.L   #16, D3
    MOVE.L  POS_Y, D4
    ADD.L   #18, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #36, D1
    MOVE.L  POS_Y, D2
    ADD.L   #16, D2
    MOVE.L  POS_X, D3
    ADD.L   #38, D3
    MOVE.L  POS_Y, D4
    ADD.L   #18, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #18, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #20, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #12, D1
    MOVE.L  POS_Y, D2
    ADD.L   #20, D2
    MOVE.L  POS_X, D3
    ADD.L   #14, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #38, D1
    MOVE.L  POS_Y, D2
    ADD.L   #20, D2
    MOVE.L  POS_X, D3
    ADD.L   #40, D3
    MOVE.L  POS_Y, D4
    ADD.L   #26, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #6, D1
    MOVE.L  POS_Y, D2
    ADD.L   #24, D2
    MOVE.L  POS_X, D3
    ADD.L   #12, D3
    MOVE.L  POS_Y, D4
    ADD.L   #26, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #24, D2
    MOVE.L  POS_X, D3
    ADD.L   #18, D3
    MOVE.L  POS_Y, D4
    ADD.L   #30, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #40, D1
    MOVE.L  POS_Y, D2
    ADD.L   #24, D2
    MOVE.L  POS_X, D3
    ADD.L   #46, D3
    MOVE.L  POS_Y, D4
    ADD.L   #26, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #4, D1
    MOVE.L  POS_Y, D2
    ADD.L   #26, D2
    MOVE.L  POS_X, D3
    ADD.L   #6, D3
    MOVE.L  POS_Y, D4
    ADD.L   #30, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #46, D1
    MOVE.L  POS_Y, D2
    ADD.L   #26, D2
    MOVE.L  POS_X, D3
    ADD.L   #48, D3
    MOVE.L  POS_Y, D4
    ADD.L   #30, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #18, D1
    MOVE.L  POS_Y, D2
    ADD.L   #28, D2
    MOVE.L  POS_X, D3
    ADD.L   #20, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #6, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #10, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #20, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #22, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #42, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #46, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #6, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #8, D3
    MOVE.L  POS_Y, D4
    ADD.L   #36, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #14, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #18, D3
    MOVE.L  POS_Y, D4
    ADD.L   #36, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #22, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #24, D3
    MOVE.L  POS_Y, D4
    ADD.L   #36, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #44, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #46, D3
    MOVE.L  POS_Y, D4
    ADD.L   #36, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #8, D1
    MOVE.L  POS_Y, D2
    ADD.L   #34, D2
    MOVE.L  POS_X, D3
    ADD.L   #14, D3
    MOVE.L  POS_Y, D4
    ADD.L   #36, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #18, D1
    MOVE.L  POS_Y, D2
    ADD.L   #34, D2
    MOVE.L  POS_X, D3
    ADD.L   #22, D3
    MOVE.L  POS_Y, D4
    ADD.L   #36, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #24, D1
    MOVE.L  POS_Y, D2
    ADD.L   #34, D2
    MOVE.L  POS_X, D3
    ADD.L   #44, D3
    MOVE.L  POS_Y, D4
    ADD.L   #36, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #34, D1
    MOVE.L  POS_Y, D2
    ADD.L   #24, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #30, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #38, D1
    MOVE.L  POS_Y, D2
    ADD.L   #26, D2
    MOVE.L  POS_X, D3
    ADD.L   #40, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #32, D1
    MOVE.L  POS_Y, D2
    ADD.L   #28, D2
    MOVE.L  POS_X, D3
    ADD.L   #34, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #30, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #32, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #28, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #30, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #34, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #38, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

*=== LAYER 2: LIGHT GREEN ===
    MOVE.L  FROG_GREEN_LIGHT, D1
    JSR     SET_PEN_COLOR
    MOVE.L  FROG_GREEN_LIGHT, D1
    JSR     SET_FILL_COLOR

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #8, D2
    MOVE.L  POS_X, D3
    ADD.L   #20, D3
    MOVE.L  POS_Y, D4
    ADD.L   #10, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #32, D1
    MOVE.L  POS_Y, D2
    ADD.L   #8, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #10, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #14, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #16, D3
    MOVE.L  POS_Y, D4
    ADD.L   #12, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #20, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #22, D3
    MOVE.L  POS_Y, D4
    ADD.L   #12, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #30, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #32, D3
    MOVE.L  POS_Y, D4
    ADD.L   #12, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #36, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #38, D3
    MOVE.L  POS_Y, D4
    ADD.L   #12, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #22, D1
    MOVE.L  POS_Y, D2
    ADD.L   #12, D2
    MOVE.L  POS_X, D3
    ADD.L   #30, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #12, D1
    MOVE.L  POS_Y, D2
    ADD.L   #14, D2
    MOVE.L  POS_X, D3
    ADD.L   #14, D3
    MOVE.L  POS_Y, D4
    ADD.L   #16, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #38, D1
    MOVE.L  POS_Y, D2
    ADD.L   #14, D2
    MOVE.L  POS_X, D3
    ADD.L   #40, D3
    MOVE.L  POS_Y, D4
    ADD.L   #16, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #14, D1
    MOVE.L  POS_Y, D2
    ADD.L   #20, D2
    MOVE.L  POS_X, D3
    ADD.L   #16, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #36, D1
    MOVE.L  POS_Y, D2
    ADD.L   #20, D2
    MOVE.L  POS_X, D3
    ADD.L   #38, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #6, D1
    MOVE.L  POS_Y, D2
    ADD.L   #26, D2
    MOVE.L  POS_X, D3
    ADD.L   #12, D3
    MOVE.L  POS_Y, D4
    ADD.L   #28, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #40, D1
    MOVE.L  POS_Y, D2
    ADD.L   #26, D2
    MOVE.L  POS_X, D3
    ADD.L   #46, D3
    MOVE.L  POS_Y, D4
    ADD.L   #28, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #18, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #34, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

*=== LAYER 3: EYE WHITE ===
    MOVE.L  #FROG_EYE_WHITE, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #FROG_EYE_WHITE, D1
    JSR     SET_FILL_COLOR

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #20, D3
    MOVE.L  POS_Y, D4
    ADD.L   #12, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #32, D1
    MOVE.L  POS_Y, D2
    ADD.L   #10, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #12, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #14, D1
    MOVE.L  POS_Y, D2
    ADD.L   #12, D2
    MOVE.L  POS_X, D3
    ADD.L   #16, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #20, D1
    MOVE.L  POS_Y, D2
    ADD.L   #12, D2
    MOVE.L  POS_X, D3
    ADD.L   #22, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #30, D1
    MOVE.L  POS_Y, D2
    ADD.L   #12, D2
    MOVE.L  POS_X, D3
    ADD.L   #32, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #36, D1
    MOVE.L  POS_Y, D2
    ADD.L   #12, D2
    MOVE.L  POS_X, D3
    ADD.L   #38, D3
    MOVE.L  POS_Y, D4
    ADD.L   #14, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

*=== LAYER 4: MID GREEN ===
    MOVE.L  FROG_GREEN_MID, D1
    JSR     SET_PEN_COLOR
    MOVE.L  FROG_GREEN_MID, D1
    JSR     SET_FILL_COLOR

    MOVE.L  POS_X, D1
    ADD.L   #14, D1
    MOVE.L  POS_Y, D2
    ADD.L   #14, D2
    MOVE.L  POS_X, D3
    ADD.L   #38, D3
    MOVE.L  POS_Y, D4
    ADD.L   #16, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #12, D1
    MOVE.L  POS_Y, D2
    ADD.L   #16, D2
    MOVE.L  POS_X, D3
    ADD.L   #14, D3
    MOVE.L  POS_Y, D4
    ADD.L   #20, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #16, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #18, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #38, D1
    MOVE.L  POS_Y, D2
    ADD.L   #16, D2
    MOVE.L  POS_X, D3
    ADD.L   #40, D3
    MOVE.L  POS_Y, D4
    ADD.L   #20, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #14, D1
    MOVE.L  POS_Y, D2
    ADD.L   #18, D2
    MOVE.L  POS_X, D3
    ADD.L   #16, D3
    MOVE.L  POS_Y, D4
    ADD.L   #20, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #36, D1
    MOVE.L  POS_Y, D2
    ADD.L   #18, D2
    MOVE.L  POS_X, D3
    ADD.L   #38, D3
    MOVE.L  POS_Y, D4
    ADD.L   #20, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #6, D1
    MOVE.L  POS_Y, D2
    ADD.L   #28, D2
    MOVE.L  POS_X, D3
    ADD.L   #12, D3
    MOVE.L  POS_Y, D4
    ADD.L   #30, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #40, D1
    MOVE.L  POS_Y, D2
    ADD.L   #28, D2
    MOVE.L  POS_X, D3
    ADD.L   #46, D3
    MOVE.L  POS_Y, D4
    ADD.L   #30, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #10, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #12, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #40, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #42, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #8, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #10, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #12, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #14, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #18, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #22, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #24, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #28, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #30, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #34, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #38, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #40, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #42, D1
    MOVE.L  POS_Y, D2
    ADD.L   #32, D2
    MOVE.L  POS_X, D3
    ADD.L   #44, D3
    MOVE.L  POS_Y, D4
    ADD.L   #34, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

*=== LAYER 5: YELLOW BELLY ===
    MOVE.L  #FROG_YELLOW_BELLY, D1
    JSR     SET_PEN_COLOR
    MOVE.L  #FROG_YELLOW_BELLY, D1
    JSR     SET_FILL_COLOR

    MOVE.L  POS_X, D1
    ADD.L   #16, D1
    MOVE.L  POS_Y, D2
    ADD.L   #20, D2
    MOVE.L  POS_X, D3
    ADD.L   #36, D3
    MOVE.L  POS_Y, D4
    ADD.L   #24, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #18, D1
    MOVE.L  POS_Y, D2
    ADD.L   #24, D2
    MOVE.L  POS_X, D3
    ADD.L   #34, D3
    MOVE.L  POS_Y, D4
    ADD.L   #28, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #20, D1
    MOVE.L  POS_Y, D2
    ADD.L   #28, D2
    MOVE.L  POS_X, D3
    ADD.L   #32, D3
    MOVE.L  POS_Y, D4
    ADD.L   #30, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  POS_X, D1
    ADD.L   #22, D1
    MOVE.L  POS_Y, D2
    ADD.L   #30, D2
    MOVE.L  POS_X, D3
    ADD.L   #30, D3
    MOVE.L  POS_Y, D4
    ADD.L   #32, D4
    JSR     FLIP_X
    MOVE.B  #87, D0
    TRAP    #15

    RTS


*-----------------------------------------------------------
* FLIP_X
* Mirrors D1,D3 around FROG_W relative to POS_X
* Scratches D6
*-----------------------------------------------------------
FLIP_X:
    SUB.L   POS_X,   D1
    MOVE.L  #FROG_W, D6
    SUB.L   D1,      D6
    SUB.L   #1,      D6
    ADD.L   POS_X,   D6
    MOVE.L  D6,      D1

    SUB.L   POS_X,   D3
    MOVE.L  #FROG_W, D6
    SUB.L   D3,      D6
    SUB.L   #1,      D6
    ADD.L   POS_X,   D6
    MOVE.L  D6,      D3

    CMP.L   D3,      D1
    BLE     FLIP_X_DONE
    EXG     D1,      D3
FLIP_X_DONE:
    RTS

* SET_PEN_COLOR and SET_FILL_COLOR defined in FROG_MAIN.X68




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
