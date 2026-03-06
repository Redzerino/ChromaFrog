*-----------------------------------------------------------
* Title      : FROG_DRAW.X68
* Author     : Sarah Crotty
* Date       : 26/02/2026
* Description: Draws the frog. Called every frame from FROG_MAIN.
*              The frog is made up of lots of coloured rectangles.
* Known Bugs : None known.
*-----------------------------------------------------------

FROG_BLACK          equ $00000000   * black - used for outlines and pupils
FROG_YELLOW_BELLY   equ $0000FFFF   * the yellow belly colour
FROG_EYE_WHITE      equ $00FFFFFF   * white for the eyes
FROG_W              equ 52          * how wide the whole frog sprite is

*-----------------------------------------------------------
* DRAW_FROG
* Called every frame. Grabs where the frog is and draws it there.
*-----------------------------------------------------------
DRAW_FROG:
    MOVE.L  PLAYER_X, POS_X        * where is the frog
    MOVE.L  PLAYER_Y, POS_Y
    JMP     DRAW_FROG_SPRITE

*-----------------------------------------------------------
* DRAW_FROG_SPRITE
* Draws the frog using lots of small filled boxes.
* Each box is drawn with TRAP #15 task 87 - you give it left/top/right/bottom.
* All positions are measured from POS_X/POS_Y.
* Colours are done in layers, each one painted over the one before.
*-----------------------------------------------------------
DRAW_FROG_SPRITE:
*=== LAYER 1: BLACK ===
* Drawn first - the outlines, pupils and joint dots
    MOVE.L  #FROG_BLACK, D1
    JSR     SET_BOTH_COLORS

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
* The bright highlight colour - changes to match whichever mode the frog is in
    MOVE.L  FROG_GREEN_LIGHT, D1   * this changes depending on green/red/blue mode
    JSR     SET_BOTH_COLORS

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
* Always white no matter what mode the frog is in
    MOVE.L  #FROG_EYE_WHITE, D1
    JSR     SET_BOTH_COLORS

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
* The main body colour - changes to match the current mode
    MOVE.L  FROG_GREEN_MID, D1     * this changes depending on green/red/blue mode
    JSR     SET_BOTH_COLORS

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
* Drawn last so it sits on top of everything else
    MOVE.L  #FROG_YELLOW_BELLY, D1
    JSR     SET_BOTH_COLORS

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

* SET_BOTH_COLORS comes from FROG_MAIN.X68 - it sets the outline and fill in one go
