SHIP_SHOW:
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

    ; invert I in top right
    lda #0 
    sta TEXT_Y
    lda #39
    sta TEXT_X
    lda #CYAN
    sta TEXT_COLOR
    lda #147                ; invert I
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR

    ; show labels
    lda #2
    sta TEXT_X

    lda #<SHIP_SHIP_LABEL
    sta TEXT_STRING_PTR
    lda #>SHIP_SHIP_LABEL
    sta TEXT_STRING_PTR+1
    lda #1
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SHIP_HOME_LABEL
    sta TEXT_STRING_PTR
    lda #>SHIP_HOME_LABEL
    sta TEXT_STRING_PTR+1
    lda #5
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SHIP_CARGO_LABEL
    sta TEXT_STRING_PTR
    lda #>SHIP_CARGO_LABEL
    sta TEXT_STRING_PTR+1
    lda #8
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SHIP_BULLETS_LABEL
    sta TEXT_STRING_PTR
    lda #>SHIP_BULLETS_LABEL
    sta TEXT_STRING_PTR+1
    lda #9
    sta TEXT_Y
    jsr TEXT_DRAW_STRING_VERT

    lda #<SHIP_CABIN_LABEL
    sta TEXT_STRING_PTR
    lda #>SHIP_CABIN_LABEL
    sta TEXT_STRING_PTR+1
    lda #8
    sta TEXT_Y
    lda #20
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SHIP_BULLETS_LABEL
    sta TEXT_STRING_PTR
    lda #>SHIP_BULLETS_LABEL
    sta TEXT_STRING_PTR+1
    lda #9
    sta TEXT_Y
    jsr TEXT_DRAW_STRING_VERT

; into...
SHIP_GAME_LOOP
    lda #1
    sta SHIP_ON

    ; s ship
    lda #KEY_S_ROW
    sta CIA1_PRA

    lda CIA1_PRB
    and #KEY_S_COL  ; check pressed
    bne +           ; not pressed info
-
    lda CIA1_PRB
    and #KEY_S_COL  ; check released
    beq -
    lda #0
    sta SHIP_ON
    jmp SCREEN_SYSTEM_SHOW
+
    jmp SHIP_GAME_LOOP


SHIP_ON
    !byte 0
SHIP_COLOR_BG
    !byte BLUE


SHIP_SHIP_LABEL
    !scr "ship", 0
SHIP_HOME_LABEL
    !scr "home system", 0
SHIP_CARGO_LABEL
    !scr "cargo bays", 0
SHIP_CABIN_LABEL
    !scr "passenger cabins", 0
SHIP_BULLETS_LABEL
    !scr "-----", 0
