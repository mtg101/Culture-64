



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
    ; blank all buffers
    lda #0
    sta ORBITS_SLOT_1_BUFFER
    sta ORBITS_SLOT_2_BUFFER
    sta ORBITS_SLOT_3_BUFFER
    sta ORBITS_SLOT_4_BUFFER
    sta ORBITS_SLOT_5_BUFFER
    sta ORBITS_SLOT_6_BUFFER
    sta ORBITS_SLOT_7_BUFFER
    sta ORBITS_SLOT_8_BUFFER

    lda ORBITS_SLOT_1
    beq +                       ; empty
    lda #<ORBITS_SLOT_1_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_1_PROPS
    sta ZP_PTR_1_PAIR
    lda #0
    sta ORBITS_CURRENT_SLOT
    lda #<ORBITS_SLOT_1_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_1_BUFFER
    sta ZP_PTR_2_PAIR
    jsr PLANET_GENERATE_IN_SLOT
+
    lda ORBITS_SLOT_2
    beq +                       ; empty
    lda #<ORBITS_SLOT_2_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_2_PROPS
    sta ZP_PTR_1_PAIR
    lda #1
    sta ORBITS_CURRENT_SLOT
    lda #<ORBITS_SLOT_2_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_2_BUFFER
    sta ZP_PTR_2_PAIR
    jsr PLANET_GENERATE_IN_SLOT
+
    lda ORBITS_SLOT_3
    beq +                       ; empty
    lda #<ORBITS_SLOT_3_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_3_PROPS
    sta ZP_PTR_1_PAIR
    lda #2
    sta ORBITS_CURRENT_SLOT
    lda #<ORBITS_SLOT_3_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_3_BUFFER
    sta ZP_PTR_2_PAIR
    jsr PLANET_GENERATE_IN_SLOT
+
    lda ORBITS_SLOT_4
    beq +                       ; empty
    lda #<ORBITS_SLOT_4_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_4_PROPS
    sta ZP_PTR_1_PAIR
    lda #3
    sta ORBITS_CURRENT_SLOT
    lda #<ORBITS_SLOT_4_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_4_BUFFER
    sta ZP_PTR_2_PAIR
    jsr PLANET_GENERATE_IN_SLOT
+
    lda ORBITS_SLOT_5
    beq +                       ; empty
    lda #<ORBITS_SLOT_5_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_5_PROPS
    sta ZP_PTR_1_PAIR
    lda #4
    sta ORBITS_CURRENT_SLOT
    lda #<ORBITS_SLOT_5_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_5_BUFFER
    sta ZP_PTR_2_PAIR
    jsr PLANET_GENERATE_IN_SLOT
+
    lda ORBITS_SLOT_6
    beq +                       ; empty
    lda #<ORBITS_SLOT_6_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_6_PROPS
    sta ZP_PTR_1_PAIR
    lda #5
    sta ORBITS_CURRENT_SLOT
    lda #<ORBITS_SLOT_6_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_6_BUFFER
    sta ZP_PTR_2_PAIR
    jsr PLANET_GENERATE_IN_SLOT
+
    lda ORBITS_SLOT_7
    beq +                       ; empty
    lda #<ORBITS_SLOT_7_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_7_PROPS
    sta ZP_PTR_1_PAIR
    lda #6
    sta ORBITS_CURRENT_SLOT
    lda #<ORBITS_SLOT_7_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_7_BUFFER
    sta ZP_PTR_2_PAIR
    jsr PLANET_GENERATE_IN_SLOT
+
    lda ORBITS_SLOT_8
    beq +                       ; empty
    lda #<ORBITS_SLOT_8_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_8_PROPS
    sta ZP_PTR_1_PAIR
    lda #7
    sta ORBITS_CURRENT_SLOT
    lda #<ORBITS_SLOT_8_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_8_BUFFER
    sta ZP_PTR_2_PAIR
    jsr PLANET_GENERATE_IN_SLOT
+
    rts 

ORBITS_SHOW_SLOTS:
    ; not showing status to start
    lda #0
    sta ORBITS_INFO_STATUS

    lda ORBITS_SLOT_1
    beq +                       ; empty
    lda #<ORBITS_SLOT_1_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_1_PROPS
    sta ZP_PTR_1_PAIR
    lda #0
    sta ORBITS_CURRENT_SLOT
    jsr PLANET_SHOW_IN_SLOT
+
    lda ORBITS_SLOT_2
    beq +                       ; empty
    lda #<ORBITS_SLOT_2_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_2_PROPS
    sta ZP_PTR_1_PAIR
    lda #1
    sta ORBITS_CURRENT_SLOT
    jsr PLANET_SHOW_IN_SLOT
+
    lda ORBITS_SLOT_3
    beq +                       ; empty
    lda #<ORBITS_SLOT_3_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_3_PROPS
    sta ZP_PTR_1_PAIR
    lda #2
    sta ORBITS_CURRENT_SLOT
    jsr PLANET_SHOW_IN_SLOT
+
    lda ORBITS_SLOT_4
    beq +                       ; empty
    lda #<ORBITS_SLOT_4_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_4_PROPS
    sta ZP_PTR_1_PAIR
    lda #3
    sta ORBITS_CURRENT_SLOT
    jsr PLANET_SHOW_IN_SLOT
+
    lda ORBITS_SLOT_5
    beq +                       ; empty
    lda #<ORBITS_SLOT_5_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_5_PROPS
    sta ZP_PTR_1_PAIR
    lda #4
    sta ORBITS_CURRENT_SLOT
    jsr PLANET_SHOW_IN_SLOT
+
    lda ORBITS_SLOT_6
    beq +                       ; empty
    lda #<ORBITS_SLOT_6_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_6_PROPS
    sta ZP_PTR_1_PAIR
    lda #5
    sta ORBITS_CURRENT_SLOT
    jsr PLANET_SHOW_IN_SLOT
+
    lda ORBITS_SLOT_7
    beq +                       ; empty
    lda #<ORBITS_SLOT_7_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_7_PROPS
    sta ZP_PTR_1_PAIR
    lda #6
    sta ORBITS_CURRENT_SLOT
    jsr PLANET_SHOW_IN_SLOT
+
    lda ORBITS_SLOT_8
    beq +                       ; empty
    lda #<ORBITS_SLOT_8_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_8_PROPS
    sta ZP_PTR_1_PAIR
    lda #7
    sta ORBITS_CURRENT_SLOT
    jsr PLANET_SHOW_IN_SLOT
+
    rts 

ORBITS_SHOW_SLOTS_INFO:
    ; clear sHIP jUMP iNFO
    lda #0 
    sta TEXT_Y
    lda #26
    sta TEXT_X
    lda #<SCREEN_SYSTEM_KEYS_LABEL_BLANK
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_KEYS_LABEL_BLANK
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    ; invert I in top right
    lda #0 
    sta TEXT_Y
    lda #39
    sta TEXT_X
    lda #CYAN
    sta TEXT_COLOR
    lda #137            ; invert I
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR

    ; color
    lda #WHITE
    sta TEXT_COLOR
    ; y
    lda #1
    sta TEXT_Y

    ; x 0
    lda #2
    sta TEXT_X
    ; str ptr
    ldx SUN_TYPE
    lda SUN_TYPE_STRING_LUT_LOW, x
    sta TEXT_STRING_PTR
    lda SUN_TYPE_STRING_LUT_HIGH, x
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

    ; x 1
    lda ORBITS_SLOT_1_X
    sta TEXT_X
    ; string ptr
    lda #<ORBITS_SLOT_1_BUFFER
    sta TEXT_STRING_PTR
    lda #>ORBITS_SLOT_1_BUFFER
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

    ; x 2
    lda ORBITS_SLOT_2_X
    sta TEXT_X
    ; string ptr
    lda #<ORBITS_SLOT_2_BUFFER
    sta TEXT_STRING_PTR
    lda #>ORBITS_SLOT_2_BUFFER
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

    ; x 3
    lda ORBITS_SLOT_3_X
    sta TEXT_X
    ; string ptr
    lda #<ORBITS_SLOT_3_BUFFER
    sta TEXT_STRING_PTR
    lda #>ORBITS_SLOT_3_BUFFER
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

    ; x 4
    lda ORBITS_SLOT_4_X
    sta TEXT_X
    ; string ptr
    lda #<ORBITS_SLOT_4_BUFFER
    sta TEXT_STRING_PTR
    lda #>ORBITS_SLOT_4_BUFFER
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

    ; x 5
    lda ORBITS_SLOT_5_X
    sta TEXT_X
    ; string ptr
    lda #<ORBITS_SLOT_5_BUFFER
    sta TEXT_STRING_PTR
    lda #>ORBITS_SLOT_5_BUFFER
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

    ; x 6
    lda ORBITS_SLOT_6_X
    sta TEXT_X
    ; string ptr
    lda #<ORBITS_SLOT_6_BUFFER
    sta TEXT_STRING_PTR
    lda #>ORBITS_SLOT_6_BUFFER
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

    ; x 7
    lda ORBITS_SLOT_7_X
    sta TEXT_X
    ; string ptr
    lda #<ORBITS_SLOT_7_BUFFER
    sta TEXT_STRING_PTR
    lda #>ORBITS_SLOT_7_BUFFER
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

    ; x 8
    lda ORBITS_SLOT_8_X
    sta TEXT_X
    ; string ptr
    lda #<ORBITS_SLOT_8_BUFFER
    sta TEXT_STRING_PTR
    lda #>ORBITS_SLOT_8_BUFFER
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

; into...
ORBITS_GAME_LOOP:
    ; i info
    lda #KEY_I_ROW
    sta CIA1_PRA

    lda CIA1_PRB
    and #KEY_I_COL  ; check pressed
    bne +           ; not pressed info
-
    lda CIA1_PRB
    and #KEY_I_COL  ; check released
    beq -
    jmp SCREEN_SYSTEM_SHOW
+
    jmp ORBITS_GAME_LOOP


ORBITS_INFO_STATUS
    !byte 0

; 0 - empty slot
; 1 - planet
; 2-255 specials (planet if not assigned)

ORBITS_DIST                         ; 0-7 types, over 32 for curve
    !byte 0, 0, 0, 0, 0, 0, 0, 0    ; 8/32
    !byte 0, 0, 0, 0, 1, 1, 1, 1    ; 8/32
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
    !byte 5             ; close planets not 3x3 so won't 'touch' sun
ORBITS_SLOT_2_X
    !byte 9
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

ORBITS_MAX_CHARS = 15
ORBITS_SLOT_1_BUFFER
    !fill ORBITS_MAX_CHARS+1, 0
ORBITS_SLOT_2_BUFFER
    !fill ORBITS_MAX_CHARS+1, 0
ORBITS_SLOT_3_BUFFER
    !fill ORBITS_MAX_CHARS+1, 0
ORBITS_SLOT_4_BUFFER
    !fill ORBITS_MAX_CHARS+1, 0
ORBITS_SLOT_5_BUFFER
    !fill ORBITS_MAX_CHARS+1, 0
ORBITS_SLOT_6_BUFFER
    !fill ORBITS_MAX_CHARS+1, 0
ORBITS_SLOT_7_BUFFER
    !fill ORBITS_MAX_CHARS+1, 0
ORBITS_SLOT_8_BUFFER
    !fill ORBITS_MAX_CHARS+1, 0
