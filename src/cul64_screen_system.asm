SCREEN_SYSTEM_LOAD:
    jsr SCREEN_OFF

    ; seed from name
    lda #<SCREEN_SYSTEM_NAME_BUFFER
    sta LFSR_NAME_PTR
    lda #>SCREEN_SYSTEM_NAME_BUFFER
    sta LFSR_NAME_PTR+1
    jsr LFSR_SEED_FROM_NAME


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

    ; music!
    jsr music_init

    jsr SCREEN_ON

    jmp SCREEN_SYSTEM_GAME_LOOP

SCREEN_SYSTEM_RESHOW:
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
    jsr NAME_GENERATE_DIPLOMAT
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
    ; j jump
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


SCREEN_SYSTEM_NAME_LABEL
    !scr "system", 0
; add $80 to each char to invert    
;    !scr 'n'+$80, 'a'+$80, 'm'+$80, 'e'+$80, ':'+$80, 0
SCREEN_SYSTEM_SUN_TYPE_LABEL
    !scr "sun type", 0
SCREEN_SYSTEM_INCLINE_LABEL
    !scr "plane incline", 0         ; 0-90 degrees
SCREEN_SYSTEM_KEPLER_LABEL
    !scr "kepler vector", 0         ; it's a cool scifi name kinda related to star systems... ignore the details!
SCREEN_SYSTEM_TECH_LEVEL_LABEL
    !scr "tech level", 0
SCREEN_SYSTEM_CUL_STATUS_LABEL
    !scr "culture status", 0

SCREEN_SYSTEM_DEGREES
    !scr " degrees", 0

SCREEN_SYSTEM_INCLINE
    !byte 0
SCREEN_SYSTEM_KEPLER
    !byte 0


SCREEN_SYSTEM_NUM_PLANETS
    !byte 0
SCREEN_SYSTEM_NUM_PLANETS_CHAR
    !byte 0, 0                      ; null terminated for regular string draw
SCREEN_SYSTEM_NUM_PLANETS_DIST      ; 0-7 planets, over 32 so most are 3-5
    !byte 0                         ; 1/32
    !byte 1, 1                      ; 2/32
    !byte 2, 2, 2                   ; 3/32
    !byte 3, 3, 3, 3                ; 4/32
    !byte 4, 4, 4, 4, 4, 4          ; 6/32
    !byte 5, 5, 5, 5, 5, 5          ; 6/32
    !byte 6, 6, 6, 6, 6, 6          ; 6/32
    !byte 7, 7, 7, 7                ; 4/32

SCREEN_SYSTEM_TECH_LEVEL 
    !byte 0

SCREEN_SYSTEM_TECH_LEVEL_DIST       ; 0-7 levels, over 32 for curve
    !byte 0, 0                      ; 2/32
    !byte 1, 1, 1                   ; 3/32
    !byte 2, 2, 2, 2                ; 4/32
    !byte 3, 3, 3, 3, 3             ; 5/32
    !byte 4, 4, 4, 4, 4, 4          ; 6/32
    !byte 5, 5, 5, 5, 5, 5          ; 6/32
    !byte 6, 6, 6, 6                ; 4/32
    !byte 7, 7                      ; 2/32

SCREEN_SYSTEM_TECH_LEVEL_STRING_LUT_LOW
    !byte <SCREEN_SYSTEM_TECH_LEVEL_0_STRING
    !byte <SCREEN_SYSTEM_TECH_LEVEL_1_STRING
    !byte <SCREEN_SYSTEM_TECH_LEVEL_2_STRING
    !byte <SCREEN_SYSTEM_TECH_LEVEL_3_STRING
    !byte <SCREEN_SYSTEM_TECH_LEVEL_4_STRING
    !byte <SCREEN_SYSTEM_TECH_LEVEL_5_STRING
    !byte <SCREEN_SYSTEM_TECH_LEVEL_6_STRING
    !byte <SCREEN_SYSTEM_TECH_LEVEL_7_STRING
SCREEN_SYSTEM_TECH_LEVEL_STRING_LUT_HIGH
    !byte >SCREEN_SYSTEM_TECH_LEVEL_0_STRING
    !byte >SCREEN_SYSTEM_TECH_LEVEL_1_STRING
    !byte >SCREEN_SYSTEM_TECH_LEVEL_2_STRING
    !byte >SCREEN_SYSTEM_TECH_LEVEL_3_STRING
    !byte >SCREEN_SYSTEM_TECH_LEVEL_4_STRING
    !byte >SCREEN_SYSTEM_TECH_LEVEL_5_STRING
    !byte >SCREEN_SYSTEM_TECH_LEVEL_6_STRING
    !byte >SCREEN_SYSTEM_TECH_LEVEL_7_STRING

SCREEN_SYSTEM_TECH_LEVEL_0_STRING
    !scr "pre-radio", 0
SCREEN_SYSTEM_TECH_LEVEL_1_STRING
    !scr "radio", 0
SCREEN_SYSTEM_TECH_LEVEL_2_STRING
    !scr "internet", 0
SCREEN_SYSTEM_TECH_LEVEL_3_STRING
    !scr "kardashev i", 0
SCREEN_SYSTEM_TECH_LEVEL_4_STRING
    !scr "kardashev ii", 0
SCREEN_SYSTEM_TECH_LEVEL_5_STRING
    !scr "warp capable", 0
SCREEN_SYSTEM_TECH_LEVEL_6_STRING
    !scr "kardashev iii", 0
SCREEN_SYSTEM_TECH_LEVEL_7_STRING
    !scr "culture", 0

SCREEN_SYSTEM_CUL_STATUS
    !byte 0
SCREEN_SYSTEM_CUL_STATUS_DIST       ; 0-7 types, over 32 for curve
    !byte 0                         ; 1/32
    !byte 1, 1                      ; 2/32
    !byte 2                         ; 1/32
    !byte 3, 3                      ; 2/432
    !byte 4, 4, 4, 4                ; 4/32
    !byte 5, 5, 5, 5, 5             ; 5/32
    !byte 6, 6, 6, 6, 6             ; 5/32
    !byte 7, 7, 7, 7, 7, 7          ; 6/12/32
    !byte 7, 7, 7, 7, 7, 7          ; 6/12/32
SCREEN_SYSTEM_CUL_STATUS_STRING_LUT_LOW
    !byte <SCREEN_SYSTEM_CUL_STATUS_0_STRING
    !byte <SCREEN_SYSTEM_CUL_STATUS_1_STRING
    !byte <SCREEN_SYSTEM_CUL_STATUS_2_STRING
    !byte <SCREEN_SYSTEM_CUL_STATUS_3_STRING
    !byte <SCREEN_SYSTEM_CUL_STATUS_4_STRING
    !byte <SCREEN_SYSTEM_CUL_STATUS_5_STRING
    !byte <SCREEN_SYSTEM_CUL_STATUS_6_STRING
    !byte <SCREEN_SYSTEM_CUL_STATUS_7_STRING
SCREEN_SYSTEM_CUL_STATUS_STRING_LUT_HIGH
    !byte >SCREEN_SYSTEM_CUL_STATUS_0_STRING
    !byte >SCREEN_SYSTEM_CUL_STATUS_1_STRING
    !byte >SCREEN_SYSTEM_CUL_STATUS_2_STRING
    !byte >SCREEN_SYSTEM_CUL_STATUS_3_STRING
    !byte >SCREEN_SYSTEM_CUL_STATUS_4_STRING
    !byte >SCREEN_SYSTEM_CUL_STATUS_5_STRING
    !byte >SCREEN_SYSTEM_CUL_STATUS_6_STRING
    !byte >SCREEN_SYSTEM_CUL_STATUS_7_STRING
SCREEN_SYSTEM_CUL_STATUS_0_STRING
    !scr "culture war", 0
SCREEN_SYSTEM_CUL_STATUS_1_STRING
    !scr "hostile", 0
SCREEN_SYSTEM_CUL_STATUS_2_STRING
    !scr "unknown", 0
SCREEN_SYSTEM_CUL_STATUS_3_STRING
    !scr "neutral", 0
SCREEN_SYSTEM_CUL_STATUS_4_STRING
    !scr "peace treaty", 0
SCREEN_SYSTEM_CUL_STATUS_5_STRING
    !scr "friendly", 0
SCREEN_SYSTEM_CUL_STATUS_6_STRING
    !scr "trade agreement", 0
SCREEN_SYSTEM_CUL_STATUS_7_STRING
    !scr "culture system", 0


SCREEN_SYSTEM_COLOR_TOP_SPACE_BORDER 
    !byte 0
SCREEN_SYSTEM_COLOR_TEXT_BG
    !byte 0
SCREEN_SYSTEM_COLOR_TEXT_BORDER
    !byte 0
SCREEN_SYSTEM_COLOR_BOTTOM_BORDER
    !byte 0
SCREEN_SYSTEM_NAME_BUFFER
    !fill BB_MAX_CHARS+1, 0
SCREEN_SYSTEM_KEYS_LABEL
    ; jUMP mUSIC dIPLOMAT sHIP iNFO
    !byte 138           ; jump 4 = 4
    !scr "ump"
    !byte 32            ; space +1 = 5
    !byte 141           ; music +5 = 10
    !scr "usic"
    !byte 32            ; space +1 = 11
    !byte 132           ; +8 = 19
    !scr "iplomat"
    !byte 32            ; +1 = 20
    !byte 147           ; +4 = 24
    !scr "hip"
    !byte 32            ; +1 = 25
    !byte 137           ; +4 = 29
    !scr "nfo"
    !byte  0                            ; +1 = 30

SCREEN_SYSTEM_KEYS_LABEL_BLANK      ; I'll worry about these waster bytes when I run out of bytes... TODO
    !fill 29, 32                        ; fill (phil ;) spaces

SCREEN_SYSTEM_SPACE_BG
    !byte 0

SCREEN_SYSTEM_PRE_LUT
    !byte 73, 74, 75, 85
SCREEN_SYSTEM_VECTOR_LUT
    !byte 77, 78, 67, 93

; if bg is black, text white, it white black
SCREEN_SYSTEM_FONT_COLOR
    !byte WHITE, BLACK, WHITE, BLACK, WHITE, WHITE, WHITE, BLACK
    !byte BLACK, WHITE, BLACK, WHITE, BLACK, BLACK, BLACK, BLACK

; $00 silent, $0F max vol
SCREEN_SYSTEM_MUSIC_ON
    !byte 0
SCREEN_SYSTEM_MUSIC_JUMPING
    !byte 0
SCREEN_SYSTEM_BG_COL_SPEED
    !byte 0    
SCREEN_SYSTEM_BG_COL_SPEED_LUT
    !byte %01111111, %00111111, %00111111, %00011111
SCREEN_SYSTEM_BG_FLASH_ON
    !byte 0    
SCREEN_SYSTEM_BG_FLASH_PROB
    !byte 0    
SCREEN_SYSTEM_BG_FLASH_PROB_LUT
    !byte %11111111, %01111111, %00111111, %00011111
; 0 sun color
; 1 nebula color
; 2 static random
; 3 random per flash
SCREEN_SYSTEM_BG_FLASH_COLOUR_TYPE
    !byte 0   
SCREEN_SYSTEM_BG_FLASH_COLOUR_STATIC
    !byte 0   
