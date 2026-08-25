
SUN_SHOW
    lda SUN_COLOR

    ldx SUN_TYPE
    cpx #5                          ; only for wolf rayet
    bne +
    lda SUN_COLOR_2                 ; use for outer 'arms'
+
    ldx SUN_TYPE
    cpx #6                          ; only for neutron pulsar
    bne +
    lda SUN_COLOR_2                 ; use for outer 'arms'
+

    ; write colors to offscreen
    sta SCREEN_RAM_C00+(40*0)
    sta SCREEN_RAM_C00+(40*0)+1
    sta SCREEN_RAM_C00+(40*1)
    sta SCREEN_RAM_C00+(40*1)+1
    sta SCREEN_RAM_C00+(40*2)
    sta SCREEN_RAM_C00+(40*2)+1
    sta SCREEN_RAM_C00+(40*3)
    sta SCREEN_RAM_C00+(40*3)+1

    ldx SUN_TYPE
    cpx #6                          ; NOT for neutron pulsar
    beq +
    lda SUN_COLOR                   ; back to regular sun
+
    sta SCREEN_RAM_C00+(40*4)
    sta SCREEN_RAM_C00+(40*4)+1
    sta SCREEN_RAM_C00+(40*5)
    sta SCREEN_RAM_C00+(40*5)+1
    sta SCREEN_RAM_C00+(40*6)
    sta SCREEN_RAM_C00+(40*6)+1

    lda SUN_COLOR                   ; always sun colour

    sta SCREEN_RAM_C00+(40*7)
    sta SCREEN_RAM_C00+(40*7)+1

    ldx SUN_TYPE
    cpx #6                          ; only for neutron pulsar
    bne +
    lda SUN_COLOR_2                 ; use for outer 'arms'
+
    sta SCREEN_RAM_C00+(40*8)
    sta SCREEN_RAM_C00+(40*8)+1
    sta SCREEN_RAM_C00+(40*9)
    sta SCREEN_RAM_C00+(40*9)+1

    ldx SUN_TYPE
    cpx #7                          ; only for binary suns
    bne +
    lda SUN_COLOR_2                 ; flip for second sun
+
    sta SCREEN_RAM_C00+(40*10)
    sta SCREEN_RAM_C00+(40*10)+1

    ldx SUN_TYPE
    cpx #5                          ; only for wolf rayet
    bne +
    lda SUN_COLOR_2                 ; use for outer 'arms'
+
    sta SCREEN_RAM_C00+(40*11)
    sta SCREEN_RAM_C00+(40*11)+1
    sta SCREEN_RAM_C00+(40*12)
    sta SCREEN_RAM_C00+(40*12)+1
    sta SCREEN_RAM_C00+(40*13)
    sta SCREEN_RAM_C00+(40*13)+1
    sta SCREEN_RAM_C00+(40*14)
    sta SCREEN_RAM_C00+(40*14)+1

    ; lut
    ldx SUN_TYPE
    lda SUN_TYPE_CHARS_LUT_LOW, x
    sta ZP_PTR_1
    lda SUN_TYPE_CHARS_LUT_HIGH, x
    sta ZP_PTR_1_PAIR

    ldy #0
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*0)
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*0)+1
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*1)
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*1)+1
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*2)
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*2)+1
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*3)
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*3)+1
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*4)
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*4)+1

    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*5)
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*5)+1
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*6)
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*6)+1
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*7)
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*7)+1
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*8)
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*8)+1
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*9)
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*9)+1

    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*10)
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*10)+1
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*11)
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*11)+1
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*12)
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*12)+1
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*13)
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*13)+1
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*14)
    iny
    lda (ZP_PTR_1), y
    sta SCREEN_RAM_800+(40*14)+1

    rts

