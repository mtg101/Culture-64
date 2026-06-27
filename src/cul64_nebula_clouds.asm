; Gemini AI used to create UDGs and Sine wave, plus explain the plasma algorithm to me

CLOUDS_PATCH_FONT:
    ; --- Setup Pointers in Zero Page ---
    ; CLOUDS_UDG_BASE 196*8=1568/$620 base $3000
    lda #$20
    sta ZP_PTR_2            ; Destination Low ($20 of $3620)
    lda #$36                ; Destination High ($36 of $3620)
    sta ZP_PTR_2_PAIR

    ldy #0                  ; Clear Y index
    
-
    lda CLOUDS_UDGS,y       ; Grab byte from UDG
    sta (ZP_PTR_2),y        ; Write byte to font
    iny                     ; Next byte
    cpy #32                 ; 4 chars 32 bytes
    bne -
    rts 

; a has x col to draw in
CLOUDS_SHOW_ASTEROID_BELT:
    sta CLOUDS_COLS_START 
    sta CLOUDS_COLS
    inc CLOUDS_COLS             ; inx before cpx

    lda #0
    sta CLOUDS_NEBULA_MODE

    jsr CLOUDS_SHOW
    rts

CLOUDS_SHOW_OORT:
    lda #36
    sta CLOUDS_COLS_START   ; last 4 cols

    lda #40
    sta CLOUDS_COLS

    lda #0
    sta CLOUDS_NEBULA_MODE

    jsr CLOUDS_SHOW
    rts

CLOUDS_SHOW_NEBULA:
    lda #0
    sta CLOUDS_COLS_START   ; start on full left

    lda #40
    sta CLOUDS_COLS

    lda #1
    sta CLOUDS_NEBULA_MODE

    jsr CLOUDS_SHOW
    rts


CLOUDS_SHOW:
    jsr LFSR_NEXT_SEED      ; fresh

    lda CLOUDS_NEBULA_MODE
    beq +
    ; nebula dark colors
    lda LFSR_W0
    and #%00000011          ; 0-3
    tax 
    lda CLOUDS_NEBULA_COLORS_LUT, x 
    jmp ++
+
    ; asteroids & oort any non black
-
    lda LFSR_W0+1
    and #%00000111              ; 0-7
    bne +                       ; not black
    jsr LFSR_NEXT_SEED          ; try next
    jmp -
+
++
    sta TEXT_COLOR
    sta CLOUDS_COLOR

    jsr LFSR_NEXT_SEED      ; fresh
    ; copy to cloud seed (yep - cloud seeding 5g Chinese Bill covid chips GAyTES omg!!eleven)
    lda LFSR_W0
    sta CLOUDS_SEED_W0
    lda LFSR_W0+1
    sta CLOUDS_SEED_W0+1
    lda LFSR_W1
    sta CLOUDS_SEED_W1
    lda LFSR_W1+1
    sta CLOUDS_SEED_W1+1
    lda LFSR_W2
    sta CLOUDS_SEED_W2
    lda LFSR_W2+1
    sta CLOUDS_SEED_W2+1

    ; steps from seed
    lda CLOUDS_SEED_W0
    and #$07                ; Keep only bits 0-2 (values 0-7)
    clc
    adc #$05                ; Step1_X is now strictly between 5 and 12
    sta CLOUDS_STEP_1_X

    lda CLOUDS_SEED_W0+1
    and #$07
    clc
    adc #$06                ; Step2_Y (Vertical frequency)
    sta CLOUDS_STEP_2_Y

    lda CLOUDS_SEED_W1
    and #$07
    clc
    adc #$04                ; Step3_X (Diagonal X shear)
    sta CLOUDS_STEP_3_X

    lda CLOUDS_SEED_W1+1
    and #$07
    clc
    adc #$07                ; Step3_Y (Diagonal Y shear)
    sta CLOUDS_STEP_3_Y

    ; base row values
    lda CLOUDS_SEED_W2
    sta CLOUDS_W2_ROW_BASE
    lda CLOUDS_SEED_W2+1
    sta CLOUDS_W3_ROW_BASE

    ldy #0                      ; y 0-14 rows
.clouds_row_loop:
    sty TEXT_Y

    ; --- Prepare Wave Starters for this line ---
    ; Wave 1 resets to a constant horizontal phase anchor every row
    lda CLOUDS_SEED_W0+1
    sta CLOUDS_W1_INDEX

    ; Wave 2 is flat vertically; its column index is locked to the row base
    lda CLOUDS_W2_ROW_BASE
    sta CLOUDS_W2_INDEX

    ; Wave 3 starts its diagonal run from the current row anchor
    lda CLOUDS_W3_ROW_BASE
    sta CLOUDS_W3_INDEX

    ldx CLOUDS_COLS_START                      ; x CLOUD_COLS_START - CLOUDS_COLS cols
.clouds_col_loop:
    stx TEXT_X

    ; --- WAVE 1: Horizontal Component ---
    ldy CLOUDS_W1_INDEX
    lda CLOUDS_SINE_LUT,y
    sta ZP_PTR_TEMP_0

    ; --- WAVE 2: Vertical Component ---
    ldy CLOUDS_W2_INDEX
    lda CLOUDS_SINE_LUT,y
    clc
    adc ZP_PTR_TEMP_0
    sta ZP_PTR_TEMP_0

    ; --- WAVE 3: Diagonal Component ---
    ldy CLOUDS_W3_INDEX
    lda CLOUDS_SINE_LUT,y
    clc
    adc ZP_PTR_TEMP_0             ; Combined sum (0-240)

    ; --- Scale down to 0-15 ---
    lsr
    lsr
    lsr
    lsr                         ; Accumulator = 0 to 15

    pha                         ; store 0-15
    lda CLOUDS_NEBULA_MODE
    bne .clouds_col_nebula
.clouds_col_oort:
    pla                         ; restore 0-15
    lsr 
    lsr                         ; now 0-3
    clc
    adc #CLOUDS_UDG_BASE         ; add base udg for gradient
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR_OFF
    jmp +

.clouds_col_nebula:
    pla                         ; restore 0-15
    ; only 12-15 show - bt 15 never turns up so...
    sec 
    cmp #11
    bcc +                   ; skip if 0-10
    clc
    adc #CLOUDS_UDG_BASE-11 ; -11 for the offset (assuming 15 not used)
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR_OFF
+

    ; --- ADVANCE 8-BIT INDICES INSTANTLY FOR THE NEXT COLUMN ---
    ; By adding directly to our 8-bit indices, they instantly wrap around
    ; the 256-byte table and change positions drastically every column.
    
    lda CLOUDS_W1_INDEX
    clc
    adc CLOUDS_STEP_1_X             ; Directly jump ahead horizontally
    sta CLOUDS_W1_INDEX

    ; Wave 2 stays completely still across the columns (pure vertical bars)

    lda CLOUDS_W3_INDEX
    clc
    adc CLOUDS_STEP_3_X             ; Jump ahead diagonally
    sta CLOUDS_W3_INDEX


    ; next col
    inx 
    cpx CLOUDS_COLS
    bne .clouds_col_loop

    ; --- END OF ROW: ADVANCE ROW ANCHORS ---
    lda CLOUDS_W2_ROW_BASE
    clc
    adc CLOUDS_STEP_2_Y             ; Shift the vertical bars down
    sta CLOUDS_W2_ROW_BASE

    lda CLOUDS_W3_ROW_BASE
    clc
    adc CLOUDS_STEP_3_Y             ; Shift the diagonal shear down
    sta CLOUDS_W3_ROW_BASE

    ; next row
    ldy TEXT_Y                  ; we used as an index earlier
    iny 
    cpy #CLOUDS_ROWS
    bne .clouds_row_loop_bounce

    rts 

.clouds_row_loop_bounce:
    jmp .clouds_row_loop
