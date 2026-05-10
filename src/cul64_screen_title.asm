




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
    sta TEXT_COLOUR

    jsr TEXT_DRAW_STRING


    ; gcu string
    lda #<SCREEN_TITLE_GCU_1
    sta TEXT_STRING_PTR
    lda #>SCREEN_TITLE_GCU_1
    sta TEXT_STRING_PTR+1

    lda #14
    sta TEXT_X
    lda #5
    sta TEXT_Y

    lda #BLUE
    sta TEXT_COLOUR

    jsr TEXT_DRAW_STRING

    ; gcu string
    lda #<SCREEN_TITLE_GCU_2
    sta TEXT_STRING_PTR
    lda #>SCREEN_TITLE_GCU_2
    sta TEXT_STRING_PTR+1

    lda #14
    sta TEXT_X
    lda #6
    sta TEXT_Y

    lda #CYAN
    sta TEXT_COLOUR

    jsr TEXT_DRAW_STRING

    ; gcu string
    lda #<SCREEN_TITLE_GCU_3
    sta TEXT_STRING_PTR
    lda #>SCREEN_TITLE_GCU_3
    sta TEXT_STRING_PTR+1

    lda #14
    sta TEXT_X
    lda #7
    sta TEXT_Y

    lda #PURPLE
    sta TEXT_COLOUR

    jsr TEXT_DRAW_STRING

    ; gcu string
    lda #<SCREEN_TITLE_GCU_4
    sta TEXT_STRING_PTR
    lda #>SCREEN_TITLE_GCU_4
    sta TEXT_STRING_PTR+1

    lda #14
    sta TEXT_X
    lda #8
    sta TEXT_Y

    lda #RED
    sta TEXT_COLOUR

    jsr TEXT_DRAW_STRING

    ; post string
    lda #<SCREEN_TITLE_POST
    sta TEXT_STRING_PTR
    lda #>SCREEN_TITLE_POST
    sta TEXT_STRING_PTR+1

    lda #16
    sta TEXT_X
    lda #19
    sta TEXT_Y

    lda #CYAN
    sta TEXT_COLOUR

    jsr TEXT_DRAW_STRING

    ; dreams string
    lda #<SCREEN_TITLE_DREAMS
    sta TEXT_STRING_PTR
    lda #>SCREEN_TITLE_DREAMS
    sta TEXT_STRING_PTR+1

    lda #3
    sta TEXT_X
    lda #21
    sta TEXT_Y

    lda #YELLOW
    sta TEXT_COLOUR

    jsr TEXT_DRAW_STRING

    ; maths string
    lda #<SCREEN_TITLE_MATHS
    sta TEXT_STRING_PTR
    lda #>SCREEN_TITLE_MATHS
    sta TEXT_STRING_PTR+1

    lda #7
    sta TEXT_X
    lda #24
    sta TEXT_Y

    lda #GREEN
    sta TEXT_COLOUR

    jsr TEXT_DRAW_STRING

    ; prompt string
    lda #<SCREEN_TITLE_PROMPT
    sta TEXT_STRING_PTR
    lda #>SCREEN_TITLE_PROMPT
    sta TEXT_STRING_PTR+1

    jsr TEXT_CENTRE_STRING

    lda #13
    sta TEXT_Y

    lda #WHITE
    sta TEXT_COLOUR

    jsr TEXT_DRAW_STRING

    jsr TEXT_WAIT_FOR_ENTER
    jmp SCREEN_JUMP_SHOW


SCREEN_TITLE_TITLE
    !scr "culture 64", 0

SCREEN_TITLE_GCU_1
    !scr "gcu philips g7000 videopac", 0
SCREEN_TITLE_GCU_2
    !scr "gcu sinclair zx spectrum+", 0
SCREEN_TITLE_GCU_3
    !scr "gcu commodore amiga 500", 0
SCREEN_TITLE_GCU_4
    !scr "gcu viglen 286", 0
SCREEN_TITLE_POST
    !scr "post-scarcity", 0
SCREEN_TITLE_DREAMS
    !scr "procedural dreams", 0
SCREEN_TITLE_MATHS
    !scr "where maths is the database", 0
SCREEN_TITLE_PROMPT
    !scr "> enter system <", 0

