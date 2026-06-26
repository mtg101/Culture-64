
NAME_BUFFER
    !fill BB_MAX_CHARS+1, 0
NAME_NUM_PAIRS
    !byte 0

NAME_THE_ONE_STRING     ; 128 pairs of chars
    !scr "a i u e o n kakikukekokysasisusesosytasitutetotynaninunenonyhahihuhehohymamimumemomyyayiyuyeyoy "     ; 96
    !scr "rarirurerorywawiwuwewowygagigugegogyzazizuzezozydadidudedodybabibubebobypapipupepopyjajijujejojykakikukekokya "   ; 110
    !scr "qucldrbrtrchstthfafefifofufylalelilolulya i u e o "   ; 50
NAME_THE_ONE_PUNCTUATION
    !scr "                         /#'-.:+"   ; 32

NAME_PATTERN_DIPLOMAT_10
    !byte 10, 0
NAME_PATTERN_DIPLOMAT_4_5
    !byte 4, 5, 0
NAME_PATTERN_DIPLOMAT_5_4
    !byte 5, 4, 0
NAME_PATTERN_DIPLOMAT_3_3_3
    !byte 3, 3, 3, 0
NAME_PATTERN_DIPLOMAT_2_2_2_2
    !byte 2, 2, 2, 2, 0
NAME_PATTERN_DIPLOMAT_LUT
    !word NAME_PATTERN_DIPLOMAT_10
    !word NAME_PATTERN_DIPLOMAT_4_5
    !word NAME_PATTERN_DIPLOMAT_5_4
    !word NAME_PATTERN_DIPLOMAT_3_3_3
    !word NAME_PATTERN_DIPLOMAT_2_2_2_2
    !word NAME_PATTERN_DIPLOMAT_4_5
    !word NAME_PATTERN_DIPLOMAT_5_4
    !word NAME_PATTERN_DIPLOMAT_3_3_3

NAME_PATTERN_SYSTEM_10
    !byte 10, 0
NAME_PATTERN_SYSTEM_4_5
    !byte 4, 5, 0
NAME_PATTERN_SYSTEM_5_4
    !byte 5, 4, 0
NAME_PATTERN_SYSTEM_3_3_3
    !byte 3, 3, 3, 0
NAME_PATTERN_SYSTEM_2_2_2_2
    !byte 2, 2, 2, 2, 0
NAME_PATTERN_SYSTEM_LUT
    !word NAME_PATTERN_SYSTEM_10
    !word NAME_PATTERN_SYSTEM_4_5
    !word NAME_PATTERN_SYSTEM_5_4
    !word NAME_PATTERN_SYSTEM_3_3_3
    !word NAME_PATTERN_SYSTEM_2_2_2_2
    !word NAME_PATTERN_SYSTEM_4_5
    !word NAME_PATTERN_SYSTEM_5_4
    !word NAME_PATTERN_SYSTEM_10

NAME_PATTERN_PLANET_7
    !byte 7, 0
NAME_PATTERN_PLANET_3_3
    !byte 3, 3, 0
NAME_PATTERN_PLANET_2_4
    !byte 2, 4, 0
NAME_PATTERN_PLANET_4_2
    !byte 4, 2, 0
NAME_PATTERN_PLANET_2_2_2
    !byte 2, 2, 2, 0
NAME_PATTERN_PLANET_LUT
    !word NAME_PATTERN_PLANET_7
    !word NAME_PATTERN_PLANET_3_3
    !word NAME_PATTERN_PLANET_2_4
    !word NAME_PATTERN_PLANET_4_2
    !word NAME_PATTERN_PLANET_2_2_2
    !word NAME_PATTERN_PLANET_7
    !word NAME_PATTERN_PLANET_3_3
    !word NAME_PATTERN_PLANET_7
