
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
    jmp SCREEN_SYSTEM_SHOW
 

SCREEN_JUMP_WHERE
    !scr "jump to which system?", 0

