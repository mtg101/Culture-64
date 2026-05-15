




SCREEN_SYSTEM_SHOW
    ; black bg
    lda #BLACK
    sta BG_COL

    ; black border
    lda #BLACK
    sta BORDER_COL

    ; seed from name
    lda #<SCREEN_SYSTEM_NAME_BUFFER
    sta LFSR_NAME_PTR
    lda #>SCREEN_SYSTEM_NAME_BUFFER
    sta LFSR_NAME_PTR+1
    jsr LFSR_SEED_FROM_NAME

    ; stars
    jsr STARS_FILL_SCREEN

    ; generate system
    jsr SYSTEM_GEN_SYS          ; huh 'gen sys' / 'genesis' 

    ; show labels
    jsr SYSTEM_SHOW_LABELS

    ; show values
    jsr SYSTEM_SHOW_VALUES

    jmp SCREEN_SYSTEM_GAME_LOOP

SYSTEM_GEN_SYS                  ; huh 'gen sys' / 'genesis' 
    jsr LFSR_NEXT_SEED

    ; 1-7 color 1
-
    lda LFSR_W0
    and #%00000111
    cmp #2
    bcs +                       ; not black or white
    jsr LFSR_NEXT_SEED          ; try next seed
    jmp -
+
    sta SCREEN_SYSTEM_COLOR_1

   ; 1-7 color 2
-
    lda LFSR_W0+1
    and #%00000111
    cmp #2
    bcs +                       ; not black or white
    jsr LFSR_NEXT_SEED          ; try next seed
    jmp -
+
    cmp SCREEN_SYSTEM_COLOR_1   ; check not same color
    bne +                       ; are different
    jsr LFSR_NEXT_SEED          ; try next seed
    jmp -
+
    sta SCREEN_SYSTEM_COLOR_2

    ; 0-7 sun type
    lda LFSR_W1
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda SCREEN_SYSTEM_SUN_TYPE_DIST, x
    sta SCREEN_SYSTEM_SUN_TYPE

    ; 0-7 planets
    lda LFSR_W1+1
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda SCREEN_SYSTEM_NUM_PLANETS_DIST, x
    sta SCREEN_SYSTEM_NUM_PLANETS
    clc 
    adc #$30                    ; start of numbers in charset
    sta SCREEN_SYSTEM_NUM_PLANETS_CHAR

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

    rts

SYSTEM_SHOW_VALUES
    ; all values same x
    lda #20
    sta TEXT_X

    lda #<SCREEN_SYSTEM_NAME_BUFFER
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_NAME_BUFFER
    sta TEXT_STRING_PTR+1
    lda #6
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; color 1
    ldx SCREEN_SYSTEM_COLOR_1
    lda SCREEN_SYSTEM_COLOR_STRING_LUT_LOW, x
    sta TEXT_STRING_PTR
    lda SCREEN_SYSTEM_COLOR_STRING_LUT_HIGH, x
    sta TEXT_STRING_PTR+1
    lda #8
    sta TEXT_Y
    lda SCREEN_SYSTEM_COLOR_1
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; color 2
    ldx SCREEN_SYSTEM_COLOR_2
    lda SCREEN_SYSTEM_COLOR_STRING_LUT_LOW, x
    sta TEXT_STRING_PTR
    lda SCREEN_SYSTEM_COLOR_STRING_LUT_HIGH, x
    sta TEXT_STRING_PTR+1
    lda #10
    sta TEXT_Y
    lda SCREEN_SYSTEM_COLOR_2
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; sun type
    ldx SCREEN_SYSTEM_SUN_TYPE
    lda SCREEN_SYSTEM_SUN_TYPE_STRING_LUT_LOW, x
    sta TEXT_STRING_PTR
    lda SCREEN_SYSTEM_SUN_TYPE_STRING_LUT_HIGH, x
    sta TEXT_STRING_PTR+1
    lda #12
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; num planets
    lda #<SCREEN_SYSTEM_NUM_PLANETS_CHAR
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_NUM_PLANETS_CHAR
    sta TEXT_STRING_PTR+1
    lda #14
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; tech level
    ldx SCREEN_SYSTEM_TECH_LEVEL
    lda SCREEN_SYSTEM_TECH_LEVEL_STRING_LUT_LOW, x
    sta TEXT_STRING_PTR
    lda SCREEN_SYSTEM_TECH_LEVEL_STRING_LUT_HIGH, x
    sta TEXT_STRING_PTR+1
    lda #16
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; culture status
    ldx SCREEN_SYSTEM_CUL_STATUS
    lda SCREEN_SYSTEM_CUL_STATUS_STRING_LUT_LOW, x
    sta TEXT_STRING_PTR
    lda SCREEN_SYSTEM_CUL_STATUS_STRING_LUT_HIGH, x
    sta TEXT_STRING_PTR+1
    lda #18
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    rts

SYSTEM_SHOW_LABELS
    ; title string
    lda #<SCREEN_SYSTEM_TITLE
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_TITLE
    sta TEXT_STRING_PTR+1
    lda #0
    sta TEXT_X
    lda #0
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; all labels same x
    lda #2
    sta TEXT_X

    lda #<SCREEN_SYSTEM_NAME_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_NAME_LABEL
    sta TEXT_STRING_PTR+1
    lda #6
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SCREEN_SYSTEM_COLOR_1_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_COLOR_1_LABEL
    sta TEXT_STRING_PTR+1
    lda #8
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SCREEN_SYSTEM_COLOR_2_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_COLOR_2_LABEL
    sta TEXT_STRING_PTR+1
    lda #10
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SCREEN_SYSTEM_SUN_TYPE_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_SUN_TYPE_LABEL
    sta TEXT_STRING_PTR+1
    lda #12
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SCREEN_SYSTEM_NUM_PLANETS_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_NUM_PLANETS_LABEL
    sta TEXT_STRING_PTR+1
    lda #14
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SCREEN_SYSTEM_TECH_LEVEL_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_TECH_LEVEL_LABEL
    sta TEXT_STRING_PTR+1
    lda #16
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SCREEN_SYSTEM_CUL_STATUS_LABEL
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_CUL_STATUS_LABEL
    sta TEXT_STRING_PTR+1
    lda #18
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    rts


SCREEN_SYSTEM_GAME_LOOP
    lda #KEY_J_ROW
    sta CIA1_PRA

    lda CIA1_PRB
    and #KEY_J_COL  ; check pressed
    bne +           ; not pressed jump
-
    lda CIA1_PRB
    and #KEY_J_COL  ; check released
    beq -
    jmp SCREEN_JUMP_SHOW
+
    jmp SCREEN_SYSTEM_GAME_LOOP


SCREEN_SYSTEM_TITLE
    !scr "culture 64", 0
SCREEN_SYSTEM_NAME_LABEL
    !scr "name:", 0
; add $80 to each char to invert    
;    !scr 'n'+$80, 'a'+$80, 'm'+$80, 'e'+$80, ':'+$80, 0
SCREEN_SYSTEM_SUN_TYPE_LABEL
    !scr "sun type:", 0
SCREEN_SYSTEM_COLOR_1_LABEL
    !scr "color 1:", 0
SCREEN_SYSTEM_COLOR_2_LABEL
    !scr "color 2:", 0
SCREEN_SYSTEM_NUM_PLANETS_LABEL
    !scr "num planets:", 0
SCREEN_SYSTEM_TECH_LEVEL_LABEL
    !scr "tech level:", 0
SCREEN_SYSTEM_CUL_STATUS_LABEL
    !scr "culture status:", 0


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

SCREEN_SYSTEM_SUN_TYPE
    !byte 0
SCREEN_SYSTEM_SUN_TYPE_DIST         ; 0-7 types, over 32 for curve
    !byte 0, 0, 0, 0, 0, 0          ; 6/32
    !byte 1, 1, 1, 1, 1             ; 5/32
    !byte 2, 2, 2, 2, 2             ; 5/32
    !byte 3, 3, 3, 3, 3             ; 5/32
    !byte 4, 4, 4, 4                ; 4/32
    !byte 5, 5, 5                   ; 3/32
    !byte 6, 6                      ; 2/32
    !byte 7, 7                      ; 2/32
SCREEN_SYSTEM_SUN_TYPE_STRING_LUT_LOW
    !byte <SCREEN_SYSTEM_SUN_TYPE_0_STRING
    !byte <SCREEN_SYSTEM_SUN_TYPE_1_STRING
    !byte <SCREEN_SYSTEM_SUN_TYPE_2_STRING
    !byte <SCREEN_SYSTEM_SUN_TYPE_3_STRING
    !byte <SCREEN_SYSTEM_SUN_TYPE_4_STRING
    !byte <SCREEN_SYSTEM_SUN_TYPE_5_STRING
    !byte <SCREEN_SYSTEM_SUN_TYPE_6_STRING
    !byte <SCREEN_SYSTEM_SUN_TYPE_7_STRING
SCREEN_SYSTEM_SUN_TYPE_STRING_LUT_HIGH
    !byte >SCREEN_SYSTEM_SUN_TYPE_0_STRING
    !byte >SCREEN_SYSTEM_SUN_TYPE_1_STRING
    !byte >SCREEN_SYSTEM_SUN_TYPE_2_STRING
    !byte >SCREEN_SYSTEM_SUN_TYPE_3_STRING
    !byte >SCREEN_SYSTEM_SUN_TYPE_4_STRING
    !byte >SCREEN_SYSTEM_SUN_TYPE_5_STRING
    !byte >SCREEN_SYSTEM_SUN_TYPE_6_STRING
    !byte >SCREEN_SYSTEM_SUN_TYPE_7_STRING

SCREEN_SYSTEM_SUN_TYPE_0_STRING
    !scr "red dwarf", 0
SCREEN_SYSTEM_SUN_TYPE_1_STRING
    !scr "yellow dwarf", 0
SCREEN_SYSTEM_SUN_TYPE_2_STRING
    !scr "blue star", 0
SCREEN_SYSTEM_SUN_TYPE_3_STRING
    !scr "red giant", 0
SCREEN_SYSTEM_SUN_TYPE_4_STRING
    !scr "white dwarf", 0
SCREEN_SYSTEM_SUN_TYPE_5_STRING
    !scr "brown dwarf", 0
SCREEN_SYSTEM_SUN_TYPE_6_STRING
    !scr "neutron", 0
SCREEN_SYSTEM_SUN_TYPE_7_STRING
    !scr "binary", 0


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


SCREEN_SYSTEM_COLOR_1 
    !byte 0
SCREEN_SYSTEM_COLOR_2
    !byte 0
SCREEN_SYSTEM_COLOR_STRING_LUT_LOW
    !byte <SCREEN_SYSTEM_COLOR_0_STRING
    !byte <SCREEN_SYSTEM_COLOR_1_STRING
    !byte <SCREEN_SYSTEM_COLOR_2_STRING
    !byte <SCREEN_SYSTEM_COLOR_3_STRING
    !byte <SCREEN_SYSTEM_COLOR_4_STRING
    !byte <SCREEN_SYSTEM_COLOR_5_STRING
    !byte <SCREEN_SYSTEM_COLOR_6_STRING
    !byte <SCREEN_SYSTEM_COLOR_7_STRING
SCREEN_SYSTEM_COLOR_STRING_LUT_HIGH
    !byte >SCREEN_SYSTEM_COLOR_0_STRING
    !byte >SCREEN_SYSTEM_COLOR_1_STRING
    !byte >SCREEN_SYSTEM_COLOR_2_STRING
    !byte >SCREEN_SYSTEM_COLOR_3_STRING
    !byte >SCREEN_SYSTEM_COLOR_4_STRING
    !byte >SCREEN_SYSTEM_COLOR_5_STRING
    !byte >SCREEN_SYSTEM_COLOR_6_STRING
    !byte >SCREEN_SYSTEM_COLOR_7_STRING
SCREEN_SYSTEM_COLOR_0_STRING
    !scr "black", 0
SCREEN_SYSTEM_COLOR_1_STRING
    !scr "white", 0
SCREEN_SYSTEM_COLOR_2_STRING
    !scr "red", 0
SCREEN_SYSTEM_COLOR_3_STRING
    !scr "cyan", 0
SCREEN_SYSTEM_COLOR_4_STRING
    !scr "purple", 0
SCREEN_SYSTEM_COLOR_5_STRING
    !scr "green", 0
SCREEN_SYSTEM_COLOR_6_STRING
    !scr "blue", 0
SCREEN_SYSTEM_COLOR_7_STRING
    !scr "yellow", 0

SCREEN_SYSTEM_NAME_BUFFER
    !fill BB_MAX_CHARS+1, 0
