*-----------------------------------------------------------
* Title      : FROG_DRAW_HUD.X68
* Author     : Sarah Crotty
* Date       : 26/02/2026
* Description: Draws the HUD (health, score, mode label, controls).
*              Also has SET_PEN_COLOR, SET_FILL_COLOR, SET_BOTH_COLORS
*              and INT_TO_STR which are used by all the other draw files.
* Known Bugs : None known.
*-----------------------------------------------------------

*-----------------------------------------------------------
* DRAW_HUD
* Draws all the on-screen info - health pips, score, mode name, controls.
*-----------------------------------------------------------
DRAW_HUD:
    * Health pips
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

    * Score
    MOVE.L  #COL_SCORE_C, D1
    JSR     SET_PEN_COLOR
    LEA     STR_SCORE, A1
    MOVE.L  #8,  D1
    MOVE.L  #28, D2
    MOVE.B  #95, D0
    TRAP    #15
    * Turn the score number into text and draw it
    MOVE.L  SCORE, D0
    JSR     INT_TO_STR
    LEA     NUM_BUF, A1
    MOVE.L  #72, D1
    MOVE.L  #28, D2
    MOVE.B  #95, D0
    TRAP    #15

    * Best score
    MOVE.L  #COL_YELLOW, D1
    JSR     SET_PEN_COLOR
    LEA     STR_BEST, A1
    MOVE.L  #8,  D1
    MOVE.L  #44, D2
    MOVE.B  #95, D0
    TRAP    #15
    * Turn the best score into text and draw it
    MOVE.L  HIGH_SCORE, D0
    JSR     INT_TO_STR
    LEA     NUM_BUF, A1
    MOVE.L  #72, D1
    MOVE.L  #44, D2
    MOVE.B  #95, D0
    TRAP    #15

    * Show which colour mode the frog is in
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
* SET_PEN_COLOR   - changes the outline colour. Pass the colour in D1.
* SET_FILL_COLOR  - changes the fill colour. Pass the colour in D1.
* SET_BOTH_COLORS - sets both at once. Handy since they are usually the same.
*-----------------------------------------------------------
SET_BOTH_COLORS:
    MOVE.B  #80, D0
    TRAP    #15                     * set the outline colour
    MOVE.B  #81, D0
    TRAP    #15                     * set the fill colour to the same thing
    RTS

SET_PEN_COLOR:
    MOVE.B  #80, D0
    TRAP    #15
    RTS

SET_FILL_COLOR:
    MOVE.B  #81, D0
    TRAP    #15
    RTS

*-----------------------------------------------------------
* INT_TO_STR
* Turns a number in D0 into text and stores it in NUM_BUF.
* Needed because the screen drawing task only works with text, not numbers.
*-----------------------------------------------------------
INT_TO_STR:
    LEA     NUM_BUF, A0
    TST.L   D0                      * if the score is zero just write "0" and done
    BNE     ITS_NONZERO
    MOVE.B  #'0', (A0)+
    MOVE.B  #0,   (A0)         
    RTS
ITS_NONZERO:
    MOVE.L  #0,   D3               * D3 keeps track of how many digits we have written
ITS_LOOP:
    TST.L   D0
    BEQ     ITS_REVERSE             * no digits left, go reverse them
    MOVE.L  D0,   D1
    DIVU    #10,  D1               * chop off the last digit
    MOVE.L  D1,   D2
    SWAP    D2                      * the digit we chopped is hiding in the top half, bring it down
    AND.L   #$FFFF, D2             * keep only that digit
    ADD.B   #'0', D2              * turn it into the letter for that digit
    MOVE.B  D2,   (A0)+            * write it to the buffer
    ADD.L   #1,   D3               * count it
    AND.L   #$FFFF, D1             * keep the rest of the number for next time
    MOVE.L  D1,   D0
    BRA     ITS_LOOP
ITS_REVERSE:
    * The digits were written last-first so we need to flip them around
    MOVE.B  #0,   (A0)      * mark the end of the string
    LEA     NUM_BUF, A0
    MOVE.L  A0,   A1
    ADDA.L  D3,   A1
    SUB.L   #1,   A1        * A1 points at the last digit
ITS_REV_LOOP:
    CMPA.L  A0,   A1
    BLE     ITS_REV_DONE    * met in the middle, all done
    MOVE.B  (A0), D1        * swap these two digits over
    MOVE.B  (A1), (A0)+
    MOVE.B  D1,   (A1)
    SUBA.L  #1,   A1        * close the gap from both ends
    BRA     ITS_REV_LOOP
ITS_REV_DONE:
    RTS

*-----------------------------------------------------------
* Text strings used on screen
*-----------------------------------------------------------
STR_SCORE:      DC.B  'SCORE:',0
STR_BEST:       DC.B  'BEST: ',0
STR_YRSCORE:    DC.B  'YOUR SCORE:',0
STR_HISCORE:    DC.B  'BEST SCORE:',0
STR_WELLPLAYED: DC.B  'Well played,',0
STR_NEWHS:      DC.B  '*** NEW HIGH SCORE! ***',0
STR_AGAIN:      DC.B  'SPACE = return to menu',0
STR_GO:         DC.B  'G A M E   O V E R',0
STR_MG:         DC.B  '[GREEN] SPACE=JUMP',0
STR_MR:         DC.B  '[RED] SPACE=BLAST FLIES',0
STR_MB:         DC.B  '[BLUE] SPACE=ATTRACT FLIES',0
STR_CTRL:       DC.B  'A/D=MOVE  C=COLOUR  SPACE=ABILITY  JUMP GREEN FLIES',0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
