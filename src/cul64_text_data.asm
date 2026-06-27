TEXT_X
    !byte 0
TEXT_Y
    !byte 0
TEXT_COLOR
    !byte 0
TEXT_STRING_PTR
    !word 0
TEXT_SCR_PTR
    !word 0
TEXT_COL_PTR
    !word 0
TEXT_STRING_LEN
    !byte 0
TEXT_CHAR           ; also used as number...
    !byte 0
TEXT_OFFSCREEN
    !byte 0




; 6bit 64 value for all typable chars
; but only ones from TEXT_BITS_TO_CHAR_LUT have values
;invalid chars are 161 inverted !
TEXT_CHAR_TO_BITS_LUT
    !byte 0 ; null terminator is 0
    !byte 1 ; a
    !byte 2 ; b
    !byte 3 ; c
    !byte 4 ; d
    !byte 5 ; e
    !byte 6 ; f
    !byte 7 ; g

    !byte 8 ; h
    !byte 161 ; invalid i    
    !byte 9 ; j
    !byte 10 ; k
    !byte 161 ; invalid l
    !byte 11 ; m
    !byte 12 ; n
    !byte 161 ; invalid o
    
    !byte 13 ; p
    !byte 14 ; q
    !byte 15 ; r
    !byte 161 ; invalid s
    !byte 16 ; t
    !byte 17 ; u
    !byte 18 ; v
    !byte 19 ; w

    !byte 20 ; x
    !byte 21 ; y
    !byte 22 ; z
    !byte 161 ; invalid [
    !byte 161 ; invalid £
    !byte 161 ; invalid ]
    !byte 161 ; invalid arrow up
    !byte 161 ; invalid arrow left

    !byte 161 ; invalid space
    !byte 161 ; invalid !
    !byte 161 ; invalid "
    !byte 161 ; invalid #
    !byte 161 ; invalid $
    !byte 161 ; invalid %
    !byte 161 ; invalid &
    !byte 161 ; invalid '

    !byte 161 ; invalid (
    !byte 161 ; invalid )
    !byte 161 ; inb=valid *
    !byte 30 ; +
    !byte 161 ; invalid ,
    !byte 31 ; -
    !byte 161 ; invalid .
    !byte 161 ; invalid /

    !byte 161 ; invalid 0
    !byte 161 ; invalid 1
    !byte 23 ; 2
    !byte 24 ; 3
    !byte 25 ; 4
    !byte 161 ; invalid 5
    !byte 26 ; 6
    !byte 27 ; 7

    !byte 28 ; 8
    !byte 39 ; 9



; 5bit 32 values LUT to char for the code
TEXT_BITS_TO_CHAR_LUT
    !byte 0 ; null terminator
    !byte 1 ; a
    !byte 2 ; b
    !byte 3 ; c
    !byte 4 ; d
    !byte 5 ; e
    !byte 6 ; f
    !byte 7 ; g

    !byte 8 ; h
    !byte 10 ; j
    !byte 11 ; k
    !byte 13 ; m
    !byte 14 ; n
    !byte 16 ; p
    !byte 17 ; q
    !byte 18 ; r

    !byte 20 ; t
    !byte 21 ; u
    !byte 22 ; v
    !byte 23 ; w
    !byte 24 ; x
    !byte 25 ; y
    !byte 26 ; z
    !byte 50 ; 2

    !byte 51 ; 3
    !byte 52 ; 4
    !byte 54 ; 6
    !byte 55 ; 7
    !byte 56 ; 8
    !byte 57 ; 9
    !byte 43 ; +
    !byte 45 ; -



