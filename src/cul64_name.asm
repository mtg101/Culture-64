NAME_GENERATE_DIPLOMAT
    jsr LFSR_NEXT_SEED          ; start fresh

    ; setup zptr
    lda #<NAME_PATTERN_DIPLOMAT_LUT
    sta ZP_PTR_1
    lda #>NAME_PATTERN_DIPLOMAT_LUT
    sta ZP_PTR_1_PAIR

    ; which pattern?
    lda LFSR_W0
    and #%00000111              ; 0-7
    asl                         ; double for word
    tay                         ; into y for zero page indirect

    ; ZP_PTR_TEMP_0 points to pattern
    lda (ZP_PTR_1), y
    sta ZP_PTR_TEMP_1
    iny
    lda (ZP_PTR_1), y
    sta ZP_PTR_TEMP_1_PAIR
    ldy #0                      ; 0 for actual pattern address
    ldx #0                      ; start of name buffer
.name_generate_loop
    lda (ZP_PTR_TEMP_1), y      ; how many pairs?
    beq +                       ; null terminated pattern
    sta NAME_NUM_PAIRS
    jsr NAME_GEN_MAX_LEN        ; this incs x within NAME_BUFFER, and we leave it alone (next will overwrite the null terminator)
                                ; it preserves y on stack for us

    txa
    pha                         ; save x

    lda LFSR_W0+1
    and #%00011111              ; 0-31
    tax
    lda NAME_THE_ONE_PUNCTUATION, x
    sta ZP_PTR_TEMP_0

    pla 
    tax                         ; restore x

    lda ZP_PTR_TEMP_0
    sta NAME_BUFFER, x          ; add punctuation (null terminator added at end)
    inx                         ; move index over space
    iny                         ; next in pattern
    jmp .name_generate_loop
+
    lda #0                      ; null terminator
    dex                         ; move back to punctuation
    sta NAME_BUFFER, x          ; replace punctuation

    rts 

NAME_GENERATE_PLANET
    jsr LFSR_NEXT_SEED          ; start fresh

    ; setup zptr
    lda #<NAME_PATTERN_PLANET_LUT
    sta ZP_PTR_1
    lda #>NAME_PATTERN_PLANET_LUT
    sta ZP_PTR_1_PAIR

    ; which pattern?
    lda LFSR_W0
    and #%00000111              ; 0-7
    asl                         ; double for word
    tay                         ; into y for zero page indirect

    ; ZP_PTR_TEMP_0 points to pattern
    lda (ZP_PTR_1), y
    sta ZP_PTR_TEMP_1
    iny
    lda (ZP_PTR_1), y
    sta ZP_PTR_TEMP_1_PAIR

    ldy #0                      ; 0 for actual pattern address
    ldx #0                      ; start of name buffer
.name_generate_planet_loop
    lda (ZP_PTR_TEMP_1), y      ; how many pairs?
    beq +                       ; null terminated pattern
    sta NAME_NUM_PAIRS
    jsr NAME_GEN_MAX_LEN        ; this incs x within NAME_BUFFER, and we leave it alone (next will overwrite the null terminator)
                                ; it preserves y on stack for us

    txa
    pha                         ; save x

    lda LFSR_W0+1
    and #%00011111              ; 0-31
    tax
    lda NAME_THE_ONE_PUNCTUATION, x
    sta ZP_PTR_TEMP_0

    pla 
    tax                         ; restore x

    lda ZP_PTR_TEMP_0
    sta NAME_BUFFER, x          ; add punctuation (null terminator added at end)
    inx                         ; move index over space
    iny                         ; next in pattern
    jmp .name_generate_planet_loop
+
    lda #0                      ; null terminator
    dex                         ; move back to punctuation
    sta NAME_BUFFER, x          ; replace punctuation

    rts 
; generates NAME_NUM_PAIRS pairs
; x is offset into NAME_BUFFER
; 0 for single long nem, but can split into other types
NAME_GEN_LEN
    tya                         ; save y
    pha
    ldy #0                      ; loop counter

.name_gen_len_loop
    cpy NAME_NUM_PAIRS
    beq .name_gen_len_done

    tya
    pha                         ; save loop counter

    ; first char of pair
    lda LFSR_W2
    and #%01111111              ; 0-127
    asl                         ; shift left, multiple by 2 = 0-254 index
    tay                         
    lda NAME_THE_ONE_STRING, y  ; first char of pair
    sta NAME_BUFFER, x
    inx                         ; inc buf index 
    iny                         ; one string index

    ; second char of pair
    lda NAME_THE_ONE_STRING, y  ; first char of pair
    cmp #$20                    ; check for space
    beq +                       ; skip space
    sta NAME_BUFFER, x          ; second char
    inx                         ; inc buf index 
+
    pla                         ; restore loop counter
    tay
    iny                         ; inc loop counter
    jsr LFSR_NEXT_SEED          ; it's ok we're not in a hurry, just cycle every time after just using w0...
    jmp .name_gen_len_loop

.name_gen_len_done:
    lda #0                      ; null terminator
    sta NAME_BUFFER, x
    pla
    tay                         ; restore y
    rts 

; max num of pairs
NAME_GEN_MAX_LEN        
    dec NAME_NUM_PAIRS          ; make 0 to max-1, eg len is 6, so make 0-5
    lda NAME_NUM_PAIRS
    and LFSR_W1                 ; simple and randomly maxes it - cute trick!
    sta NAME_NUM_PAIRS
    inc NAME_NUM_PAIRS          ; and makes it back to 1 to max
    jsr NAME_GEN_LEN
    rts

NAME_BUFFER
    !fill BB_MAX_CHARS+1, 0
NAME_NUM_PAIRS
    !byte 0

NAME_THE_ONE_STRING     ; 128 pairs of chars
    !scr "a i u e o n kakikukekokysasisusesosytasitutetotynaninunenonyhahihuhehohymamimumemomyyayiyuyeyoy "     ; 96
    !scr "rarirurerorywawiwuwewowygagigugegogyzazizuzezozydadidudedodybabibubebobypapipupepopyjajijujejojykakikukekokya "   ; 110
    !scr "qucldrbrtrchstthfafefifofufylalelilolulya i u e o "   ; 50
NAME_THE_ONE_PUNCTUATION
    !scr "                         /#'-.:+"   ; 32

NAME_PATTERN_DIPLOMAT_10
    !byte 10, 0
NAME_PATTERN_DIPLOMAT_4_5
    !byte 4, 5, 0
NAME_PATTERN_DIPLOMAT_5_4
    !byte 5, 4, 0
NAME_PATTERN_DIPLOMAT_3_3_3
    !byte 3, 3, 3, 0
NAME_PATTERN_DIPLOMAT_2_2_2_2
    !byte 2, 2, 2, 2, 0
NAME_PATTERN_DIPLOMAT_LUT
    !word NAME_PATTERN_DIPLOMAT_10
    !word NAME_PATTERN_DIPLOMAT_4_5
    !word NAME_PATTERN_DIPLOMAT_5_4
    !word NAME_PATTERN_DIPLOMAT_3_3_3
    !word NAME_PATTERN_DIPLOMAT_2_2_2_2
    !word NAME_PATTERN_DIPLOMAT_4_5
    !word NAME_PATTERN_DIPLOMAT_5_4
    !word NAME_PATTERN_DIPLOMAT_3_3_3

NAME_PATTERN_PLANET_7
    !byte 7, 0
NAME_PATTERN_PLANET_3_3
    !byte 3, 3, 0
NAME_PATTERN_PLANET_2_4
    !byte 2, 4, 0
NAME_PATTERN_PLANET_4_2
    !byte 4, 2, 0
NAME_PATTERN_PLANET_2_2_2
    !byte 2, 2, 2, 0
NAME_PATTERN_PLANET_LUT
    !word NAME_PATTERN_PLANET_7
    !word NAME_PATTERN_PLANET_3_3
    !word NAME_PATTERN_PLANET_2_4
    !word NAME_PATTERN_PLANET_4_2
    !word NAME_PATTERN_PLANET_2_2_2
    !word NAME_PATTERN_PLANET_7
    !word NAME_PATTERN_PLANET_3_3
    !word NAME_PATTERN_PLANET_7
