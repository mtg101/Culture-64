




STARS_FILL_SCREEN

    ldx #0
-
    jsr STARS_GEN_CHAR
    sta SCREEN_RAM_250_0, x

    jsr STARS_GEN_COLOR
    sta SCREEN_COL_RAM_250_0, x

    inx
    cpx #250
    bne -

    ldx #0
-
    jsr STARS_GEN_CHAR
    sta SCREEN_RAM_250_1, x

    jsr STARS_GEN_COLOR
    sta SCREEN_COL_RAM_250_1, x

    inx
    cpx #250
    bne -

    ldx #0
-
    jsr STARS_GEN_CHAR
    sta SCREEN_RAM_250_2, x

    jsr STARS_GEN_COLOR
    sta SCREEN_COL_RAM_250_2, x

    inx
    cpx #250
    bne -

    ldx #0
-
    jsr STARS_GEN_CHAR
    sta SCREEN_RAM_250_3, x

    jsr STARS_GEN_COLOR
    sta SCREEN_COL_RAM_250_3, x

    inx
    cpx #250
    bne -

    rts

; stores random COLOR in a
; 1 in 8 CYAN, 2 in 8 white, 5 in 8 yellow
STARS_GEN_COLOR
    lda MATHS_RNG
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
    lda MATHS_RNG
    and #%01111111              ; 0-127
    bne .star_char_space        ; mostly empty space

    lda MATHS_RNG
    and #%00001111              ; 0-15 - but SID seems to like 0 and hate 15 - will replace with LFSR seeds later hack for now...
    cmp #%00001011
    beq .star_char_asterisk     ; 1 in 16

    cmp #%00001110
    beq .star_char_plus         ; 1 in 16
    cmp #%00001100
    beq .star_char_plus         ; 2 in 16


                                ; rest dots (13 in 16)
.star_char_period
    lda #'.'
    rts
.star_char_plus
    lda #'+'
    rts
.star_char_asterisk
    lda #'*'
    rts
.star_char_space
    lda #' '
    rts
