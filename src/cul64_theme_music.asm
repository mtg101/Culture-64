; ==============================================================================
; PROCEDURAL MUSIC DRIVER (ACME ASSEMBLER)
; 100% Self-Contained, Zero-Page Free, Pure Register Math
; ==============================================================================

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
cfg_rhythm_mask:!byte 0         ; Rests configuration bitmask
cfg_bass_pitch: !byte 0         ; Root pitch for the drone

; ==============================================================================
; API ROUTINE: music_init
; Call this when entering a location to parse your seeds and reset the chip
; ==============================================================================
music_init:
    jsr LFSR_NEXT_SEED

    ; 1. Hard reset all SID registers to a clean state
    ldx #$1C
    lda #0
.clear_sid:
    sta SID_BASE, x
    dex
    bpl .clear_sid

    ; 2. Reset engine playback clocks
    sta clock_ticks
    sta step_counter

    ; 3. CRITICAL: Force audio paths open and set volume to maximum
    lda #$00
    sta FILTER_RES              ; Clear $D417 (Bypasses filter, forces V3 into output)
    lda SCREEN_SYSTEM_THEME_VOL
    sta VOLUME_RETI             ; Set $D418 to $0F (Max Volume, standard output)

    ; 4. DERIVE MUSIC ENGINE PARAMETERS FROM YOUR SEEDS
    
    ; Melody Init: Load High Byte of LFSR_W2. If 0, fallback to $7F so it shifts
    lda LFSR_W2 + 1
    bne .store_lfsr
    lda #$7F
.store_lfsr:
    sta runtime_lfsr

    ; Scale Picker: Use LFSR_W1 Low Byte to select 1 of 4 scales (0, 8, 16, 24)
    lda LFSR_W1
    and #%00000011
    asl
    asl
    asl
    sta cfg_scale_idx

    ; Rhythm Picker: Use LFSR_W1 High Byte as a pattern logic gate mask
    lda LFSR_W1 + 1
    sta cfg_rhythm_mask

    ; Bass Drone Picker: Use LFSR_W0 Low Byte to choose a steady root room key
    lda LFSR_W0
    and #$07                    ; Select notes 0-7 from the active scale
    clc
    adc cfg_scale_idx
    tax
    lda table_scales, x
    lsr                         ; Drop 2 octaves for sub-bass feel
    lsr
    bne .store_bass
    lda #$05                    ; Prevent silent 0 frequency fallback
.store_bass:
    sta cfg_bass_pitch

    ; 5. CONFIGURE ADSR ENVELOPES

    ; Voice 1 (Noise Drum): Instant Attack, snappy decay phase
    lda #$0A                    ; Instant Attack ($0-), Snappy Decay (-$A)
    sta V1_AD
    lda #$08                    ; Zero Sustain ($0-), Short crisp Release (-$8)
    sta V1_SR

    ; Voice 2 (Melody): Instant Attack, Medium Release
    lda #$00
    sta V2_AD
    lda #$A4
    sta V2_SR

    ; Voice 3 (Drone): Instant Attack, Infinite Sustain
    lda #$00
    sta V3_AD
    lda #$F0
    sta V3_SR

    rts

; ==============================================================================
; API ROUTINE: music_play_frame
; Call this exactly once per frame inside your raster interrupt
; ==============================================================================
music_play_frame:
    inc clock_ticks
    lda clock_ticks
    and #$07                    ; Speed controller: Step sequencer every 8 frames
    beq .run_sequencer
    rts                         ; Exit early if not a step boundary

.run_sequencer:
    lda #0
    sta clock_ticks             ; Reset frame accumulator

    ; Advance sequencer loop (0 to 15 step count)
    lda step_counter
    clc
    adc #1
    and #$0F
    sta step_counter

    ; --------------------------------------------------------------------------
    ; CHANNEL 1: THE BEAT (TRUE NOISE KICK-START EDITION)
    ; --------------------------------------------------------------------------
    lda step_counter
    and #$03
    bne .decay_drum             ; If not on the beat, branch to gate off

    ; STRIKE DRUM (Steps 0, 4, 8, 12)
    ; Step A: Set pitch low so the noise has a heavy, bassy rumble
    lda #$00
    sta V1_FREQ_LO
    lda #$12                    ; Low frequency register placement
    sta V1_FREQ_HI
    
    ; Step B: THE KICK-START TRICK
    ; Briefly pulse a Triangle wave to wake up the internal oscillators
    lda #$10                    ; Triangle Wave, Gate OFF
    sta V1_CTRL
    
    ; Step C: Immediately slam it into Noise mode + Gate ON
    lda #$81                    ; Noise Waveform ($80) + Gate ON ($01)
    sta V1_CTRL
    jmp .channel2_melody

.decay_drum:
    ; On steps 1, 2, 3 we drop the gate to let the ADSR release phase finish
    lda #$80                    ; Noise Waveform ($80) + Gate OFF ($00)
    sta V1_CTRL

    ; --------------------------------------------------------------------------
    ; CHANNEL 2: THE MELODY (LFSR SEQUENCER)
    ; --------------------------------------------------------------------------
.channel2_melody:
    ; Galois LFSR T-State Step Shift (Standard Max-Length Tap $B8)
    lda runtime_lfsr
    lsr
    bcc .no_lfsr_feedback
    eor #$B8
.no_lfsr_feedback:
    sta runtime_lfsr

    ; Evaluate rhythm seed mask to decide if this note plays or rests
    lda step_counter
    and #$07                    ; Transform step counter to 0-7 bit position
    tax
    lda table_bit_masks, x
    and cfg_rhythm_mask
    beq .melody_rest            ; If mask bit is 0, skip note trigger

    ; Translate LFSR math into note scale frequencies
    lda runtime_lfsr
    and #$07                    ; Limit index to 0-7
    clc
    adc cfg_scale_idx           ; Add active scale offset
    tax

    lda table_scales, x
    sta V2_FREQ_HI              ; Set melody pitch High Byte
    lda #$00
    sta V2_FREQ_LO              ; Clear Low Byte

    lda #$21                    ; Sawtooth Waveform + Gate ON
    sta V2_CTRL
    jmp .channel3_drone

.melody_rest:
    lda #$20                    ; Sawtooth Waveform + Gate OFF (Release phase)
    sta V2_CTRL

    ; --------------------------------------------------------------------------
    ; CHANNEL 3: THE DRONE (STEADY AMBIENT PAD)
    ; --------------------------------------------------------------------------
.channel3_drone:
    ; Voice 3 plays a continuous, un-interrupted background room root key
    lda #$00
    sta V3_FREQ_LO
    lda cfg_bass_pitch
    sta V3_FREQ_HI

    lda #$11                    ; Triangle Waveform + Gate ON (Smooth low drone)
    sta V3_CTRL

    rts

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