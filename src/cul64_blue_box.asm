




BB_SHOW_TEXT_BOX
    ; CENTER white text
    jsr TEXT_CENTER_STRING
    lda #13
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR

    jsr BB_DRAW_BOX
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

    ; mid row blank
    ldx #0
-
    lda #' '
    sta BB_TEXT_BOX_TEXT_ROW, x
    lda #WHITE
    sta BB_TEXT_BOX_TEXT_ROW_COL, x
    inx
    cpx #40
    bne -
    ; left
    lda #101
    sta BB_TEXT_BOX_TEXT_ROW
    ; right
    lda #103
    sta BB_TEXT_BOX_TEXT_ROW+39

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



BB_SHOW_OPTIONS_BOX
    rts
BB_SHOW_TEXT_ENTRY_BOX
    rts


BB_TEXT_BOX_TOP_BORDER_ROW      = SCREEN_RAM + (12 * 40)
BB_TEXT_BOX_TEXT_ROW            = BB_TEXT_BOX_TOP_BORDER_ROW + 40
BB_TEXT_BOX_BOT_BORDER_ROW      = BB_TEXT_BOX_TEXT_ROW + 40

BB_TEXT_BOX_TOP_BORDER_ROW_COL  = COLOR_RAM + (12 * 40)
BB_TEXT_BOX_TEXT_ROW_COL        = BB_TEXT_BOX_TOP_BORDER_ROW_COL + 40
BB_TEXT_BOX_BOT_BORDER_ROW_COL  = BB_TEXT_BOX_TEXT_ROW_COL + 40


