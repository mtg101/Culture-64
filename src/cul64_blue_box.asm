




BB_SHOW_TEXT_BOX
    jsr BB_DRAW_BOX

    ; center white text
    jsr TEXT_CENTER_STRING
    lda #13
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    jsr TEXT_WAIT_FOR_ENTER
    rts

BB_SHOW_OPTIONS_BOX
    rts
BB_SHOW_TEXT_ENTRY_BOX
    jsr BB_DRAW_BOX

    ; center white text
    jsr TEXT_CENTER_STRING
    lda #13
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; just press enter for now...
    lda #<BB_NO_TEXT_ENTRY_YET
    sta TEXT_STRING_PTR
    lda #>BB_NO_TEXT_ENTRY_YET
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING
    lda #15
    sta TEXT_Y
    jsr TEXT_DRAW_STRING

    jsr TEXT_WAIT_FOR_ENTER
    rts

BB_DRAW_BOX
    ; text always white
    ldy #WHITE

    ; top row border
    ldx #0
-
    lda #119 ; high hoz bar
    sta BB_TEXT_BOX_TOP_BORDER_ROW, x
    lda #WHITE
    sta BB_TEXT_BOX_TOP_BORDER_ROW_COL, x
    inx
    cpx #40
    bne -
    ; top left
    lda #79
    sta BB_TEXT_BOX_TOP_BORDER_ROW
    ; top right
    lda #80
    sta BB_TEXT_BOX_TOP_BORDER_ROW+39

    ; text 1 blank
    ldx #0
-
    lda #' '
    sta BB_TEXT_BOX_TEXT_ROW_1, x
    lda #WHITE
    sta BB_TEXT_BOX_TEXT_ROW_COL_1, x
    inx
    cpx #40
    bne -
    ; left
    lda #101
    sta BB_TEXT_BOX_TEXT_ROW_1
    ; right
    lda #103
    sta BB_TEXT_BOX_TEXT_ROW_1+39

    ; text gap blank
    ldx #0
-
    lda #' '
    sta BB_TEXT_BOX_TEXT_ROW_GAP, x
    lda #WHITE
    sta BB_TEXT_BOX_TEXT_ROW_COL_GAP, x
    inx
    cpx #40
    bne -
    ; left
    lda #101
    sta BB_TEXT_BOX_TEXT_ROW_GAP
    ; right
    lda #103
    sta BB_TEXT_BOX_TEXT_ROW_GAP+39

    ; text 2 blank
    ldx #0
-
    lda #' '
    sta BB_TEXT_BOX_TEXT_ROW_2, x
    lda #WHITE
    sta BB_TEXT_BOX_TEXT_ROW_COL_2, x
    inx
    cpx #40
    bne -
    ; left
    lda #101
    sta BB_TEXT_BOX_TEXT_ROW_2
    ; right
    lda #103
    sta BB_TEXT_BOX_TEXT_ROW_2+39

    ; bot row border
    ldx #0
-
    lda #111 ; low hoz bar
    sta BB_TEXT_BOX_BOT_BORDER_ROW, x
    lda #WHITE
    sta BB_TEXT_BOX_BOT_BORDER_ROW_COL, x
    inx
    cpx #40
    bne -
    ; bot left
    lda #76
    sta BB_TEXT_BOX_BOT_BORDER_ROW
    ; bot right
    lda #122
    sta BB_TEXT_BOX_BOT_BORDER_ROW+39

    rts




BB_TEXT_BOX_TOP_BORDER_ROW      = SCREEN_RAM + (12 * 40)
BB_TEXT_BOX_TEXT_ROW_1          = BB_TEXT_BOX_TOP_BORDER_ROW + 40
BB_TEXT_BOX_TEXT_ROW_GAP        = BB_TEXT_BOX_TEXT_ROW_1 + 40
BB_TEXT_BOX_TEXT_ROW_2          = BB_TEXT_BOX_TEXT_ROW_GAP + 40
BB_TEXT_BOX_BOT_BORDER_ROW      = BB_TEXT_BOX_TEXT_ROW_2 + 40

BB_TEXT_BOX_TOP_BORDER_ROW_COL  = COLOR_RAM + (12 * 40)
BB_TEXT_BOX_TEXT_ROW_COL_1      = BB_TEXT_BOX_TOP_BORDER_ROW_COL + 40
BB_TEXT_BOX_TEXT_ROW_COL_GAP    = BB_TEXT_BOX_TEXT_ROW_COL_1 + 40
BB_TEXT_BOX_TEXT_ROW_COL_2      = BB_TEXT_BOX_TEXT_ROW_COL_GAP + 40
BB_TEXT_BOX_BOT_BORDER_ROW_COL  = BB_TEXT_BOX_TEXT_ROW_COL_2 + 40


BB_NO_TEXT_ENTRY_YET
    !scr "> press enter for now <", 0
