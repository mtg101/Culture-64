NAME_GENERATE
    jsr LFSR_NEXT_SEED              ; start fresh

    ; TODO style? one long, two med, three small, med-single-med, etc

    ; test with max length 
    lda #BB_MAX_CHARS
    sta NAME_LEN
    jsr NAME_GEN_MAX_LEN

    rts 

NAME_GEN_LEN
    ldx #0
.name_gen_len_loop
    cpx NAME_LEN
    beq .name_gen_len_done

; hacky hack hack
    lda 'q'

    sta NAME_BUFFER, x
    inx
    jmp .name_gen_len_loop
.name_gen_len_done:
   lda #0              ; null terminator
    sta NAME_BUFFER, x
    rts 

NAME_GEN_MAX_LEN        
    dec NAME_LEN        ; make 0 to max-1, eg len is 10, so make 0-9
    lda NAME_LEN
    and LFSR_W0         ; simple and randomly maxes it - cute trick!
    sta NAME_LEN
    inc NAME_LEN        ; and makes it back to 1 to max
    jsr NAME_GEN_LEN
    rts

NAME_BUFFER
    !fill BB_MAX_CHARS+1, 0
NAME_THE_ONE_STRING     ; 128 pairs of chars
    !scr "a i u e o n kakikukekokysasisusesosytasitutetotynaninunenonyhahihuhehohymamimumemomyyayiyuyeyoy "     ; 96
    !scr "rarirurerorywawiwuwewowygagigugegogyzazizuzezozydadidudedodybabibubebobypapipupepopyjajijujejojykakikukekokya "   ; 110
    !scr "i u e o n chstthckprlalelilolytrqu/ ' - . : + "   ; 46
    !byte 73, $20, 75, $20      ; 4
NAME_LEN
    !byte 0



