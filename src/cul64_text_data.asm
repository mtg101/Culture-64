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
    !byte 161 ; invalid 0/null
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
    !byte 0 ; *
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
    !byte 29 ; 9



; 5bit 32 values LUT to char for the code
TEXT_BITS_TO_CHAR_LUT
    !byte 42 ; *
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



TEXT_WORD_LUT_LO
    !byte <TEXT_WORD_0
    !byte <TEXT_WORD_1
    !byte <TEXT_WORD_2
    !byte <TEXT_WORD_3
    !byte <TEXT_WORD_4
    !byte <TEXT_WORD_5
    !byte <TEXT_WORD_6
    !byte <TEXT_WORD_7

    !byte <TEXT_WORD_8
    !byte <TEXT_WORD_9
    !byte <TEXT_WORD_10
    !byte <TEXT_WORD_11
    !byte <TEXT_WORD_12
    !byte <TEXT_WORD_13
    !byte <TEXT_WORD_14
    !byte <TEXT_WORD_15

    !byte <TEXT_WORD_16
    !byte <TEXT_WORD_17
    !byte <TEXT_WORD_18
    !byte <TEXT_WORD_19
    !byte <TEXT_WORD_20
    !byte <TEXT_WORD_21
    !byte <TEXT_WORD_22
    !byte <TEXT_WORD_23

    !byte <TEXT_WORD_24
    !byte <TEXT_WORD_25
    !byte <TEXT_WORD_26
    !byte <TEXT_WORD_27
    !byte <TEXT_WORD_28
    !byte <TEXT_WORD_29
    !byte <TEXT_WORD_30
    !byte <TEXT_WORD_31

TEXT_WORD_LUT_HI
    !byte >TEXT_WORD_0
    !byte >TEXT_WORD_1
    !byte >TEXT_WORD_2
    !byte >TEXT_WORD_3
    !byte >TEXT_WORD_4
    !byte >TEXT_WORD_5
    !byte >TEXT_WORD_6
    !byte >TEXT_WORD_7

    !byte >TEXT_WORD_8
    !byte >TEXT_WORD_9
    !byte >TEXT_WORD_10
    !byte >TEXT_WORD_11
    !byte >TEXT_WORD_12
    !byte >TEXT_WORD_13
    !byte >TEXT_WORD_14
    !byte >TEXT_WORD_15

    !byte >TEXT_WORD_16
    !byte >TEXT_WORD_17
    !byte >TEXT_WORD_18
    !byte >TEXT_WORD_19
    !byte >TEXT_WORD_20
    !byte >TEXT_WORD_21
    !byte >TEXT_WORD_22
    !byte >TEXT_WORD_23

    !byte >TEXT_WORD_24
    !byte >TEXT_WORD_25
    !byte >TEXT_WORD_26
    !byte >TEXT_WORD_27
    !byte >TEXT_WORD_28
    !byte >TEXT_WORD_29
    !byte >TEXT_WORD_30
    !byte >TEXT_WORD_31





; greetings and formalities
TEXT_WORD_0
    !scr ""
TEXT_WORD_1
    !scr "hello"
TEXT_WORD_2
    !scr "friend"
TEXT_WORD_3
    !scr "an-nyeong"
TEXT_WORD_4
    !scr "konnichiwa"
TEXT_WORD_5
    !scr "clear skies"
TEXT_WORD_6
    !scr "take care"
TEXT_WORD_7
    !scr "ciao"

; common language
TEXT_WORD_8
    !scr "kudasai"
TEXT_WORD_9
    !scr "por favor"
TEXT_WORD_10
    !scr "why?"
TEXT_WORD_11
    !scr "right?"
TEXT_WORD_12
    !scr "good"
TEXT_WORD_13
    !scr "bad"
TEXT_WORD_14
    !scr "fraking"
TEXT_WORD_15
    !scr "yata!"

; things
TEXT_WORD_16
    !scr "planet"
TEXT_WORD_17
    !scr "star"
TEXT_WORD_18
    !scr "station"
TEXT_WORD_19
    !scr "system"
TEXT_WORD_20
    !scr "jump gate"
TEXT_WORD_21
    !scr "ship"
TEXT_WORD_22
    !scr "mind"
TEXT_WORD_23
    !scr "you"

; actions
TEXT_WORD_24
    !scr "repair"
TEXT_WORD_25
    !scr "help"
TEXT_WORD_26
    !scr "investigate"
TEXT_WORD_27
    !scr "contact"
TEXT_WORD_28
    !scr "send"
TEXT_WORD_29
    !scr "escape"
TEXT_WORD_30
    !scr "i will"
TEXT_WORD_31
    !scr "---"


