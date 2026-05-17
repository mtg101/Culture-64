

SYS_NO_BASIC_ROM
    sei         ; Disable interrupts just in case
    lda #ROM_NO_BASIC    
    sta $01     ; BASIC is now gone!

    jsr RASTER_INTERRUPT_SETUP  ; take over irq

    cli         ; Re-enable interrupts
    rts

SYS_NO_BASIC_NO_KERNEL_ROM
    sei         ; Disable interrupts just in case
    lda #ROM_JUST_IO
    sta $01     ; BASIC & kernel both gone

    ; reclaim all of the stack
    ldx #$ff    ; the very top of the stack ($01FF)
    txs         ; set it    
    
    jsr RASTER_INTERRUPT_SETUP  ; take over irq

    cli         ; Re-enable interrupts
    jmp SYS_NO_BASIC_NO_KERNEL_ROM_DONE

; source: ZP_PTR_1 null terminated
; target: ZP_PTR_2
SYS_MEM_COPY
    ldy #0
.sys_mem_cpy_loop
    lda (ZP_PTR_1), y
    sta (ZP_PTR_2), y
    beq +               ; copied null terminator, we are done
    iny 
    jmp .sys_mem_cpy_loop

+    rts
