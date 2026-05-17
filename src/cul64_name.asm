NAME_GENERATE
    jsr LFSR_NEXT_SEED              ; start fresh

    ; TODO style? one long, two med, three small, med-single-med, etc

    ; test with max length 
    lda #BB_MAX_CHARS/2         ; specifies number of pairs, max 8
    sta NAME_LEN
    jsr NAME_GEN_MAX_LEN

    rts 

; generates NAME_LEN pairs
NAME_GEN_LEN
    ldy #0                      ; loop counter
    ldx #0                      ; name buf index

.name_gen_len_loop
    cpy NAME_LEN
    beq .name_gen_len_done

    tya
    pha                         ; save loop counter

    ; first char of pair
    lda LFSR_W0
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
    jsr LFSR_NEXT_SEED          ; wasteful as we only used w0 but easy...
    jmp .name_gen_len_loop

.name_gen_len_done:
   lda #0              ; null terminator
    sta NAME_BUFFER, x
    rts 

; max num of pairs
NAME_GEN_MAX_LEN        
    dec NAME_LEN        ; make 0 to max-1, eg len is 6, so make 0-5
    lda NAME_LEN
    and LFSR_W0         ; simple and randomly maxes it - cute trick!
    sta NAME_LEN
    inc NAME_LEN        ; and makes it back to 1 to max
    jsr NAME_GEN_LEN
    rts

NAME_BUFFER
    !fill BB_MAX_CHARS+1, 0
NAME_LEN
    !byte 0

NAME_THE_ONE_STRING     ; 128 pairs of chars
    !scr "a i u e o n kakikukekokysasisusesosytasitutetotynaninunenonyhahihuhehohymamimumemomyyayiyuyeyoy "     ; 96
    !scr "rarirurerorywawiwuwewowygagigugegogyzazizuzezozydadidudedodybabibubebobypapipupepopyjajijujejojykakikukekokya "   ; 110
    !scr "qucldrbrtrchstthfafifofulaleliloly/ ' - . : + "   ; 46
    !byte 73, $20, 75, $20      ; 4



