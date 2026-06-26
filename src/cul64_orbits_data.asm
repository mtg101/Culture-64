
ORBITS_INFO_STATUS
    !byte 0

; 0 - empty slot
; 1 - planet
; 2 - asteroid belt
; 3 - jump gate
; 4 - station

ORBITS_DIST                         ; 4x8=32
    !byte 0, 0, 0, 0, 0, 0, 0, 0    
    !byte 0, 0, 0, 0, 2, 2, 3, 4    
    !byte 1, 1, 1, 1, 1, 1, 1, 1    
    !byte 1, 1, 1, 1, 1, 1, 1, 1    

ORBITS_JUMP_TABLE_LO
    !byte 0                 ; not used
    !byte <PLANET_GENERATE_IN_SLOT
    !byte <PLANET_GENERATE_ASTEROID_BELT_IN_SLOT
    !byte <PLANET_GENERATE_JUMP_GATE_IN_SLOT
    !byte <PLANET_GENERATE_STATION_IN_SLOT

ORBITS_JUMP_TABLE_HI
    !byte 0                 ; not used
    !byte >PLANET_GENERATE_IN_SLOT
    !byte >PLANET_GENERATE_ASTEROID_BELT_IN_SLOT
    !byte >PLANET_GENERATE_JUMP_GATE_IN_SLOT
    !byte >PLANET_GENERATE_STATION_IN_SLOT

ORBITS_JUMP_TABLE_SLOT_1_LO
    !byte 0                 ; not used
    !byte <PLANET_SHOW_SLOT_1
    !byte <PLANET_SHOW_ASTEROID_BELT
    !byte <PLANET_SHOW_JUMP_GATE
    !byte <PLANET_SHOW_STATION
ORBITS_JUMP_TABLE_SLOT_1_HI
    !byte 0                 ; not used
    !byte >PLANET_SHOW_SLOT_1
    !byte >PLANET_SHOW_ASTEROID_BELT
    !byte >PLANET_SHOW_JUMP_GATE
    !byte >PLANET_SHOW_STATION

ORBITS_JUMP_TABLE_SLOT_2_LO
    !byte 0                 ; not used
    !byte <PLANET_SHOW_SLOT_2
    !byte <PLANET_SHOW_ASTEROID_BELT
    !byte <PLANET_SHOW_JUMP_GATE
    !byte <PLANET_SHOW_STATION
ORBITS_JUMP_TABLE_SLOT_2_HI
    !byte 0                 ; not used
    !byte >PLANET_SHOW_SLOT_2
    !byte >PLANET_SHOW_ASTEROID_BELT
    !byte >PLANET_SHOW_JUMP_GATE
    !byte >PLANET_SHOW_STATION

ORBITS_JUMP_TABLE_SLOT_3_LO
    !byte 0                 ; not used
    !byte <PLANET_SHOW_SLOT_3
    !byte <PLANET_SHOW_ASTEROID_BELT
    !byte <PLANET_SHOW_JUMP_GATE
    !byte <PLANET_SHOW_STATION
ORBITS_JUMP_TABLE_SLOT_3_HI
    !byte 0                 ; not used
    !byte >PLANET_SHOW_SLOT_3
    !byte >PLANET_SHOW_ASTEROID_BELT
    !byte >PLANET_SHOW_JUMP_GATE
    !byte >PLANET_SHOW_STATION

ORBITS_JUMP_TABLE_SLOT_4_LO
    !byte 0                 ; not used
    !byte <PLANET_SHOW_SLOT_4
    !byte <PLANET_SHOW_ASTEROID_BELT
    !byte <PLANET_SHOW_JUMP_GATE
    !byte <PLANET_SHOW_STATION
ORBITS_JUMP_TABLE_SLOT_4_HI
    !byte 0                 ; not used
    !byte >PLANET_SHOW_SLOT_4
    !byte >PLANET_SHOW_ASTEROID_BELT
    !byte >PLANET_SHOW_JUMP_GATE
    !byte >PLANET_SHOW_STATION

ORBITS_JUMP_TABLE_SLOT_5_LO
    !byte 0                 ; not used
    !byte <PLANET_SHOW_SLOT_5
    !byte <PLANET_SHOW_ASTEROID_BELT
    !byte <PLANET_SHOW_JUMP_GATE
    !byte <PLANET_SHOW_STATION
ORBITS_JUMP_TABLE_SLOT_5_HI
    !byte 0                 ; not used
    !byte >PLANET_SHOW_SLOT_5
    !byte >PLANET_SHOW_ASTEROID_BELT
    !byte >PLANET_SHOW_JUMP_GATE
    !byte >PLANET_SHOW_STATION

ORBITS_JUMP_TABLE_SLOT_6_LO
    !byte 0                 ; not used
    !byte <PLANET_SHOW_SLOT_6
    !byte <PLANET_SHOW_ASTEROID_BELT
    !byte <PLANET_SHOW_JUMP_GATE
    !byte <PLANET_SHOW_STATION
ORBITS_JUMP_TABLE_SLOT_6_HI
    !byte 0                 ; not used
    !byte >PLANET_SHOW_SLOT_6
    !byte >PLANET_SHOW_ASTEROID_BELT
    !byte >PLANET_SHOW_JUMP_GATE
    !byte >PLANET_SHOW_STATION

ORBITS_JUMP_TABLE_SLOT_7_LO
    !byte 0                 ; not used
    !byte <PLANET_SHOW_SLOT_7
    !byte <PLANET_SHOW_ASTEROID_BELT
    !byte <PLANET_SHOW_JUMP_GATE
    !byte <PLANET_SHOW_STATION
ORBITS_JUMP_TABLE_SLOT_7_HI
    !byte 0                 ; not used
    !byte >PLANET_SHOW_SLOT_7
    !byte >PLANET_SHOW_ASTEROID_BELT
    !byte >PLANET_SHOW_JUMP_GATE
    !byte >PLANET_SHOW_STATION

ORBITS_JUMP_TABLE_SLOT_8_LO
    !byte 0                 ; not used
    !byte <PLANET_SHOW_SLOT_8
    !byte <PLANET_SHOW_ASTEROID_BELT
    !byte <PLANET_SHOW_JUMP_GATE
    !byte <PLANET_SHOW_STATION
ORBITS_JUMP_TABLE_SLOT_8_HI
    !byte 0                 ; not used
    !byte >PLANET_SHOW_SLOT_8
    !byte >PLANET_SHOW_ASTEROID_BELT
    !byte >PLANET_SHOW_JUMP_GATE
    !byte >PLANET_SHOW_STATION


ORBITS_SLOT_1
    !byte 0
ORBITS_SLOT_2
    !byte 0
ORBITS_SLOT_3
    !byte 0
ORBITS_SLOT_4
    !byte 0
ORBITS_SLOT_5
    !byte 0
ORBITS_SLOT_6
    !byte 0
ORBITS_SLOT_7
    !byte 0
ORBITS_SLOT_8
    !byte 0

; properties for slots
; each type knows how to handle the byte (planets size for now - might need to be word later - or it's seed for simpler LFSR?)
ORBITS_SLOT_1_PROPS
    !byte 0
ORBITS_SLOT_2_PROPS
    !byte 0
ORBITS_SLOT_3_PROPS
    !byte 0
ORBITS_SLOT_4_PROPS
    !byte 0
ORBITS_SLOT_5_PROPS
    !byte 0
ORBITS_SLOT_6_PROPS
    !byte 0
ORBITS_SLOT_7_PROPS
    !byte 0
ORBITS_SLOT_8_PROPS
    !byte 0

ORBITS_Y = 7

ORBITS_SLOT_1_X
    !byte 5             ; close planets not 3x3 so won't 'touch' sun
ORBITS_SLOT_2_X
    !byte 9
ORBITS_SLOT_3_X
    !byte 13             
ORBITS_SLOT_4_X
    !byte 18            
ORBITS_SLOT_5_X
    !byte 23            
ORBITS_SLOT_6_X
    !byte 28            
ORBITS_SLOT_7_X
    !byte 33            
ORBITS_SLOT_8_X
    !byte 38            ; just enough space for 3x3

ORBITS_MAX_CHARS = 15
ORBITS_SLOT_1_BUFFER
    !fill ORBITS_MAX_CHARS+1, 0
ORBITS_SLOT_2_BUFFER
    !fill ORBITS_MAX_CHARS+1, 0
ORBITS_SLOT_3_BUFFER
    !fill ORBITS_MAX_CHARS+1, 0
ORBITS_SLOT_4_BUFFER
    !fill ORBITS_MAX_CHARS+1, 0
ORBITS_SLOT_5_BUFFER
    !fill ORBITS_MAX_CHARS+1, 0
ORBITS_SLOT_6_BUFFER
    !fill ORBITS_MAX_CHARS+1, 0
ORBITS_SLOT_7_BUFFER
    !fill ORBITS_MAX_CHARS+1, 0
ORBITS_SLOT_8_BUFFER
    !fill ORBITS_MAX_CHARS+1, 0

ORBITS_CURRENT_SLOT
    !byte 0

ORBITS_SLOT_3_MOON_1
    !byte 0
ORBITS_SLOT_3_MOON_2
    !byte 0
ORBITS_SLOT_4_MOON_1
    !byte 0
ORBITS_SLOT_4_MOON_2
    !byte 0
ORBITS_SLOT_5_MOON_1
    !byte 0
ORBITS_SLOT_5_MOON_2
    !byte 0
ORBITS_SLOT_5_MOON_3
    !byte 0
ORBITS_SLOT_5_MOON_4
    !byte 0
ORBITS_SLOT_6_MOON_1
    !byte 0
ORBITS_SLOT_6_MOON_2
    !byte 0
ORBITS_SLOT_6_MOON_3
    !byte 0
ORBITS_SLOT_6_MOON_4
    !byte 0
ORBITS_SLOT_7_MOON_1
    !byte 0
ORBITS_SLOT_7_MOON_2
    !byte 0
ORBITS_SLOT_7_MOON_3
    !byte 0
ORBITS_SLOT_7_MOON_4
    !byte 0
ORBITS_SLOT_8_MOON_1
    !byte 0
ORBITS_SLOT_8_MOON_2
    !byte 0
ORBITS_SLOT_8_MOON_3
    !byte 0
ORBITS_SLOT_8_MOON_4
    !byte 0

ORBITS_MOON_CHARS_LUT
    !byte 81, 81, 81, 81, 81, 81, 81, 81
    !byte 87, 42, 90, 86, 88, 43, 81, 81    

ORBITS_DYSON_SWARM 
    !byte 0
ORBITS_OORT_CLOUD
    !byte 0

ORBITS_OORT_COLORS
    !byte RED, RED, BLUE, BLUE, PURPLE, PURPLE, GREEN, GREEN

ORBITS_DYSON_SWARM_LABEL
    !scr "dyson swarm", 0
ORBITS_OORT_CLOUD_LABEL
    !scr "oort cloud", 0
ORBITS_ASTEROID_BELT_LABEL
    !scr "asteroid belt", 0
ORBITS_JUMP_GATE_LABEL
    !scr "jump gate", 0
ORBITS_STATION_LABEL
    !scr "station", 0

