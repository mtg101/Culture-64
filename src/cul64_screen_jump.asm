




SCREEN_JUMP_SHOW
    ; black bg
    lda #BLACK
    sta BG_COL

    ; black border
    lda #BLACK
    sta BORDER_COL

    ; stars
    jsr STARS_FILL_SCREEN

    ; title string
    lda #<SCREEN_JUMP_TITLE
    sta TEXT_STRING_PTR
    lda #>SCREEN_JUMP_TITLE
    sta TEXT_STRING_PTR+1

    lda #0
    sta TEXT_X
    lda #0
    sta TEXT_Y

    lda #WHITE
    sta TEXT_COLOUR

    jsr TEXT_DRAW_STRING


    ; where string
    lda #<SCREEN_JUMP_WHERE
    sta TEXT_STRING_PTR
    lda #>SCREEN_JUMP_WHERE
    sta TEXT_STRING_PTR+1

    jsr TEXT_CENTRE_STRING

    lda #13
    sta TEXT_Y

    lda #WHITE
    sta TEXT_COLOUR

    jsr TEXT_DRAW_STRING

 
    rts



SCREEN_JUMP_TITLE
    !scr "culture 64", 0

SCREEN_JUMP_WHERE
    !scr "jump to which system?", 0

