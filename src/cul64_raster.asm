!macro ACK_IRQ {
    asl VIC_INTER
}

!macro SET_IRQ .irq_name {
    lda #<.irq_name         ; Low byte
    sta SELF_INT_PTR_LOW    
    lda #>.irq_name         ; High byte
    sta SELF_INT_PTR_HI     
}

; only up to 255... !TODO
!macro RASTER_INTERRUPT_SET_ROW .row {
    lda #.row
    sta RASTER_LINE      
    lda VIC_CR1 
    and #$7f        ; Ensure the 8th bit of the raster line is 0 (for lines < 256)
    sta VIC_CR1
}

!macro PUSH_ALL {
    pha         ; Push Accumulator to stack
    txa         ; Transfer X to Accumulator...
    pha         ; ...then push it
    tya         ; Transfer Y to Accumulator...
    pha         ; ...then push it
}

!macro PULL_ALL {
    pla         ; Pull Y from stack into Accumulator
    tay         ; Transfer it back to Y
    pla         ; Pull X from stack into Accumulator
    tax         ; Transfer it back to X
    pla         ; Pull original Accumulator from stack
}

!macro NOPS .count {
    !if .count > 0 {
        !for .i, 1, .count {
            nop
        }
    }
}

; SEI before called as we're in process of turning off kernel... (and re-anable after)
RASTER_INTERRUPT_SETUP
    ; Disable the CIA "Timer" interrupts (the 60Hz system tick)
    lda #$7F
    sta VIC_ICR_CIA_1       ; Clear CIA 1 interrupt control
    sta VIC_ICR_CIA_2       ; Clear CIA 2 interrupt control
    lda VIC_ICR_CIA_1       ; Acknowledge any pending CIA interrupts
    lda VIC_ICR_CIA_2       ; Acknowledge any pending CIA interrupts

    ; Setup VIC-II to trigger a Raster Interrupt
    lda #$01
    sta VIC_IMASK   ; Enable Raster Interrupts only

    ; Set the line number where the interrupt triggers
    ; default to row 0
    +RASTER_INTERRUPT_SET_ROW 0

    ; Point the Vector to our custom routine
    +SET_IRQ RASTER_IRQ_TOP
    rts             


; --- INTERRUPT ROUTINES ---

RASTER_IRQ_TOP
    +PUSH_ALL

    lda SCREEN_SYSTEM_COLOR_1
    sta BORDER_COL
    lda #BLACK
    sta BG_COL

    +RASTER_INTERRUPT_SET_ROW 50
    +ACK_IRQ
    +SET_IRQ RASTER_IRQ_START_MAIN_SCREEN
    +PULL_ALL
    rti
RASTER_IRQ_START_MAIN_SCREEN
    +PUSH_ALL

    lda #01
    sta RASTER_CHASE_BEAM 

    +RASTER_INTERRUPT_SET_ROW 100
    +ACK_IRQ
    +SET_IRQ RASTER_IRQ_START_BLUE_BOX
    +PULL_ALL
    rti

RASTER_IRQ_START_BLUE_BOX
    +PUSH_ALL

    ; stall for hblank
    +NOPS 12

    lda RASTER_BLUE_BOX_STATUS
    beq +
    ; flip bg to blue
    lda #BLUE
    sta BG_COL
+    
   +RASTER_INTERRUPT_SET_ROW 140
    +ACK_IRQ
    +SET_IRQ RASTER_IRQ_END_BLUE_BOX
    +PULL_ALL
    rti

RASTER_IRQ_END_BLUE_BOX
    +PUSH_ALL

    ; stall for hblank
    +NOPS 15

    lda BG_COL
    beq +
    ; flip bg back to black
    lda #BLACK
    sta BG_COL
+    
    +RASTER_INTERRUPT_SET_ROW 170
    +ACK_IRQ
    +SET_IRQ RASTER_IRQ_START_TEXT_AREA
    +PULL_ALL
    rti

RASTER_IRQ_START_TEXT_AREA
    +PUSH_ALL

    ; stall for hblank
    +NOPS 15

    lda SCREEN_SYSTEM_COLOR_2
    sta BG_COL
    sta BORDER_COL

    +RASTER_INTERRUPT_SET_ROW 173
    +ACK_IRQ
    +SET_IRQ RASTER_IRQ_TEXT_AREA_TOP_BORDER_ON
    +PULL_ALL
    rti

RASTER_IRQ_TEXT_AREA_TOP_BORDER_ON
    +PUSH_ALL

    ; stall for hblank
    +NOPS 15

    lda SCREEN_SYSTEM_COLOR_1
    sta BG_COL
    sta BORDER_COL

    +RASTER_INTERRUPT_SET_ROW 175
    +ACK_IRQ
    +SET_IRQ RASTER_IRQ_TEXT_AREA_TOP_BORDER_OFF
    +PULL_ALL
    rti

RASTER_IRQ_TEXT_AREA_TOP_BORDER_OFF
    +PUSH_ALL

    ; stall for hblank
    +NOPS 15

    lda SCREEN_SYSTEM_COLOR_2
    sta BG_COL
    sta BORDER_COL
+    
    +RASTER_INTERRUPT_SET_ROW 250
    +ACK_IRQ
    +SET_IRQ RASTER_IRQ_END_MAIN_SCREEN
    +PULL_ALL
    rti

RASTER_IRQ_END_MAIN_SCREEN
    +PUSH_ALL

    lda #01
    sta RASTER_BOTTOM_BORDER

    +RASTER_INTERRUPT_SET_ROW 253
    +ACK_IRQ
    +SET_IRQ RASTER_IRQ_TEXT_AREA_BOTTOM_BORDER_ON
    +PULL_ALL
    rti

RASTER_IRQ_TEXT_AREA_BOTTOM_BORDER_ON
    +PUSH_ALL

    ; stall for hblank
    +NOPS 15

    lda SCREEN_SYSTEM_COLOR_1
    sta BG_COL
    sta BORDER_COL

    +RASTER_INTERRUPT_SET_ROW 255
    +ACK_IRQ
    +SET_IRQ RASTER_IRQ_TEXT_AREA_BOTTOM_BORDER_OFF
    +PULL_ALL
    rti

RASTER_IRQ_TEXT_AREA_BOTTOM_BORDER_OFF
    +PUSH_ALL

    ; stall for hblank
    +NOPS 15

    lda SCREEN_SYSTEM_COLOR_2
    sta BG_COL
    sta BORDER_COL
+    
    +RASTER_INTERRUPT_SET_ROW 0
    +ACK_IRQ
    +SET_IRQ RASTER_IRQ_TOP
    +PULL_ALL
    rti

; raster flags go 1 when they're ready for main loop (which will need to clear)
RASTER_CHASE_BEAM
    !byte $00
RASTER_BOTTOM_BORDER
    !byte $00
RASTER_BLUE_BOX_STATUS
    !byte $00

