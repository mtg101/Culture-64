; zptr_1 holds ptr to properties
; #%76543210
; 0-2 size (1-3)
; 3-5 col (1-7)
PLANET_GENERATE_IN_SLOT:
    jsr LFSR_NEXT_SEED              ; own seed

    ; zptry offset
    ldy #0

    ; position
    lda ORBITS_CURRENT_SLOT

    cmp #2                      ; 0-1
    bcs +
    ; 0-1 - size=1x1
    lda #1
    sta (ZP_PTR_1), y           ; save to slot props
    jmp .planet_size_done
+
    cmp #4                      ; 0-3 but 0-1 already done: 2-3
    bcs +
    ; 2-4 - size=2x2
    lda #2
    sta (ZP_PTR_1), y           ; save to slot props
    jmp .planet_size_done
+
    ; 5-8 - size=3x3
    lda #3
    sta (ZP_PTR_1), y           ; save to slot props
    ; jmp .planet_size_done
+
.planet_size_done

    ; color
-
    lda LFSR_W0+1
    and #%00000111              ; 0-7
    bne +                       ; not black
    jsr LFSR_NEXT_SEED          ; try next
    jmp -
+

    asl 
    asl                         ; now in bits 2-4
    sta PLANETS_TEMP

    lda (ZP_PTR_1), y 
    ora PLANETS_TEMP            ; 0-2 size, 3-5 color

    sta (ZP_PTR_1), y           ; save to slot props

    ; planet name
    jsr NAME_GENERATE_PLANET
    lda #<NAME_BUFFER
    sta ZP_PTR_1
    lda #>NAME_BUFFER
    sta ZP_PTR_1_PAIR
    ; ZP_PTR_2 and pair already has dest address
    jsr SYS_MEM_COPY    

    rts 

PLANET_SHOW_IN_SLOT:
    ldy #0                      ; zptr index

    ; color
    lda (ZP_PTR_1), y
    and #%00011100
    lsr 
    lsr                         ; 1-7 in a now for color
    sta TEXT_COLOR

    ; y
    lda #ORBITS_Y
    sta TEXT_Y
    ; x
    ldx ORBITS_CURRENT_SLOT
    lda ORBITS_SLOT_1_X, x
    sta TEXT_X

    ; size
    lda (ZP_PTR_1), y
    and #%00000011              ; sz 0-3, but never 0
    cmp #1
    bne + 
    ; size 1x1
    lda PLANETS_1x1
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR
    jmp .planet_show_size_done
+
    cmp #2
    bne + 
    ; size 2x2
    dec TEXT_X
    dec TEXT_Y

    lda #<PLANETS_2x2_T
    sta TEXT_STRING_PTR
    lda #>PLANETS_2x2_T
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    inc TEXT_Y
    lda #<PLANETS_2x2_M
    sta TEXT_STRING_PTR
    lda #>PLANETS_2x2_M
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    inc TEXT_Y
    lda #<PLANETS_2x2_B
    sta TEXT_STRING_PTR
    lda #>PLANETS_2x2_B
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    jmp .planet_show_size_done
+
    ; size 3x3
    dec TEXT_X
    dec TEXT_Y

    lda #<PLANETS_3x3_T
    sta TEXT_STRING_PTR
    lda #>PLANETS_3x3_T
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    inc TEXT_Y
    lda #<PLANETS_3x3_M
    sta TEXT_STRING_PTR
    lda #>PLANETS_3x3_M
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    inc TEXT_Y
    lda #<PLANETS_3x3_B
    sta TEXT_STRING_PTR
    lda #>PLANETS_3x3_B
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING
.planet_show_size_done:
    rts 


PLANETS_TEMP
    !byte 0

PLANETS_1x1
    !byte 81

PLANETS_2x2_T
    !byte 85, 67, 73, 0
PLANETS_2x2_M
    !byte 66, 81, 66, 0
PLANETS_2x2_B
    !byte 74, 67, 75, 0

PLANETS_3x3_T
    !byte 233, 224, 223, 0
PLANETS_3x3_M
    !byte 224, 224, 224, 0
PLANETS_3x3_B
    !byte 95, 224, 105, 0

PLANETS_MOON_TYPE_LUT
    !byte 81, 81, 81, 81, 81, 81, 81, 81
    !byte 87, 42, 90, 86, 46, 43, 81, 81

