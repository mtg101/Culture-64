
CLOUDS_SEED_W0
    !word 0
CLOUDS_SEED_W1
    !word 0
CLOUDS_SEED_W2
    !word 0

CLOUDS_STEP_1_X
    !byte 0
CLOUDS_STEP_2_Y
    !byte 0
CLOUDS_STEP_3_X
    !byte 0
CLOUDS_STEP_3_Y
    !byte 0

CLOUDS_W1_INDEX
    !byte 0
CLOUDS_W2_INDEX
    !byte 0
CLOUDS_W3_INDEX
    !byte 0

CLOUDS_W2_ROW_BASE
    !byte 0
CLOUDS_W3_ROW_BASE
    !byte 0

CLOUDS_UDGS         ; light to dense
CLOUDS_1
    !byte %00000000
    !byte %00100000
    !byte %00000000
    !byte %00000000
    !byte %00000100
    !byte %00000000
    !byte %01000000
    !byte %00000000
CLOUDS_2
    !byte %00000000
    !byte %00100000
    !byte %00000010
    !byte %00010000
    !byte %00000000
    !byte %01000000
    !byte %00001000
    !byte %00000000
CLOUDS_3
    !byte %01000000
    !byte %00000100
    !byte %10010000
    !byte %01000000
    !byte %00001000
    !byte %01000000
    !byte %00010010
    !byte %00001000
CLOUDS_4
    !byte %01000100
    !byte %00010010
    !byte %01000100
    !byte %00100010
    !byte %01001000
    !byte %01001010
    !byte %00010001
    !byte %00100100


; =====================================================================
; 256-BYTE SINE TABLE FOR PLASMA GENERATION (ACME FORMAT)
; Values range from 0 ($00) to 80 ($50) with a midpoint of 40 ($28)
; 80 max means you can combine 3 waves for max 240 not overflowing
; =====================================================================
!align 255, 0
CLOUDS_SINE_LUT
    !byte $28,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,$30,$31,$32,$33,$34,$35,$36
    !byte $37,$38,$39,$39,$3a,$3b,$3c,$3d,$3e,$3f,$3f,$40,$41,$42,$42,$43
    !byte $44,$44,$45,$46,$46,$47,$48,$48,$49,$49,$4a,$4a,$4b,$4b,$4c,$4c
    !byte $4c,$4d,$4d,$4d,$4e,$4e,$4e,$4f,$4f,$4f,$4f,$4f,$4f,$4f,$4f,$4f
    !byte $50,$4f,$4f,$4f,$4f,$4f,$4f,$4f,$4f,$4f,$4e,$4e,$4e,$4d,$4d,$4d
    !byte $4c,$4c,$4c,$4b,$4b,$4a,$4a,$49,$49,$48,$48,$47,$46,$46,$45,$44
    !byte $44,$43,$42,$42,$41,$40,$3f,$3f,$3e,$3d,$3c,$3b,$3a,$39,$39,$38
    !byte $37,$36,$35,$34,$33,$32,$31,$30,$2f,$2e,$2d,$2c,$2b,$2a,$29,$28
    !byte $28,$27,$26,$25,$24,$23,$22,$21,$20,$1f,$1e,$1d,$1c,$1b,$1a,$19
    !byte $18,$17,$16,$16,$15,$14,$13,$12,$11,$10,$10,$0f,$0e,$0d,$0d,$0c
    !byte $0b,$0b,$0a,$09,$09,$08,$07,$07,$06,$06,$05,$05,$04,$04,$03,$03
    !byte $03,$02,$02,$02,$01,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$02,$02,$02
    !byte $03,$03,$03,$04,$04,$05,$05,$06,$06,$07,$07,$08,$09,$09,$0a,$0b
    !byte $0b,$0c,$0d,$0d,$0e,$0f,$10,$10,$11,$12,$13,$14,$15,$16,$16,$17
    !byte $18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27

CLOUDS_NEBULA_COLORS_LUT
    !byte PURPLE, GREEN, RED, BLUE

CLOUDS_UDG_BASE = 196
CLOUDS_ROWS = 15
CLOUDS_COLS
    !byte 40
CLOUDS_COLS_START 
    !byte 0
CLOUDS_NEBULA_MODE
    !byte 0
CLOUDS_NEBULA_COLOR
    !byte 0
CLOUDS_OORT_COLOR
    !byte 0
CLOUDS_RENDER_COLOR
    !byte 0
