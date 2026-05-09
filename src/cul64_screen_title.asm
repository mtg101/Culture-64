




SCREEN_TITLE_SHOW
    ; colour
    lda #WHITE
    sta TEXT_COLOUR

    ; string
    lda #<SCREEN_TITLE_TITLE
    sta TEXT_STRING_PTR
    lda #>SCREEN_TITLE_TITLE
    sta TEXT_STRING_PTR+1

    lda #5
    sta TEXT_X
    sta TEXT_Y

    jsr TEXT_DRAW_STRING
    
    rts



SCREEN_TITLE_TITLE
    !scr "culture 64", 0
