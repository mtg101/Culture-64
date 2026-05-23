



ORBITS_GENERATE:
    jsr LFSR_NEXT_SEED              ; own value


    ; slot 1
    lda LFSR_W0
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda ORBITS_DIST, x
    sta ORBITS_SLOT_1

    ; slot 2
    lda LFSR_W0+1
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda ORBITS_DIST, x
    sta ORBITS_SLOT_2

    ; slot 3
    lda LFSR_W1
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda ORBITS_DIST, x
    sta ORBITS_SLOT_3

    ; slot 4
    lda LFSR_W1+1
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda ORBITS_DIST, x
    sta ORBITS_SLOT_4

    ; slot 5
    lda LFSR_W2
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda ORBITS_DIST, x
    sta ORBITS_SLOT_5

    ; slot 6
    lda LFSR_W2+1
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda ORBITS_DIST, x
    sta ORBITS_SLOT_6

    jsr LFSR_NEXT_SEED              ; need new seeds...

    ; slot 7
    lda LFSR_W0
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda ORBITS_DIST, x
    sta ORBITS_SLOT_7

    ; slot 8
    lda LFSR_W0+1
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda ORBITS_DIST, x
    sta ORBITS_SLOT_8

    jsr ORBITS_GENERATE_SLOTS

    rts

ORBITS_GENERATE_SLOTS:
    lda ORBITS_SLOT_1
    beq +                       ; empty
    lda #<ORBITS_SLOT_1_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_1_PROPS
    sta ZP_PTR_1_PAIR
    jsr PLANET_GENERATE_IN_SLOT
+
    lda ORBITS_SLOT_2
    beq +                       ; empty
    lda #<ORBITS_SLOT_2_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_2_PROPS
    sta ZP_PTR_1_PAIR
    jsr PLANET_GENERATE_IN_SLOT
+
    lda ORBITS_SLOT_3
    beq +                       ; empty
    lda #<ORBITS_SLOT_3_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_3_PROPS
    sta ZP_PTR_1_PAIR
    jsr PLANET_GENERATE_IN_SLOT
+
    lda ORBITS_SLOT_4
    beq +                       ; empty
    lda #<ORBITS_SLOT_4_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_4_PROPS
    sta ZP_PTR_1_PAIR
    jsr PLANET_GENERATE_IN_SLOT
+
    lda ORBITS_SLOT_5
    beq +                       ; empty
    lda #<ORBITS_SLOT_5_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_5_PROPS
    sta ZP_PTR_1_PAIR
    jsr PLANET_GENERATE_IN_SLOT
+
    lda ORBITS_SLOT_6
    beq +                       ; empty
    lda #<ORBITS_SLOT_6_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_6_PROPS
    sta ZP_PTR_1_PAIR
    jsr PLANET_GENERATE_IN_SLOT
+
    lda ORBITS_SLOT_7
    beq +                       ; empty
    lda #<ORBITS_SLOT_7_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_7_PROPS
    sta ZP_PTR_1_PAIR
    jsr PLANET_GENERATE_IN_SLOT
+
    lda ORBITS_SLOT_8
    beq +                       ; empty
    lda #<ORBITS_SLOT_8_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_8_PROPS
    sta ZP_PTR_1_PAIR
    jsr PLANET_GENERATE_IN_SLOT
+
    rts 

ORBITS_SHOW_SLOTS:
    lda ORBITS_SLOT_1
    beq +                       ; empty
    lda #<ORBITS_SLOT_1
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_1
    sta ZP_PTR_1_PAIR
    lda #0
    sta ORBITS_CURRENT_SLOT
    jsr PLANET_SHOW_IN_SLOT
+
    lda ORBITS_SLOT_2
    beq +                       ; empty
    lda #<ORBITS_SLOT_2
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_2
    sta ZP_PTR_1_PAIR
    lda #1
    sta ORBITS_CURRENT_SLOT
    jsr PLANET_SHOW_IN_SLOT
+
    lda ORBITS_SLOT_3
    beq +                       ; empty
    lda #<ORBITS_SLOT_3
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_3
    sta ZP_PTR_1_PAIR
    lda #2
    sta ORBITS_CURRENT_SLOT
    jsr PLANET_SHOW_IN_SLOT
+
    lda ORBITS_SLOT_4
    beq +                       ; empty
    lda #<ORBITS_SLOT_4
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_4
    sta ZP_PTR_1_PAIR
    lda #3
    sta ORBITS_CURRENT_SLOT
    jsr PLANET_SHOW_IN_SLOT
+
    lda ORBITS_SLOT_5
    beq +                       ; empty
    lda #<ORBITS_SLOT_5
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_5
    sta ZP_PTR_1_PAIR
    lda #4
    sta ORBITS_CURRENT_SLOT
    jsr PLANET_SHOW_IN_SLOT
+
    lda ORBITS_SLOT_6
    beq +                       ; empty
    lda #<ORBITS_SLOT_6
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_6
    sta ZP_PTR_1_PAIR
    lda #5
    sta ORBITS_CURRENT_SLOT
    jsr PLANET_SHOW_IN_SLOT
+
    lda ORBITS_SLOT_7
    beq +                       ; empty
    lda #<ORBITS_SLOT_7
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_7
    sta ZP_PTR_1_PAIR
    lda #6
    sta ORBITS_CURRENT_SLOT
    jsr PLANET_SHOW_IN_SLOT
+
    lda ORBITS_SLOT_8
    beq +                       ; empty
    lda #<ORBITS_SLOT_8
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_8
    sta ZP_PTR_1_PAIR
    lda #7
    sta ORBITS_CURRENT_SLOT
    jsr PLANET_SHOW_IN_SLOT
+
    rts 

; 0 - empty slot
; 1 - planet
; 2-255 specials (planet if not assigned)

ORBITS_DIST                         ; 0-7 types, over 32 for curve
    !byte 0, 0, 0, 0                ; 4/32
    !byte 1, 1, 1, 1                ; 4/32
    !byte 1, 1, 1, 1, 1, 1, 1, 1    ; 8/32
    !byte 1, 1, 1, 1, 1, 1, 1, 1    ; 8/32
    !byte 1, 1, 1, 1, 1, 1, 1, 1    ; 8/32


ORBITS_SLOT_1
    !byte 0
ORBITS_SLOT_2
    !byte 0
ORBITS_SLOT_3
    !byte 0
ORBITS_SLOT_4
    !byte 0
ORBITS_SLOT_5
    !byte 0
ORBITS_SLOT_6
    !byte 0
ORBITS_SLOT_7
    !byte 0
ORBITS_SLOT_8
    !byte 0

; properties for slots
; each type knows how to handle the byte (planets size for now - might need to be word later - or it's seed for simpler LFSR?)
ORBITS_SLOT_1_PROPS
    !byte 0
ORBITS_SLOT_2_PROPS
    !byte 0
ORBITS_SLOT_3_PROPS
    !byte 0
ORBITS_SLOT_4_PROPS
    !byte 0
ORBITS_SLOT_5_PROPS
    !byte 0
ORBITS_SLOT_6_PROPS
    !byte 0
ORBITS_SLOT_7_PROPS
    !byte 0
ORBITS_SLOT_8_PROPS
    !byte 0

ORBITS_Y = 7

ORBITS_SLOT_1_X
    !byte 3             ; close planets not 3x3 so won't 'touch' sun
ORBITS_SLOT_2_X
    !byte 8
ORBITS_SLOT_3_X
    !byte 13             
ORBITS_SLOT_4_X
    !byte 18            
ORBITS_SLOT_5_X
    !byte 23            
ORBITS_SLOT_6_X
    !byte 28            
ORBITS_SLOT_7_X
    !byte 33            
ORBITS_SLOT_8_X
    !byte 38            ; just enough space for 3x3

ORBITS_CURRENT_SLOT
    !byte 0

