DIPLOMAT_SHOW:
    ; clear bg
    ldx #0
-
    lda #$20                    ; space
    sta SCREEN_RAM_250_0, x
    inx
    cpx #250
    bne -

    ldx #0
-
    lda #$20                    ; space
    sta SCREEN_RAM_250_1, x
    inx
    cpx #250
    bne -

    ldx #0
-
    lda #$20                    ; space
    sta SCREEN_RAM_250_2, x
    inx
    cpx #100
    bne -

    ; invert D in top right
    lda #0 
    sta TEXT_Y
    lda #39
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    lda #132                ; invert D
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR

    ; bg from system bg
    lda SCREEN_SYSTEM_COLOR_TEXT_BG
    sta SCREEN_SYSTEM_SPACE_BG

    ; show diplomat label
    lda #<DIPLOMAT_DIPLOMAT_LABEL
    sta TEXT_STRING_PTR
    lda #>DIPLOMAT_DIPLOMAT_LABEL
    sta TEXT_STRING_PTR+1
    lda #1
    sta TEXT_Y
    lda #2
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; show diplomat name
    lda #<DIPLOMAT_BUFFER
    sta TEXT_STRING_PTR
    lda #>DIPLOMAT_BUFFER
    sta TEXT_STRING_PTR+1
    lda #1
    sta TEXT_Y
    lda #20
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; show diplomat logo
    jsr DIPLOMAT_COPY_TO_LOGO
    lda #15
    sta LOGO_X
    lda #0
    sta LOGO_Y
    jsr LOGO_RENDER

    ; show passenger label
    lda #<DIPLOMAT_PASSENGER_LABEL
    sta TEXT_STRING_PTR
    lda #>DIPLOMAT_PASSENGER_LABEL
    sta TEXT_STRING_PTR+1
    lda #4
    sta TEXT_Y
    lda #20
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING


    lda SHIP_HAS_PASSENGER
    bne +++

    lda DIPLOMAT_HAS_PASSENGER
    beq +
    jsr DIPLOMAT_SHOW_PASSENGER
    jmp ++
+
    ; show empty passenger cabin
    lda #<DIPLOMAT_NONE_LABEL
    sta TEXT_STRING_PTR
    lda #>DIPLOMAT_NONE_LABEL
    sta TEXT_STRING_PTR+1
    lda #7
    sta TEXT_Y
    lda #22
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING
    jmp ++
+++
    ; show empty passenger cabin
    lda #<DIPLOMAT_FULL_LABEL
    sta TEXT_STRING_PTR
    lda #>DIPLOMAT_FULL_LABEL
    sta TEXT_STRING_PTR+1
    lda #7
    sta TEXT_Y
    lda #22
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING
++
    ; show comms label
    lda #<DIPLOMAT_COMMS_LABEL
    sta TEXT_STRING_PTR
    lda #>DIPLOMAT_COMMS_LABEL
    sta TEXT_STRING_PTR+1
    lda #4
    sta TEXT_Y
    lda #2
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; show send message label
    lda #<DIPLOMAT_READ_LABEL
    sta TEXT_STRING_PTR
    lda #>DIPLOMAT_READ_LABEL
    sta TEXT_STRING_PTR+1
    lda #7
    sta TEXT_Y
    lda #4
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; show read message label
    lda #<DIPLOMAT_SEND_LABEL
    sta TEXT_STRING_PTR
    lda #>DIPLOMAT_SEND_LABEL
    sta TEXT_STRING_PTR+1
    lda #9
    sta TEXT_Y
    lda #4
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; show call label
    lda #<DIPLOMAT_CALL_LABEL
    sta TEXT_STRING_PTR
    lda #>DIPLOMAT_CALL_LABEL
    sta TEXT_STRING_PTR+1
    lda #11
    sta TEXT_Y
    lda #4
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING
    jmp DIPLOMAT_GAME_LOOP


DIPLOMAT_SHOW_PASSENGER:
    ; load passenger seed
    lda DIPLOMAT_PASSENGER_SEED_W0
    sta LFSR_W0
    lda DIPLOMAT_PASSENGER_SEED_W0+1
    sta LFSR_W0+1
    lda DIPLOMAT_PASSENGER_SEED_W1
    sta LFSR_W1
    lda DIPLOMAT_PASSENGER_SEED_W1+1
    sta LFSR_W1+1
    lda DIPLOMAT_PASSENGER_SEED_W2
    sta LFSR_W2
    lda DIPLOMAT_PASSENGER_SEED_W2+1
    sta LFSR_W2+1

    ; get passenger logo
    jsr LOGO_GENERATE
    lda #36
    sta LOGO_X
    lda #4
    sta LOGO_Y
    jsr LOGO_RENDER

    ; get passenger name
    jsr NAME_GENERATE_PERSON_NAME
    lda #<NAME_BUFFER
    sta ZP_PTR_1
    lda #>NAME_BUFFER
    sta ZP_PTR_1_PAIR
    lda #<DIPLOMAT_PASSENGER_BUFFER
    sta ZP_PTR_2
    lda #>DIPLOMAT_PASSENGER_BUFFER
    sta ZP_PTR_2_PAIR
    jsr SYS_MEM_COPY

    ; show passenger name
    lda #<DIPLOMAT_PASSENGER_BUFFER
    sta TEXT_STRING_PTR
    lda #>DIPLOMAT_PASSENGER_BUFFER
    sta TEXT_STRING_PTR+1
    lda #8
    sta TEXT_Y
    lda #20
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; show passenger dest label
    lda #<DIPLOMAT_DEST_LABEL
    sta TEXT_STRING_PTR
    lda #>DIPLOMAT_DEST_LABEL
    sta TEXT_STRING_PTR+1
    lda #10
    sta TEXT_Y
    lda #20
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    ; get dest system
    jsr NAME_GENERATE_SYSTEM
    lda #<NAME_BUFFER
    sta ZP_PTR_1
    lda #>NAME_BUFFER
    sta ZP_PTR_1_PAIR
    lda #<DIPLOMAT_PASSENGER_DEST_BUFFER
    sta ZP_PTR_2
    lda #>DIPLOMAT_PASSENGER_DEST_BUFFER
    sta ZP_PTR_2_PAIR
    jsr SYS_MEM_COPY

    ; show passenger dest system
    lda #<DIPLOMAT_PASSENGER_DEST_BUFFER
    sta TEXT_STRING_PTR
    lda #>DIPLOMAT_PASSENGER_DEST_BUFFER
    sta TEXT_STRING_PTR+1
    lda #11
    sta TEXT_Y
    lda #20
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    jsr TEXT_DRAW_STRING

    rts 


DIPLOMAT_GAME_LOOP
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
    jmp SCREEN_SYSTEM_RESHOW
+

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
    jmp BB_CALL_SHOW
+

    ; s send message
    lda #KEY_S_ROW
    sta CIA1_PRA

    lda CIA1_PRB
    and #KEY_S_COL  ; check pressed
    bne +           ; not pressed info
-
    lda CIA1_PRB
    and #KEY_S_COL  ; check released
    beq -
    jmp BB_SEND_SHOW
+

    ; r read message
    lda #KEY_R_ROW
    sta CIA1_PRA

    lda CIA1_PRB
    and #KEY_R_COL  ; check pressed
    bne +           ; not pressed info
-
    lda CIA1_PRB
    and #KEY_R_COL  ; check released
    beq -
    jmp BB_READ_SHOW
+

    ; only if passenger
    lda DIPLOMAT_HAS_PASSENGER
    beq ++

    ; only if don't already have one
    lda SHIP_HAS_PASSENGER
    bne ++

    ; p passenger
    lda #KEY_P_ROW
    sta CIA1_PRA

    lda CIA1_PRB
    and #KEY_P_COL  ; check pressed
    bne +           ; not pressed info
-
    lda CIA1_PRB
    and #KEY_P_COL  ; check released
    beq -
    jsr DIPLOMAT_PICK_UP_PASSENGER
    jmp SHIP_SHOW
+
++
    jmp DIPLOMAT_GAME_LOOP


DIPLOMAT_PICK_UP_PASSENGER:
    lda #1
    sta SHIP_HAS_PASSENGER 
    lda #16                ; regular p
    sta DIPLOMAT_PASSENGER_LABEL

    lda DIPLOMAT_PASSENGER_SEED_W0
    sta SHIP_PASSENGER_SEED_W0
    lda DIPLOMAT_PASSENGER_SEED_W0+1
    sta SHIP_PASSENGER_SEED_W0+1
    lda DIPLOMAT_PASSENGER_SEED_W1
    sta SHIP_PASSENGER_SEED_W1
    lda DIPLOMAT_PASSENGER_SEED_W1+1
    sta SHIP_PASSENGER_SEED_W1+1
    lda DIPLOMAT_PASSENGER_SEED_W2
    sta SHIP_PASSENGER_SEED_W2
    lda DIPLOMAT_PASSENGER_SEED_W2+1
    sta SHIP_PASSENGER_SEED_W2+1
    rts 

DIPLOMAT_COPY_FROM_LOGO:
    lda LOGO_TL_CHAR
    sta DIPLOMAT_LOGO_TL_CHAR

    lda LOGO_TR_CHAR
    sta DIPLOMAT_LOGO_TR_CHAR

    lda LOGO_BL_CHAR
    sta DIPLOMAT_LOGO_BL_CHAR

    lda LOGO_BR_CHAR
    sta DIPLOMAT_LOGO_BR_CHAR

    lda LOGO_TL_COL
    sta DIPLOMAT_LOGO_TL_COL

    lda LOGO_TR_COL
    sta DIPLOMAT_LOGO_TR_COL

    lda LOGO_BL_COL
    sta DIPLOMAT_LOGO_BL_COL

    lda LOGO_BR_COL
    sta DIPLOMAT_LOGO_BR_COL

    lda LOGO_BORDER_COLOR
    sta DIPLOMAT_LOGO_BORDER_COLOR

    rts 

DIPLOMAT_COPY_TO_LOGO: 
    lda DIPLOMAT_LOGO_TL_CHAR
    sta LOGO_TL_CHAR

    lda DIPLOMAT_LOGO_TR_CHAR
    sta LOGO_TR_CHAR

    lda DIPLOMAT_LOGO_BL_CHAR
    sta LOGO_BL_CHAR

    lda DIPLOMAT_LOGO_BR_CHAR
    sta LOGO_BR_CHAR

    lda DIPLOMAT_LOGO_TL_COL
    sta LOGO_TL_COL

    lda DIPLOMAT_LOGO_TR_COL
    sta LOGO_TR_COL

    lda DIPLOMAT_LOGO_BL_COL
    sta LOGO_BL_COL

    lda DIPLOMAT_LOGO_BR_COL
    sta LOGO_BR_COL

    lda DIPLOMAT_LOGO_BORDER_COLOR
    sta LOGO_BORDER_COLOR

    rts 
