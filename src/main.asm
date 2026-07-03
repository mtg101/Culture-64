;
; VS64 generated Example was the starting point...
;

*=$0801
!byte $0c,$08,$b5,$07,$9e,$20,$32,$30,$36,$32,$00,$00,$00

    jmp MAIN


; just defs no memory used
!source "src/c64_defs.asm"



; data in bank 2 full 16k (only rom charset and vic is pointing to bank 1)
*=MEM_BANK_3

!zone Data                                  ; for compiler warning / errors

!source "src/c64_screen_data.asm"
!source "src/c64_system_data.asm"
!source "src/cul64_blue_box_data.asm"
!source "src/cul64_diplomat_data.asm"
!source "src/cul64_lfsr_data.asm"
!source "src/cul64_logo_data.asm"
!source "src/cul64_message_data.asm"
!source "src/cul64_name_data.asm"
!source "src/cul64_nebula_clouds_data.asm"
!source "src/cul64_orbits_data.asm"
!source "src/cul64_planets_data.asm"
!source "src/cul64_raster_data.asm"
!source "src/cul64_screen_system_data.asm"
!source "src/cul64_screen_title_data.asm"
!source "src/cul64_ship_data.asm"
!source "src/cul64_stars_data.asm"
!source "src/cul64_sun_data.asm"
!source "src/cul64_text_data.asm"
!source "src/cul64_theme_music_data.asm"

; --- End of code section ---
!ifndef DATA_PASS1 {
    DATA_PASS1 = 1
} else {
    !ifndef DATA_PASS2 {
        DATA_PASS2 = 1
    } else {
        !ifndef DATA_PASS3 {
            !warn "Data size is ", *-MEM_BANK_3, " of max 16383 (0x3fff) (ending at ", *, " of max 49151 (0xbfff)) -- leaving ", 0x3fff-(*-MEM_BANK_3) 
            !if * > $bFFF {
                !error "Code has hit the bank 1 boundary!"
            }
            DATA_PASS3 = 1
        }
    }
}


; code in bank 1 full 16k to use
*=MEM_BANK_2

!zone Code                                  ; for compiler warning / errors

!source "src/c64_screen.asm"
!source "src/c64_system.asm"
!source "src/cul64_blue_box.asm"
!source "src/cul64_diplomat.asm"
!source "src/cul64_lfsr.asm"
!source "src/cul64_logo.asm"
!source "src/cul64_message.asm"
!source "src/cul64_name.asm"
!source "src/cul64_nebula_clouds.asm"
!source "src/cul64_orbits.asm"
!source "src/cul64_planets.asm"
!source "src/cul64_raster.asm"
!source "src/cul64_screen_system.asm"
!source "src/cul64_screen_title.asm"
!source "src/cul64_ship.asm"
!source "src/cul64_stars.asm"
!source "src/cul64_sun.asm"
!source "src/cul64_text.asm"
!source "src/cul64_theme_music.asm"


MAIN
    jsr SCREEN_OFF
    jsr ROM_CLR_SCREEN
    jsr SCREEN_MCM_ON
    jsr SCREEN_CHAR_COPY_ROM_3000_FROM_64
    jsr SCREEN_PATCH_3000_FONT
    jsr CLOUDS_PATCH_FONT
    jsr PLANETS_JUMP_GATE_PATCH_FONT
    jsr PLANETS_STATION_PATCH_FONT

    jmp SYS_NO_BASIC_NO_KERNEL_ROM  ; also does raster irq setup - jmp as it's reclaiming the stack
SYS_NO_BASIC_NO_KERNEL_ROM_DONE    
    jsr SCREEN_ON
    jmp SCREEN_TITLE_SHOW
; screens have their own game loops

; --- End of code section ---
!ifndef CODE_PASS1 {
    CODE_PASS1 = 1
} else {
    !ifndef CODE_PASS2 {
        CODE_PASS2 = 1
    } else {
        !ifndef CODE_PASS3 {
            !warn "Code size is ", *-MEM_BANK_2, " of max 16383 (0x3fff) (ending at ", *, " of max 32767 (0x7fff)) -- leaving ", 0x3fff-(*-MEM_BANK_2) 
            !if * > $7FFF {
                !error "Code has hit the bank 1 boundary!"
            }
            CODE_PASS3 = 1
        }
    }
}

; sources with fixed memory locations
!zone Font                                  ; for compiler warning / errors
!source "src/cul64_font.asm"
