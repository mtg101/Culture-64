; draws to offscreen, including colors
TEXT_DRAW_CHAR_OFF
    lda #1
    sta TEXT_OFFSCREEN
    jsr TEXT_DRAW_CHAR
    lda #0
    sta TEXT_OFFSCREEN
    rts 

; draws TEXT_CHAR to screen based on variables TEXT_X, TEXT_Y, TEXT_COLOR
; copy/pasta TODO don't waste bytes ;)
TEXT_DRAW_CHAR
    ; y is row
    ldy TEXT_Y 

    ; char ptr row
    lda SCREEN_ROW_LOW, y
    sta TEXT_SCR_PTR
    lda SCREEN_ROW_HIGH, y
    sta TEXT_SCR_PTR+1

    ; col ptr row
    lda SCREEN_ROW_LOW, y
    sta TEXT_COL_PTR
    lda SCREEN_COL_HIGH, y
    sta TEXT_COL_PTR+1

    ; fix ptrs for offscreen
    lda TEXT_OFFSCREEN
    beq +                       ; quickly jump if not offscreen
    lda SCREEN_800_ROW_HIGH, y
    sta TEXT_SCR_PTR+1
    lda SCREEN_C00_COL_HIGH, y
    sta TEXT_COL_PTR+1
+

    ; add col to screen
    lda TEXT_SCR_PTR
    clc
    adc TEXT_X 
    sta TEXT_SCR_PTR

    bcc +                       ; no carry
    inc TEXT_SCR_PTR+1          ; carry so add one to high
+

    ; add col to COLOR
    lda TEXT_COL_PTR
    clc
    adc TEXT_X 
    sta TEXT_COL_PTR

    bcc +                       ; no carry
    inc TEXT_COL_PTR+1          ; carry so add one to high
+
    ; zero page screen
    lda TEXT_SCR_PTR
    sta ZP_PTR_1
    lda TEXT_SCR_PTR+1
    sta ZP_PTR_1_PAIR

    ; zero page COLOR
    lda TEXT_COL_PTR
    sta ZP_PTR_2
    lda TEXT_COL_PTR+1
    sta ZP_PTR_2_PAIR

    ldy #0                      ; need an offset...

    ; draw char
    lda TEXT_CHAR
    sta (ZP_PTR_1), y

    ; set col
    lda TEXT_COLOR
    sta (ZP_PTR_2), y

    rts

; draws to offscreen, including colors
TEXT_DRAW_STRING_OFF
    lda #1
    sta TEXT_OFFSCREEN
    jsr TEXT_DRAW_STRING
    lda #0
    sta TEXT_OFFSCREEN
    rts 

; draws string to screen based on variables
TEXT_DRAW_STRING
    ; y is row
    ldy TEXT_Y 

    ; char ptr row
    lda SCREEN_ROW_LOW, y
    sta TEXT_SCR_PTR
    lda SCREEN_ROW_HIGH, y
    sta TEXT_SCR_PTR+1

    ; col ptr row
    lda SCREEN_ROW_LOW, y
    sta TEXT_COL_PTR
    lda SCREEN_COL_HIGH, y
    sta TEXT_COL_PTR+1

    ; fix ptrs for offscreen
    lda TEXT_OFFSCREEN
    beq +                       ; quickly jump if not offscreen
    lda SCREEN_800_ROW_HIGH, y
    sta TEXT_SCR_PTR+1
    lda SCREEN_C00_COL_HIGH, y
    sta TEXT_COL_PTR+1
+

    ; add col to screen
    lda TEXT_SCR_PTR
    clc
    adc TEXT_X 
    sta TEXT_SCR_PTR

    bcc +                       ; no carry
    inc TEXT_SCR_PTR+1          ; carry so add one to high
+

    ; add col to COLOR
    lda TEXT_COL_PTR
    clc
    adc TEXT_X 
    sta TEXT_COL_PTR

    bcc +                       ; no carry
    inc TEXT_COL_PTR+1          ; carry so add one to high
+
    ; zero page string
    lda TEXT_STRING_PTR
    sta ZP_PTR_TEMP_0
    lda TEXT_STRING_PTR+1
    sta ZP_PTR_TEMP_0_PAIR

    ; zero page screen
    lda TEXT_SCR_PTR
    sta ZP_PTR_1
    lda TEXT_SCR_PTR+1
    sta ZP_PTR_1_PAIR

    ; zero page COLOR
    lda TEXT_COL_PTR
    sta ZP_PTR_2
    lda TEXT_COL_PTR+1
    sta ZP_PTR_2_PAIR

    ; y is offset
    ldy #0

.string_loop
    ; load next char
    lda (ZP_PTR_TEMP_0), y

    ; check for null terminator
    beq .string_done

    ; draw char
    sta (ZP_PTR_1), y

    ; set col
    lda TEXT_COLOR
    sta (ZP_PTR_2), y

    ; next char
    iny

    jmp .string_loop


.string_done
    rts

; draws to offscreen, including colors
TEXT_DRAW_STRING_VERT_OFF
    lda #1
    sta TEXT_OFFSCREEN
    jsr TEXT_DRAW_STRING_VERT
    lda #0
    sta TEXT_OFFSCREEN
    rts 

TEXT_DRAW_STRING_VERT:
    ; y is row
    ldy TEXT_Y 

    ; char ptr row
    lda SCREEN_ROW_LOW, y
    sta TEXT_SCR_PTR
    lda SCREEN_ROW_HIGH, y
    sta TEXT_SCR_PTR+1

    ; col ptr row
    lda SCREEN_ROW_LOW, y
    sta TEXT_COL_PTR
    lda SCREEN_COL_HIGH, y
    sta TEXT_COL_PTR+1

    ; fix ptrs for offscreen
    lda TEXT_OFFSCREEN
    beq +                       ; quickly jump if not offscreen
    lda SCREEN_800_ROW_HIGH, y
    sta TEXT_SCR_PTR+1
    lda SCREEN_C00_COL_HIGH, y
    sta TEXT_COL_PTR+1
+

    ; add col to screen
    lda TEXT_SCR_PTR
    clc
    adc TEXT_X 
    sta TEXT_SCR_PTR

    bcc +                       ; no carry
    inc TEXT_SCR_PTR+1          ; carry so add one to high
+
    ; add col to COLOR
    lda TEXT_COL_PTR
    clc
    adc TEXT_X 
    sta TEXT_COL_PTR

    bcc +                       ; no carry
    inc TEXT_COL_PTR+1          ; carry so add one to high
+
    ; zero page string
    lda TEXT_STRING_PTR
    sta ZP_PTR_TEMP_0
    lda TEXT_STRING_PTR+1
    sta ZP_PTR_TEMP_0_PAIR

    ; zero page screen
    lda TEXT_SCR_PTR
    sta ZP_PTR_1
    lda TEXT_SCR_PTR+1
    sta ZP_PTR_1_PAIR

    ; zero page COLOR
    lda TEXT_COL_PTR
    sta ZP_PTR_2
    lda TEXT_COL_PTR+1
    sta ZP_PTR_2_PAIR

    ; y is offset
    ldy #0

.string_loop_vert
    ; load next char
    lda (ZP_PTR_TEMP_0), y

    ; check for null terminator
    beq .string_done_vert

    ; y is 0 for vert
    tya 
    pha

    ; load char again...
    lda (ZP_PTR_TEMP_0), y

    ; no offset as we're adding 40 to ptrs...
    ldy #0

    ; draw char
    sta (ZP_PTR_1), y

    ; inc char row
    clc                         ; clear carry
    lda #40                     ; 40 cols
    adc ZP_PTR_1                
    sta ZP_PTR_1
    bcc +
    inc ZP_PTR_1_PAIR
+

    ; set col
    lda TEXT_COLOR
    sta (ZP_PTR_2), y

    ; inc col row
    clc                         ; clear carry
    lda #40                     ; 40 cols
    adc ZP_PTR_2                
    sta ZP_PTR_2
    bcc +
    inc ZP_PTR_2_PAIR
+
    ; restore y
    pla
    tay
    ; next char
    iny
    jmp .string_loop_vert
.string_done_vert
    rts 

; sets TEXT_X to CENTER the string at TEXT_STRING_PTR
TEXT_CENTER_STRING
    ; how long is string?

    ; zero page string
    lda TEXT_STRING_PTR
    sta ZP_PTR_TEMP_0
    lda TEXT_STRING_PTR+1
    sta ZP_PTR_TEMP_0_PAIR

    ; y is offset
    ldy #0

.len_loop
    ; load next char
    lda (ZP_PTR_TEMP_0), y    
    ; check for null terminator
    beq .len_done

    iny
    jmp .len_loop

.len_done
    sty TEXT_STRING_LEN
    
    ; 40 screen width - string length
    lda #40
    sec
    sbc TEXT_STRING_LEN

    ; divide by 2 to CENTER
    lsr

    ; save
    sta TEXT_X
    rts

TEXT_CENTER_STRING_VERT
    ; how long is string?

    ; zero page string
    lda TEXT_STRING_PTR
    sta ZP_PTR_TEMP_0
    lda TEXT_STRING_PTR+1
    sta ZP_PTR_TEMP_0_PAIR

    ; y is offset
    ldy #0

.len_loop_vert
    ; load next char
    lda (ZP_PTR_TEMP_0), y    
    ; check for null terminator
    beq .len_done_vert

    iny
    jmp .len_loop_vert

.len_done_vert
    sty TEXT_STRING_LEN
    
    ; 15 string height area
    lda #15
    sec
    sbc TEXT_STRING_LEN

    ; divide by 2 to CENTER
    lsr

    ; save
    sta TEXT_Y
    rts 


; this is Gemini AI toaster stuff...
    ; but this is just drudgery Assembler 101 end of term test stuff
    ; I could work it out but I'm learning procgen not that now!

; incs TEXT_X as it draws to allow things like ' degrees' printed after
TEXT_DRAW_NUMBER:
    lda TEXT_CHAR    ; reuse as number

    ; --- 1. Find the Hundreds Digit ---
    ldx #$2F         ; $2F is ASCII '0' minus 1
GetHundreds:
    inx              ; Increment character code ('0', '1', '2'...)
    sec
    sbc #100         ; Subtract 100
    bcs GetHundreds  ; If it didn't roll under 0, keep going
    adc #100         ; Fix the over-subtraction

    ; only show if not 0
    cpx #48
    beq +
    stx TEXT_CHAR
    jsr TEXT_DRAW_CHAR  
    inc TEXT_X
+

    ; --- 2. Find the Tens Digit ---
    ldx #$2F
GetTens:
    inx
    sec
    sbc #10          ; Subtract 10
    bcs GetTens      ; If it didn't roll under 0, keep going
    adc #10          ; Fix the over-subtraction

    cpx #48
    beq +
    stx TEXT_CHAR
    jsr TEXT_DRAW_CHAR  
    inc TEXT_X
+

    ; --- 3. What's left is the Ones Digit ---
    clc
    adc #$30         ; Convert the remaining raw number to ASCII '0'-'9'
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR
    inc TEXT_X
    rts 

; waits for release, so doesn't fire multiple times
; space handling added using VSCODE agent which was pretty interesting to try
TEXT_WAIT_FOR_ENTER_SPACE
    lda #KEY_ENTER_ROW
    sta CIA1_PRA
.wait_poll
    lda CIA1_PRB
    and #KEY_ENTER_COL          ; check ENTER pressed
    beq .wait_release

    lda #KEY_SPACE_ROW
    sta CIA1_PRA
    lda CIA1_PRB
    and #KEY_SPACE_COL          ; check SPACE pressed
    beq .wait_release

    lda #KEY_ENTER_ROW
    sta CIA1_PRA
    jmp .wait_poll

.wait_release
    lda #KEY_ENTER_ROW
    sta CIA1_PRA
    lda CIA1_PRB
    and #KEY_ENTER_COL          ; wait for ENTER release
    beq .wait_release

    lda #KEY_SPACE_ROW
    sta CIA1_PRA
    lda CIA1_PRB
    and #KEY_SPACE_COL          ; wait for SPACE release
    beq .wait_release

    rts

; ZP_PTR_1 points to known string
; ZP_PTR_2 points to compare string
; returns: in a - 0=not same 1=same
TEXT_COMPARE_STRINGS:
    ldy #0

.text_compare_strings_loop:
    lda (ZP_PTR_1), y
    bne +
    ; null pointer reached, so the same, return true
    lda #1
    rts
+
    ; compare
    cmp (ZP_PTR_2), y
    beq +               ; same so check next
    ; not same, return false
    lda #0
    rts
+
    iny
    jmp .text_compare_strings_loop

