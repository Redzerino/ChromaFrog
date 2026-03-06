*-----------------------------------------------------------
* Title      : FROG_DRAW_FLIES.X68
* Author     : Sarah Crotty
* Date       : 26/02/2026
* Description: Draws the background and all three types of fly.
*              Called every frame from FROG_MAIN.X68.
* Known Bugs : None known.
*-----------------------------------------------------------

*-----------------------------------------------------------
* DRAW_BACKGROUND
* Draws the sky and ground every frame.
*-----------------------------------------------------------
DRAW_BACKGROUND:
    MOVE.L  #COL_BG, D1
    JSR     SET_BOTH_COLORS
    MOVE.L  #0,   D1
    MOVE.L  #0,   D2
    MOVE.L  #639, D3
    MOVE.L  #GROUND_Y+20, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  #COL_GROUND, D1
    JSR     SET_BOTH_COLORS
    MOVE.L  #0,   D1
    MOVE.L  #GROUND_Y+20, D2
    MOVE.L  #639, D3
    MOVE.L  #479, D4
    MOVE.B  #87, D0
    TRAP    #15

    MOVE.L  #COL_GROUND_LT, D1
    JSR     SET_BOTH_COLORS
    MOVE.L  #0,   D1
    MOVE.L  #GROUND_Y+20, D2
    MOVE.L  #639, D3
    MOVE.L  #GROUND_Y+26, D4
    MOVE.B  #87, D0
    TRAP    #15
    RTS

*-----------------------------------------------------------
* DRAW_ALL_FLIES
* Draws every fly that is currently alive.
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
* DRAW_RED_FLY
* Draws one red fly at COL_FLY_X/Y. D6 makes the wings flap.
*-----------------------------------------------------------
DRAW_RED_FLY:
    MOVE.L  #COL_WING_R, D1
    JSR     SET_BOTH_COLORS
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
    JSR     SET_BOTH_COLORS
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
    JSR     SET_BOTH_COLORS
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
* DRAW_BLUE_FLY
* Draws one blue fly at COL_FLY_X/Y. D6 makes the wings flap.
*-----------------------------------------------------------
DRAW_BLUE_FLY:
    MOVE.L  #COL_WING_B, D1
    JSR     SET_BOTH_COLORS
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
    JSR     SET_BOTH_COLORS
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
    JSR     SET_BOTH_COLORS
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
* DRAW_GREEN_FLY
* Draws one green fly at COL_FLY_X/Y. D6 makes the wings flap.
* Green flies are a bit bigger so they are easy to see on the ground.
*-----------------------------------------------------------
DRAW_GREEN_FLY:
    * Left wing
    MOVE.L  #COL_WING_G, D1
    JSR     SET_BOTH_COLORS
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
    JSR     SET_BOTH_COLORS
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
    JSR     SET_BOTH_COLORS
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
