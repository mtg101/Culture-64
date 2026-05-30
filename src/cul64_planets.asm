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
    jsr PLANETS_LOAD_UDGS       ; load every time as we're procgen hacking the planet colors

    ldy #0                      ; zptr index

    ; color
    lda (ZP_PTR_1), y
    and #%00011100
    lsr 
    lsr                         ; 1-7 in a now for color
    ora #%00001000              ; set bit 3 for MCM
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

PLANETS_LOAD_UDGS:
    ldx #0
-
    lda PLANETS_19_UDG, x
    tay                     ; temp for later

    ; for each bit pair, check if it's 00 or 11
    and #%11000000
    beq +                   ; skip if 00

    ; hack to shared from 11
    tya                     ; restore
    and #%01111111          ; change 11 or 01 for shared 1
    tay                     ; save it

+    
    tya                     ; back from temp
    and #%00110000
    beq +                   ; skip if 00

    ; hack to shared from 11
    tya                     ; restore
    and #%11011111          ; change 11 or 01 for shared 1
    tay                     ; save it

+
    tya                     ; back from temp
    and #%00001100
    beq +                   ; skip if 00

    ; hack to shared from 11
    tya                     ; restore
    and #%11111011          ; change 11 or 10 for shared 2
    tay                     ; save it

+
    tya                     ; back from temp
    and #%00000011
    beq +                   ; skip if 00

    ; hack to shared from 11
    tya                     ; restore
    and #%11111110          ; change 11 or 10 for shared 2
    tay                     ; save it

+
    tya                     ; restore for final save
    sta PLANETS_19_FONT_RAM, x
    inx 
    cpx #19*8               ; 19 udgs, 8 bytes each
    bne -
    rts

PLANETS_TEMP
    !byte 0

PLANETS_1x1
    !byte 237

PLANETS_2x2_T
    !byte 238, 239, 240, 0
PLANETS_2x2_M
    !byte 241, 242, 243, 0
PLANETS_2x2_B
    !byte 244, 245, 246, 0

PLANETS_3x3_T
    !byte 247, 248, 249, 0
PLANETS_3x3_M
    !byte 250, 251, 252, 0
PLANETS_3x3_B
    !byte 253, 254, 255, 0


; mcm characters for planets
; each byte is in bit-pairs for wide pixel
; %00 means bg, %01 shared 1, %02 shared 2, %11 fg
; fg for char needs to be set 9-15 (set bit 3) to force MCM
PLANETS_19_UDG
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

PLANETS_19_FONT_RAM     = $3000 + (237*8)
