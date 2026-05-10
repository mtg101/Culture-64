




SCREEN_JUMP_SHOW
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

    jsr TEXT_WAIT_FOR_ENTER
    jmp SCREEN_SYSTEM_SHOW
 

SCREEN_JUMP_TITLE
    !scr "culture 64", 0

SCREEN_JUMP_WHERE
    !scr "jump to which system?", 0

