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
    ; 2-4 - size=2x
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

    jmp (ZP_PTR_RETURN)             ; jump back to next orbit

PLANET_SHOW_SLOT_1:
    ; color
    lda ORBITS_SLOT_1_PROPS
    and #%00011100
    lsr 
    lsr                         ; 1-7 in a now for color
    ora #%00001000              ; set bit 3 for MCM
    sta TEXT_COLOR

    ; y
    lda #ORBITS_Y
    sta TEXT_Y
    ; x
    lda ORBITS_SLOT_1_X
    sta TEXT_X

    ; char
    lda PLANETS_1x1_1
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR
    jmp (ZP_PTR_RETURN)             ; jump back to next orbit

PLANET_SHOW_SLOT_2:
    ; color
    lda ORBITS_SLOT_2_PROPS
    and #%00011100
    lsr 
    lsr                         ; 1-7 in a now for color
    ora #%00001000              ; set bit 3 for MCM
    sta TEXT_COLOR

    ; y
    lda #ORBITS_Y
    sta TEXT_Y
    ; x
    lda ORBITS_SLOT_2_X
    sta TEXT_X

    ; char
    lda PLANETS_1x1_2
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR
    jmp (ZP_PTR_RETURN)             ; jump back to next orbit

PLANET_SHOW_SLOT_3:
    ; color
    lda ORBITS_SLOT_3_PROPS
    and #%00011100
    lsr 
    lsr                         ; 1-7 in a now for color
    ora #%00001000              ; set bit 3 for MCM
    sta TEXT_COLOR

    ; y
    lda #ORBITS_Y
    sta TEXT_Y
    ; x
    lda ORBITS_SLOT_3_X
    sta TEXT_X

    ; size 3x3
    dec TEXT_X
    dec TEXT_Y

    ; chars
    lda #<PLANETS_2x2_T_3
    sta TEXT_STRING_PTR
    lda #>PLANETS_2x2_T_3
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    inc TEXT_Y
    lda #<PLANETS_2x2_M_3
    sta TEXT_STRING_PTR
    lda #>PLANETS_2x2_M_3
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    inc TEXT_Y
    lda #<PLANETS_2x2_B_3
    sta TEXT_STRING_PTR
    lda #>PLANETS_2x2_B_3
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING
    jmp (ZP_PTR_RETURN)             ; jump back to next orbit

PLANET_SHOW_SLOT_4:
    ; color
    lda ORBITS_SLOT_4_PROPS
    and #%00011100
    lsr 
    lsr                         ; 1-7 in a now for color
    ora #%00001000              ; set bit 3 for MCM
    sta TEXT_COLOR

    ; y
    lda #ORBITS_Y
    sta TEXT_Y
    ; x
    lda ORBITS_SLOT_4_X
    sta TEXT_X

    ; size 3x3
    dec TEXT_X
    dec TEXT_Y

    ; chars
    lda #<PLANETS_2x2_T_4
    sta TEXT_STRING_PTR
    lda #>PLANETS_2x2_T_4
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    inc TEXT_Y
    lda #<PLANETS_2x2_M_4
    sta TEXT_STRING_PTR
    lda #>PLANETS_2x2_M_4
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    inc TEXT_Y
    lda #<PLANETS_2x2_B_4
    sta TEXT_STRING_PTR
    lda #>PLANETS_2x2_B_4
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING
    jmp (ZP_PTR_RETURN)             ; jump back to next orbit

PLANET_SHOW_SLOT_5:
    ; color
    lda ORBITS_SLOT_5_PROPS
    and #%00011100
    lsr 
    lsr                         ; 1-7 in a now for color
    ora #%00001000              ; set bit 3 for MCM
    sta TEXT_COLOR

    ; y
    lda #ORBITS_Y
    sta TEXT_Y
    ; x
    lda ORBITS_SLOT_5_X
    sta TEXT_X

    ; size 3x3
    dec TEXT_X
    dec TEXT_Y

    ; chars
    lda #<PLANETS_3x3_T_5
    sta TEXT_STRING_PTR
    lda #>PLANETS_3x3_T_5
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    inc TEXT_Y
    lda #<PLANETS_3x3_M_5
    sta TEXT_STRING_PTR
    lda #>PLANETS_3x3_M_5
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    inc TEXT_Y
    lda #<PLANETS_3x3_B_5
    sta TEXT_STRING_PTR
    lda #>PLANETS_3x3_B_5
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING
    jmp (ZP_PTR_RETURN)             ; jump back to next orbit

PLANET_SHOW_SLOT_6:
    ; color
    lda ORBITS_SLOT_6_PROPS
    and #%00011100
    lsr 
    lsr                         ; 1-7 in a now for color
    ora #%00001000              ; set bit 3 for MCM
    sta TEXT_COLOR

    ; y
    lda #ORBITS_Y
    sta TEXT_Y
    ; x
    lda ORBITS_SLOT_6_X
    sta TEXT_X

    ; size 3x3
    dec TEXT_X
    dec TEXT_Y

    ; chars
    lda #<PLANETS_3x3_T_6
    sta TEXT_STRING_PTR
    lda #>PLANETS_3x3_T_6
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    inc TEXT_Y
    lda #<PLANETS_3x3_M_6
    sta TEXT_STRING_PTR
    lda #>PLANETS_3x3_M_6
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    inc TEXT_Y
    lda #<PLANETS_3x3_B_6
    sta TEXT_STRING_PTR
    lda #>PLANETS_3x3_B_6
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING
    jmp (ZP_PTR_RETURN)             ; jump back to next orbit

PLANET_SHOW_SLOT_7:
    ; color
    lda ORBITS_SLOT_7_PROPS
    and #%00011100
    lsr 
    lsr                         ; 1-7 in a now for color
    ora #%00001000              ; set bit 3 for MCM
    sta TEXT_COLOR

    ; y
    lda #ORBITS_Y
    sta TEXT_Y
    ; x
    lda ORBITS_SLOT_7_X
    sta TEXT_X

    ; size 3x3
    dec TEXT_X
    dec TEXT_Y

    ; chars
    lda #<PLANETS_3x3_T_7
    sta TEXT_STRING_PTR
    lda #>PLANETS_3x3_T_7
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    inc TEXT_Y
    lda #<PLANETS_3x3_M_7
    sta TEXT_STRING_PTR
    lda #>PLANETS_3x3_M_7
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    inc TEXT_Y
    lda #<PLANETS_3x3_B_7
    sta TEXT_STRING_PTR
    lda #>PLANETS_3x3_B_7
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING
    jmp (ZP_PTR_RETURN)             ; jump back to next orbit

PLANET_SHOW_SLOT_8:
    ; color
    lda ORBITS_SLOT_8_PROPS
    and #%00011100
    lsr 
    lsr                         ; 1-7 in a now for color
    ora #%00001000              ; set bit 3 for MCM
    sta TEXT_COLOR

    ; y
    lda #ORBITS_Y
    sta TEXT_Y
    ; x
    lda ORBITS_SLOT_8_X
    sta TEXT_X

    ; size 3x3
    dec TEXT_X
    dec TEXT_Y

    ; chars
    lda #<PLANETS_3x3_T_8
    sta TEXT_STRING_PTR
    lda #>PLANETS_3x3_T_8
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    inc TEXT_Y
    lda #<PLANETS_3x3_M_8
    sta TEXT_STRING_PTR
    lda #>PLANETS_3x3_M_8
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    inc TEXT_Y
    lda #<PLANETS_3x3_B_8
    sta TEXT_STRING_PTR
    lda #>PLANETS_3x3_B_8
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING
    jmp (ZP_PTR_RETURN)             ; jump back to next orbit


PLANET_SHOW_ASTEROID_BELT:
    ; x
    lda ORBITS_CURRENT_SLOT
    tax 
    lda ORBITS_SLOT_1_X, x
    jsr CLOUDS_SHOW_ASTEROID_BELT

    jmp (ZP_PTR_RETURN)             ; jump back to next orbit
; hack remove me
PLANET_SHOW_ASTEROID_BELT_HACK
    !scr "$$$$$$$$$$", 0
PLANET_SHOW_JUMP_GATE:
    ; color
    lda ORBITS_CURRENT_SLOT
    tax
    lda ORBITS_SLOT_1_PROPS, x
    sta TEXT_COLOR

    ; y
    lda #ORBITS_Y-5
    sta TEXT_Y
    ; x
    lda ORBITS_CURRENT_SLOT
    tax 
    lda ORBITS_SLOT_1_X, x
    sta TEXT_X

    ; string ptr
    lda #<PLANET_SHOW_JUMP_GATE_HACK
    sta TEXT_STRING_PTR
    lda #>PLANET_SHOW_JUMP_GATE_HACK
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT    

    jmp (ZP_PTR_RETURN)             ; jump back to next orbit
; hack remove me
PLANET_SHOW_JUMP_GATE_HACK
    !scr "gate", 0
PLANET_SHOW_STATION:
    ; color
    lda ORBITS_CURRENT_SLOT
    tax
    lda ORBITS_SLOT_1_PROPS, x
    sta TEXT_COLOR

    ; y
    lda #ORBITS_Y-5
    sta TEXT_Y
    ; x
    lda ORBITS_CURRENT_SLOT
    tax 
    lda ORBITS_SLOT_1_X, x
    sta TEXT_X

    ; string ptr
    lda #<PLANET_SHOW_STATION_HACK
    sta TEXT_STRING_PTR
    lda #>PLANET_SHOW_STATION_HACK
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT    

    jmp (ZP_PTR_RETURN)             ; jump back to next orbit
; hack remove me
PLANET_SHOW_STATION_HACK
    !scr "+xox+", 0


PLANETS_LOAD_UDGS:
    ; slot 1 - 1x1
    lda #<PLANETS_1x1_CHAR
    sta ZP_PTR_1
    lda #>PLANETS_1x1_CHAR
    sta ZP_PTR_1_PAIR

    lda #<PLANETS_FONT_1x1_1
    sta ZP_PTR_2
    lda #>PLANETS_FONT_1x1_1
    sta ZP_PTR_2_PAIR

    lda #8
    sta ZP_PTR_TEMP_0_PAIR

    jsr PLANETS_LOAD_UDGS_BLOCK

    ; slot 2 - 1x1
    lda #<PLANETS_1x1_CHAR
    sta ZP_PTR_1
    lda #>PLANETS_1x1_CHAR
    sta ZP_PTR_1_PAIR

    lda #<PLANETS_FONT_1x1_2
    sta ZP_PTR_2
    lda #>PLANETS_FONT_1x1_2
    sta ZP_PTR_2_PAIR

    lda #8
    sta ZP_PTR_TEMP_0_PAIR

    jsr PLANETS_LOAD_UDGS_BLOCK

    ; slot 3 - 2x2 (3x3)
    lda #<PLANETS_2x2_CHAR_TL
    sta ZP_PTR_1
    lda #>PLANETS_2x2_CHAR_TL
    sta ZP_PTR_1_PAIR

    lda #<PLANETS_FONT_2x2_3
    sta ZP_PTR_2
    lda #>PLANETS_FONT_2x2_3
    sta ZP_PTR_2_PAIR

    lda #8*9
    sta ZP_PTR_TEMP_0_PAIR

    jsr PLANETS_LOAD_UDGS_BLOCK

    ; slot 4 - 2x2 (3x3)
    lda #<PLANETS_2x2_CHAR_TL
    sta ZP_PTR_1
    lda #>PLANETS_2x2_CHAR_TL
    sta ZP_PTR_1_PAIR

    lda #<PLANETS_FONT_2x2_4
    sta ZP_PTR_2
    lda #>PLANETS_FONT_2x2_4
    sta ZP_PTR_2_PAIR

    lda #8*9
    sta ZP_PTR_TEMP_0_PAIR

    jsr PLANETS_LOAD_UDGS_BLOCK

    ; slot 5 - 3x3
    lda #<PLANETS_3x3_CHAR_TL
    sta ZP_PTR_1
    lda #>PLANETS_3x3_CHAR_TL
    sta ZP_PTR_1_PAIR

    lda #<PLANETS_FONT_3x3_5
    sta ZP_PTR_2
    lda #>PLANETS_FONT_3x3_5
    sta ZP_PTR_2_PAIR

    lda #8*9
    sta ZP_PTR_TEMP_0_PAIR

    jsr PLANETS_LOAD_UDGS_BLOCK

    ; slot 6 - 3x3
    lda #<PLANETS_3x3_CHAR_TL
    sta ZP_PTR_1
    lda #>PLANETS_3x3_CHAR_TL
    sta ZP_PTR_1_PAIR

    lda #<PLANETS_FONT_3x3_6
    sta ZP_PTR_2
    lda #>PLANETS_FONT_3x3_6
    sta ZP_PTR_2_PAIR

    lda #8*9
    sta ZP_PTR_TEMP_0_PAIR

    jsr PLANETS_LOAD_UDGS_BLOCK

    ; slot 7 - 3x3
    lda #<PLANETS_3x3_CHAR_TL
    sta ZP_PTR_1
    lda #>PLANETS_3x3_CHAR_TL
    sta ZP_PTR_1_PAIR

    lda #<PLANETS_FONT_3x3_7
    sta ZP_PTR_2
    lda #>PLANETS_FONT_3x3_7
    sta ZP_PTR_2_PAIR

    lda #8*9
    sta ZP_PTR_TEMP_0_PAIR

    jsr PLANETS_LOAD_UDGS_BLOCK

    ; slot 8 - 3x3
    lda #<PLANETS_3x3_CHAR_TL
    sta ZP_PTR_1
    lda #>PLANETS_3x3_CHAR_TL
    sta ZP_PTR_1_PAIR

    lda #<PLANETS_FONT_3x3_8
    sta ZP_PTR_2
    lda #>PLANETS_FONT_3x3_8
    sta ZP_PTR_2_PAIR

    lda #8*9
    sta ZP_PTR_TEMP_0_PAIR

    jsr PLANETS_LOAD_UDGS_BLOCK

    rts


; zptr1 pair source
; zptr2 pair dest
; zptr temp0 pair alone num bytes (main temp 0 used in routine)
PLANETS_LOAD_UDGS_BLOCK:
    ldy #0
-
    jsr LFSR_NEXT_SEED      ; fresh each loop

    lda (ZP_PTR_1), y
    sta ZP_PTR_TEMP_0       ; save for later
    ; for each bit pair, check if it's 00 or 11
    and #%11000000
    beq +                   ; skip if 00
    lda LFSR_W0
    and #%00000011          ; 0-3
    tax
    lda PLANETS_COLOR_LUT_1, x
    sta ZP_PTR_TEMP_1

    lda ZP_PTR_TEMP_0       ; restore
    and ZP_PTR_TEMP_1
    sta ZP_PTR_TEMP_0       ; save for later
+    
    lda ZP_PTR_TEMP_0       ; restore
    and #%00110000
    beq +                   ; skip if 00
    lda LFSR_W0+1
    and #%00000011          ; 0-3
    tax
    lda PLANETS_COLOR_LUT_2, x
    sta ZP_PTR_TEMP_1

    lda ZP_PTR_TEMP_0       ; restore
    and ZP_PTR_TEMP_1
    sta ZP_PTR_TEMP_0       ; save for later
+
    lda ZP_PTR_TEMP_0       ; restore
    and #%00001100
    beq +                   ; skip if 00
    lda LFSR_W1
    and #%00000011          ; 0-3
    tax
    lda PLANETS_COLOR_LUT_3, x
    sta ZP_PTR_TEMP_1

    lda ZP_PTR_TEMP_0       ; restore
    and ZP_PTR_TEMP_1
    sta ZP_PTR_TEMP_0       ; save for later
+
    lda ZP_PTR_TEMP_0       ; restore
    and #%00000011
    beq +                   ; skip if 00
    lda LFSR_W1+1
    and #%00000011          ; 0-3
    tax
    lda PLANETS_COLOR_LUT_4, x
    sta ZP_PTR_TEMP_1

    lda ZP_PTR_TEMP_0       ; restore
    and ZP_PTR_TEMP_1
    sta ZP_PTR_TEMP_0       ; save for later
+
    lda ZP_PTR_TEMP_0       ; restore
    sta (ZP_PTR_2), y
    iny
    cpy ZP_PTR_TEMP_0_PAIR
    bne -
    rts

PLANET_GENERATE_ASTEROID_BELT_IN_SLOT:
    jsr LFSR_NEXT_SEED              ; own seed

    ; color
-
    lda LFSR_W0+1
    and #%00000111              ; 0-7
    bne +                       ; not black
    jsr LFSR_NEXT_SEED          ; try next
    jmp -
+
    ldy #0
    sta (ZP_PTR_1), y           ; save to slot props

    ; planet name
    lda #<ORBITS_ASTEROID_BELT_LABEL
    sta ZP_PTR_1
    lda #>ORBITS_ASTEROID_BELT_LABEL
    sta ZP_PTR_1_PAIR
    ; ZP_PTR_2 and pair already has dest address
    jsr SYS_MEM_COPY    

    jmp (ZP_PTR_RETURN)             ; jump back to next orbit

PLANET_GENERATE_JUMP_GATE_IN_SLOT: 
    jsr LFSR_NEXT_SEED              ; own seed

    ; color
-
    lda LFSR_W0+1
    and #%00000111              ; 0-7
    bne +                       ; not black
    jsr LFSR_NEXT_SEED          ; try next
    jmp -
+
    ldy #0
    sta (ZP_PTR_1), y           ; save to slot props

    ; planet name
    lda #<ORBITS_JUMP_GATE_LABEL
    sta ZP_PTR_1
    lda #>ORBITS_JUMP_GATE_LABEL
    sta ZP_PTR_1_PAIR
    ; ZP_PTR_2 and pair already has dest address
    jsr SYS_MEM_COPY    

    jmp (ZP_PTR_RETURN)             ; jump back to next orbit

PLANET_GENERATE_STATION_IN_SLOT: 
    jsr LFSR_NEXT_SEED              ; own seed

    ; color
-
    lda LFSR_W0+1
    and #%00000111              ; 0-7
    bne +                       ; not black
    jsr LFSR_NEXT_SEED          ; try next
    jmp -
+
    ldy #0
    sta (ZP_PTR_1), y           ; save to slot props

    ; planet name
    lda #<ORBITS_STATION_LABEL
    sta ZP_PTR_1
    lda #>ORBITS_STATION_LABEL
    sta ZP_PTR_1_PAIR
    ; ZP_PTR_2 and pair already has dest address
    jsr SYS_MEM_COPY    

    jmp (ZP_PTR_RETURN)             ; jump back to next orbit





PLANETS_TEMP
    !byte 0

PLANETS_1x1_1
    !byte 200
PLANETS_1x1_2
    !byte 201

PLANETS_2x2_T_3
    !byte 202, 203, 204, 0
PLANETS_2x2_M_3
    !byte 205, 206, 207, 0
PLANETS_2x2_B_3
    !byte 208, 209, 210, 0

PLANETS_2x2_T_4
    !byte 211, 212, 213, 0
PLANETS_2x2_M_4
    !byte 214, 215, 216, 0
PLANETS_2x2_B_4
    !byte 217, 218, 219, 0

PLANETS_3x3_T_5
    !byte 220, 221, 222, 0
PLANETS_3x3_M_5
    !byte 223, 224, 225, 0
PLANETS_3x3_B_5
    !byte 226, 227, 228, 0

PLANETS_3x3_T_6
    !byte 229, 230, 231, 0
PLANETS_3x3_M_6
    !byte 232, 233, 234, 0
PLANETS_3x3_B_6
    !byte 235, 236, 237, 0

PLANETS_3x3_T_7
    !byte 238, 239, 240, 0
PLANETS_3x3_M_7
    !byte 241, 242, 243, 0
PLANETS_3x3_B_7
    !byte 244, 245, 246, 0

PLANETS_3x3_T_8
    !byte 247, 248, 249, 0
PLANETS_3x3_M_8
    !byte 250, 251, 252, 0
PLANETS_3x3_B_8
    !byte 253, 254, 255, 0

PLANETS_FONT_1x1_1      = $3000 + (200*8)
PLANETS_FONT_1x1_2      = $3000 + (201*8)
PLANETS_FONT_2x2_3      = $3000 + (202*8)
PLANETS_FONT_2x2_4      = $3000 + (211*8)
PLANETS_FONT_3x3_5      = $3000 + (220*8)
PLANETS_FONT_3x3_6      = $3000 + (229*8)
PLANETS_FONT_3x3_7      = $3000 + (238*8)
PLANETS_FONT_3x3_8      = $3000 + (247*8)


PLANETS_FONT_PATCH_223  = $3000 + (223*8)
PLANETS_FONT_PATCH_95  = $3000 + (95*8)



; mcm characters for planets
; each byte is in bit-pairs for wide pixel
; %00 means bg, %01 shared 1, %02 shared 2, %11 fg
; fg for char needs to be set 9-15 (set bit 3) to force MCM
PLANETS_1x1_CHAR
    !byte $3C, $3C, $FF, $FF, $FF, $FF, $3C, $3C

PLANETS_2x2_CHAR_TL
    !byte $00,$00,$00,$00,$00,$00,$03,$03
PLANETS_2x2_CHAR_TM
    !byte $00,$00,$00,$00,$00,$3C,$FF,$FF
PLANETS_2x2_CHAR_TR
    !byte $00,$00,$00,$00,$00,$00,$C0,$C0
PLANETS_2x2_CHAR_ML
    !byte $03,$0F,$0F,$0F,$0F,$0F,$0F,$03
PLANETS_2x2_CHAR_MM
    !byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
PLANETS_2x2_CHAR_MR
    !byte $C0,$F0,$F0,$F0,$F0,$F0,$F0,$C0
PLANETS_2x2_CHAR_BL
    !byte $03,$03,$00,$00,$00,$00,$00,$00
PLANETS_2x2_CHAR_BM
    !byte $FF,$FF,$3C,$00,$00,$00,$00,$00
PLANETS_2x2_CHAR_BR
    !byte $C0,$C0,$00,$00,$00,$00,$00,$00

PLANETS_3x3_CHAR_TL
    !byte $00,$00,$00,$00,$03,$03,$0F,$0F
PLANETS_3x3_CHAR_TM
    !byte $00,$00,$00,$3C,$FF,$FF,$FF,$FF
PLANETS_3x3_CHAR_TR
    !byte $00,$00,$00,$00,$C0,$C0,$F0,$F0
PLANETS_3x3_CHAR_ML
    !byte $0F,$3F,$3F,$3F,$3F,$3F,$3F,$0F
PLANETS_3x3_CHAR_MM
    !byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
PLANETS_3x3_CHAR_MR
    !byte $F0,$FC,$FC,$FC,$FC,$FC,$FC,$F0
PLANETS_3x3_CHAR_BL
    !byte $0F,$0F,$03,$03,$00,$00,$00,$00
PLANETS_3x3_CHAR_BM
    !byte $FF,$FF,$FF,$FF,$3C,$00,$00,$00
PLANETS_3x3_CHAR_BR
    !byte $F0,$F0,$C0,$C0,$00,$00,$00,$00

PLANETS_COLOR_LUT_1
    !byte %11111111, %11111111, %01111111, %10111111
PLANETS_COLOR_LUT_2
    !byte %11111111, %11111111, %11011111, %11101111
PLANETS_COLOR_LUT_3
    !byte %11111111, %11111111, %11110111, %11111011
PLANETS_COLOR_LUT_4
    !byte %11111111, %11111111, %11111101, %11111110
