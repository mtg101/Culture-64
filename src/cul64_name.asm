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
    lda 'q'
    sta NAME_BUFFER, x
    inx
    cpx #BB_MAX_CHARS
    beq +
    jmp .name_gen_len_loop
+   rts 

NAME_GEN_MAX_LEN
    ; TODO choose 1-NAME_LEN based on seed
    lda NAME_LEN
    sta NAME_LEN
    jsr NAME_GEN_LEN
    rts

NAME_BUFFER
    !fill BB_MAX_CHARS+1, 0
NAME_THE_ONE_STRING     ; 128 pairs of chars
    !scr "a i u e o n kakikukekokysasisusesosytasitutetotynaninunenonyhahihuhehohymamimumemomyyayiyuyeyoy "
    !scr "rarirurerorywawiwuwewowygagigugegogyzazizuzezozydadidudedodybabibubebobypapipupepopyjajijujejojykakikukekokya "
    !scr "i u e o n tasitutetotynaninunenony/ ' - . : + "
    !byte 73, $20, 75, $20
NAME_LEN
    !byte 0



