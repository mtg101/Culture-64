; zptr_1 holds ptr
PLANET_GENERATE_IN_SLOT:
    jsr LFSR_NEXT_SEED              ; own seed

    lda LFSR_W0
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda PLANETS_DIST, x

    ldy #0
    sta (ZP_PTR_1), y           ; save to slot

    rts 

PLANET_SHOW_IN_SLOT:
    ; HACK just show #81 in x/y

    lda #ORBITS_Y
    sta TEXT_Y

    ldx ORBITS_CURRENT_SLOT
    lda ORBITS_SLOT_1_X, x
    sta TEXT_X

    lda #1                          ; hack white
    sta TEXT_COLOR

    lda #81                         ; hack circle
    sta TEXT_CHAR

    jsr TEXT_DRAW_CHAR

    rts 

PLANETS_DIST                        ; 0-2 types, over 32 for curve (1x1, 2x2, 3x3)
    !byte 0, 0, 0, 0                ; 4/32
    !byte 2, 2, 2, 2                ; 4/32
    !byte 1, 1, 1, 1, 1, 1, 1, 1    ; 8/32
    !byte 1, 1, 1, 1, 1, 1, 1, 1    ; 8/32
    !byte 1, 1, 1, 1, 1, 1, 1, 1    ; 8/32

