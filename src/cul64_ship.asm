SHIP_TOGGLE:
    lda SHIP_STATUS
    beq +
    lda #0
    sta SHIP_STATUS
    jsr SHIP_HIDE
    rts
+
    lda #1
    sta SHIP_STATUS
    jsr SHIP_SHOW
    rts 

SHIP_SHOW:
    rts

SHIP_HIDE:  
    jsr SCREEN_SYSTEM_SHOW
    rts

SHIP_STATUS
    !byte 0

