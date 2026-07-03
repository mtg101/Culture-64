MESSAGE_SHOW_SEND:
    ; save text colors
    lda SCREEN_SYSTEM_COLOR_TOP_SPACE_BORDER
    sta MESSAGE_SYSTEM_COLOR_TOP_SPACE_BORDER
    lda SCREEN_SYSTEM_COLOR_TEXT_BG
    sta MESSAGE_SYSTEM_COLOR_TEXT_BG
    lda SCREEN_SYSTEM_COLOR_TEXT_BORDER
    sta MESSAGE_SYSTEM_COLOR_TEXT_BORDER

    jsr MESSAGE_SHOW_SCREEN
    jsr MESSAGE_SHOW_INPUT_SCREEN

    ; send mode
    lda #1
    sta MESSAGE_SEND_MODE

    ; text yellow
    lda #YELLOW
    sta TEXT_COLOR

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

    ; show TO:
    lda #<MESSAGE_TO_LABEL
    sta TEXT_STRING_PTR
    lda #>MESSAGE_TO_LABEL
    sta TEXT_STRING_PTR+1
    lda #1
    sta TEXT_Y
    lda #1
    sta TEXT_X
    jsr TEXT_DRAW_STRING

    ; show name from SHIP_CALL_NAME_BUFFER
    lda #<SHIP_CALL_NAME_BUFFER
    sta TEXT_STRING_PTR
    lda #>SHIP_CALL_NAME_BUFFER
    sta TEXT_STRING_PTR+1
    lda #1
    sta TEXT_Y
    lda #5
    sta TEXT_X
    jsr TEXT_DRAW_STRING

    jmp MESSAGE_GAME_LOOP

MESSAGE_SHOW_READ:
    ; save text colors
    lda SCREEN_SYSTEM_COLOR_TOP_SPACE_BORDER
    sta MESSAGE_SYSTEM_COLOR_TOP_SPACE_BORDER
    lda SCREEN_SYSTEM_COLOR_TEXT_BG
    sta MESSAGE_SYSTEM_COLOR_TEXT_BG
    lda SCREEN_SYSTEM_COLOR_TEXT_BORDER
    sta MESSAGE_SYSTEM_COLOR_TEXT_BORDER

    jsr MESSAGE_SHOW_SCREEN

    ; read mode
    lda #0
    sta MESSAGE_SEND_MODE

    ; text yellow
    lda #YELLOW
    sta TEXT_COLOR

    ; invert R in top right
    lda #0 
    sta TEXT_Y
    lda #39
    sta TEXT_X
    lda #WHITE
    sta TEXT_COLOR
    lda #146                ; invert R
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR

    ; show message:
    lda #<MESSAGE_MESSAGE_LABEL
    sta TEXT_STRING_PTR
    lda #>MESSAGE_MESSAGE_LABEL
    sta TEXT_STRING_PTR+1
    lda #1
    sta TEXT_Y
    lda #1
    sta TEXT_X
    jsr TEXT_DRAW_STRING

    jmp MESSAGE_GAME_LOOP

MESSAGE_SHOW_SCREEN:
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

    ; message bg blue
    lda #BLUE
    sta SCREEN_SYSTEM_SPACE_BG

    lda #DK_GRAY
    sta SCREEN_SYSTEM_COLOR_TOP_SPACE_BORDER

    ; show bb-style border
    lda #YELLOW
    sta TEXT_COLOR

    ; top row border
    ldx #0
-
    lda #119 ; high hoz bar
    sta MESSAGE_SHOW_TOP, x
    lda #YELLOW
    sta MESSAGE_SHOW_TOP_COL, x
    inx
    cpx #40
    bne -
    ; top left
    lda #79
    sta MESSAGE_SHOW_TOP
    ; top right
    lda #80
    sta MESSAGE_SHOW_TOP+39

    ; left col border
    lda #0
    sta TEXT_X
    lda #1
    sta TEXT_Y

    ; string ptr
    lda #<MESSAGE_LEFT_BORDER
    sta TEXT_STRING_PTR
    lda #>MESSAGE_LEFT_BORDER
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING_VERT

    ; right col border
    ; left col border
    lda #39
    sta TEXT_X

    ; string ptr
    lda #<MESSAGE_RIGHT_BORDER
    sta TEXT_STRING_PTR
    lda #>MESSAGE_RIGHT_BORDER
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING_VERT

    rts

MESSAGE_SHOW_INPUT_SCREEN:
    ldx #100
-
    lda #$20                    ; space
    sta SCREEN_RAM_250_2, x
    inx
    cpx #250
    bne -

    ldx #0
-
    lda #$20                    ; space
    sta SCREEN_RAM_250_3, x
    inx
    cpx #250
    bne -

    lda #LT_BLUE
    sta SCREEN_SYSTEM_COLOR_TEXT_BG
    lda #ORANGE
    sta SCREEN_SYSTEM_COLOR_TEXT_BORDER

    rts 


MESSAGE_GAME_LOOP
    lda MESSAGE_SEND_MODE
    beq .message_read_keys
    ; send mode
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
    jmp MESSAGE_RETURN_TO_DIPLOMAT
+
    jmp ++
.message_read_keys:    
    ; read mode1
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
    jmp MESSAGE_RETURN_TO_DIPLOMAT
+
++
    jmp MESSAGE_GAME_LOOP

MESSAGE_RETURN_TO_DIPLOMAT:
    ; restore text colors
    lda MESSAGE_SYSTEM_COLOR_TOP_SPACE_BORDER
    sta SCREEN_SYSTEM_COLOR_TOP_SPACE_BORDER
    lda MESSAGE_SYSTEM_COLOR_TEXT_BG
    sta SCREEN_SYSTEM_COLOR_TEXT_BG
    lda MESSAGE_SYSTEM_COLOR_TEXT_BORDER
    sta SCREEN_SYSTEM_COLOR_TEXT_BORDER

    jsr SYSTEM_SHOW_LABELS
    jsr SYSTEM_SHOW_VALUES

    jmp DIPLOMAT_SHOW


