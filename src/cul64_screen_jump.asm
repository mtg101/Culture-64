
SCREEN_JUMP_SHOW
    ; turn on blue box mode
    lda #1
    sta RASTER_BLUE_BOX_STATUS

    ; where string
    lda #<SCREEN_JUMP_WHERE
    sta TEXT_STRING_PTR
    lda #>SCREEN_JUMP_WHERE
    sta TEXT_STRING_PTR+1

    jsr BB_SHOW_TEXT_ENTRY_BOX

    ; turn off blue box mode
    lda #0
    sta RASTER_BLUE_BOX_STATUS

    ; jump effect
    lda #BLACK
    sta SCREEN_SYSTEM_COLOR_1
    sta SCREEN_SYSTEM_COLOR_2
    sta SCREEN_SYSTEM_COLOR_3
    jsr STARS_FILL_SCREEN
    jsr STARS_FILL_SCREEN
    jsr STARS_FILL_SCREEN
    jsr STARS_FILL_SCREEN

    ; save system name
    ldx #0
.char_loop
    lda BB_TEXT_ENTRY_BUFFER, x
    sta SCREEN_SYSTEM_NAME_BUFFER, x
    inx
    cpx #BB_MAX_CHARS
    bne .char_loop
    
    jmp SCREEN_SYSTEM_SHOW
 

SCREEN_JUMP_WHERE
    !scr "jump to which system?", 0

