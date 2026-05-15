; generates logo from current seed
LOGO_GENERATE
    jsr    LFSR_NEXT_SEED      ; get a clean seed

    lda LFSR_W0
    ora #%11000000  ; 192-255 - inverted symbols
    sta LOGO_TL_CHAR

    lda LFSR_W0+1
    ora #%11000000  ; 192-255 - inverted symbols
    sta LOGO_TR_CHAR

    lda LFSR_W1
    ora #%11000000  ; 192-255 - inverted symbols
    sta LOGO_BL_CHAR

    lda LFSR_W1+1
    ora #%11000000  ; 192-255 - inverted symbols
    sta LOGO_BR_CHAR

    jsr    LFSR_NEXT_SEED      ; need another seed

    lda LFSR_W0
    and #%00000111  ; 0-7
    sta LOGO_TL_COL

    lda LFSR_W0+1
    and #%00000111  ; 0-7
    sta LOGO_TR_COL

    lda LFSR_W1
    and #%00000111  ; 0-7
    sta LOGO_BL_COL

    lda LFSR_W1+1
    and #%00000111  ; 0-7
    sta LOGO_BR_COL

    rts


; renders at LOGO_X / LOGO_Y
LOGO_RENDER
    ; tl
    lda LOGO_X
    sta TEXT_X
    lda LOGO_Y
    sta TEXT_Y
    lda LOGO_TL_CHAR
    sta TEXT_CHAR
    lda LOGO_TL_COL
    sta TEXT_COLOR
    jsr TEXT_DRAW_CHAR

    ; tr
    inc TEXT_X
    lda LOGO_TR_CHAR
    sta TEXT_CHAR
    lda LOGO_TR_COL
    sta TEXT_COLOR
    jsr TEXT_DRAW_CHAR

    ; bl
    dec TEXT_X
    inc TEXT_Y
    lda LOGO_BL_CHAR
    sta TEXT_CHAR
    lda LOGO_BL_COL
    sta TEXT_COLOR
    jsr TEXT_DRAW_CHAR

    ; br
    inc TEXT_X
    lda LOGO_BR_CHAR
    sta TEXT_CHAR
    lda LOGO_BR_COL
    sta TEXT_COLOR
    jsr TEXT_DRAW_CHAR

    rts


LOGO_TL_CHAR
    !byte 0
LOGO_TR_CHAR
    !byte 0
LOGO_BL_CHAR
    !byte 0
LOGO_BR_CHAR
    !byte 0
LOGO_TL_COL
    !byte 0
LOGO_TR_COL
    !byte 0
LOGO_BL_COL
    !byte 0
LOGO_BR_COL
    !byte 0

LOGO_X
    !byte 0
LOGO_Y
    !byte 0
