





; draws string to screen based on variables
TEXT_DRAW_STRING
    ; y is row
    ldy TEXT_Y 

    ; char ptr row
    lda SCREEN_ROW_LOW, y
    sta TEXT_SCR_PTR
    lda SCREEN_ROW_HIGH, y
    sta TEXT_SCR_PTR+1

    ; col ptr row
    lda SCREEN_COL_LOW, y
    sta TEXT_COL_PTR
    lda SCREEN_COL_HIGH, y
    sta TEXT_COL_PTR+1

    ; add col to screen
    lda TEXT_SCR_PTR
    clc
    adc TEXT_X 
    sta TEXT_SCR_PTR

    bcc +                       ; no carry
    inc TEXT_SCR_PTR+1          ; carry so add one to high
+

    ; add col to colour
    lda TEXT_COL_PTR
    clc
    adc TEXT_X 
    sta TEXT_COL_PTR

    bcc +                       ; no carry
    inc TEXT_COL_PTR+1          ; carry so add one to high
+
    ; zero page string
    lda TEXT_STRING_PTR
    sta ZP_PTR_TEMP_0
    lda TEXT_STRING_PTR+1
    sta ZP_PTR_TEMP_0_PAIR

    ; zero page screen
    lda TEXT_SCR_PTR
    sta ZP_PTR_1
    lda TEXT_SCR_PTR+1
    sta ZP_PTR_1_PAIR

    ; zero page colour
    lda TEXT_COL_PTR
    sta ZP_PTR_2
    lda TEXT_COL_PTR+1
    sta ZP_PTR_2_PAIR

    ; y is offset
    ldy #0

.string_loop
    ; load next char
    lda (ZP_PTR_TEMP_0), y

    ; check for null terminator
    beq .string_done

    ; draw char
    sta (ZP_PTR_1), y

    ; set col
    lda TEXT_COLOUR
    sta (ZP_PTR_2), y

    ; next char
    iny

    jmp .string_loop


.string_done
    rts

; sets TEXT_X to centre the string at TEXT_STRING_PTR
TEXT_CENTRE_STRING
    ; how long is string?

    ; zero page string
    lda TEXT_STRING_PTR
    sta ZP_PTR_TEMP_0
    lda TEXT_STRING_PTR+1
    sta ZP_PTR_TEMP_0_PAIR

    ; y is offset
    ldy #0

.len_loop
    ; load next char
    lda (ZP_PTR_TEMP_0), y    
    ; check for null terminator
    beq .len_done

    iny
    jmp .len_loop

.len_done
    sty TEXT_STRING_LEN
    
    ; 40 screen width - string length
    lda #40
    sec
    sbc TEXT_STRING_LEN

    ; divide by 2 to centre
    lsr

    ; save
    sta TEXT_X
    rts





; variables

TEXT_X
    !byte 0

TEXT_Y
    !byte 0

TEXT_COLOUR
    !byte 0

TEXT_STRING_PTR
    !word 0

TEXT_SCR_PTR
    !word 0

TEXT_COL_PTR
    !word 0
TEXT_STRING_LEN
    !byte 0
