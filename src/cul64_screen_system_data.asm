
SCREEN_SYSTEM_NAME_LABEL
    !scr "system", 0
; add $80 to each char to invert    
;    !scr 'n'+$80, 'a'+$80, 'm'+$80, 'e'+$80, ':'+$80, 0
SCREEN_SYSTEM_SUN_TYPE_LABEL
    !scr "sun type", 0
SCREEN_SYSTEM_INCLINE_LABEL
    !scr "plane incline", 0         ; 0-90 degrees
SCREEN_SYSTEM_KEPLER_LABEL
    !scr "kepler vector", 0         ; it's a cool scifi name kinda related to star systems... ignore the details!
SCREEN_SYSTEM_TECH_LEVEL_LABEL
    !scr "tech level", 0
SCREEN_SYSTEM_CUL_STATUS_LABEL
    !scr "culture status", 0

SCREEN_SYSTEM_DEGREES
    !scr " degrees", 0

SCREEN_SYSTEM_INCLINE
    !byte 0
SCREEN_SYSTEM_KEPLER
    !byte 0


SCREEN_SYSTEM_NUM_PLANETS
    !byte 0
SCREEN_SYSTEM_NUM_PLANETS_CHAR
    !byte 0, 0                      ; null terminated for regular string draw
SCREEN_SYSTEM_NUM_PLANETS_DIST      ; 0-7 planets, over 32 so most are 3-5
    !byte 0                         ; 1/32
    !byte 1, 1                      ; 2/32
    !byte 2, 2, 2                   ; 3/32
    !byte 3, 3, 3, 3                ; 4/32
    !byte 4, 4, 4, 4, 4, 4          ; 6/32
    !byte 5, 5, 5, 5, 5, 5          ; 6/32
    !byte 6, 6, 6, 6, 6, 6          ; 6/32
    !byte 7, 7, 7, 7                ; 4/32

SCREEN_SYSTEM_TECH_LEVEL 
    !byte 0

SCREEN_SYSTEM_TECH_LEVEL_DIST       ; 0-7 levels, over 32 for curve
    !byte 0, 0                      ; 2/32
    !byte 1, 1, 1                   ; 3/32
    !byte 2, 2, 2, 2                ; 4/32
    !byte 3, 3, 3, 3, 3             ; 5/32
    !byte 4, 4, 4, 4, 4, 4          ; 6/32
    !byte 5, 5, 5, 5, 5, 5          ; 6/32
    !byte 6, 6, 6, 6                ; 4/32
    !byte 7, 7                      ; 2/32

SCREEN_SYSTEM_TECH_LEVEL_STRING_LUT_LOW
    !byte <SCREEN_SYSTEM_TECH_LEVEL_0_STRING
    !byte <SCREEN_SYSTEM_TECH_LEVEL_1_STRING
    !byte <SCREEN_SYSTEM_TECH_LEVEL_2_STRING
    !byte <SCREEN_SYSTEM_TECH_LEVEL_3_STRING
    !byte <SCREEN_SYSTEM_TECH_LEVEL_4_STRING
    !byte <SCREEN_SYSTEM_TECH_LEVEL_5_STRING
    !byte <SCREEN_SYSTEM_TECH_LEVEL_6_STRING
    !byte <SCREEN_SYSTEM_TECH_LEVEL_7_STRING
SCREEN_SYSTEM_TECH_LEVEL_STRING_LUT_HIGH
    !byte >SCREEN_SYSTEM_TECH_LEVEL_0_STRING
    !byte >SCREEN_SYSTEM_TECH_LEVEL_1_STRING
    !byte >SCREEN_SYSTEM_TECH_LEVEL_2_STRING
    !byte >SCREEN_SYSTEM_TECH_LEVEL_3_STRING
    !byte >SCREEN_SYSTEM_TECH_LEVEL_4_STRING
    !byte >SCREEN_SYSTEM_TECH_LEVEL_5_STRING
    !byte >SCREEN_SYSTEM_TECH_LEVEL_6_STRING
    !byte >SCREEN_SYSTEM_TECH_LEVEL_7_STRING

SCREEN_SYSTEM_TECH_LEVEL_0_STRING
    !scr "pre-radio", 0
SCREEN_SYSTEM_TECH_LEVEL_1_STRING
    !scr "radio", 0
SCREEN_SYSTEM_TECH_LEVEL_2_STRING
    !scr "internet", 0
SCREEN_SYSTEM_TECH_LEVEL_3_STRING
    !scr "kardashev i", 0
SCREEN_SYSTEM_TECH_LEVEL_4_STRING
    !scr "kardashev ii", 0
SCREEN_SYSTEM_TECH_LEVEL_5_STRING
    !scr "warp capable", 0
SCREEN_SYSTEM_TECH_LEVEL_6_STRING
    !scr "kardashev iii", 0
SCREEN_SYSTEM_TECH_LEVEL_7_STRING
    !scr "culture", 0

SCREEN_SYSTEM_CUL_STATUS
    !byte 0
SCREEN_SYSTEM_CUL_STATUS_DIST       ; 0-7 types, over 32 for curve
    !byte 0                         ; 1/32
    !byte 1, 1                      ; 2/32
    !byte 2                         ; 1/32
    !byte 3, 3                      ; 2/432
    !byte 4, 4, 4, 4                ; 4/32
    !byte 5, 5, 5, 5, 5             ; 5/32
    !byte 6, 6, 6, 6, 6             ; 5/32
    !byte 7, 7, 7, 7, 7, 7          ; 6/12/32
    !byte 7, 7, 7, 7, 7, 7          ; 6/12/32
SCREEN_SYSTEM_CUL_STATUS_STRING_LUT_LOW
    !byte <SCREEN_SYSTEM_CUL_STATUS_0_STRING
    !byte <SCREEN_SYSTEM_CUL_STATUS_1_STRING
    !byte <SCREEN_SYSTEM_CUL_STATUS_2_STRING
    !byte <SCREEN_SYSTEM_CUL_STATUS_3_STRING
    !byte <SCREEN_SYSTEM_CUL_STATUS_4_STRING
    !byte <SCREEN_SYSTEM_CUL_STATUS_5_STRING
    !byte <SCREEN_SYSTEM_CUL_STATUS_6_STRING
    !byte <SCREEN_SYSTEM_CUL_STATUS_7_STRING
SCREEN_SYSTEM_CUL_STATUS_STRING_LUT_HIGH
    !byte >SCREEN_SYSTEM_CUL_STATUS_0_STRING
    !byte >SCREEN_SYSTEM_CUL_STATUS_1_STRING
    !byte >SCREEN_SYSTEM_CUL_STATUS_2_STRING
    !byte >SCREEN_SYSTEM_CUL_STATUS_3_STRING
    !byte >SCREEN_SYSTEM_CUL_STATUS_4_STRING
    !byte >SCREEN_SYSTEM_CUL_STATUS_5_STRING
    !byte >SCREEN_SYSTEM_CUL_STATUS_6_STRING
    !byte >SCREEN_SYSTEM_CUL_STATUS_7_STRING
SCREEN_SYSTEM_CUL_STATUS_0_STRING
    !scr "culture war", 0
SCREEN_SYSTEM_CUL_STATUS_1_STRING
    !scr "hostile", 0
SCREEN_SYSTEM_CUL_STATUS_2_STRING
    !scr "unknown", 0
SCREEN_SYSTEM_CUL_STATUS_3_STRING
    !scr "neutral", 0
SCREEN_SYSTEM_CUL_STATUS_4_STRING
    !scr "peace treaty", 0
SCREEN_SYSTEM_CUL_STATUS_5_STRING
    !scr "friendly", 0
SCREEN_SYSTEM_CUL_STATUS_6_STRING
    !scr "trade agreement", 0
SCREEN_SYSTEM_CUL_STATUS_7_STRING
    !scr "culture system", 0


SCREEN_SYSTEM_THANKS_LUT_LO
    !byte <SCREEN_SYSTEM_THANKS_0
    !byte <SCREEN_SYSTEM_THANKS_1
    !byte <SCREEN_SYSTEM_THANKS_2
    !byte <SCREEN_SYSTEM_THANKS_3
    !byte <SCREEN_SYSTEM_THANKS_4
    !byte <SCREEN_SYSTEM_THANKS_5
    !byte <SCREEN_SYSTEM_THANKS_6
    !byte <SCREEN_SYSTEM_THANKS_7
SCREEN_SYSTEM_THANKS_LUT_HI
    !byte >SCREEN_SYSTEM_THANKS_0
    !byte >SCREEN_SYSTEM_THANKS_1
    !byte >SCREEN_SYSTEM_THANKS_2
    !byte >SCREEN_SYSTEM_THANKS_3
    !byte >SCREEN_SYSTEM_THANKS_4
    !byte >SCREEN_SYSTEM_THANKS_5
    !byte >SCREEN_SYSTEM_THANKS_6
    !byte >SCREEN_SYSTEM_THANKS_7

SCREEN_SYSTEM_THANKS_0
    !scr "\"thanks for the lift!\"", 0
SCREEN_SYSTEM_THANKS_1
    !scr "\"arigatou gozaimasu\"", 0
SCREEN_SYSTEM_THANKS_2
    !scr "\"gam-sa-ham-ni-da\"", 0
SCREEN_SYSTEM_THANKS_3
    !scr "\"danke schoen\"", 0
SCREEN_SYSTEM_THANKS_4
    !scr "\"cheers guv!\"", 0
SCREEN_SYSTEM_THANKS_5
    !scr "\"ta mate!\"", 0
SCREEN_SYSTEM_THANKS_6
    !scr "\"efharisto poli!\"", 0
SCREEN_SYSTEM_THANKS_7
    !scr "\"muchas gracias\"", 0


SCREEN_SYSTEM_COLOR_TOP_SPACE_BORDER 
    !byte 0
SCREEN_SYSTEM_COLOR_TEXT_BG
    !byte 0
SCREEN_SYSTEM_COLOR_TEXT_BORDER
    !byte 0
SCREEN_SYSTEM_COLOR_BOTTOM_BORDER
    !byte 0
SCREEN_SYSTEM_NAME_BUFFER
    !fill BB_MAX_CHARS+1, 0
SCREEN_SYSTEM_KEYS_LABEL
    ; jUMP mUSIC dIPLOMAT sHIP iNFO
    !byte 138           ; jump 4 = 4
    !scr "ump"
    !byte 32            ; space +1 = 5
    !byte 141           ; music +5 = 10
    !scr "usic"
    !byte 32            ; space +1 = 11
    !byte 132           ; +8 = 19
    !scr "iplomat"
    !byte 32            ; +1 = 20
    !byte 147           ; +4 = 24
    !scr "hip"
    !byte 32            ; +1 = 25
    !byte 137           ; +4 = 29
    !scr "nfo"
    !byte  0                            ; +1 = 30

SCREEN_SYSTEM_SPACE_BG
    !byte 0

SCREEN_SYSTEM_PRE_LUT
    !byte 73, 74, 75, 85
SCREEN_SYSTEM_VECTOR_LUT
    !byte 77, 78, 67, 93

; if bg is black, text white, it white black
SCREEN_SYSTEM_FONT_COLOR
    !byte WHITE, BLACK, WHITE, BLACK, WHITE, WHITE, WHITE, BLACK
    !byte BLACK, WHITE, BLACK, WHITE, BLACK, BLACK, BLACK, BLACK

; $00 silent, $0F max vol
SCREEN_SYSTEM_MUSIC_ON
    !byte 0
SCREEN_SYSTEM_MUSIC_JUMPING
    !byte 0
SCREEN_SYSTEM_BG_COL_SPEED
    !byte 0    
SCREEN_SYSTEM_BG_COL_SPEED_LUT
    !byte %01111111, %00111111, %00111111, %00011111
SCREEN_SYSTEM_BG_FLASH_ON
    !byte 0    
SCREEN_SYSTEM_BG_FLASH_PROB
    !byte 0    
SCREEN_SYSTEM_BG_FLASH_PROB_LUT
    !byte %11111111, %01111111, %00111111, %00011111
; 0 sun color
; 1 nebula color
; 2 static random
; 3 random per flash
SCREEN_SYSTEM_BG_FLASH_COLOUR_TYPE
    !byte 0   
SCREEN_SYSTEM_BG_FLASH_COLOUR_STATIC
    !byte 0   
