; ==============================================================================
; PROCEDURAL MUSIC DRIVER (ACME ASSEMBLER)
; 100% Self-Contained, Zero-Page Free, Pure Register Math
; ==============================================================================


; ==============================================================================
; API ROUTINE: music_init
; Call this when entering a location to parse your seeds and reset the chip
; ==============================================================================
music_init:
    ; un pause music from jump
    lda #0
    sta SCREEN_SYSTEM_MUSIC_JUMPING

    ; next seed
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

    ; --------------------------------------------------------------------------
    ; UPDATED FILTER ROUTING
    ; --------------------------------------------------------------------------
    ; Register $D417 (FILTER_RES):
    ; Bit 7-4: Resonance amount (Let's set it to $4 for a nice wet synth sound)
    ; Bit 2: Filter Voice 3 (1 = Route through filter!)
    ; Bit 1: Filter Voice 2 (1 = Route through filter!)
    ; Bit 0: Filter Voice 1 (0 = Keep drum clean and unfiltered)
    lda #%01000110              ; Resonance $4 + Route Voice 2 & 3
    sta FILTER_RES              ; $D417

    ; Register $D418 (VOLUME_RETI):
    ; Bit 4: Low-Pass Filter Mode (1 = ON)
    ; Bit 3-0: Master Volume (Start at Max $0F)
    lda #%00011111              ; Low-Pass Mode ($10) + Max Volume ($0F)
    sta VOLUME_RETI             ; $D418

    ; 4. DERIVE MUSIC ENGINE PARAMETERS FROM YOUR SEEDS
    
    ; Melody Init: If 0, fallback to $7F so it shifts
    lda LFSR_W0
    bne .store_lfsr
    lda #$7F
.store_lfsr:
    sta runtime_lfsr

    ; Scale Picker
    lda LFSR_W0+1
    and #%00000011
    asl
    asl
    asl
    sta cfg_scale_idx

    ; Rhythm Picker
    lda LFSR_W1
;    ora #%10001000              ; force melody notes on bars
    sta cfg_rhythm_mask_1
    lda LFSR_W1+1
;    ora #%10001000              ; force melody notes on bars
    sta cfg_rhythm_mask_2

    ; Bass Drone Picker 1
    lda LFSR_W2
    and #$07                    ; Select notes 0-7 from the active scale
    clc
    adc cfg_scale_idx
    tax
    lda table_scales, x
    lsr                         ; Drop 2 octaves for sub-bass feel
    lsr
    bne +
    lda #$05                    ; Prevent silent 0 frequency fallback
+
    sta cfg_bass_pitch_1

    ; Bass Drone Picker 2
    lda LFSR_W2+1
    and #$07                    ; Select notes 0-7 from the active scale
    clc
    adc cfg_scale_idx
    tax
    lda table_scales, x
    lsr                         ; Drop 2 octaves for sub-bass feel
    lsr
    bne +
    lda #$05                    ; Prevent silent 0 frequency fallback
+
    sta cfg_bass_pitch_2

    ; 5. CONFIGURE ADSR ENVELOPES
    jsr LFSR_NEXT_SEED      ; and again

    ; drum stuff  variants
    lda LFSR_W0
    and #%00000111              ; 0=7
    tax
    lda drum_ad_lut, x
    sta V1_AD

    lda LFSR_W0+1
    and #%00000111              ; 0=7
    tax
    lda drum_sr_lut, x
    sta V1_SR

    ; Voice 2 (Melody): Instant Attack, Medium Release variants
    lda LFSR_W1
    and #%00000111              ; 0=7
    tax
    lda melody_ad_lut, x
    sta V2_AD

    lda LFSR_W1+1
    and #%00000111              ; 0=7
    tax
    lda melody_sr_lut, x
    sta V2_SR

    ; Voice 3 (Drone): Instant Attack, Infinite Sustain variants
    lda LFSR_W2
    and #%00000111              ; 0=7
    tax
    lda drone_ad_lut, x
    sta V3_AD

    lda LFSR_W2+1
    and #%00000111              ; 0=7
    tax
    lda drone_sr_lut, x
    sta V3_SR

    jsr LFSR_NEXT_SEED      ; and again

    ; drum pattern
    lda LFSR_W0
    and #%00000111          ; 0-7
    tax
    lda drum_pattern_lut_low, x 
    sta drum_pattern_ptr
    lda drum_pattern_lut_high, x 
    sta drum_pattern_ptr+1

    ; melody instrument
    lda LFSR_W0+1
    and #%00000111          ; 0-7
    tax 
    lda melody_instrument_lut, x
    sta melody_instrument

    ; drone instrument
    lda LFSR_W1
    and #%00000111          ; 0-7
    tax 
    lda drone_instrument_lut, x
    sta drone_instrument

    rts

; ==============================================================================
; API ROUTINE: music_play_frame
; Call this exactly once per frame inside your raster interrupt
; ==============================================================================
music_play_frame:
    ; only if music is on
    lda SCREEN_SYSTEM_MUSIC_ON
    bne +
    ; music is off
    lda #$00
    sta VOLUME_RETI             ; volume off
    rts                         
+    
    ; music is on
    ; but not while jumping
    lda SCREEN_SYSTEM_MUSIC_JUMPING
    beq +
    jsr sfx_update_frame_warp
    rts                         
+    

    ; --------------------------------------------------------------------------
    ; DYNAMIC DRONE OSCILLATOR (RUNS EVERY FRAME)
    ; --------------------------------------------------------------------------
    ; We read the rapid frame counter to create a running LFO (Low Frequency Oscillator)
    lda clock_ticks
    asl                         ; Multiply by 2 to make the oscillation faster
    and #$3F                    ; Squelch it to a repeating 0-63 triangle ramp range
    cmp #$20                    ; Symmetrical fold-back mirror check
    bcc .ramp_up
    eor #$3F                    ; Flip the wave to create a clean triangle LFO shape
.ramp_up:
    ; A now contains a smoothly oscillating value from 0 to 31
    
    ; 1. APPLY FILTER CUTOFF SWEEP
    ; Push our oscillating value into the high byte of the filter cutoff.
    ; This opens and closes the tone, making it sound "wet" and breathing.
    clc
    adc #$15                    ; Add a baseline so the filter never closes completely
    sta SID_BASE + 22           ; $D416 - Filter Cutoff Frequency High

    ; 2. APPLY THE PUMPING VOLUME TREMOLO
    ; We map our frame counter directly to the step tracker to duck the volume.
    ; If the drum is about to hit (step_counter sub-beat low), drop the volume.
    lda step_counter
    and #$03
    bne .volume_swell           ; If not a drum step, swell the volume up
    
    ; Drum hit frame: Slam master volume down for heavy side-chain compression thud
    lda #%00011000              ; Low-Pass Mode ON ($10) + Med Volume ($08)
    sta VOLUME_RETI
    jmp .apply_done

.volume_swell:
    ; Between beats: Open the master volume back up to max
    lda #%00011111              ; Low-Pass Mode ON ($10) + Max Volume ($0F)
    sta VOLUME_RETI

.apply_done:
    ; --------------------------------------------------------------------------
    ; STANDARD TEMPO CLOCK CHECK
    ; --------------------------------------------------------------------------
    inc clock_ticks
    lda clock_ticks
    and #$07
    beq .run_sequencer
    ; kill that drum noise
    lda #$80                    ; Noise Waveform ($80) + Gate OFF ($00)
    sta V1_CTRL
    rts
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
    ; CHANNEL 1: THE BEAT 
    ; --------------------------------------------------------------------------
    lda step_counter        ; 0-15
    tay

    lda drum_pattern_ptr
    sta ZP_PTR_1
    lda drum_pattern_ptr+1
    sta ZP_PTR_1_PAIR

    lda (ZP_PTR_1), y
    beq .skip_drum         ; not playing this beat   

    cmp #2
    beq +                    ; playing bass

    ; SNARE DRUM
    lda #$00
    sta V1_FREQ_LO
    lda #$40                    ; Low frequency register placement
    sta V1_FREQ_HI
    jmp ++
+    
    ; BASS DRUM
    lda #$00
    sta V1_FREQ_LO
    lda #$09                    ; Low frequency register placement
    sta V1_FREQ_HI

++
    ; Step B: THE KICK-START TRICK
    ; Briefly pulse a Triangle wave to wake up the internal oscillators
    lda #$10                    ; Triangle Wave, Gate OFF
    sta V1_CTRL
    
    ; Step C: Immediately slam it into Noise mode + Gate ON
    lda #$81                    ; Noise Waveform ($80) + Gate ON ($01)
    sta V1_CTRL
    jmp .channel2_melody

.skip_drum:

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
    cmp #8
    bcc +                       
    ; second rhythm
    and #$07                    ; Transform step counter to 0-7 bit position
    tax
    lda table_bit_masks, x
    and cfg_rhythm_mask_2
    jmp ++
+
    ; first rhythm
    and #$07                    ; Transform step counter to 0-7 bit position
    tax
    lda table_bit_masks, x
    and cfg_rhythm_mask_1
++

    beq .melody_rest            ; If mask bit is 0, skip note trigger

    ; WEIGHTED PITCH CHOICE
    ; Isolate a 3-bit slice from the LFSR (Value 0 to 7)
    lda runtime_lfsr
    and #%00000111
    
    ; Branch table logic based on the 0-7 result
    cmp #3
    bcc .move_up_one            ; 0, 1, 2 -> Go up 1 step
    
    cmp #6
    bcc .move_down_one          ; 3, 4, 5 -> Go down 1 step
    
    cmp #6
    beq .leap_up_two            ; 6       -> Expressive leap up 2 steps
    
    jmp .apply_pitch            ; 7       -> Stay on the same note (0 movement)

.move_up_one:
    inc last_note_idx
    jmp .clamp_bounds

.move_down_one:
    dec last_note_idx
    jmp .clamp_bounds

.leap_up_two:
    lda last_note_idx
    clc
    adc #2                      ; Jump up two scale degrees
    sta last_note_idx

.clamp_bounds:
    ; Force our running scale index to stay bounded strictly between 0 and 7
    lda last_note_idx
    and #$07                    ; Clean wraps from 7->0 or 0->7
    sta last_note_idx

.apply_pitch:
    ; Combine our relative note index with the base scale offset
    lda last_note_idx
    clc
    adc cfg_scale_idx
    tax

    lda table_scales, x
    sta V2_FREQ_HI              ; Set melody pitch High Byte
    lda #$00
    sta V2_FREQ_LO              ; Clear Low Byte

    lda melody_instrument
    sta V2_CTRL
    jmp .channel3_drone

.melody_rest:
    lda melody_instrument
    and #%11111110          ; gate off
    sta V2_CTRL

    ; --------------------------------------------------------------------------
    ; CHANNEL 3: THE DRONE (STEADY AMBIENT PAD)
    ; --------------------------------------------------------------------------
.channel3_drone:
    ; Voice 4 plays base, changes every 8 beats
    lda #$00
    sta V3_FREQ_LO

    ; assume first note
    lda cfg_bass_pitch_1
    sta V3_FREQ_HI

    ; second note if needed
    lda step_counter
    cmp #8
    bcc +               ; it was less than 8 for stick with first note

    lda cfg_bass_pitch_2
    sta V3_FREQ_HI

+

    lda drone_instrument
    sta V3_CTRL

    rts


; ==============================================================================
; Call this the exact frame the player initiates the jump
; seed needs to set from ship's seed for ship=based jump sound
; ==============================================================================
sfx_trigger_warp:
    lda LFSR_W0                     
    and #%00000110          ; always even it seems? so use middle and shift
    lsr
    sta jump_sound_speed    ; 0-3

    lda #%01000000              ; Resonance $4 + NOT Route Voice 2 & 3
    sta FILTER_RES              ; $D417

    ; 1. Set effect duration - 30 frames (~0.5 second - 50hz won't be too long)
    lda LFSR_W1
    and #%00111111          ; 0-63
    clc
    adc #10                 ; 10-73
    sta warp_timer
    sta warp_timer_start

    ; 2. Ensure Master Volume is wide open
    lda #$0F
    sta VOLUME_RETI

    ; 3. Setup Voice Envelopes
    lda #$00                    ; Instant Attack
    sta V1_AD
    sta V2_AD
    sta V3_AD
    lda #$F0                    ; Full Sustain
    sta V1_SR
    sta V2_SR
    sta V3_SR

    ; 5. Set initial starting frequencies -low to rise during jump
    lda #$00
    sta V1_FREQ_LO
    sta V1_FREQ_HI              
    sta V2_FREQ_LO
    sta V2_FREQ_HI
    sta V3_FREQ_LO
    sta V3_FREQ_HI

    ; 6. Gate both voices ON
    lda #%00100001              ; Sawtooth + Gate ON voice 1
    sta V1_CTRL
    lda #%00010001              ; triangle + Gate ON voice 2
    sta V2_CTRL
    lda #%10000001              ; noise + Gate ON voice 3
    sta V3_CTRL

    rts


; ==============================================================================
; play sfx warp
; ==============================================================================
sfx_update_frame_warp:
    lda warp_timer
    bne .process_sfx            ; If timer > 0, update the sound
    rts                         ; Otherwise, exit immediately

.process_sfx:
    dec warp_timer              ; Count down to 0
    bne .calculate_sweep        ; If it hasn't hit 0, calculate the sweep
    
    ; --- EFFECT ENDS ---
    lda #$00                    ; Gate OFF Voice 1
    sta V1_CTRL
    lda #$00                    ; Gate OFF Voice 2
    sta V2_CTRL
    lda #$00                    ; Gate OFF Voice 3
    sta V3_CTRL
    rts

.calculate_sweep:
    ; --- DYNAMIC FREQUENCY ACCELERATION ---
    ; To make the jump feel like it accelerates, we calculate the sweep using:
    ; Current Pitch = (30 - warp_timer)
    ; This creates a linear upward ramp.
    lda warp_timer_start
    sec
    sbc warp_timer              ; A now goes from 1 (start) to 59 (end)
    
    ; Shift left to multiply by 0/2/4/8 to make the pitch climb rapidly differently

    ldx jump_sound_speed
.sweep_speed_loop:
    asl
    dex
    bmi +
    jmp .sweep_speed_loop
+
    sta V1_FREQ_HI              ; Slam it straight into Voice 1's pitch
    ; Optional: Add a bit of texture to the low byte to create ring vibrato
    sta V1_FREQ_LO

    sta V2_FREQ_HI              ; Slam it straight into Voice 1's pitch
    ; Optional: Add a bit of texture to the low byte to create ring vibrato
    sta V2_FREQ_LO

    sta V3_FREQ_HI              ; Slam it straight into Voice 1's pitch
    ; Optional: Add a bit of texture to the low byte to create ring vibrato
    sta V3_FREQ_LO


    ; --- GRADUAL NOISE DECAY OVERRIDE ---
    ; Slowly drop the Noise gate halfway through to keep it clean
    ; lda warp_timer
    ; cmp #15                     ; Halfway mark (0.5 seconds in)
    ; bne .exit
    
    ; lda #$80                    ; Force Gate OFF on Noise to let it bleed out
    ; sta V2_CTRL

.exit:
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

