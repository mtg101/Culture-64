; moves from current seed to next
; you use that next seed for some procgen, then next seed again
LFSR_NEXT_SEED
    ; w0 = w0 + w1
    clc
    lda LFSR_W0         ; load low
    adc LFSR_W1         ; add low
    sta LFSR_W0         ; store low
    lda LFSR_W0+1       ; load high
    adc LFSR_W1+1       ; add high with carry
    sta LFSR_W0+1       ; store high

    ; w1 = w1 + w2
    clc
    lda LFSR_W1         ; load low
    adc LFSR_W2         ; add low
    sta LFSR_W1         ; store low
    lda LFSR_W1+1       ; load high
    adc LFSR_W2+1       ; add high with carry
    sta LFSR_W1+1       ; store high

    ; w2 = w0 + w2
    clc
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
    rts

LFSR_RESET
    lda #187
    sta LFSR_W0
    lda #0
    sta LFSR_W0+1

    lda #23
    sta LFSR_W1
    lda #0
    sta LFSR_W1+1

    lda #42
    sta LFSR_W2
    lda #0
    sta LFSR_W2+1

    rts

; the 48bit seed 
LFSR_W0
    !word 42
LFSR_W1
    !word 68
LFSR_W2
    !word 7000
