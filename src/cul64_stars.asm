STARS_CLEAR_LOWER
    ldx #0

-
    lda #$20
    sta SCREEN_RAM_250_3, x
    inx
    cpx #250
    bne -

-
    sta SCREEN_RAM_250_2+100, x
    inx
    cpx #250
    bne -


    rts

STARS_FILL_SCREEN
    ldx #0
-
    jsr STARS_GEN_CHAR
    sta SCREEN_RAM_250_0, x

    jsr STARS_GEN_COLOR
    sta SCREEN_COL_RAM_250_0, x

    jsr LFSR_NEXT_SEED

    inx
    cpx #250
    bne -

    ldx #0
-
    jsr STARS_GEN_CHAR
    sta SCREEN_RAM_250_1, x

    jsr STARS_GEN_COLOR
    sta SCREEN_COL_RAM_250_1, x

    jsr LFSR_NEXT_SEED

    inx
    cpx #250
    bne -

    ldx #0
-
    jsr STARS_GEN_CHAR
    sta SCREEN_RAM_250_2, x

    jsr STARS_GEN_COLOR
    sta SCREEN_COL_RAM_250_2, x

    jsr LFSR_NEXT_SEED

    inx
    cpx #250
    bne -

    ldx #0
-
    jsr STARS_GEN_CHAR
    sta SCREEN_RAM_250_3, x

    jsr STARS_GEN_COLOR
    sta SCREEN_COL_RAM_250_3, x

    jsr LFSR_NEXT_SEED

    inx
    cpx #250
    bne -

    rts

; stores random COLOR in a
; 1 in 8 CYAN, 2 in 8 white, 5 in 8 yellow
STARS_GEN_COLOR
    lda LFSR_W0
    and #%00000111  ; 0-7
    beq .star_col_cyan
    cmp #3          ; carry will be clear if it's 0, 1 or 2
    bcc .star_col_white

.star_col_yellow
    lda #YELLOW
    rts
.star_col_cyan
    lda #CYAN
    rts
.star_col_white
    lda #WHITE
    rts

; stores random star char in a
; only 1 in 128 isn't blank space
STARS_GEN_CHAR
    lda LFSR_W1
    and #%00111111              ; 0-63
    bne .star_char_space        ; mostly empty space

.star_char_period
    lda #'.'
    rts
.star_char_space
    lda #' '
    rts

