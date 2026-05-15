; moves from current seed to next
; you use that next seed for some procgen, then next seed again
LFSR_NEXT_SEED
    ; w0 = w0 + w1
    clc                 ; clear carry so we start clean
    lda LFSR_W0         ; load low
    adc LFSR_W1         ; add low
    sta LFSR_W0         ; store low
    lda LFSR_W0+1       ; load high
    adc LFSR_W1+1       ; add high with carry
    sta LFSR_W0+1       ; store high

    ; w1 = w1 + w2      ; don't clear carry to things propagate properly
    lda LFSR_W1         ; load low
    adc LFSR_W2         ; add low
    sta LFSR_W1         ; store low
    lda LFSR_W1+1       ; load high
    adc LFSR_W2+1       ; add high with carry
    sta LFSR_W1+1       ; store high

    ; w2 = w0 + w2      ; don't clear carry to things propagate properly
    lda LFSR_W0         ; load low
    adc LFSR_W2         ; add low
    sta LFSR_W2         ; store low
    lda LFSR_W0+1       ; load high
    adc LFSR_W2+1       ; add high with carry
    sta LFSR_W2+1       ; store high

    rts

; name is pointed to by ZP_PTR_1, null terminated
LFSR_SEED_FROM_NAME
    jsr LFSR_RESET

    ; zero page string
    lda LFSR_NAME_PTR
    sta ZP_PTR_TEMP_0
    lda LFSR_NAME_PTR+1
    sta ZP_PTR_TEMP_0_PAIR

    ldy #0                      ; y is zp offset
    clc                         ; always start from same position

.seed_name_loop:
    lda (ZP_PTR_TEMP_0), y      ; load next char
    beq .seed_name_loop_done    ; check for null terminator

    ; the fuckery - just mess about with 3/6 bytes...
    tax
    adc LFSR_W0
    sta LFSR_W0
    txa
    sbc LFSR_W1
    sta LFSR_W1
    txa
    adc LFSR_W2
    sta LFSR_W2
    
    ; advance seed
    jsr LFSR_NEXT_SEED

    iny                         ; next char
    jmp .string_loop


.seed_name_loop_done:
    rts

LFSR_RESET
    lda #LFSR_W0_START
    sta LFSR_W0
    lda #0
    sta LFSR_W0+1

    lda #LFSR_W1_START
    sta LFSR_W1
    lda #0
    sta LFSR_W1+1

    lda #LFSR_W1_START
    sta LFSR_W2
    lda #0
    sta LFSR_W2+1

    rts

; the 48bit seed 
LFSR_W0
    !word LFSR_W0_START
LFSR_W1
    !word LFSR_W1_START
LFSR_W2
    !word LFSR_W2_START

LFSR_W0_START = 42
LFSR_W1_START = 23
LFSR_W2_START = 187

LFSR_NAME_PTR
    !word 0