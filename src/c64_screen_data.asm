
SCREEN_CHAR_SET_3000
    lda MEM_SETUP      ; Get current Screen/Char settings
    and #%11110001     ; Clear bits 1, 2, and 3 (Keep the Screen pointer)
    ora #%00001100     ; Set bits 1-3 to %110 (Binary 6)
    sta MEM_SETUP      ; Apply changes
    rts

; Screen RAM Row Start Addresses (Low Bytes)
; same for all: col, offscreen, main etc
SCREEN_ROW_LOW
    !byte $00, $28, $50, $78, $a0, $c8, $f0, $18
    !byte $40, $68, $90, $b8, $e0, $08, $30, $58
    !byte $80, $a8, $d0, $f8, $20, $48, $70, $98
    !byte $c0

; Screen RAM Row Start Addresses (High Bytes)
SCREEN_ROW_HIGH
    !byte $04, $04, $04, $04, $04, $04, $04, $05
    !byte $05, $05, $05, $05, $05, $06, $06, $06
    !byte $06, $06, $06, $06, $07, $07, $07, $07
    !byte $07

; Color RAM Row Start Addresses (High Bytes)
SCREEN_COL_HIGH
    !byte $d8, $d8, $d8, $d8, $d8, $d8, $d8, $d9
    !byte $d9, $d9, $d9, $d9, $d9, $da, $da, $da
    !byte $da, $da, $da, $da, $db, $db, $db, $db
    !byte $db

; off Screen RAM Row Start Addresses (Low Bytes) $0800
; Screen RAM Row Start Addresses (High Bytes)
SCREEN_800_ROW_HIGH
    !byte $08, $08, $08, $08, $08, $08, $08, $09
    !byte $09, $09, $09, $09, $09, $0a, $0a, $0a
    !byte $0a, $0a, $0a, $0a, $0b, $0b, $0b, $0b
    !byte $0b

; Color offscreen in $0c00 screen slot Row Start Addresses (Low Bytes)
; Color RAM Row Start Addresses (High Bytes)
SCREEN_C00_COL_HIGH
    !byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0d
    !byte $0d, $0d, $0d, $0d, $0d, $0e, $0e, $0e
    !byte $0e, $0e, $0e, $0e, $0f, $0f, $0f, $0f
    !byte $0f

SCREEN_RAM_250_0 = SCREEN_RAM
SCREEN_RAM_250_1 = SCREEN_RAM_250_0 + 250
SCREEN_RAM_250_2 = SCREEN_RAM_250_1 + 250
SCREEN_RAM_250_3 = SCREEN_RAM_250_2 + 250

SCREEN_800_RAM_250_0 = SCREEN_RAM_800
SCREEN_800_RAM_250_1 = SCREEN_800_RAM_250_0 + 250
SCREEN_800_RAM_250_2 = SCREEN_800_RAM_250_1 + 250
SCREEN_800_RAM_250_3 = SCREEN_800_RAM_250_2 + 250

SCREEN_COL_RAM_250_0 = COLOR_RAM
SCREEN_COL_RAM_250_1 = SCREEN_COL_RAM_250_0 + 250
SCREEN_COL_RAM_250_2 = SCREEN_COL_RAM_250_1 + 250
SCREEN_COL_RAM_250_3 = SCREEN_COL_RAM_250_2 + 250

SCREEN_C00_COL_RAM_250_0 = SCREEN_RAM_C00
SCREEN_C00_COL_RAM_250_1 = SCREEN_C00_COL_RAM_250_0 + 250
SCREEN_C00_COL_RAM_250_2 = SCREEN_C00_COL_RAM_250_1 + 250
SCREEN_C00_COL_RAM_250_3 = SCREEN_C00_COL_RAM_250_2 + 250

