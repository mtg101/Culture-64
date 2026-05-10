




SCREEN_SYSTEM_SHOW
    ; black bg
    lda #BLACK
    sta BG_COL

    ; black border
    lda #BLACK
    sta BORDER_COL

    ; stars
    jsr STARS_FILL_SCREEN

    ; title string
    lda #<SCREEN_SYSTEM_TITLE
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_TITLE
    sta TEXT_STRING_PTR+1
    lda #0
    sta TEXT_X
    lda #0
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; all labels same x
    lda #5
    sta TEXT_X

    lda #<SCREEN_SYSTEM_NAME_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_NAME_LABEL
    sta TEXT_STRING_PTR+1
    lda #6
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SCREEN_SYSTEM_COLOR_1_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_COLOR_1_LABEL
    sta TEXT_STRING_PTR+1
    lda #8
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SCREEN_SYSTEM_COLOR_2_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_COLOR_2_LABEL
    sta TEXT_STRING_PTR+1
    lda #10
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SCREEN_SYSTEM_SUN_TYPE_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_SUN_TYPE_LABEL
    sta TEXT_STRING_PTR+1
    lda #12
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SCREEN_SYSTEM_NUM_PLANETS_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_NUM_PLANETS_LABEL
    sta TEXT_STRING_PTR+1
    lda #14
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SCREEN_SYSTEM_TECH_LEVEL_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_TECH_LEVEL_LABEL
    sta TEXT_STRING_PTR+1
    lda #16
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SCREEN_SYSTEM_SEC_STATUS_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_SEC_STATUS_LABEL
    sta TEXT_STRING_PTR+1
    lda #18
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING


SCREEN_SYSTEM_GAME_LOOP

    lda #KEY_J_ROW
    sta CIA1_PRA

    lda CIA1_PRB
    and #KEY_J_COL  ; check pressed
    bne +           ; not pressed jump
-
    lda CIA1_PRB
    and #KEY_J_COL  ; check released
    beq -
    jmp SCREEN_JUMP_SHOW
+
    jmp SCREEN_SYSTEM_GAME_LOOP


SCREEN_SYSTEM_TITLE
    !scr "culture 64", 0
SCREEN_SYSTEM_NAME_LABEL
    !scr "name:", 0
SCREEN_SYSTEM_SUN_TYPE_LABEL
    !scr "sun type:", 0
SCREEN_SYSTEM_COLOR_1_LABEL
    !scr "color 1:", 0
SCREEN_SYSTEM_COLOR_2_LABEL
    !scr "color 2:", 0
SCREEN_SYSTEM_NUM_PLANETS_LABEL
    !scr "num planets:", 0
SCREEN_SYSTEM_TECH_LEVEL_LABEL
    !scr "tech level:", 0
SCREEN_SYSTEM_SEC_STATUS_LABEL
    !scr "security:", 0


