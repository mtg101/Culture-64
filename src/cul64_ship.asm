SHIP_SHOW:
    ; clear sHIP jUMP iNFO
    lda #0 
    sta TEXT_Y
    lda #26
    sta TEXT_X
    lda #<SCREEN_SYSTEM_KEYS_LABEL_BLANK
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_KEYS_LABEL_BLANK
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    ; invert I in top right
    lda #0 
    sta TEXT_Y
    lda #39
    sta TEXT_X
    lda #CYAN
    sta TEXT_COLOR
    lda #147                ; invert I
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR

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
    jmp SCREEN_SYSTEM_SHOW
+
    jmp SHIP_GAME_LOOP

SHIP_HIDE:  
    jsr SCREEN_SYSTEM_SHOW
    rts


