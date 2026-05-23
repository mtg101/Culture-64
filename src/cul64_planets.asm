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

    rts 

PLANET_SHOW_IN_SLOT:
    ldy #0                      ; zptr index

    ; color
    lda (ZP_PTR_1), y
    and #%00111000
    lsr 
    lsr 
    lsr                             ; 1-7 in a now for color
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
    lda #81
    sta TEXT_CHAR
    jmp .planet_show_size_done
+
    cmp #2
    bne + 
    ; size 2x2
    lda #87
    sta TEXT_CHAR
    jmp .planet_show_size_done
+
    ; size 3x3
    lda #160
    sta TEXT_CHAR
    ; .planet_size_done
.planet_show_size_done:
    jsr TEXT_DRAW_CHAR
    rts 


PLANETS_TEMP
    !byte 0

