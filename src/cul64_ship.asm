SHIP_GEN_FROM_NAME:
    ; gen seed from name
    lda #<SHIP_NAME_BUFFER
    sta LFSR_NAME_PTR
    lda #>SHIP_NAME_BUFFER
    sta LFSR_NAME_PTR+1
    jsr LFSR_SEED_FROM_NAME


    ; gen home system name from seed
    jsr NAME_GENERATE_SYSTEM
    lda #<NAME_BUFFER
    sta ZP_PTR_1
    lda #>NAME_BUFFER
    sta ZP_PTR_1_PAIR
    lda #<SHIP_HOME_BUFFER
    sta ZP_PTR_2
    lda #>SHIP_HOME_BUFFER
    sta ZP_PTR_2_PAIR
    jsr SYS_MEM_COPY

    ; generate logo from seed
    jsr LOGO_GENERATE
    jsr SHIP_COPY_FROM_LOGO

    rts

SHIP_COPY_FROM_LOGO:
    lda LOGO_TL_CHAR
    sta SHIP_LOGO_TL_CHAR

    lda LOGO_TR_CHAR
    sta SHIP_LOGO_TR_CHAR

    lda LOGO_BL_CHAR
    sta SHIP_LOGO_BL_CHAR

    lda LOGO_BR_CHAR
    sta SHIP_LOGO_BR_CHAR

    lda LOGO_TL_COL
    sta SHIP_LOGO_TL_COL

    lda LOGO_TR_COL
    sta SHIP_LOGO_TR_COL

    lda LOGO_BL_COL
    sta SHIP_LOGO_BL_COL

    lda LOGO_BR_COL
    sta SHIP_LOGO_BR_COL

    lda LOGO_BORDER_COLOR
    sta SHIP_LOGO_BORDER_COLOR

    rts 

SHIP_COPY_TO_LOGO: 
    lda SHIP_LOGO_TL_CHAR
    sta LOGO_TL_CHAR

    lda SHIP_LOGO_TR_CHAR
    sta LOGO_TR_CHAR

    lda SHIP_LOGO_BL_CHAR
    sta LOGO_BL_CHAR

    lda SHIP_LOGO_BR_CHAR
    sta LOGO_BR_CHAR

    lda SHIP_LOGO_TL_COL
    sta LOGO_TL_COL

    lda SHIP_LOGO_TR_COL
    sta LOGO_TR_COL

    lda SHIP_LOGO_BL_COL
    sta LOGO_BL_COL

    lda SHIP_LOGO_BR_COL
    sta LOGO_BR_COL

    lda SHIP_LOGO_BORDER_COLOR
    sta LOGO_BORDER_COLOR

    rts 


SHIP_SHOW:
    ; play theme music
    lda #<SHIP_NAME_BUFFER
    sta LFSR_NAME_PTR
    lda #>SHIP_NAME_BUFFER
    sta LFSR_NAME_PTR+1
    jsr LFSR_SEED_FROM_NAME

    jsr music_init

    ; clear bg
    ldx #0
-
    lda #$20                    ; space
    sta SCREEN_RAM_250_0, x
    lda #YELLOW
    sta SCREEN_COL_RAM_250_0, x
    inx
    cpx #250
    bne -

    ldx #0
-
    lda #$20                    ; space
    sta SCREEN_RAM_250_1, x
    lda #YELLOW
    sta SCREEN_COL_RAM_250_1, x
    inx
    cpx #250
    bne -

    ldx #0
-
    lda #$20                    ; space
    sta SCREEN_RAM_250_2, x
    lda #YELLOW
    sta SCREEN_COL_RAM_250_2, x
    inx
    cpx #100
    bne -

    ; invert S in top right
    lda #0 
    sta TEXT_Y
    lda #39
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    lda #147                ; invert S
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR

    ; blue bg
    lda #BLUE
    sta SCREEN_SYSTEM_SPACE_BG

    ; show labels
    lda #2
    sta TEXT_X

    lda #<SHIP_SHIP_LABEL
    sta TEXT_STRING_PTR
    lda #>SHIP_SHIP_LABEL
    sta TEXT_STRING_PTR+1
    lda #1
    sta TEXT_Y
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SHIP_CABIN_LABEL
    sta TEXT_STRING_PTR
    lda #>SHIP_CABIN_LABEL
    sta TEXT_STRING_PTR+1
    lda #5
    sta TEXT_Y
    lda #20
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SHIP_EMPTY_LABEL
    sta TEXT_STRING_PTR
    lda #>SHIP_EMPTY_LABEL
    sta TEXT_STRING_PTR+1
    lda #7
    sta TEXT_Y
    lda #22
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; show values
    lda #<SHIP_NAME_BUFFER
    sta TEXT_STRING_PTR
    lda #>SHIP_NAME_BUFFER
    sta TEXT_STRING_PTR+1
    lda #1
    sta TEXT_Y
    lda #20
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SHIP_HOME_LABEL
    sta TEXT_STRING_PTR
    lda #>SHIP_HOME_LABEL
    sta TEXT_STRING_PTR+1
    lda #13
    sta TEXT_Y
    lda #2
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #<SHIP_HOME_BUFFER
    sta TEXT_STRING_PTR
    lda #>SHIP_HOME_BUFFER
    sta TEXT_STRING_PTR+1
    lda #13
    sta TEXT_Y
    lda #20
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    lda #15
    sta LOGO_X
    lda #0
    sta LOGO_Y
    jsr SHIP_COPY_TO_LOGO
    jsr LOGO_RENDER

    ; show ship
    lda #<SHIP_CHARS_1
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_1
    sta TEXT_STRING_PTR+1
    lda #5
    sta TEXT_Y
    lda #4
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING
    lda #<SHIP_CHARS_2
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_2
    sta TEXT_STRING_PTR+1
    lda #6
    sta TEXT_Y
    jsr TEXT_DRAW_STRING
    lda #<SHIP_CHARS_3
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_3
    sta TEXT_STRING_PTR+1
    lda #7
    sta TEXT_Y
    jsr TEXT_DRAW_STRING
    lda #<SHIP_CHARS_4
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_4
    sta TEXT_STRING_PTR+1
    lda #8
    sta TEXT_Y
    jsr TEXT_DRAW_STRING
    lda #<SHIP_CHARS_5
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_5
    sta TEXT_STRING_PTR+1
    lda #9
    sta TEXT_Y
    jsr TEXT_DRAW_STRING
    lda #<SHIP_CHARS_6
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_6
    sta TEXT_STRING_PTR+1
    lda #10
    sta TEXT_Y
    jsr TEXT_DRAW_STRING

; into...
SHIP_GAME_LOOP
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
    jmp SCREEN_SYSTEM_RESHOW
+
    ; h home jump
    lda #KEY_H_ROW
    sta CIA1_PRA

    lda CIA1_PRB
    and #KEY_H_COL  ; check pressed
    bne +           ; not pressed info
-
    lda CIA1_PRB
    and #KEY_H_COL  ; check released
    beq -
    jmp SHIP_GO_HOME    
+
    jmp SHIP_GAME_LOOP

SHIP_GO_HOME:
    ; jump home: prepopulate jump bb with home system name

    ldx #0
.ship_go_home_loop:
    lda SHIP_HOME_BUFFER, x
    sta BB_TEXT_ENTRY_BUFFER, x
    inx
    cmp #0
    bne .ship_go_home_loop

    dex
    stx BB_CHAR_COUNT
    stx BB_TEXT_ENTRY_PRE_POP   ; we have pre-popd, any non-zero works so use x

    jmp BB_JUMP_SHOW

SHIP_SHOW_CALL:
    ; play friend's theme music
    lda #<SHIP_CALL_NAME_BUFFER
    sta LFSR_NAME_PTR
    lda #>SHIP_CALL_NAME_BUFFER
    sta LFSR_NAME_PTR+1
    jsr LFSR_SEED_FROM_NAME
    jsr music_init

    ; clear bg
    ldx #0
-
    lda #$20                    ; space
    sta SCREEN_RAM_250_0, x
    lda #YELLOW
    sta SCREEN_COL_RAM_250_0, x
    inx
    cpx #250
    bne -

    ldx #0
-
    lda #$20                    ; space
    sta SCREEN_RAM_250_1, x
    lda #YELLOW
    sta SCREEN_COL_RAM_250_1, x
    inx
    cpx #250
    bne -

    ldx #0
-
    lda #$20                    ; space
    sta SCREEN_RAM_250_2, x
    lda #YELLOW
    sta SCREEN_COL_RAM_250_2, x
    inx
    cpx #100
    bne -

    ; invert C in top right
    lda #0 
    sta TEXT_Y
    lda #39
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    lda #131                ; invert C
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR

    ; blue bg
    lda #BLUE
    sta SCREEN_SYSTEM_SPACE_BG

    lda #<SHIP_NAME_BUFFER
    sta TEXT_STRING_PTR
    lda #>SHIP_NAME_BUFFER
    sta TEXT_STRING_PTR+1
    lda #5
    sta TEXT_Y
    lda #2
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; logo
    lda #1
    sta LOGO_X
    lda #0
    sta LOGO_Y
    jsr SHIP_COPY_TO_LOGO
    jsr LOGO_RENDER

    ; show ship
    lda #<SHIP_CHARS_1
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_1
    sta TEXT_STRING_PTR+1
    lda #8
    sta TEXT_Y
    lda #4
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING
    lda #<SHIP_CHARS_2
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_2
    sta TEXT_STRING_PTR+1
    lda #9
    sta TEXT_Y
    jsr TEXT_DRAW_STRING
    lda #<SHIP_CHARS_3
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_3
    sta TEXT_STRING_PTR+1
    lda #10
    sta TEXT_Y
    jsr TEXT_DRAW_STRING
    lda #<SHIP_CHARS_4
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_4
    sta TEXT_STRING_PTR+1
    lda #11
    sta TEXT_Y
    jsr TEXT_DRAW_STRING
    lda #<SHIP_CHARS_5
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_5
    sta TEXT_STRING_PTR+1
    lda #12
    sta TEXT_Y
    jsr TEXT_DRAW_STRING
    lda #<SHIP_CHARS_6
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_6
    sta TEXT_STRING_PTR+1
    lda #13
    sta TEXT_Y
    jsr TEXT_DRAW_STRING

    ; friend ship (lols)
    lda #<SHIP_CALL_NAME_BUFFER
    sta TEXT_STRING_PTR
    lda #>SHIP_CALL_NAME_BUFFER
    sta TEXT_STRING_PTR+1
    lda #5
    sta TEXT_Y
    lda #20
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; friend logo
    lda #19
    sta LOGO_X
    lda #0
    sta LOGO_Y

    lda #<SHIP_CALL_NAME_BUFFER
    sta LFSR_NAME_PTR
    lda #>SHIP_CALL_NAME_BUFFER
    sta LFSR_NAME_PTR+1
    jsr LFSR_SEED_FROM_NAME
    jsr LOGO_GENERATE
    jsr LOGO_RENDER

    ; show friend ship (rofl)
    lda #<SHIP_CHARS_1
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_1
    sta TEXT_STRING_PTR+1
    lda #8
    sta TEXT_Y
    lda #23
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING
    lda #<SHIP_CHARS_2
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_2
    sta TEXT_STRING_PTR+1
    lda #9
    sta TEXT_Y
    jsr TEXT_DRAW_STRING
    lda #<SHIP_CHARS_3
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_3
    sta TEXT_STRING_PTR+1
    lda #10
    sta TEXT_Y
    jsr TEXT_DRAW_STRING
    lda #<SHIP_CHARS_4
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_4
    sta TEXT_STRING_PTR+1
    lda #11
    sta TEXT_Y
    jsr TEXT_DRAW_STRING
    lda #<SHIP_CHARS_5
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_5
    sta TEXT_STRING_PTR+1
    lda #12
    sta TEXT_Y
    jsr TEXT_DRAW_STRING
    lda #<SHIP_CHARS_6
    sta TEXT_STRING_PTR
    lda #>SHIP_CHARS_6
    sta TEXT_STRING_PTR+1
    lda #13
    sta TEXT_Y
    jsr TEXT_DRAW_STRING


; into...
SHIP_GAME_CALL_LOOP:
    ; c call
    lda #KEY_C_ROW
    sta CIA1_PRA

    lda CIA1_PRB
    and #KEY_C_COL  ; check pressed
    bne +           ; not pressed info
-
    lda CIA1_PRB
    and #KEY_C_COL  ; check released
    beq -
    ; reset music
    ; seed from name
    lda #<SCREEN_SYSTEM_NAME_BUFFER
    sta LFSR_NAME_PTR
    lda #>SCREEN_SYSTEM_NAME_BUFFER
    sta LFSR_NAME_PTR+1
    jsr LFSR_SEED_FROM_NAME
    jsr music_init

    jmp DIPLOMAT_SHOW
+
    jmp SHIP_GAME_CALL_LOOP


