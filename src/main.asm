;
; VS64 generated Example was the starting point...
;

*=$0801
!byte $0c,$08,$b5,$07,$9e,$20,$32,$30,$36,$32,$00,$00,$00

    jmp MAIN

; data in memory includes

; all the code (no location specific data) in bank 1 full 16k to use
*=$4000

!source "src/c64_defs.asm"
!source "src/c64_maths.asm"
!source "src/c64_screen.asm"
!source "src/c64_system.asm"
!source "src/cul64_raster.asm"
!source "src/cul64_text.asm"
!source "src/cul64_stars.asm"

!source "src/cul64_screen_title.asm"
!source "src/cul64_screen_jump.asm"


MAIN
    jsr SCREEN_OFF
    jsr ROM_CLR_SCREEN
    jsr SCREEN_MCM_ON
    jsr MATHS_SETUP_RNG
    jsr SCREEN_CHAR_COPY_ROM_3000_ALL

    jmp SYS_NO_BASIC_NO_KERNEL_ROM  ; also does raster irq setup - jmp as it's reclaiming the stack
SYS_NO_BASIC_NO_KERNEL_ROM_DONE    
    jsr SCREEN_ON

    jsr SCREEN_TITLE_SHOW


MAIN_LOOP
    ; is bottom border?
    lda RASTER_BOTTOM_BORDER
    beq MAIN_LOOP                   ; not time yet...

    ; clear raster flag
    lda #$00
    sta RASTER_BOTTOM_BORDER
    jmp MAIN_LOOP

; --- End of code section ---

!ifndef PASS1 {
;    !warn "Pass 1"
    PASS1 = 1
} else {
    !ifndef PASS2 {
;        !warn "Pass 2"
        PASS2 = 1
    } else {
        !ifndef PASS3 {
;            !warn "Pass 3"
            !warn "Code size is ", *-$4000, " of max 16383 (0x3fff) (ending at ", *, " of max 32767 (0x7fff))"
            !if * > $7FFF {
                !error "Code has hit the bank 1 boundary!"
            }
            PASS3 = 1
        }
    }
}


