DIPLOMAT_SHOW:
    ; clear bg
    ldx #0
-
    lda #$20                    ; space
    sta SCREEN_RAM_250_0, x
    lda #YELLOW
    sta SCREEN_COL_RAM_250_0, x
    inx
    cpx #250
    bne -

    ldx #0
-
    lda #$20                    ; space
    sta SCREEN_RAM_250_1, x
    lda #YELLOW
    sta SCREEN_COL_RAM_250_1, x
    inx
    cpx #250
    bne -

    ldx #0
-
    lda #$20                    ; space
    sta SCREEN_RAM_250_2, x
    lda #YELLOW
    sta SCREEN_COL_RAM_250_2, x
    inx
    cpx #100
    bne -

    ; invert D in top right
    lda #0 
    sta TEXT_Y
    lda #39
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    lda #132                ; invert D
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR

    ; bg from system bg
    lda SCREEN_SYSTEM_COLOR_TEXT_BG
    sta SCREEN_SYSTEM_SPACE_BG

    ; show diplomat label
    lda #<DIPLOMAT_DIPLOMAT_LABEL
    sta TEXT_STRING_PTR
    lda #>DIPLOMAT_DIPLOMAT_LABEL
    sta TEXT_STRING_PTR+1
    lda #1
    sta TEXT_Y
    lda #2
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; show diplomat name
    lda #<DIPLOMAT_BUFFER
    sta TEXT_STRING_PTR
    lda #>DIPLOMAT_BUFFER
    sta TEXT_STRING_PTR+1
    lda #1
    sta TEXT_Y
    lda #20
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; show diplomat logo
    lda #15
    sta LOGO_X
    lda #0
    sta LOGO_Y
    jsr LOGO_RENDER

    ; show passenger label
    lda #<DIPLOMAT_PASSENGER_LABEL
    sta TEXT_STRING_PTR
    lda #>DIPLOMAT_PASSENGER_LABEL
    sta TEXT_STRING_PTR+1
    lda #5
    sta TEXT_Y
    lda #2
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; show no cargo
    lda #<DIPLOMAT_NONE_LABEL
    sta TEXT_STRING_PTR
    lda #>DIPLOMAT_NONE_LABEL
    sta TEXT_STRING_PTR+1
    lda #7
    sta TEXT_Y
    lda #4
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING


; into...
DIPLOMAT_GAME_LOOP
    ; d diplomat
    lda #KEY_D_ROW
    sta CIA1_PRA

    lda CIA1_PRB
    and #KEY_D_COL  ; check pressed
    bne +           ; not pressed info
-
    lda CIA1_PRB
    and #KEY_D_COL  ; check released
    beq -
    jmp SCREEN_SYSTEM_RESHOW
+
    jmp DIPLOMAT_GAME_LOOP


DIPLOMAT_PASSENGER_LABEL
    !scr "passenger", 0
DIPLOMAT_NONE_LABEL
    !scr "< none >", 0
DIPLOMAT_DIPLOMAT_LABEL
    !scr "diplomat", 0
DIPLOMAT_BUFFER
    !fill BB_MAX_CHARS+1, 0

