

SCREEN_OFF
    lda VIC_CR1
    and #%11101111 ; Clear Bit 4 
    sta VIC_CR1
    rts

SCREEN_ON
    lda VIC_CR1
    ora #%00010000 ; Set Bit 4 
    sta VIC_CR1
    rts    

SCREEN_MCM_ON
    lda VIC_CR2
    ora #%00010000 ; Set Bit 4 
    sta VIC_CR2
    rts    

SCREEN_PATCH_3000_FONT:
    lda #<PLANETS_FONT_PATCH_223
    sta ZP_PTR_1
    lda #>PLANETS_FONT_PATCH_223
    sta ZP_PTR_1_PAIR

    lda #<PLANETS_FONT_PATCH_95
    sta ZP_PTR_2
    lda #>PLANETS_FONT_PATCH_95
    sta ZP_PTR_2_PAIR

    lda #8
    sta ZP_PTR_TEMP_0

    jsr SYS_MEM_COPY_NUM

    rts 

SCREEN_CHAR_COPY_ROM_3000_ALL
     sei          ; Disable interrupts to prevent the Kernal 
                  ; from trying to read I/O while we hide it.

     lda $01      ; Save current memory configuration
     pha
     lda #$33     ; Map Character ROM at $D000-$DFFF
     sta $01

    ; --- Setup Pointers in Zero Page ---
    lda #$00
    sta ZP_PTR_1       ; Source Low ($00 of $D000)
    sta ZP_PTR_2       ; Destination Low ($00 of $3000)
    
    lda #$d0      ; Source High ($D0 of $D000)
    sta ZP_PTR_1_PAIR
    lda #$30      ; Destination High ($30 of $3000)
    sta ZP_PTR_2_PAIR

    ; copy all, can overwrite later with UDG
    ldx #$08      ; copy all 256 chars: 8 bytes per char = 2048 bytes = 8x256 pages
    ldy #$00      ; Clear Y index
    
rom_loop:
    lda (ZP_PTR_1),y   ; Grab byte from ROM
    sta (ZP_PTR_2),y   ; Write byte to RAM
    iny           ; Next byte
    bne rom_loop ; Loop until Y wraps to 0 (256 bytes)
    
    inc ZP_PTR_1_PAIR       ; Move source to next page
    inc ZP_PTR_2_PAIR       ; Move destination to next page
    dex           ; Decrease page count
    bne rom_loop ; Repeat for all 8 pages

     ; --- Restore Memory Map ---
     pla
     sta $01
     cli          ; Re-enable interrupts

     jsr SCREEN_CHAR_SET_3000
     rts

SCREEN_CHAR_COPY_ROM_3000_FROM_64
     sei          ; Disable interrupts to prevent the Kernel 
                  ; from trying to read I/O while we hide it.

     lda $01      ; Save current memory configuration
     pha
     lda #$33     ; Map Character ROM at $D000-$DFFF
     sta $01

    ; --- Setup Pointers in Zero Page ---
    ; 64*8=512/$200
    lda #0
    sta ZP_PTR_1       ; Source Low ($00 of $D200)
    sta ZP_PTR_2       ; Destination Low ($00 of $3200)
    
    lda #$d2      ; Source High ($D2 of $D200)
    sta ZP_PTR_1_PAIR
    lda #$32      ; Destination High ($32 of $3200)
    sta ZP_PTR_2_PAIR

    ; leave first 64 free
    ldx #$06      ; copy 192 chars: 8 bytes per char = 1536 bytes = 6x256 pages
    ldy #$00      ; Clear Y index
    
rom_loop_64:
    lda (ZP_PTR_1),y   ; Grab byte from ROM
    sta (ZP_PTR_2),y   ; Write byte to RAM
    iny           ; Next byte
    bne rom_loop_64 ; Loop until Y wraps to 0 (256 bytes)
    
    inc ZP_PTR_1_PAIR       ; Move source to next page
    inc ZP_PTR_2_PAIR       ; Move destination to next page
    dex           ; Decrease page count
    bne rom_loop_64 ; Repeat for all 8 pages

     ; --- Restore Memory Map ---
     pla
     sta $01
     cli          ; Re-enable interrupts

     jsr SCREEN_CHAR_SET_3000
     rts
