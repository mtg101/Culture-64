; zptr_1 holds ptr to properties
; #%76543210
; 0-2 size (1-3)
; 3-5 col (1-7)
PLANET_GENERATE_IN_SLOT:
    jsr LFSR_NEXT_SEED              ; own seed

    ; size
    lda LFSR_W0
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda PLANETS_SIZE_DIST, x

    ldy #0
    sta (ZP_PTR_1), y           ; save to slot props

    ; color
-
    lda LFSR_W0+1
    and #%00000111              ; 0-7
    bne +                       ; not black
    jsr LFSR_NEXT_SEED          ; try next
    jmp -
+

    asl 
    asl 
    asl                         ; now in bits 3-5
    sta PLANETS_TEMP

    lda (ZP_PTR_1), y 
    ora PLANETS_TEMP            ; 0-2 size, 3-5 color

    sta (ZP_PTR_1), y           ; save to slot props

    rts 

PLANET_SHOW_IN_SLOT:
    ; HACK just show #81 in x/y

    lda #ORBITS_Y
    sta TEXT_Y

    ldx ORBITS_CURRENT_SLOT
    lda ORBITS_SLOT_1_X, x
    sta TEXT_X

    ; get color from props
    ldy #0
    lda (ZP_PTR_1), y
    and #%00111000
    lsr 
    lsr 
    lsr                             ; 1-7 in a now for color
    sta TEXT_COLOR

    lda #81                         ; hack circle
    sta TEXT_CHAR

    jsr TEXT_DRAW_CHAR

    
    rts 

PLANETS_SIZE_DIST                        ; 1x1, 2x2, 3x3 types, over 32 for curve
                                    ; hack needs to come from distance to star and stuff...
    !byte 1, 1, 1, 1                ; 4/32
    !byte 3, 3, 3, 3                ; 4/32
    !byte 2, 2, 2, 2, 2, 2, 2, 2    ; 8/32
    !byte 1, 1, 1, 1, 1, 1, 1, 1    ; 8/32
    !byte 2, 2, 2, 2, 3, 3, 3, 3    ; 8/32

PLANETS_TEMP
    !byte 0

