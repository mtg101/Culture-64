SCREEN_SYSTEM_LOAD:
    jsr SCREEN_OFF

    ; seed from name
    lda #<SCREEN_SYSTEM_NAME_BUFFER
    sta LFSR_NAME_PTR
    lda #>SCREEN_SYSTEM_NAME_BUFFER
    sta LFSR_NAME_PTR+1
    jsr LFSR_SEED_FROM_NAME

    ; music!
    jsr music_init

    jsr SYSTEM_GEN_SYS          ; huh 'gen sys' / 'genesis' 
 
    ; background space
    jsr STARS_FILL_SPACE_OFF
    jsr CLOUDS_SHOW_NEBULA
    jsr SUN_SHOW
    jsr ORBITS_SHOW_SLOTS

    jsr SCREEN_SYSTEM_COPY_SPACE_TO_SCREEN

    jsr SYSTEM_SHOW_KEYS        ; overlay on copied space
    ; lower text
    jsr STARS_CLEAR_LOWER
    jsr SYSTEM_SHOW_LABELS
    jsr SYSTEM_SHOW_VALUES
    
    ; black bg
    lda #BLACK
    sta SCREEN_SYSTEM_SPACE_BG

    jsr SCREEN_ON

    ; passenger arrived?
    lda SHIP_HAS_PASSENGER
    beq +
    ; have passenger
    



+
    jmp SCREEN_SYSTEM_GAME_LOOP

SCREEN_SYSTEM_RESHOW:
    ; seed from name
    lda #<SCREEN_SYSTEM_NAME_BUFFER
    sta LFSR_NAME_PTR
    lda #>SCREEN_SYSTEM_NAME_BUFFER
    sta LFSR_NAME_PTR+1
    jsr LFSR_SEED_FROM_NAME
    jsr music_init

    ; black bg
    lda #BLACK
    sta SCREEN_SYSTEM_SPACE_BG
    jsr SCREEN_SYSTEM_COPY_SPACE_TO_SCREEN
    jsr SYSTEM_SHOW_KEYS        ; overlay on copied space
    jmp SCREEN_SYSTEM_GAME_LOOP

SYSTEM_GEN_SYS                  ; huh 'gen sys' / 'genesis' 
    jsr LFSR_NEXT_SEED          ; fresh own seed

    ; 2-15 color 1 (not black white)
-
    lda LFSR_W0
    and #%00001111
    cmp #2
    bcs +                       ; not black or white
    jsr LFSR_NEXT_SEED          ; try next seed
    jmp -
+
    sta SCREEN_SYSTEM_COLOR_TOP_SPACE_BORDER

    ; 2-15 color 2 (not same as 1)
-
    lda LFSR_W0+1
    and #%00001111
    cmp SCREEN_SYSTEM_COLOR_TOP_SPACE_BORDER   ; check not same color
    bne +                       ; are different
    jsr LFSR_NEXT_SEED          ; try next seed
    jmp -
+
    sta SCREEN_SYSTEM_COLOR_TEXT_BG

    ; 0-15 color 3 (not same as 2)
-
    lda LFSR_W1
    and #%00001111
    cmp SCREEN_SYSTEM_COLOR_TEXT_BG   ; check not same color
    bne +                       ; are different
    jsr LFSR_NEXT_SEED          ; try next seed
    jmp -
+
    sta SCREEN_SYSTEM_COLOR_TEXT_BORDER

    ; 0-15 color 4 (not same as 3)
-
    lda LFSR_W1+1
    and #%00001111
    cmp SCREEN_SYSTEM_COLOR_TEXT_BORDER   ; check not same color
    bne +                       ; are different
    jsr LFSR_NEXT_SEED          ; try next seed
    jmp -
+
    sta SCREEN_SYSTEM_COLOR_BOTTOM_BORDER

    ; 0-15 shared MCM for planet color 1 (VIC-2 only looks at 4 bits so don't have to make 0-15)
    lda LFSR_W2
    sta BG_COL_1

    ; 0-15 planet color 1
    lda LFSR_W2+1
    sta BG_COL_2

    jsr LFSR_NEXT_SEED          ; new seed needed
 
    ; 0-7 sun type
    lda LFSR_W0
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda SUN_TYPE_DIST, x
    sta SUN_TYPE

    ; sun color
    lda #<SUN_TYPE_0_COLOR
    sta ZP_PTR_1
    lda #>SUN_TYPE_0_COLOR
    sta ZP_PTR_1_PAIR

    ldy SUN_TYPE
    lda (ZP_PTR_1), y               ; a has color
    sta SUN_COLOR

    ; special for binary
    lda SUN_TYPE
    cmp #7
    bne +                           ; skip if not binary

    ; binary so diff sun colour for each one
    lda LFSR_W0+1
    and #%00000111                  ; 0-7
    tay
    lda (ZP_PTR_1), y               ; a has color
    sta SUN_COLOR

    lda LFSR_W1
    and #%00000111                  ; 0-7
    tay
    lda (ZP_PTR_1), y               ; a has color
    sta SUN_COLOR_2

+

    ; 0-7 planets
    lda LFSR_W1+1
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda SCREEN_SYSTEM_NUM_PLANETS_DIST, x
    sta SCREEN_SYSTEM_NUM_PLANETS
    clc 
    adc #$30                    ; start of numbers in charset
    sta SCREEN_SYSTEM_NUM_PLANETS_CHAR

    ; diplomat name
    jsr NAME_GENERATE_PERSON_NAME
    lda #<NAME_BUFFER
    sta ZP_PTR_1
    lda #>NAME_BUFFER
    sta ZP_PTR_1_PAIR
    lda #<DIPLOMAT_BUFFER
    sta ZP_PTR_2
    lda #>DIPLOMAT_BUFFER
    sta ZP_PTR_2_PAIR
    jsr SYS_MEM_COPY

    ; diplomat logo
    jsr LOGO_GENERATE
    jsr DIPLOMAT_COPY_FROM_LOGO

    ; 0-7 tech level
    lda LFSR_W2
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda SCREEN_SYSTEM_TECH_LEVEL_DIST, x
    sta SCREEN_SYSTEM_TECH_LEVEL

    ; 0-7 culture status
    lda LFSR_W2+1
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda SCREEN_SYSTEM_CUL_STATUS_DIST, x
    sta SCREEN_SYSTEM_CUL_STATUS

    ; orbits (planets mostly)
    jsr ORBITS_GENERATE

    jsr LFSR_NEXT_SEED          ; new seed needed
    ; incline
-
    lda LFSR_W0
    and #%01111111              ; 0-127
    cmp #91
    bcc +                       ; it's 0-90
    jsr LFSR_NEXT_SEED          ; new seed needed
    jmp -
+
    sta SCREEN_SYSTEM_INCLINE

    ; kepler
    lda LFSR_W0+1
    sta SCREEN_SYSTEM_KEPLER

    ; bg anim speed
    lda LFSR_W1
    and #%00000011
    tax 
    lda SCREEN_SYSTEM_BG_COL_SPEED_LUT, x
    sta SCREEN_SYSTEM_BG_COL_SPEED

    ; bg flash
    ; todo: 1 in 32 chance it actually flashes (bit high, but want to see it sometimes!)
    lda LFSR_W1+1
    and #%00011111
    bne +
    lda #1                          ; on when 0 (1 in 256)
    jmp ++
+
    lda #0                          ; normally off
++
    sta SCREEN_SYSTEM_BG_FLASH_ON

    ; prob when showing
    lda LFSR_W2
    and #%00000011
    tax 
    lda SCREEN_SYSTEM_BG_FLASH_PROB_LUT, x
    sta SCREEN_SYSTEM_BG_FLASH_PROB

    ; colour type
    lda LFSR_W2+1
    and #%00000011
    sta SCREEN_SYSTEM_BG_FLASH_COLOUR_TYPE

    jsr LFSR_NEXT_SEED          ; new seed needed

    bne +
    ; 0 sun color
    lda SUN_COLOR
    sta SCREEN_SYSTEM_BG_FLASH_COLOUR_STATIC
    jmp ++
+
    lda SCREEN_SYSTEM_BG_FLASH_COLOUR_TYPE
    cmp #1
    bne +
    ; 1 nebula color
    lda CLOUDS_COLOR
    sta SCREEN_SYSTEM_BG_FLASH_COLOUR_STATIC
    jmp ++
+
    lda SCREEN_SYSTEM_BG_FLASH_COLOUR_TYPE
    cmp #2
    bne +
    ; 2 static random
    ; color not black
-
    lda LFSR_W0
    and #%00000111              ; 0-7
    bne +++                     ; not black
    jsr LFSR_NEXT_SEED          ; try next
    jmp -
+++
    sta SCREEN_SYSTEM_BG_FLASH_COLOUR_STATIC
    jmp ++
+
    ; 3 random per flash
    ; so don't need static but set white for debug
    lda #WHITE
    sta SCREEN_SYSTEM_BG_FLASH_COLOUR_STATIC
++

    ; passenger
    lda #0
    sta DIPLOMAT_HAS_PASSENGER
    lda #16                ; regular p
    sta DIPLOMAT_PASSENGER_LABEL

    lda LFSR_W0+1
    clc 
    adc RASTER_FRAME_COUNTER_L0         ; and 'random' factor each time
    and #%00000011
;    beq +                   ; 1 in 4 has passenger
    ; has passenger
    lda #1
    sta DIPLOMAT_HAS_PASSENGER          

    ; use frame counter to 'random' factor the passenger seed
    lda LFSR_W1
    clc
    adc RASTER_FRAME_COUNTER_L0
    sta LFSR_W1
    lda LFSR_W2
    clc
    adc RASTER_FRAME_COUNTER_HI
    sta LFSR_W2

    jsr LFSR_NEXT_SEED      ; fresh seed
    lda LFSR_W0
    sta DIPLOMAT_PASSENGER_SEED_W0
    lda LFSR_W0+1
    sta DIPLOMAT_PASSENGER_SEED_W0+1
    lda LFSR_W1
    sta DIPLOMAT_PASSENGER_SEED_W1
    lda LFSR_W1+1
    sta DIPLOMAT_PASSENGER_SEED_W1+1
    lda LFSR_W2
    sta DIPLOMAT_PASSENGER_SEED_W2
    lda LFSR_W2+1
    sta DIPLOMAT_PASSENGER_SEED_W2+1

    ; only if don't already have one
    lda SHIP_HAS_PASSENGER
    bne +
    lda #144                ; inverted p
    sta DIPLOMAT_PASSENGER_LABEL
+   
    rts

SYSTEM_SHOW_VALUES
    ; white or black?
    ldx SCREEN_SYSTEM_COLOR_TEXT_BG
    lda SCREEN_SYSTEM_FONT_COLOR, x 
    sta TEXT_COLOR

    ; all values same x
    lda #20
    sta TEXT_X

    lda #<SCREEN_SYSTEM_NAME_BUFFER
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_NAME_BUFFER
    sta TEXT_STRING_PTR+1
    lda #16
    sta TEXT_Y
    jsr TEXT_DRAW_STRING

    ldx SCREEN_SYSTEM_TECH_LEVEL
    lda SCREEN_SYSTEM_TECH_LEVEL_STRING_LUT_LOW, x
    sta TEXT_STRING_PTR
    lda SCREEN_SYSTEM_TECH_LEVEL_STRING_LUT_HIGH, x
    sta TEXT_STRING_PTR+1
    lda #18
    sta TEXT_Y
    jsr TEXT_DRAW_STRING

    ldx SCREEN_SYSTEM_CUL_STATUS
    lda SCREEN_SYSTEM_CUL_STATUS_STRING_LUT_LOW, x
    sta TEXT_STRING_PTR
    lda SCREEN_SYSTEM_CUL_STATUS_STRING_LUT_HIGH, x
    sta TEXT_STRING_PTR+1
    lda #20
    sta TEXT_Y
    jsr TEXT_DRAW_STRING

    lda #22
    sta TEXT_Y
    lda SCREEN_SYSTEM_INCLINE
    sta TEXT_CHAR
    jsr TEXT_DRAW_NUMBER

    lda #<SCREEN_SYSTEM_DEGREES
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_DEGREES
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    lda #24
    sta TEXT_Y
    lda #20
    sta TEXT_X
    jsr SYSTEM_SHOW_KEPLER

    rts

SYSTEM_SHOW_KEPLER:
    ; show card suit
    lda SCREEN_SYSTEM_KEPLER
    and #%11000000
    lsr 
    lsr 
    lsr 
    lsr 
    lsr 
    lsr                         ; 0-3
    tax
    lda SCREEN_SYSTEM_PRE_LUT, x
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR
    inc TEXT_X

    ; space
    lda #$20    
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR
    inc TEXT_X

    ; show vector 1
    lda SCREEN_SYSTEM_KEPLER
    and #%00110000
    lsr 
    lsr 
    lsr 
    lsr 
    tax 
    lda SCREEN_SYSTEM_VECTOR_LUT, x
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR
    inc TEXT_X

    ; show vector 2
    lda SCREEN_SYSTEM_KEPLER
    and #%00001100
    lsr 
    lsr 
    tax 
    lda SCREEN_SYSTEM_VECTOR_LUT, x
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR
    inc TEXT_X

    ; show vector 3
    lda SCREEN_SYSTEM_KEPLER
    and #%00000011
    tax 
    lda SCREEN_SYSTEM_VECTOR_LUT, x
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR
    inc TEXT_X

    rts 

SYSTEM_SHOW_LABELS
    ; white or black?
    ldx SCREEN_SYSTEM_COLOR_TEXT_BG
    lda SCREEN_SYSTEM_FONT_COLOR, x 
    sta TEXT_COLOR

    ; all labels same x
    lda #2
    sta TEXT_X

    lda #<SCREEN_SYSTEM_NAME_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_NAME_LABEL
    sta TEXT_STRING_PTR+1
    lda #16
    sta TEXT_Y
    jsr TEXT_DRAW_STRING

    lda #<SCREEN_SYSTEM_TECH_LEVEL_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_TECH_LEVEL_LABEL
    sta TEXT_STRING_PTR+1
    lda #18
    sta TEXT_Y
    jsr TEXT_DRAW_STRING

    lda #<SCREEN_SYSTEM_CUL_STATUS_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_CUL_STATUS_LABEL
    sta TEXT_STRING_PTR+1
    lda #20
    sta TEXT_Y
    jsr TEXT_DRAW_STRING

    lda #<SCREEN_SYSTEM_INCLINE_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_INCLINE_LABEL
    sta TEXT_STRING_PTR+1
    lda #22
    sta TEXT_Y
    jsr TEXT_DRAW_STRING

    lda #<SCREEN_SYSTEM_KEPLER_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_KEPLER_LABEL
    sta TEXT_STRING_PTR+1
    lda #24
    sta TEXT_Y
    jsr TEXT_DRAW_STRING

    rts

SYSTEM_SHOW_KEYS:
    lda #0 
    sta TEXT_Y
    lda #11
    sta TEXT_X
    lda #CYAN
    sta TEXT_COLOR
    lda #<SCREEN_SYSTEM_KEYS_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_KEYS_LABEL
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    ; set mUSIC color depending on state
    lda SCREEN_SYSTEM_MUSIC_ON
    beq +
    ; music is on, show dark 'm'
    lda #16
    sta TEXT_X
    lda #GREEN
    sta COLOR_RAM+16
+
    rts     

SCREEN_SYSTEM_GAME_LOOP
    ; m music
    lda #KEY_M_ROW
    sta CIA1_PRA

    lda CIA1_PRB
    and #KEY_M_COL  ; check pressed
    bne +           ; not pressed music
-
    lda CIA1_PRB
    and #KEY_M_COL  ; check released
    beq -
    jsr SCREEN_SYSTEM_TOGGLE_THEME_MUSIC
+
    ; j jump
    lda #KEY_J_ROW
    sta CIA1_PRA

    lda CIA1_PRB
    and #KEY_J_COL  ; check pressed
    bne +           ; not pressed jump
-
    lda CIA1_PRB
    and #KEY_J_COL  ; check released
    beq -
    jmp BB_JUMP_SHOW
+
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
    jmp ORBITS_SHOW_SLOTS_INFO
+
    ; s ship
    lda #KEY_S_ROW
    sta CIA1_PRA

    lda CIA1_PRB
    and #KEY_S_COL  ; check pressed
    bne +           ; not pressed info
-
    lda CIA1_PRB
    and #KEY_S_COL  ; check released
    beq -
    jmp SHIP_SHOW
+
    ; d diplomat
    lda #KEY_D_ROW
    sta CIA1_PRA

    lda CIA1_PRB
    and #KEY_D_COL  ; check pressed
    bne +           ; not pressed info
-
    lda CIA1_PRB
    and #KEY_D_COL  ; check released
    beq -
    jmp DIPLOMAT_SHOW
+
    jsr SCREEN_SYSTEM_ANIMATE           ; animates every frame
    jmp SCREEN_SYSTEM_GAME_LOOP

SCREEN_SYSTEM_TOGGLE_THEME_MUSIC:
    lda SCREEN_SYSTEM_MUSIC_ON
    eor #01
    sta SCREEN_SYSTEM_MUSIC_ON
    jsr SYSTEM_SHOW_KEYS    
    rts

SCREEN_SYSTEM_TOGGLE_SHARED_COLORS:
    lda BG_COL_1
    tax
    lda BG_COL_2
    sta BG_COL_1
    txa 
    sta BG_COL_2
    rts 

SCREEN_SYSTEM_ANIMATE:
    lda RASTER_FRAME_FLAG
    bne +
    rts                 ; flag not set, don't do anything
+   
    ; bg colour animation
    lda RASTER_FRAME_COUNTER_L0
    and SCREEN_SYSTEM_BG_COL_SPEED
    bne +
    jsr SCREEN_SYSTEM_TOGGLE_SHARED_COLORS
+
    ; bg flash
    lda SCREEN_SYSTEM_BG_FLASH_ON
    beq +
    jsr SCREEN_SYSTEM_FLASH_BG
+
    lda #0
    sta RASTER_FRAME_FLAG
    rts 


SCREEN_SYSTEM_FLASH_BG:
    jsr LFSR_NEXT_SEED
    lda LFSR_W0
    and SCREEN_SYSTEM_BG_FLASH_PROB
    bne .no_flash
    lda SCREEN_SYSTEM_BG_FLASH_COLOUR_TYPE
    cmp #3                          ; is it random color?
    bne .static_flash
    ; 2-15 color 1 (not black white)
-
    lda LFSR_W0
    and #%00001111
    cmp #2
    bcs +                       ; not black or white
    jsr LFSR_NEXT_SEED          ; try next seed
    jmp -
+
.static_flash:
    lda SCREEN_SYSTEM_BG_FLASH_COLOUR_STATIC
    jmp .flash_done
.no_flash:
    lda #BLACK
.flash_done:
    sta SCREEN_SYSTEM_SPACE_BG
    rts 

; only copies the 600 space chars & colours
; in 250/ 250 / 100 blocks
SCREEN_SYSTEM_COPY_SPACE_TO_SCREEN:

    ; first 250

    ; source chars
    lda #<SCREEN_800_RAM_250_0
    sta ZP_PTR_1
    lda #>SCREEN_800_RAM_250_0
    sta ZP_PTR_1_PAIR
    ; target chars
    lda #<SCREEN_RAM_250_0
    sta ZP_PTR_2
    lda #>SCREEN_RAM_250_0
    sta ZP_PTR_2_PAIR
    ; 250
    lda #250
    sta ZP_PTR_TEMP_0
    jsr SYS_MEM_COPY_NUM

    ; source colours
    lda #<SCREEN_C00_COL_RAM_250_0
    sta ZP_PTR_1
    lda #>SCREEN_C00_COL_RAM_250_0
    sta ZP_PTR_1_PAIR
    ; target colours
    lda #<SCREEN_COL_RAM_250_0
    sta ZP_PTR_2
    lda #>SCREEN_COL_RAM_250_0
    sta ZP_PTR_2_PAIR
    ; num
    lda #250
    sta ZP_PTR_TEMP_0
    jsr SYS_MEM_COPY_NUM

    ; second 250

    ; source chars
    lda #<SCREEN_800_RAM_250_1
    sta ZP_PTR_1
    lda #>SCREEN_800_RAM_250_1
    sta ZP_PTR_1_PAIR
    ; target chars
    lda #<SCREEN_RAM_250_1
    sta ZP_PTR_2
    lda #>SCREEN_RAM_250_1
    sta ZP_PTR_2_PAIR
    ; 250
    lda #250
    sta ZP_PTR_TEMP_0
    jsr SYS_MEM_COPY_NUM

    ; source colours
    lda #<SCREEN_C00_COL_RAM_250_1
    sta ZP_PTR_1
    lda #>SCREEN_C00_COL_RAM_250_1
    sta ZP_PTR_1_PAIR
    ; target colours
    lda #<SCREEN_COL_RAM_250_1
    sta ZP_PTR_2
    lda #>SCREEN_COL_RAM_250_1
    sta ZP_PTR_2_PAIR
    ; num
    lda #250
    sta ZP_PTR_TEMP_0
    jsr SYS_MEM_COPY_NUM

    ; last 100

    ; source chars
    lda #<SCREEN_800_RAM_250_2
    sta ZP_PTR_1
    lda #>SCREEN_800_RAM_250_2
    sta ZP_PTR_1_PAIR
    ; target chars
    lda #<SCREEN_RAM_250_2
    sta ZP_PTR_2
    lda #>SCREEN_RAM_250_2
    sta ZP_PTR_2_PAIR
    ; 250
    lda #100
    sta ZP_PTR_TEMP_0
    jsr SYS_MEM_COPY_NUM

    ; source colours
    lda #<SCREEN_C00_COL_RAM_250_2
    sta ZP_PTR_1
    lda #>SCREEN_C00_COL_RAM_250_2
    sta ZP_PTR_1_PAIR
    ; target colours
    lda #<SCREEN_COL_RAM_250_2
    sta ZP_PTR_2
    lda #>SCREEN_COL_RAM_250_2
    sta ZP_PTR_2_PAIR
    ; num
    lda #100
    sta ZP_PTR_TEMP_0
    jsr SYS_MEM_COPY_NUM

    rts 

