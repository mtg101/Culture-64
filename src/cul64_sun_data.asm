SUN_TYPE
    !byte 0

SUN_COLOR 
    !byte 0
SUN_COLOR_2
    !byte 0

SUN_TYPE_DIST         ; 0-7 types, over 32 for curve
    !byte 0, 0, 0, 0, 0, 0          ; 6/32
    !byte 1, 1, 1, 1, 1             ; 5/32
    !byte 2, 2, 2, 2, 2             ; 5/32
    !byte 3, 3, 3, 3, 3             ; 5/32
    !byte 4, 4, 4, 4                ; 4/32
    !byte 5, 5, 5                   ; 3/32
    !byte 6, 6                      ; 2/32
    !byte 7, 7                      ; 2/32
SUN_TYPE_STRING_LUT_LOW
    !byte <SUN_TYPE_0_STRING
    !byte <SUN_TYPE_1_STRING
    !byte <SUN_TYPE_2_STRING
    !byte <SUN_TYPE_3_STRING
    !byte <SUN_TYPE_4_STRING
    !byte <SUN_TYPE_5_STRING
    !byte <SUN_TYPE_6_STRING
    !byte <SUN_TYPE_7_STRING
SUN_TYPE_STRING_LUT_HIGH
    !byte >SUN_TYPE_0_STRING
    !byte >SUN_TYPE_1_STRING
    !byte >SUN_TYPE_2_STRING
    !byte >SUN_TYPE_3_STRING
    !byte >SUN_TYPE_4_STRING
    !byte >SUN_TYPE_5_STRING
    !byte >SUN_TYPE_6_STRING
    !byte >SUN_TYPE_7_STRING

SUN_TYPE_0_STRING
    !scr "red dwarf", 0
SUN_TYPE_1_STRING
    !scr "yellow dwarf", 0
SUN_TYPE_2_STRING
    !scr "blue giant", 0
SUN_TYPE_3_STRING
    !scr "red giant", 0
SUN_TYPE_4_STRING
    !scr "white dwarf", 0
SUN_TYPE_5_STRING
    !scr "wolf-rayet", 0
SUN_TYPE_6_STRING
    !scr "pulsar neutron", 0
SUN_TYPE_7_STRING
    !scr "binary", 0

SUN_TYPE_0_COLOR
    !byte RED
SUN_TYPE_1_COLOR
    !byte YELLOW
SUN_TYPE_2_COLOR
    !byte CYAN
SUN_TYPE_3_COLOR
    !byte RED
SUN_TYPE_4_COLOR
    !byte WHITE
SUN_TYPE_5_COLOR
    !byte PURPLE
SUN_TYPE_6_COLOR
    !byte CYAN
SUN_TYPE_7_COLOR
    !byte WHITE

SUN_TYPE_CHARS_LUT_LOW
    !byte <SUN_TYPE_0_CHARS
    !byte <SUN_TYPE_1_CHARS
    !byte <SUN_TYPE_2_CHARS
    !byte <SUN_TYPE_3_CHARS
    !byte <SUN_TYPE_4_CHARS
    !byte <SUN_TYPE_5_CHARS
    !byte <SUN_TYPE_6_CHARS
    !byte <SUN_TYPE_7_CHARS
SUN_TYPE_CHARS_LUT_HIGH
    !byte >SUN_TYPE_0_CHARS
    !byte >SUN_TYPE_1_CHARS
    !byte >SUN_TYPE_2_CHARS
    !byte >SUN_TYPE_3_CHARS
    !byte >SUN_TYPE_4_CHARS
    !byte >SUN_TYPE_5_CHARS
    !byte >SUN_TYPE_6_CHARS
    !byte >SUN_TYPE_7_CHARS
SUN_TYPE_0_CHARS
    !byte $20, $20
    !byte $20, $20
    !byte 95, $20
    !byte 160, $20
    !byte 160, $20

    !byte 160, 116
    !byte 160, 116
    !byte 160, 117
    !byte 160, 116
    !byte 160, 116

    !byte 160, $20
    !byte 160, $20
    !byte 105, $20
    !byte $20, $20
    !byte $20, $20

SUN_TYPE_1_CHARS
    !byte $20, $20
    !byte $20, $20
    !byte 95, $20
    !byte 160, $20
    !byte 160, $20

    !byte 160, 116
    !byte 160, 116
    !byte 160, 117
    !byte 160, 116
    !byte 160, 116

    !byte 160, $20
    !byte 160, $20
    !byte 105, $20
    !byte $20, $20
    !byte $20, $20

SUN_TYPE_2_CHARS
    !byte $20, $20
    !byte 95, $20
    !byte 160, $20
    !byte 160, $20
    !byte 160, $20

    !byte 160, 116
    !byte 160, 116
    !byte 160, 117
    !byte 160, 116
    !byte 160, 116

    !byte 160, $20
    !byte 160, $20
    !byte 160, $20
    !byte 105, $20
    !byte $20, $20

SUN_TYPE_3_CHARS
    !byte 95, $20
    !byte 160, $20
    !byte 160, $20
    !byte 160, 116
    !byte 160, 116

    !byte 160, 116
    !byte 160, 117
    !byte 160, 117
    !byte 160, 117
    !byte 160, 116

    !byte 160, 116
    !byte 160, 116
    !byte 160, $20
    !byte 160, $20
    !byte 105, $20

SUN_TYPE_4_CHARS
    !byte $20, $20
    !byte $20, $20
    !byte 95, $20
    !byte 160, $20
    !byte 160, $20

    !byte 160, 116
    !byte 160, 116
    !byte 160, 117
    !byte 160, 116
    !byte 160, 116

    !byte 160, $20
    !byte 160, $20
    !byte 105, $20
    !byte $20, $20
    !byte $20, $20

SUN_TYPE_5_CHARS
    !byte 58, $20
    !byte $20, $20
    !byte 58, $20
    !byte $20, $20
    !byte 160, $20

    !byte 160, 116
    !byte 160, 116
    !byte 160, 117
    !byte 160, 116
    !byte 160, 116

    !byte 160, $20
    !byte $20, $20
    !byte 58, $20
    !byte $20, $20
    !byte 58, $20

SUN_TYPE_6_CHARS
    !byte $20, 58
    !byte $20, 58
    !byte $20, 58
    !byte $20, 58
    !byte $20, 58

    !byte $20, 66
    !byte $20, 66
    !byte $20, 81
    !byte $20, 66
    !byte $20, 66

    !byte $20, 58
    !byte $20, 58
    !byte $20, 58
    !byte $20, 58
    !byte $20, 58
    !byte $20, 58

SUN_TYPE_7_CHARS
    !byte 95, $20
    !byte 160, $20
    !byte 160, $20
    !byte 160, 116
    !byte 160, 116

    !byte 160, $20
    !byte 160, $20
    !byte 105, $20
    !byte $20, $20
    !byte $20, $20

    !byte 95, $20
    !byte 160, $20
    !byte 160, $20
    !byte 160, $20
    !byte 105, $20

