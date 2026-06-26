; ------------------------------------------------------------------------------
; ENGINE LOOKUP MATRICES
; ------------------------------------------------------------------------------
table_bit_masks:
    !byte %10000000, %01000000, %00100000, %00010000
    !byte %00001000, %00000100, %00000010, %00000001

; Scale configurations (SID Freq MSB)
table_scales:
    ; 0: Deep Aeolian Minor (Moody/Exploration)
    !byte $11, $14, $16, $1A, $1E, $22, $25, $2B
    
    ; 8: Triumphant Major (Safe Haven)
    !byte $11, $13, $15, $16, $1A, $1E, $21, $2B
    
    ; 16: Phrygian Mode (Menacing/Dungeon)
    !byte $11, $12, $16, $1A, $1C, $20, $25, $2B
    
    ; 24: Pentatonic (Classic Arcade/Fast Pace)
    !byte $11, $14, $16, $1A, $1E, $25, $2B, $33

; ------------------------------------------------------------------------------
; HARDWARE REGISTERS
; ------------------------------------------------------------------------------
SID_BASE    = $D400

V1_FREQ_LO  = SID_BASE + 0
V1_FREQ_HI  = SID_BASE + 1
V1_PW_LO    = SID_BASE + 2
V1_PW_HI    = SID_BASE + 3
V1_CTRL     = SID_BASE + 4
V1_AD       = SID_BASE + 5
V1_SR       = SID_BASE + 6

V2_FREQ_LO  = SID_BASE + 7
V2_FREQ_HI  = SID_BASE + 8
V2_CTRL     = SID_BASE + 11
V2_AD       = SID_BASE + 12
V2_SR       = SID_BASE + 13

V3_FREQ_LO  = SID_BASE + 14
V3_FREQ_HI  = SID_BASE + 15
V3_CTRL     = SID_BASE + 18
V3_AD       = SID_BASE + 19
V3_SR       = SID_BASE + 20

FILTER_RES  = SID_BASE + 23     ; $D417
VOLUME_RETI = SID_BASE + 24     ; $D418

; INTERNAL ENGINE CLOCKS
clock_ticks:    !byte 0         ; Frame counter
step_counter:   !byte 0         ; 16th-note step (0-15)

; RUNTIME CONFIGURATION GENERATED FROM SEEDS
runtime_lfsr:   !byte 0         ; Current state of running melody generator
cfg_scale_idx:  !byte 0         ; Offset into the scale table (0, 8, 16, or 24)
cfg_rhythm_mask_1:    !byte 0         ; Rests configuration bitmask
cfg_rhythm_mask_2:  !byte 0         ; Rests configuration bitmask

cfg_bass_pitch_1: !byte 0         ; Root pitch 1 for the drone
cfg_bass_pitch_2: !byte 0         ; Root pitch 1 for the drone


warp_timer:     !byte 0         ; 0 = Inactive, counts down
warp_timer_start: !byte 0       ; start value


last_note_idx:  !byte 0         ; Tracks our current scale step position (0-7)

drone_instrument !byte 0        

drum_pattern_ptr !word 0

drone_instrument_lut
    !byte %10000001         ; noise
    !byte %01000001         ; pulse
    !byte %00100001         ; saw
    !byte %00100001         ; saw
    !byte %00100001         ; saw
    !byte %00010001         ; tri
    !byte %00010001         ; tri
    !byte %00010001         ; tri

melody_instrument !byte 0

melody_instrument_lut
    !byte %10000001         ; noise
    !byte %01000001         ; pulse
    !byte %00100001         ; saw
    !byte %00100001         ; saw
    !byte %00100001         ; saw
    !byte %00010001         ; tri
    !byte %00010001         ; tri
    !byte %00010001         ; tri

; drum pattern lut
drum_pattern_lut_low
    !byte <drum_pattern_1
    !byte <drum_pattern_2
    !byte <drum_pattern_3
    !byte <drum_pattern_4
    !byte <drum_pattern_5
    !byte <drum_pattern_6
    !byte <drum_pattern_7
    !byte <drum_pattern_8

drum_pattern_lut_high
    !byte >drum_pattern_1
    !byte >drum_pattern_2
    !byte >drum_pattern_3
    !byte >drum_pattern_4
    !byte >drum_pattern_5
    !byte >drum_pattern_6
    !byte >drum_pattern_7
    !byte >drum_pattern_8

; drum patterns
; 16 byte tables of on/off
drum_pattern_1
    !byte 0001
    !byte 0
    !byte 002
    !byte 0
    !byte 0001
    !byte 0
    !byte 002
    !byte 0
    !byte 0001
    !byte 0
    !byte 002
    !byte 0
    !byte 0001
    !byte 0
    !byte 002
    !byte 0

drum_pattern_2
    !byte 002
    !byte 0001
    !byte 002
    !byte 0001
    !byte 002
    !byte 0001
    !byte 002
    !byte 0001
    !byte 002
    !byte 0001
    !byte 002
    !byte 0001
    !byte 002
    !byte 0001
    !byte 002
    !byte 0001

drum_pattern_3
    !byte 002
    !byte 0
    !byte 0001
    !byte 0
    !byte 002
    !byte 0
    !byte 0
    !byte 0
    !byte 002
    !byte 0
    !byte 0001
    !byte 0
    !byte 002
    !byte 0
    !byte 0
    !byte 0

drum_pattern_4
    !byte 0001
    !byte 0
    !byte 0
    !byte 002
    !byte 0001
    !byte 0
    !byte 0
    !byte 002
    !byte 0001
    !byte 0
    !byte 0
    !byte 002
    !byte 0001
    !byte 0
    !byte 0
    !byte 002

drum_pattern_5
    !byte 0001
    !byte 0
    !byte 0
    !byte 0
    !byte 002
    !byte 0
    !byte 0
    !byte 0
    !byte 0001
    !byte 0
    !byte 0
    !byte 0
    !byte 002
    !byte 0
    !byte 0
    !byte 0

drum_pattern_6
    !byte 0
    !byte 0
    !byte 0001
    !byte 0
    !byte 0001
    !byte 0
    !byte 0
    !byte 0
    !byte 0
    !byte 0
    !byte 0001
    !byte 0
    !byte 0001
    !byte 0
    !byte 0
    !byte 0

drum_pattern_7
    !byte 0001
    !byte 0001
    !byte 0
    !byte 0
    !byte 0001
    !byte 0001
    !byte 0
    !byte 0
    !byte 0001
    !byte 0001
    !byte 0
    !byte 0
    !byte 0001
    !byte 0001
    !byte 0
    !byte 0

drum_pattern_8
    !byte 002
    !byte 0
    !byte 0001
    !byte 0
    !byte 002
    !byte 0
    !byte 0001
    !byte 0
    !byte 002
    !byte 0
    !byte 0001
    !byte 0
    !byte 002
    !byte 0
    !byte 0001
    !byte 0


    ; lda #$0A                    ; Instant Attack ($0-), Snappy Decay (-$A)
    ; sta V1_AD
    ; lda #$00                    ; Zero Sustain and release - crisp
    ; sta V1_SR
drum_ad_lut
    !byte $0A
    !byte $0F
    !byte $0A
    !byte $04
    !byte $1A
    !byte $8F
    !byte $4A
    !byte $26

drum_sr_lut
    !byte $00
    !byte $02
    !byte $00
    !byte $00
    !byte $28
    !byte $40
    !byte $13
    !byte $10

    ; ; Voice 2 (Melody): Instant Attack, Medium Release
    ; lda #$00
    ; sta V2_AD
    ; lda #$A4
    ; sta V2_SR

melody_ad_lut
    !byte $00
    !byte $10
    !byte $20
    !byte $30
    !byte $01
    !byte $02
    !byte $03
    !byte $64

melody_sr_lut
    !byte $A4
    !byte $A4
    !byte $A0
    !byte $A0
    !byte $24
    !byte $24
    !byte $9F
    !byte $97

    ; ; Voice 3 (Drone): Instant Attack, Infinite Sustain
    ; lda #$00
    ; sta V3_AD
    ; lda #$F0
    ; sta V3_SR

drone_ad_lut
    !byte $00
    !byte $10
    !byte $20
    !byte $30
    !byte $02
    !byte $04
    !byte $05
    !byte $82

drone_sr_lut
    !byte $F1
    !byte $F2
    !byte $F3
    !byte $E4
    !byte $F5
    !byte $A6
    !byte $F1
    !byte $FB

jump_sound_speed            ; 0 means i ASL other 2 ASL
    !byte $00

