




SCREEN_TITLE_SHOW
    ; black bg
    lda #BLACK
    sta BG_COL

    ; black border
    lda #BLACK
    sta BORDER_COL

    ; stars
    jsr STARS_FILL_SCREEN


    ; title string
    lda #<SCREEN_TITLE_TITLE
    sta TEXT_STRING_PTR
    lda #>SCREEN_TITLE_TITLE
    sta TEXT_STRING_PTR+1

    lda #0
    sta TEXT_X
    lda #0
    sta TEXT_Y

    lda #WHITE
    sta TEXT_COLOR

    jsr TEXT_DRAW_STRING


    ; gcu string
    lda #<SCREEN_TITLE_GCU_1
    sta TEXT_STRING_PTR
    lda #>SCREEN_TITLE_GCU_1
    sta TEXT_STRING_PTR+1

    lda #14
    sta TEXT_X
    lda #21
    sta TEXT_Y

    lda #BLUE
    sta TEXT_COLOR

    jsr TEXT_DRAW_STRING

    ; gcu string
    lda #<SCREEN_TITLE_GCU_2
    sta TEXT_STRING_PTR
    lda #>SCREEN_TITLE_GCU_2
    sta TEXT_STRING_PTR+1

    lda #14
    sta TEXT_X
    lda #22
    sta TEXT_Y

    lda #CYAN
    sta TEXT_COLOR

    jsr TEXT_DRAW_STRING

    ; gcu string
    lda #<SCREEN_TITLE_GCU_3
    sta TEXT_STRING_PTR
    lda #>SCREEN_TITLE_GCU_3
    sta TEXT_STRING_PTR+1

    lda #14
    sta TEXT_X
    lda #23
    sta TEXT_Y

    lda #PURPLE
    sta TEXT_COLOR

    jsr TEXT_DRAW_STRING

    ; gcu string
    lda #<SCREEN_TITLE_GCU_4
    sta TEXT_STRING_PTR
    lda #>SCREEN_TITLE_GCU_4
    sta TEXT_STRING_PTR+1

    lda #14
    sta TEXT_X
    lda #24
    sta TEXT_Y

    lda #RED
    sta TEXT_COLOR

    jsr TEXT_DRAW_STRING

    ; post string
    lda #<SCREEN_TITLE_POST
    sta TEXT_STRING_PTR
    lda #>SCREEN_TITLE_POST
    sta TEXT_STRING_PTR+1

    lda #3
    sta TEXT_X
    lda #14
    sta TEXT_Y

    lda #CYAN
    sta TEXT_COLOR

    jsr TEXT_DRAW_STRING

    ; dreams string
    lda #<SCREEN_TITLE_DREAMS
    sta TEXT_STRING_PTR
    lda #>SCREEN_TITLE_DREAMS
    sta TEXT_STRING_PTR+1

    lda #21
    sta TEXT_X
    lda #16
    sta TEXT_Y

    lda #YELLOW
    sta TEXT_COLOR

    jsr TEXT_DRAW_STRING

    ; maths string
    lda #<SCREEN_TITLE_MATHS
    sta TEXT_STRING_PTR
    lda #>SCREEN_TITLE_MATHS
    sta TEXT_STRING_PTR+1

    lda #7
    sta TEXT_X
    lda #4
    sta TEXT_Y

    lda #GREEN
    sta TEXT_COLOR

    jsr TEXT_DRAW_STRING

    ; prompt string
    lda #<BB_TEXT_RETURN
    sta TEXT_STRING_PTR
    lda #>BB_TEXT_RETURN
    sta TEXT_STRING_PTR+1

    jsr TEXT_CENTER_STRING

    lda #9
    sta TEXT_Y

    lda #WHITE
    sta TEXT_COLOR

    jsr TEXT_DRAW_STRING

    jsr TEXT_WAIT_FOR_ENTER_SPACE
    jmp BB_SHIP_NAME_SHOW


