
PLANETS_TEMP
    !byte 0

PLANETS_1x1_1
    !byte 200
PLANETS_1x1_2
    !byte 201

PLANETS_2x2_T_3
    !byte 202, 203, 204, 0
PLANETS_2x2_M_3
    !byte 205, 206, 207, 0
PLANETS_2x2_B_3
    !byte 208, 209, 210, 0

PLANETS_2x2_T_4
    !byte 211, 212, 213, 0
PLANETS_2x2_M_4
    !byte 214, 215, 216, 0
PLANETS_2x2_B_4
    !byte 217, 218, 219, 0

PLANETS_3x3_T_5
    !byte 220, 221, 222, 0
PLANETS_3x3_M_5
    !byte 223, 224, 225, 0
PLANETS_3x3_B_5
    !byte 226, 227, 228, 0

PLANETS_3x3_T_6
    !byte 229, 230, 231, 0
PLANETS_3x3_M_6
    !byte 232, 233, 234, 0
PLANETS_3x3_B_6
    !byte 235, 236, 237, 0

PLANETS_3x3_T_7
    !byte 238, 239, 240, 0
PLANETS_3x3_M_7
    !byte 241, 242, 243, 0
PLANETS_3x3_B_7
    !byte 244, 245, 246, 0

PLANETS_3x3_T_8
    !byte 247, 248, 249, 0
PLANETS_3x3_M_8
    !byte 250, 251, 252, 0
PLANETS_3x3_B_8
    !byte 253, 254, 255, 0

PLANETS_FONT_1x1_1      = $3000 + (200*8)
PLANETS_FONT_1x1_2      = $3000 + (201*8)
PLANETS_FONT_2x2_3      = $3000 + (202*8)
PLANETS_FONT_2x2_4      = $3000 + (211*8)
PLANETS_FONT_3x3_5      = $3000 + (220*8)
PLANETS_FONT_3x3_6      = $3000 + (229*8)
PLANETS_FONT_3x3_7      = $3000 + (238*8)
PLANETS_FONT_3x3_8      = $3000 + (247*8)


PLANETS_FONT_PATCH_223  = $3000 + (223*8)
PLANETS_FONT_PATCH_95  = $3000 + (95*8)



; mcm characters for planets
; each byte is in bit-pairs for wide pixel
; %00 means bg, %01 shared 1, %02 shared 2, %11 fg
; fg for char needs to be set 9-15 (set bit 3) to force MCM
PLANETS_1x1_CHAR
    !byte $3C, $3C, $FF, $FF, $FF, $FF, $3C, $3C

PLANETS_2x2_CHAR_TL
    !byte $00,$00,$00,$00,$00,$00,$03,$03
PLANETS_2x2_CHAR_TM
    !byte $00,$00,$00,$00,$00,$3C,$FF,$FF
PLANETS_2x2_CHAR_TR
    !byte $00,$00,$00,$00,$00,$00,$C0,$C0
PLANETS_2x2_CHAR_ML
    !byte $03,$0F,$0F,$0F,$0F,$0F,$0F,$03
PLANETS_2x2_CHAR_MM
    !byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
PLANETS_2x2_CHAR_MR
    !byte $C0,$F0,$F0,$F0,$F0,$F0,$F0,$C0
PLANETS_2x2_CHAR_BL
    !byte $03,$03,$00,$00,$00,$00,$00,$00
PLANETS_2x2_CHAR_BM
    !byte $FF,$FF,$3C,$00,$00,$00,$00,$00
PLANETS_2x2_CHAR_BR
    !byte $C0,$C0,$00,$00,$00,$00,$00,$00

PLANETS_3x3_CHAR_TL
    !byte $00,$00,$00,$00,$03,$03,$0F,$0F
PLANETS_3x3_CHAR_TM
    !byte $00,$00,$00,$3C,$FF,$FF,$FF,$FF
PLANETS_3x3_CHAR_TR
    !byte $00,$00,$00,$00,$C0,$C0,$F0,$F0
PLANETS_3x3_CHAR_ML
    !byte $0F,$3F,$3F,$3F,$3F,$3F,$3F,$0F
PLANETS_3x3_CHAR_MM
    !byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
PLANETS_3x3_CHAR_MR
    !byte $F0,$FC,$FC,$FC,$FC,$FC,$FC,$F0
PLANETS_3x3_CHAR_BL
    !byte $0F,$0F,$03,$03,$00,$00,$00,$00
PLANETS_3x3_CHAR_BM
    !byte $FF,$FF,$FF,$FF,$3C,$00,$00,$00
PLANETS_3x3_CHAR_BR
    !byte $F0,$F0,$C0,$C0,$00,$00,$00,$00

PLANETS_COLOR_LUT_1
    !byte %11111111, %11111111, %01111111, %10111111
PLANETS_COLOR_LUT_2
    !byte %11111111, %11111111, %11011111, %11101111
PLANETS_COLOR_LUT_3
    !byte %11111111, %11111111, %11110111, %11111011
PLANETS_COLOR_LUT_4
    !byte %11111111, %11111111, %11111101, %11111110


PLANETS_JUMP_GATE_UDGS
!byte $00,$03,$03,$0D,$0D,$36,$36,$D8,$FF,$55,$55,$AA,$AA,$00,$14,$00
!byte $00,$C0,$C0,$70,$70,$9C,$9C,$27
!byte $D8,$D8,$D8,$DB,$DB,$D8,$D8,$D8,$00,$00,$00,$00,$00,$00,$00,$00
!byte $27,$27,$27,$E7,$E7,$27,$27,$27
!byte $D8,$36,$36,$0D,$0D,$03,$03,$00,$00,$28,$00,$AA,$AA,$55,$55,$FF
!byte $27,$9C,$9C,$70,$70,$C0,$C0,$00

PLANETS_JUMP_GATE_UDG_BASE = 187

PLANETS_JUMP_GATE_TOP
    !byte 187, 188, 189, 0
PLANETS_JUMP_GATE_MID
    !byte 190, 191, 192, 0
PLANETS_JUMP_GATE_BOT
    !byte 193, 194, 195, 0

PLANETS_STATION_UDGS
!byte $FF,$55,$3C,$3C,$3C,$3C,$3C,$FF
!byte $FF,$5E,$5E,$5E,$7A,$7A,$7A,$FF
!byte $FF,$3C,$3C,$3C,$3C,$3C,$55,$FF

PLANETS_STATION_UDG_BASE = 184

PLANETS_STATION
    !byte 184, 185, 186, 0

