*-----------------------------------------------------------
* Title      : FROG_MENU.X68
* Author     : Sarah Crotty
* Date       : 26/02/2026
* Description: The start screen and name entry. Open THIS file in
*              Easy68K - it pulls in all the other files automatically.
* Known Bugs : If two flies hit you in the same moment you might only
*              lose one health pip instead of two.
*-----------------------------------------------------------

*-----------------------------------------------------------
* These memory addresses are used by all four files so they need to match up
FROG_NAME       equ $4F00   * where the players name is stored (up to 12 letters plus a null at the end)
MUSTACHE_FLAG   equ $4F14   * set to 1 if the player typed "filip" as their name

*-----------------------------------------------------------
* Colours used on the start and name screens
*-----------------------------------------------------------
MC_BG           equ $00132213    * background colour - matches the game
MC_GROUND       equ $00224422    * ground colour
MC_WHITE        equ $00FFFFFF    * white for text
MC_YELLOW       equ $000088FF    * orangey yellow - matches the colour used in the game
MC_GREEN        equ $0055DD11    * bright green for the name and confirm prompts
MC_RED          equ $000022FF    * red for warnings and borders
MC_BLUE         equ $00FF6622    * blue accent
MC_PANEL        equ $00112211    * dark background for panels and boxes
MC_DARK         equ $00080808    * almost black
MC_CYAN         equ $00FFC84D    * gold colour for score and headings

NAME_MAX        equ 12           * longest name the player is allowed to type

*-----------------------------------------------------------
* Entry
*-----------------------------------------------------------
    ORG     $1000           * start of user memory
MENU_START:
    * Open the game window
    MOVE.L  #640, D1
    MOVE.L  #480, D2
    MOVE.B  #33,  D0
    TRAP    #15

    * Turn on double buffering so nothing flickers
    MOVE.L  #17,  D1
    MOVE.B  #92,  D0
    TRAP    #15

    * Stop Easy68K from grabbing the ESC key so we can use it ourselves
    MOVE.L  #1,   D1
    MOVE.B  #24,  D0
    TRAP    #15

    MOVE.L  #0, MUSTACHE_FLAG       * make sure the moustache easter egg is off at the start

    * Load all sounds into DirectX memory so they are ready to play
    * Reference 0 = background music, 1 = jump, 2 = hit
    LEA     SND_MUSIC, A1
    MOVE.B  #0, D1
    MOVE.B  #74, D0
    TRAP    #15                     * load music.wav as sound 0

    LEA     SND_JUMP, A1
    MOVE.B  #1, D1
    MOVE.B  #74, D0
    TRAP    #15                     * load jump.wav as sound 1

    LEA     SND_HIT, A1
    MOVE.B  #2, D1
    MOVE.B  #74, D0
    TRAP    #15                     * load hit.wav as sound 2

    * Start background music looping straight away
    MOVE.B  #0, D1
    MOVE.L  #1, D2                  * 1 = loop
    MOVE.B  #77, D0
    TRAP    #15

*=== START SCREEN ==========================================
SHOW_START:
    JSR     DRAW_START

* Wait for the player to press Enter to start
WAIT_ENTER:
    MOVE.L  #$0D000000, D1         * Enter key code
    MOVE.B  #19, D0
    TRAP    #15
    BTST.L  #31, D1                 * is it being pressed?
    BEQ     CHECK_ESC_START         * no - check for ESC instead
    * Wait for them to let go of Enter before we start reading the name
    * otherwise the Enter press ends up in the name input
WAIT_ENTER_UP:
    MOVE.L  #$0D000000, D1
    MOVE.B  #19, D0
    TRAP    #15
    BTST.L  #31, D1
    BNE     WAIT_ENTER_UP           * still holding it, wait
    BRA     NAME_ENTRY_SECTION      * let go, safe to continue
CHECK_ESC_START:
    MOVE.L  #$1B000000, D1
    MOVE.B  #19, D0
    TRAP    #15
    BTST.L  #31, D1
    BNE     QUIT_MENU
    BRA     WAIT_ENTER
NAME_ENTRY_SECTION:

*=== NAME ENTRY ============================================
    JSR     NAME_ENTRY

*=== CHECK FOR EASTER EGG ==================================
    JSR     CHECK_MUSTACHE

*=== HAND OFF TO GAME ======================================
    JMP     GAME_START

*-----------------------------------------------------------
* DRAW_START
* Draws the title screen - the background, the game name,
* what each colour mode does, and the "press enter" message.
*-----------------------------------------------------------
DRAW_START:
    * Sky
    MOVE.L  #MC_BG, D1
    MOVE.B  #81, D0
    TRAP    #15
    MOVE.L  #MC_BG, D1
    MOVE.B  #80, D0
    TRAP    #15
    MOVE.L  #0,   D1
    MOVE.L  #0,   D2
    MOVE.L  #639, D3
    MOVE.L  #479, D4
    MOVE.B  #87,  D0
    TRAP    #15

    * Ground
    MOVE.L  #MC_GROUND, D1
    MOVE.B  #81, D0
    TRAP    #15
    MOVE.L  #MC_GROUND, D1
    MOVE.B  #80, D0
    TRAP    #15
    MOVE.L  #0,   D1
    MOVE.L  #390, D2
    MOVE.L  #639, D3
    MOVE.L  #479, D4
    MOVE.B  #87,  D0
    TRAP    #15

    * Title box
    MOVE.L  #MC_PANEL, D1
    MOVE.B  #81, D0
    TRAP    #15
    MOVE.L  #MC_GREEN, D1
    MOVE.B  #80, D0
    TRAP    #15
    MOVE.L  #90,  D1
    MOVE.L  #60,  D2
    MOVE.L  #550, D3
    MOVE.L  #175, D4
    MOVE.B  #87,  D0
    TRAP    #15
    * border
    MOVE.L  #MC_PANEL, D1
    MOVE.B  #81, D0
    TRAP    #15
    MOVE.L  #90,  D1
    MOVE.L  #60,  D2
    MOVE.L  #550, D3
    MOVE.L  #175, D4
    MOVE.B  #90,  D0
    TRAP    #15

    * Title text
    MOVE.L  #MC_GREEN, D1
    MOVE.B  #80, D0
    TRAP    #15
    LEA     STR_TITLE1, A1
    MOVE.L  #130, D1
    MOVE.L  #80,  D2
    MOVE.B  #95,  D0
    TRAP    #15

    MOVE.L  #MC_YELLOW, D1
    MOVE.B  #80, D0
    TRAP    #15
    LEA     STR_TITLE2, A1
    MOVE.L  #155, D1
    MOVE.L  #115, D2
    MOVE.B  #95,  D0
    TRAP    #15

    * How to play box
    MOVE.L  #MC_PANEL, D1
    MOVE.B  #81, D0
    TRAP    #15
    MOVE.L  #MC_PANEL, D1
    MOVE.B  #80, D0
    TRAP    #15
    MOVE.L  #60,  D1
    MOVE.L  #190, D2
    MOVE.L  #580, D3
    MOVE.L  #375, D4
    MOVE.B  #87,  D0
    TRAP    #15

    * Green row
    MOVE.L  #MC_GREEN, D1
    MOVE.B  #80, D0
    TRAP    #15
    LEA     STR_H_GREEN, A1
    MOVE.L  #75,  D1
    MOVE.L  #200, D2
    MOVE.B  #95,  D0
    TRAP    #15

    MOVE.L  #MC_WHITE, D1
    MOVE.B  #80, D0
    TRAP    #15
    LEA     STR_H_GREEN2, A1
    MOVE.L  #75,  D1
    MOVE.L  #218, D2
    MOVE.B  #95,  D0
    TRAP    #15

    * Red row
    MOVE.L  #MC_RED, D1
    MOVE.B  #80, D0
    TRAP    #15
    LEA     STR_H_RED, A1
    MOVE.L  #75,  D1
    MOVE.L  #245, D2
    MOVE.B  #95,  D0
    TRAP    #15

    MOVE.L  #MC_WHITE, D1
    MOVE.B  #80, D0
    TRAP    #15
    LEA     STR_H_RED2, A1
    MOVE.L  #75,  D1
    MOVE.L  #263, D2
    MOVE.B  #95,  D0
    TRAP    #15

    * Blue row
    MOVE.L  #MC_BLUE, D1
    MOVE.B  #80, D0
    TRAP    #15
    LEA     STR_H_BLUE, A1
    MOVE.L  #75,  D1
    MOVE.L  #290, D2
    MOVE.B  #95,  D0
    TRAP    #15

    MOVE.L  #MC_WHITE, D1
    MOVE.B  #80, D0
    TRAP    #15
    LEA     STR_H_BLUE2, A1
    MOVE.L  #75,  D1
    MOVE.L  #308, D2
    MOVE.B  #95,  D0
    TRAP    #15

    * Green fly hint
    MOVE.L  #MC_WHITE, D1
    MOVE.B  #80, D0
    TRAP    #15
    LEA     STR_H_GF, A1
    MOVE.L  #75,  D1
    MOVE.L  #335, D2
    MOVE.B  #95,  D0
    TRAP    #15

    * Press space
    MOVE.L  #MC_GREEN, D1
    MOVE.B  #81, D0
    TRAP    #15
    MOVE.L  #MC_PANEL, D1
    MOVE.B  #80, D0
    TRAP    #15
    MOVE.L  #195, D1
    MOVE.L  #400, D2
    MOVE.L  #445, D3
    MOVE.L  #428, D4
    MOVE.B  #87,  D0
    TRAP    #15
    MOVE.L  #MC_GREEN, D1
    MOVE.B  #80, D0
    TRAP    #15
    LEA     STR_PRESS, A1
    MOVE.L  #203, D1
    MOVE.L  #407, D2
    MOVE.B  #95,  D0
    TRAP    #15

    * Flip
    MOVE.B  #94,  D0
    TRAP    #15
    RTS

*-----------------------------------------------------------
* NAME_ENTRY
* This is where the player types their name.
* Backspace deletes, Shift+Enter confirms.
*-----------------------------------------------------------
NAME_ENTRY:
    * Clear the name and get ready for typing
    LEA     FROG_NAME, A0
    MOVE.B  #0, (A0)                * empty the name buffer
    MOVE.L  #0, D7                  * D7 keeps count of how many letters have been typed

NE_REDRAW:
    JSR     DRAW_NAME_SCREEN

NE_LOOP:
    * Wait for the next key press
    MOVE.B  #5,  D0
    TRAP    #15                     * task 5 waits here until something is typed

    CMP.B   #$1B, D1               * ESC key?
    BEQ     QUIT_MENU               * yes - quit

    CMP.B   #$0D, D1               * was that the Enter key?
    BNE     NE_NOT_ENTER
    * Enter was pressed - only confirm if Shift is also held
    MOVE.L  #$10000000, D1         * check if Shift is being held right now
    MOVE.B  #19, D0
    TRAP    #15
    BTST.L  #31, D1
    BNE     NE_DONE                 * Shift+Enter - confirm the name
    BRA     NE_LOOP                 * just Enter on its own - ignore and keep typing
NE_NOT_ENTER:

    CMP.B   #$08, D1               * was that backspace?
    BNE     NE_PRINTABLE
    * Delete the last letter
    TST.L   D7
    BEQ     NE_LOOP                 * nothing typed yet, nothing to delete
    SUB.L   #1, D7                  * one less letter
    LEA     FROG_NAME, A0
    ADDA.L  D7, A0                  * go to where the last letter is
    MOVE.B  #0, (A0)                * wipe it out
    BRA     NE_REDRAW

NE_PRINTABLE:
    * Only add the character if its a normal typeable one
    CMP.B   #32,  D1               * below space means its a control key, ignore
    BLT     NE_LOOP
    CMP.B   #126, D1               * above ~ means its a weird character, ignore
    BGT     NE_LOOP
    CMP.L   #NAME_MAX, D7          * is the name already as long as it can be?
    BGE     NE_LOOP                 * yes - dont add any more

    LEA     FROG_NAME, A0
    ADDA.L  D7, A0                  * go to the end of what has been typed so far
    MOVE.B  D1,  (A0)+             * add the new letter
    MOVE.B  #0,  (A0)              * put a null after it so text drawing knows where to stop
    ADD.L   #1,  D7                * one more letter in the name now
    BRA     NE_REDRAW              * redraw so the player can see what they typed

NE_DONE:
    * If they didnt type anything just use the default name Froggy
    TST.L   D7
    BNE     NE_EXIT                 * they did type something, keep it
    LEA     FROG_NAME,   A0
    LEA     STR_DEFAULT, A1
NE_COPY:
    MOVE.B  (A1)+, D0              * copy each letter of the default name
    MOVE.B  D0,    (A0)+
    BNE     NE_COPY                 * keep going until the null at the end
NE_EXIT:
    RTS

*-----------------------------------------------------------
* DRAW_NAME_SCREEN
* Draws the name entry screen - the box where you type,
* whatever you have typed so far, and the hint at the bottom.
*-----------------------------------------------------------
DRAW_NAME_SCREEN:
    * Background
    MOVE.L  #MC_BG, D1
    MOVE.B  #81, D0
    TRAP    #15
    MOVE.L  #MC_BG, D1
    MOVE.B  #80, D0
    TRAP    #15
    MOVE.L  #0,   D1
    MOVE.L  #0,   D2
    MOVE.L  #639, D3
    MOVE.L  #479, D4
    MOVE.B  #87,  D0
    TRAP    #15

    * Ground
    MOVE.L  #MC_GROUND, D1
    MOVE.B  #81, D0
    TRAP    #15
    MOVE.L  #MC_GROUND, D1
    MOVE.B  #80, D0
    TRAP    #15
    MOVE.L  #0,   D1
    MOVE.L  #390, D2
    MOVE.L  #639, D3
    MOVE.L  #479, D4
    MOVE.B  #87,  D0
    TRAP    #15

    * Panel
    MOVE.L  #MC_PANEL, D1
    MOVE.B  #81, D0
    TRAP    #15
    MOVE.L  #MC_CYAN, D1
    MOVE.B  #80, D0
    TRAP    #15
    MOVE.L  #110, D1
    MOVE.L  #100, D2
    MOVE.L  #530, D3
    MOVE.L  #340, D4
    MOVE.B  #87,  D0
    TRAP    #15
    MOVE.L  #MC_PANEL, D1
    MOVE.B  #81, D0
    TRAP    #15
    MOVE.L  #110, D1
    MOVE.L  #100, D2
    MOVE.L  #530, D3
    MOVE.L  #340, D4
    MOVE.B  #90,  D0
    TRAP    #15

    * Heading
    MOVE.L  #MC_CYAN, D1
    MOVE.B  #80, D0
    TRAP    #15
    LEA     STR_NAME_HD, A1
    MOVE.L  #195, D1
    MOVE.L  #120, D2
    MOVE.B  #95,  D0
    TRAP    #15

    * Subheading
    MOVE.L  #MC_WHITE, D1
    MOVE.B  #80, D0
    TRAP    #15
    LEA     STR_NAME_SUB, A1
    MOVE.L  #155, D1
    MOVE.L  #148, D2
    MOVE.B  #95,  D0
    TRAP    #15

    * Input box
    MOVE.L  #MC_DARK, D1
    MOVE.B  #81, D0
    TRAP    #15
    MOVE.L  #MC_CYAN, D1
    MOVE.B  #80, D0
    TRAP    #15
    MOVE.L  #130, D1
    MOVE.L  #178, D2
    MOVE.L  #510, D3
    MOVE.L  #218, D4
    MOVE.B  #87,  D0
    TRAP    #15
    MOVE.L  #MC_DARK, D1
    MOVE.B  #81, D0
    TRAP    #15
    MOVE.L  #130, D1
    MOVE.L  #178, D2
    MOVE.L  #510, D3
    MOVE.L  #218, D4
    MOVE.B  #90,  D0
    TRAP    #15

    * Current name
    MOVE.L  #MC_GREEN, D1
    MOVE.B  #80, D0
    TRAP    #15
    LEA     FROG_NAME, A1
    MOVE.L  #138, D1
    MOVE.L  #186, D2
    MOVE.B  #95,  D0
    TRAP    #15

    * Cursor - X = 138 + len*8
    MOVE.L  #0, D5
    LEA     FROG_NAME, A0
DNS_LEN:
    MOVE.B  (A0)+, D6
    BEQ     DNS_DONE
    ADD.L   #1, D5
    BRA     DNS_LEN
DNS_DONE:
    MULU    #8, D5
    ADD.L   #138, D5
    MOVE.L  #MC_CYAN, D1
    MOVE.B  #81, D0
    TRAP    #15
    MOVE.L  #MC_CYAN, D1
    MOVE.B  #80, D0
    TRAP    #15
    MOVE.L  D5,  D1
    MOVE.L  #186, D2
    MOVE.L  D5,  D3
    ADD.L   #2,  D3
    MOVE.L  #202, D4
    MOVE.B  #87,  D0
    TRAP    #15

    * Hints
    MOVE.L  #MC_WHITE, D1
    MOVE.B  #80, D0
    TRAP    #15
    LEA     STR_NAME_HINT1, A1
    MOVE.L  #155, D1
    MOVE.L  #240, D2
    MOVE.B  #95,  D0
    TRAP    #15

    LEA     STR_NAME_HINT2, A1
    MOVE.L  #155, D1
    MOVE.L  #260, D2
    MOVE.B  #95,  D0
    TRAP    #15

    * Flip
    MOVE.B  #94,  D0
    TRAP    #15
    RTS

*-----------------------------------------------------------
* CHECK_MUSTACHE
* Compares FROG_NAME against "filip" (case-insensitive).
* Sets MUSTACHE_FLAG=1 if match, 0 otherwise.
* Checks each char with OR $20 to lowercase before comparing.
*-----------------------------------------------------------
*-----------------------------------------------------------
* CHECK_MUSTACHE
* Sets MUSTACHE_FLAG=1 if FROG_NAME is "filip" (exact, lowercase)
* Also checks "Filip" with capital F.
*-----------------------------------------------------------
CHECK_MUSTACHE:
    * Check if the name is "filip" or "Filip" to unlock the moustache easter egg
    MOVE.L  #0, MUSTACHE_FLAG      * start by assuming no match

    LEA     FROG_NAME, A0
    LEA     STR_FILIP, A1           * try matching "filip"
    JSR     STR_EQUAL
    TST.L   D0
    BNE     CM_YES                  * it matched

    LEA     FROG_NAME, A0
    LEA     STR_FILIP2, A1          * try matching "Filip" with capital F
    JSR     STR_EQUAL
    TST.L   D0
    BEQ     CM_NO                   * neither matched

CM_YES:
    MOVE.L  #1, MUSTACHE_FLAG      * turn on the moustache
CM_NO:
    RTS

*-----------------------------------------------------------
* STR_EQUAL
* Compares two strings. Returns 1 if they are the same, 0 if not.
* A0 and A1 should point to the two strings before calling this.
*-----------------------------------------------------------
STR_EQUAL:
    * Compare two strings one letter at a time.
    * Both have to match AND end at the same place (so "filip" doesnt match "filipe")
SE_LOOP:
    MOVE.B  (A0)+, D0              * get the next letter from the name
    MOVE.B  (A1)+, D1              * get the next letter from what we are checking against
    CMP.B   D1, D0                 * same?
    BNE     SE_NO                   * no - not a match
    TST.B   D0                     * did both strings just end at the same time?
    BNE     SE_LOOP                 * no - keep checking
    MOVE.L  #1, D0                 * yes - they are the same
    RTS
SE_NO:
    MOVE.L  #0, D0                 * not a match
    RTS

*-----------------------------------------------------------
* Text strings for the menu screens
*-----------------------------------------------------------
STR_TITLE1:     DC.B  '=== C H R O M A F R O G ===',0
STR_TITLE2:     DC.B  'Dodge. Jump. Absorb. Survive.',0
STR_FILIP:      DC.B  'filip',0
STR_FILIP2:     DC.B  'Filip',0
STR_H_GREEN:    DC.B  'GREEN FROG + SPACE:',0
STR_H_GREEN2:   DC.B  '  Jump over green flies for +5pts each',0
STR_H_RED:      DC.B  'RED FROG + SPACE:',0
STR_H_RED2:     DC.B  '  Blast red flies straight into the sky',0
STR_H_BLUE:     DC.B  'BLUE FROG + SPACE:',0
STR_H_BLUE2:    DC.B  '  Pull blue flies toward you for +10pts each',0
STR_H_GF:       DC.B  'Touch any fly without the right colour = DAMAGE!',0
STR_PRESS:      DC.B  '  PRESS ENTER TO PLAY  ',0
STR_NAME_HD:    DC.B  'NAME YOUR FROG',0
STR_NAME_SUB:   DC.B  'What shall your frog be called?',0
STR_NAME_HINT1: DC.B  'SHIFT+ENTER = confirm name',0
STR_NAME_HINT2: DC.B  'BACKSPACE = delete',0
STR_DEFAULT:    DC.B  'Froggy',0

* Sound file paths - WAV files must be in the same folder as the .X68 files
SND_MUSIC:      DC.B  'music.wav',0
SND_JUMP:       DC.B  'jump.wav',0
SND_HIT:        DC.B  'hit.wav',0

*-----------------------------------------------------------
* QUIT_MENU
* ESC was pressed on the menu, shut everything down.
*-----------------------------------------------------------
QUIT_MENU:
    MOVE.B  #9, D0
    TRAP    #15

    INCLUDE "FROG_MAIN.X68"

    END     MENU_START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
