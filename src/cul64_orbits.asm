



ORBITS_GENERATE:
    jsr LFSR_NEXT_SEED              ; own value

    ; slot 1
    lda LFSR_W0
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda ORBITS_DIST, x
    sta ORBITS_SLOT_1

    ; slot 2
    lda LFSR_W0+1
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda ORBITS_DIST, x
    sta ORBITS_SLOT_2

    ; slot 3
    lda LFSR_W1
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda ORBITS_DIST, x
    sta ORBITS_SLOT_3

    ; slot 4
    lda LFSR_W1+1
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda ORBITS_DIST, x
    sta ORBITS_SLOT_4

    ; slot 5
    lda LFSR_W2
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda ORBITS_DIST, x
    sta ORBITS_SLOT_5

    ; slot 6
    lda LFSR_W2+1
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda ORBITS_DIST, x
    sta ORBITS_SLOT_6

    jsr LFSR_NEXT_SEED              ; need new seeds...

    ; slot 7
    lda LFSR_W0
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda ORBITS_DIST, x
    sta ORBITS_SLOT_7

    ; slot 8
    lda LFSR_W0+1
    and #%00011111              ; 0-31
    tax                         ; offset in x
    lda ORBITS_DIST, x
    sta ORBITS_SLOT_8

    jsr ORBITS_GENERATE_SLOTS

    rts

ORBITS_GENERATE_SLOTS:
    ; blank all buffers
    lda #0
    sta ORBITS_SLOT_1_BUFFER
    sta ORBITS_SLOT_2_BUFFER
    sta ORBITS_SLOT_3_BUFFER
    sta ORBITS_SLOT_4_BUFFER
    sta ORBITS_SLOT_5_BUFFER
    sta ORBITS_SLOT_6_BUFFER
    sta ORBITS_SLOT_7_BUFFER
    sta ORBITS_SLOT_8_BUFFER

    lda #0
    sta ORBITS_DYSON_SWARM

ORBITS_GENERATE_SLOT_1:
    lda ORBITS_SLOT_1
    beq +                       ; empty

    ; jump table and return
    tax                         ; x has index
    lda ORBITS_JUMP_TABLE_LO, x
    sta ZP_PTR_JUMP
    lda ORBITS_JUMP_TABLE_HI, x
    sta ZP_PTR_JUMP_PAIR
    lda #<ORBITS_GENERATE_SLOT_2
    sta ZP_PTR_RETURN
    lda #>ORBITS_GENERATE_SLOT_2
    sta ZP_PTR_RETURN_PAIR

    ; props and slot to pass
    lda #<ORBITS_SLOT_1_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_1_PROPS
    sta ZP_PTR_1_PAIR
    lda #0
    sta ORBITS_CURRENT_SLOT
    lda #<ORBITS_SLOT_1_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_1_BUFFER
    sta ZP_PTR_2_PAIR

    jmp (ZP_PTR_JUMP)               ; will jmp back to ZP_PTR_RETURN
+
    ; empty but if it's kardy ii+ maybe a dyson swarm!
    lda SCREEN_SYSTEM_TECH_LEVEL
    cmp #4                          ; 0-3 below kard ii level for dyson
    bcc ORBITS_GENERATE_SLOT_2

    ; empty slot 1, and tech enough for a dyson swarm!
    lda LFSR_W1
    and #%00000001
    bne ORBITS_GENERATE_SLOT_2      ; 50% dyson swarm
    lda #1
    sta ORBITS_DYSON_SWARM

    ; src
    lda #<ORBITS_DYSON_SWARM_LABEL
    sta ZP_PTR_1
    lda #>ORBITS_DYSON_SWARM_LABEL
    sta ZP_PTR_1_PAIR
    ; dest
    lda #<ORBITS_SLOT_1_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_1_BUFFER
    sta ZP_PTR_2_PAIR
    jsr SYS_MEM_COPY    

ORBITS_GENERATE_SLOT_2:
    lda ORBITS_SLOT_2
    beq +                       ; empty
    ; jump table and return
    tax                         ; x has index
    lda ORBITS_JUMP_TABLE_LO, x
    sta ZP_PTR_JUMP
    lda ORBITS_JUMP_TABLE_HI, x
    sta ZP_PTR_JUMP_PAIR
    lda #<ORBITS_GENERATE_SLOT_3
    sta ZP_PTR_RETURN
    lda #>ORBITS_GENERATE_SLOT_3
    sta ZP_PTR_RETURN_PAIR

    ; props and slot to pass
    lda #<ORBITS_SLOT_2_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_2_PROPS
    sta ZP_PTR_1_PAIR
    lda #1
    sta ORBITS_CURRENT_SLOT
    lda #<ORBITS_SLOT_2_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_2_BUFFER
    sta ZP_PTR_2_PAIR

    jmp (ZP_PTR_JUMP)               ; will jmp back to ZP_PTR_RETURN
+
ORBITS_GENERATE_SLOT_3:
    lda ORBITS_SLOT_3
    beq +                       ; empty
    ; jump table and return
    tax                         ; x has index
    lda ORBITS_JUMP_TABLE_LO, x
    sta ZP_PTR_JUMP
    lda ORBITS_JUMP_TABLE_HI, x
    sta ZP_PTR_JUMP_PAIR
    lda #<ORBITS_GENERATE_SLOT_4
    sta ZP_PTR_RETURN
    lda #>ORBITS_GENERATE_SLOT_4
    sta ZP_PTR_RETURN_PAIR

    ; props and slot to pass
    lda #<ORBITS_SLOT_3_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_3_PROPS
    sta ZP_PTR_1_PAIR
    lda #2
    sta ORBITS_CURRENT_SLOT
    lda #<ORBITS_SLOT_3_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_3_BUFFER
    sta ZP_PTR_2_PAIR

    jmp (ZP_PTR_JUMP)               ; will jmp back to ZP_PTR_RETURN
+
ORBITS_GENERATE_SLOT_4:
    lda ORBITS_SLOT_4
    beq +                       ; empty
    ; jump table and return
    tax                         ; x has index
    lda ORBITS_JUMP_TABLE_LO, x
    sta ZP_PTR_JUMP
    lda ORBITS_JUMP_TABLE_HI, x
    sta ZP_PTR_JUMP_PAIR
    lda #<ORBITS_GENERATE_SLOT_5
    sta ZP_PTR_RETURN
    lda #>ORBITS_GENERATE_SLOT_5
    sta ZP_PTR_RETURN_PAIR

    ; props and slot to pass
    lda #<ORBITS_SLOT_4_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_4_PROPS
    sta ZP_PTR_1_PAIR
    lda #3
    sta ORBITS_CURRENT_SLOT
    lda #<ORBITS_SLOT_4_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_4_BUFFER
    sta ZP_PTR_2_PAIR

    jmp (ZP_PTR_JUMP)               ; will jmp back to ZP_PTR_RETURN
+
ORBITS_GENERATE_SLOT_5:
    lda ORBITS_SLOT_5
    beq +                       ; empty
    ; jump table and return
    tax                         ; x has index
    lda ORBITS_JUMP_TABLE_LO, x
    sta ZP_PTR_JUMP
    lda ORBITS_JUMP_TABLE_HI, x
    sta ZP_PTR_JUMP_PAIR
    lda #<ORBITS_GENERATE_SLOT_6
    sta ZP_PTR_RETURN
    lda #>ORBITS_GENERATE_SLOT_6
    sta ZP_PTR_RETURN_PAIR

    ; props and slot to pass
    lda #<ORBITS_SLOT_5_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_5_PROPS
    sta ZP_PTR_1_PAIR
    lda #4
    sta ORBITS_CURRENT_SLOT
    lda #<ORBITS_SLOT_5_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_5_BUFFER
    sta ZP_PTR_2_PAIR

    jmp (ZP_PTR_JUMP)               ; will jmp back to ZP_PTR_RETURN
+
ORBITS_GENERATE_SLOT_6:
    lda ORBITS_SLOT_6
    beq +                       ; empty
    ; jump table and return
    tax                         ; x has index
    lda ORBITS_JUMP_TABLE_LO, x
    sta ZP_PTR_JUMP
    lda ORBITS_JUMP_TABLE_HI, x
    sta ZP_PTR_JUMP_PAIR
    lda #<ORBITS_GENERATE_SLOT_7
    sta ZP_PTR_RETURN
    lda #>ORBITS_GENERATE_SLOT_7
    sta ZP_PTR_RETURN_PAIR

    ; props and slot to pass
    lda #<ORBITS_SLOT_6_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_6_PROPS
    sta ZP_PTR_1_PAIR
    lda #5
    sta ORBITS_CURRENT_SLOT
    lda #<ORBITS_SLOT_6_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_6_BUFFER
    sta ZP_PTR_2_PAIR

    jmp (ZP_PTR_JUMP)               ; will jmp back to ZP_PTR_RETURN
+
ORBITS_GENERATE_SLOT_7:
    lda #7
    sta ORBITS_CURRENT_SLOT
    lda ORBITS_SLOT_7
    beq +                       ; empty
    ; jump table and return
    tax                         ; x has index
    lda ORBITS_JUMP_TABLE_LO, x
    sta ZP_PTR_JUMP
    lda ORBITS_JUMP_TABLE_HI, x
    sta ZP_PTR_JUMP_PAIR
    lda #<ORBITS_GENERATE_SLOT_8
    sta ZP_PTR_RETURN
    lda #>ORBITS_GENERATE_SLOT_8
    sta ZP_PTR_RETURN_PAIR

    ; props and slot to pass
    lda #<ORBITS_SLOT_7_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_7_PROPS
    sta ZP_PTR_1_PAIR
    lda #6
    sta ORBITS_CURRENT_SLOT
    lda #<ORBITS_SLOT_7_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_7_BUFFER
    sta ZP_PTR_2_PAIR

    jmp (ZP_PTR_JUMP)               ; will jmp back to ZP_PTR_RETURN
+
ORBITS_GENERATE_SLOT_8:
    lda #8
    sta ORBITS_CURRENT_SLOT
    lda ORBITS_SLOT_8
    beq +                       ; empty
    ; jump table and return
    tax                         ; x has index
    lda ORBITS_JUMP_TABLE_LO, x
    sta ZP_PTR_JUMP
    lda ORBITS_JUMP_TABLE_HI, x
    sta ZP_PTR_JUMP_PAIR
    lda #<ORBITS_GENERATE_SLOT_DONE
    sta ZP_PTR_RETURN
    lda #>ORBITS_GENERATE_SLOT_DONE
    sta ZP_PTR_RETURN_PAIR

    ; props and slot to pass
    lda #<ORBITS_SLOT_8_PROPS
    sta ZP_PTR_1
    lda #>ORBITS_SLOT_8_PROPS
    sta ZP_PTR_1_PAIR
    lda #7
    sta ORBITS_CURRENT_SLOT
    lda #<ORBITS_SLOT_8_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_8_BUFFER
    sta ZP_PTR_2_PAIR

    jmp (ZP_PTR_JUMP)               ; will jmp back to ZP_PTR_RETURN
+
ORBITS_GENERATE_SLOT_DONE:
    jsr LFSR_NEXT_SEED          ; planets used it

    lda #0
    sta ORBITS_OORT_CLOUD

    lda ORBITS_SLOT_7
    bne .no_oort
    lda ORBITS_SLOT_8
    bne .no_oort

    ; so slots 7 and 8 are empty : oort cloud always (it's rare!)
    jsr CLOUDS_SHOW_OORT

    ; src
    lda #<ORBITS_OORT_CLOUD_LABEL
    sta ZP_PTR_1
    lda #>ORBITS_OORT_CLOUD_LABEL
    sta ZP_PTR_1_PAIR
    ; dest
    lda #<ORBITS_SLOT_8_BUFFER
    sta ZP_PTR_2
    lda #>ORBITS_SLOT_8_BUFFER
    sta ZP_PTR_2_PAIR
    jsr SYS_MEM_COPY    


.no_oort
    jsr ORBITS_GENERATE_MOONS

    rts 

ORBITS_DYSON_SWARM_SHOW:
    lda #0
    sta TEXT_Y
    lda SUN_COLOR
    sta TEXT_COLOR

; top 
    lda #77
    sta TEXT_CHAR

    lda #4
    sta TEXT_X
    jsr TEXT_DRAW_CHAR
    inc TEXT_Y
    lda #4
    sta TEXT_X
    jsr TEXT_DRAW_CHAR
    inc TEXT_X
    jsr TEXT_DRAW_CHAR
    inc TEXT_Y
    lda #4
    sta TEXT_X
    jsr TEXT_DRAW_CHAR
    inc TEXT_X
    jsr TEXT_DRAW_CHAR
    inc TEXT_X
    jsr TEXT_DRAW_CHAR

; mid
    inc TEXT_Y
    lda #41
    sta TEXT_CHAR
.dyson_loop_mid:
    lda #4
    sta TEXT_X
    jsr TEXT_DRAW_CHAR
    inc TEXT_X
    jsr TEXT_DRAW_CHAR
    inc TEXT_X
    jsr TEXT_DRAW_CHAR
    inc TEXT_Y
    lda TEXT_Y
    cmp #12
    beq +
    jmp .dyson_loop_mid
+

; bot
    lda #78
    sta TEXT_CHAR

    lda #4
    sta TEXT_X
    jsr TEXT_DRAW_CHAR
    inc TEXT_X
    jsr TEXT_DRAW_CHAR
    inc TEXT_X
    jsr TEXT_DRAW_CHAR

    inc TEXT_Y
    lda #4
    sta TEXT_X
    jsr TEXT_DRAW_CHAR
    inc TEXT_X
    jsr TEXT_DRAW_CHAR

    inc TEXT_Y
    lda #4
    sta TEXT_X
    jsr TEXT_DRAW_CHAR


    rts 

ORBITS_GENERATE_MOONS:
    jsr LFSR_NEXT_SEED      ; fresh set

    lda #0
    sta ORBITS_SLOT_3_MOON_1    ; blank it
    lda ORBITS_SLOT_3
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W0
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W0+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_3_MOON_1    
+
    lda #0
    sta ORBITS_SLOT_3_MOON_2    ; blank it
    lda ORBITS_SLOT_3
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W1
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W1+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_3_MOON_2    
+
    
    jsr LFSR_NEXT_SEED      ; fresh set

    lda #0
    sta ORBITS_SLOT_4_MOON_1    ; blank it
    lda ORBITS_SLOT_4
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W0
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W0+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_4_MOON_1    
+
    lda #0
    sta ORBITS_SLOT_4_MOON_2    ; blank it
    lda ORBITS_SLOT_4
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W1
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W1+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_4_MOON_2    
+

    jsr LFSR_NEXT_SEED      ; fresh set

    lda #0
    sta ORBITS_SLOT_5_MOON_1    ; blank it
    lda ORBITS_SLOT_5
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W0
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W0+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_5_MOON_1    
+
    lda #0
    sta ORBITS_SLOT_5_MOON_2    ; blank it
    lda ORBITS_SLOT_5
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W1
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W1+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_5_MOON_2    
+

    jsr LFSR_NEXT_SEED      ; fresh set

    lda #0
    sta ORBITS_SLOT_5_MOON_3    ; blank it
    lda ORBITS_SLOT_5
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W0
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W0+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_5_MOON_3    
+
    lda #0
    sta ORBITS_SLOT_5_MOON_4    ; blank it
    lda ORBITS_SLOT_5
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W1
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W1+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_5_MOON_4    
+

    jsr LFSR_NEXT_SEED      ; fresh set

    lda #0
    sta ORBITS_SLOT_6_MOON_1    ; blank it
    lda ORBITS_SLOT_6
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W0
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W0+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_6_MOON_1    
+
    lda #0
    sta ORBITS_SLOT_6_MOON_2    ; blank it
    lda ORBITS_SLOT_6
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W1
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W1+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_6_MOON_2    
+

    jsr LFSR_NEXT_SEED      ; fresh set

    lda #0
    sta ORBITS_SLOT_6_MOON_3    ; blank it
    lda ORBITS_SLOT_6
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W0
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W0+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_6_MOON_3    
+
    lda #0
    sta ORBITS_SLOT_6_MOON_4    ; blank it
    lda ORBITS_SLOT_6
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W1
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W1+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_6_MOON_4    
+

    jsr LFSR_NEXT_SEED      ; fresh set

    lda #0
    sta ORBITS_SLOT_7_MOON_1    ; blank it
    lda ORBITS_SLOT_7
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W0
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W0+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_7_MOON_1    
+
    lda #0
    sta ORBITS_SLOT_7_MOON_2    ; blank it
    lda ORBITS_SLOT_7
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W1
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W1+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_7_MOON_2    
+

    jsr LFSR_NEXT_SEED      ; fresh set

    lda #0
    sta ORBITS_SLOT_7_MOON_3    ; blank it
    lda ORBITS_SLOT_7
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W0
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W0+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_7_MOON_3    
+
    lda #0
    sta ORBITS_SLOT_7_MOON_4    ; blank it
    lda ORBITS_SLOT_7
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W1
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W1+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_7_MOON_4    
+

    jsr LFSR_NEXT_SEED      ; fresh set

    lda #0
    sta ORBITS_SLOT_8_MOON_1    ; blank it
    lda ORBITS_SLOT_8
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W0
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W0+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_8_MOON_1    
+
    lda #0
    sta ORBITS_SLOT_8_MOON_2    ; blank it
    lda ORBITS_SLOT_8
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W1
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W1+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_8_MOON_2    
+

    jsr LFSR_NEXT_SEED      ; fresh set

    lda #0
    sta ORBITS_SLOT_8_MOON_3    ; blank it
    lda ORBITS_SLOT_8
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W0
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W0+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_8_MOON_3    
+
    lda #0
    sta ORBITS_SLOT_8_MOON_4    ; blank it
    lda ORBITS_SLOT_8
    cmp #1
    bne +                       ; no planet, so no moons
    lda LFSR_W1
    and #%00000001
    beq +                       ; 50% no moon
    lda LFSR_W1+1               ; hmm 1 in 8 moons are there but invisible black...
    sta ORBITS_SLOT_8_MOON_4    
+

    rts


ORBITS_SHOW_SLOTS:
    ; not showing status to start
    lda #0
    sta ORBITS_INFO_STATUS

    jsr PLANETS_LOAD_UDGS       ; load every time as we're procgen hacking the planet colors

    lda ORBITS_DYSON_SWARM
    beq +
    jsr ORBITS_DYSON_SWARM_SHOW
+
ORBITS_SHOW_SLOT_1:
    lda ORBITS_SLOT_1
    beq +                       ; empty
    ; jump table and return
    tax                         ; x has index
    lda ORBITS_JUMP_TABLE_SLOT_1_LO, x
    sta ZP_PTR_JUMP
    lda ORBITS_JUMP_TABLE_SLOT_1_HI, x
    sta ZP_PTR_JUMP_PAIR
    lda #<ORBITS_SHOW_SLOT_2
    sta ZP_PTR_RETURN
    lda #>ORBITS_SHOW_SLOT_2
    sta ZP_PTR_RETURN_PAIR
    lda #0
    sta ORBITS_CURRENT_SLOT
    jmp (ZP_PTR_JUMP)
+

ORBITS_SHOW_SLOT_2:
    lda ORBITS_SLOT_2
    beq +                       ; empty
    ; jump table and return
    tax                         ; x has index
    lda ORBITS_JUMP_TABLE_SLOT_2_LO, x
    sta ZP_PTR_JUMP
    lda ORBITS_JUMP_TABLE_SLOT_2_HI, x
    sta ZP_PTR_JUMP_PAIR
    lda #<ORBITS_SHOW_SLOT_3
    sta ZP_PTR_RETURN
    lda #>ORBITS_SHOW_SLOT_3
    sta ZP_PTR_RETURN_PAIR
    lda #1
    sta ORBITS_CURRENT_SLOT
    jmp (ZP_PTR_JUMP)
+
ORBITS_SHOW_SLOT_3:
    lda ORBITS_SLOT_3
    beq +                       ; empty
    ; jump table and return
    tax                         ; x has index
    lda ORBITS_JUMP_TABLE_SLOT_3_LO, x
    sta ZP_PTR_JUMP
    lda ORBITS_JUMP_TABLE_SLOT_3_HI, x
    sta ZP_PTR_JUMP_PAIR
    lda #<ORBITS_SHOW_SLOT_4
    sta ZP_PTR_RETURN
    lda #>ORBITS_SHOW_SLOT_4
    sta ZP_PTR_RETURN_PAIR
    lda #2
    sta ORBITS_CURRENT_SLOT
    jmp (ZP_PTR_JUMP)
+
ORBITS_SHOW_SLOT_4:
    lda ORBITS_SLOT_4
    beq +                       ; empty
    ; jump table and return
    tax                         ; x has index
    lda ORBITS_JUMP_TABLE_SLOT_4_LO, x
    sta ZP_PTR_JUMP
    lda ORBITS_JUMP_TABLE_SLOT_4_HI, x
    sta ZP_PTR_JUMP_PAIR
    lda #<ORBITS_SHOW_SLOT_5
    sta ZP_PTR_RETURN
    lda #>ORBITS_SHOW_SLOT_5
    sta ZP_PTR_RETURN_PAIR
    lda #3
    sta ORBITS_CURRENT_SLOT
    jmp (ZP_PTR_JUMP)
+
ORBITS_SHOW_SLOT_5:
    lda ORBITS_SLOT_5
    beq +                       ; empty
    ; jump table and return
    tax                         ; x has index
    lda ORBITS_JUMP_TABLE_SLOT_5_LO, x
    sta ZP_PTR_JUMP
    lda ORBITS_JUMP_TABLE_SLOT_5_HI, x
    sta ZP_PTR_JUMP_PAIR
    lda #<ORBITS_SHOW_SLOT_6
    sta ZP_PTR_RETURN
    lda #>ORBITS_SHOW_SLOT_6
    sta ZP_PTR_RETURN_PAIR
    lda #4
    sta ORBITS_CURRENT_SLOT
    jmp (ZP_PTR_JUMP)
+
ORBITS_SHOW_SLOT_6:
    lda ORBITS_SLOT_6
    beq +                       ; empty
    ; jump table and return
    tax                         ; x has index
    lda ORBITS_JUMP_TABLE_SLOT_6_LO, x
    sta ZP_PTR_JUMP
    lda ORBITS_JUMP_TABLE_SLOT_6_HI, x
    sta ZP_PTR_JUMP_PAIR
    lda #<ORBITS_SHOW_SLOT_7
    sta ZP_PTR_RETURN
    lda #>ORBITS_SHOW_SLOT_7
    sta ZP_PTR_RETURN_PAIR
    lda #5
    sta ORBITS_CURRENT_SLOT
    jmp (ZP_PTR_JUMP)
+
ORBITS_SHOW_SLOT_7:
    lda ORBITS_SLOT_7
    beq +                       ; empty
    ; jump table and return
    tax                         ; x has index
    lda ORBITS_JUMP_TABLE_SLOT_7_LO, x
    sta ZP_PTR_JUMP
    lda ORBITS_JUMP_TABLE_SLOT_7_HI, x
    sta ZP_PTR_JUMP_PAIR
    lda #<ORBITS_SHOW_SLOT_8
    sta ZP_PTR_RETURN
    lda #>ORBITS_SHOW_SLOT_8
    sta ZP_PTR_RETURN_PAIR
    lda #6
    sta ORBITS_CURRENT_SLOT
    jmp (ZP_PTR_JUMP)
+
ORBITS_SHOW_SLOT_8:
    lda ORBITS_SLOT_8
    beq +                       ; empty
    ; jump table and return
    tax                         ; x has index
    lda ORBITS_JUMP_TABLE_SLOT_8_LO, x
    sta ZP_PTR_JUMP
    lda ORBITS_JUMP_TABLE_SLOT_8_HI, x
    sta ZP_PTR_JUMP_PAIR
    lda #<ORBITS_SHOW_SLOT_DONE
    sta ZP_PTR_RETURN
    lda #>ORBITS_SHOW_SLOT_DONE
    sta ZP_PTR_RETURN_PAIR
    lda #7
    sta ORBITS_CURRENT_SLOT
    jmp (ZP_PTR_JUMP)
+
ORBITS_SHOW_SLOT_DONE:
    jsr ORBITS_SHOW_MOONS
    rts 

ORBITS_SHOW_MOONS:
    lda ORBITS_SLOT_3_MOON_1
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y-3
    sta TEXT_Y
    lda ORBITS_SLOT_3_X
    sta TEXT_X
    lda ORBITS_SLOT_3_MOON_1
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_3_MOON_2
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y+3
    sta TEXT_Y
    lda ORBITS_SLOT_3_X
    sta TEXT_X
    lda ORBITS_SLOT_3_MOON_2
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_4_MOON_1
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y-3
    sta TEXT_Y
    lda ORBITS_SLOT_4_X
    sta TEXT_X
    lda ORBITS_SLOT_4_MOON_1
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_4_MOON_2
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y+3
    sta TEXT_Y
    lda ORBITS_SLOT_4_X
    sta TEXT_X
    lda ORBITS_SLOT_4_MOON_2
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_5_MOON_1
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y-3
    sta TEXT_Y
    lda ORBITS_SLOT_5_X
    sta TEXT_X
    lda ORBITS_SLOT_5_MOON_1
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_5_MOON_2
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y+3
    sta TEXT_Y
    lda ORBITS_SLOT_5_X
    sta TEXT_X
    lda ORBITS_SLOT_5_MOON_2
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_5_MOON_3
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y-5
    sta TEXT_Y
    lda ORBITS_SLOT_5_X
    sta TEXT_X
    lda ORBITS_SLOT_5_MOON_3
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_5_MOON_4
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y+5
    sta TEXT_Y
    lda ORBITS_SLOT_5_X
    sta TEXT_X
    lda ORBITS_SLOT_5_MOON_4
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_6_MOON_1
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y-3
    sta TEXT_Y
    lda ORBITS_SLOT_6_X
    sta TEXT_X
    lda ORBITS_SLOT_6_MOON_1
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_6_MOON_2
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y+3
    sta TEXT_Y
    lda ORBITS_SLOT_6_X
    sta TEXT_X
    lda ORBITS_SLOT_6_MOON_2
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_6_MOON_3
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y-5
    sta TEXT_Y
    lda ORBITS_SLOT_6_X
    sta TEXT_X
    lda ORBITS_SLOT_6_MOON_3
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_6_MOON_4
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y+5
    sta TEXT_Y
    lda ORBITS_SLOT_6_X
    sta TEXT_X
    lda ORBITS_SLOT_6_MOON_4
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_7_MOON_1
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y-3
    sta TEXT_Y
    lda ORBITS_SLOT_7_X
    sta TEXT_X
    lda ORBITS_SLOT_7_MOON_1
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_7_MOON_2
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y+3
    sta TEXT_Y
    lda ORBITS_SLOT_7_X
    sta TEXT_X
    lda ORBITS_SLOT_7_MOON_2
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_7_MOON_3
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y-5
    sta TEXT_Y
    lda ORBITS_SLOT_7_X
    sta TEXT_X
    lda ORBITS_SLOT_7_MOON_3
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_7_MOON_4
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y+5
    sta TEXT_Y
    lda ORBITS_SLOT_7_X
    sta TEXT_X
    lda ORBITS_SLOT_7_MOON_4
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_8_MOON_1
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y-3
    sta TEXT_Y
    lda ORBITS_SLOT_8_X
    sta TEXT_X
    lda ORBITS_SLOT_8_MOON_1
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_8_MOON_2
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y+3
    sta TEXT_Y
    lda ORBITS_SLOT_8_X
    sta TEXT_X
    lda ORBITS_SLOT_8_MOON_2
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_8_MOON_3
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y-5
    sta TEXT_Y
    lda ORBITS_SLOT_8_X
    sta TEXT_X
    lda ORBITS_SLOT_8_MOON_3
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    lda ORBITS_SLOT_8_MOON_4
    and #%00000111           
    beq +                       ; black means no moon
    sta TEXT_COLOR
    lda #ORBITS_Y+5
    sta TEXT_Y
    lda ORBITS_SLOT_8_X
    sta TEXT_X
    lda ORBITS_SLOT_8_MOON_4
    jsr ORBITS_SET_MOON_CHAR
    jsr TEXT_DRAW_CHAR
+
    rts 

ORBITS_SET_MOON_CHAR:
    ; a holds moon byte
    lsr
    lsr 
    lsr                         ; first 3 bits are color, shift past them, leaving 0-31
    and #%00001111              ; 0-15
    tax
    lda ORBITS_MOON_CHARS_LUT, x
    sta TEXT_CHAR
    rts 

ORBITS_SHOW_SLOTS_INFO:
    ; clear sHIP jUMP iNFO
    lda #0 
    sta TEXT_Y
    lda #11
    sta TEXT_X
    lda #<SCREEN_SYSTEM_KEYS_LABEL_BLANK
    sta TEXT_STRING_PTR
    lda #>SCREEN_SYSTEM_KEYS_LABEL_BLANK
    sta TEXT_STRING_PTR+1
    jsr TEXT_DRAW_STRING

    ; invert I in top right
    lda #0 
    sta TEXT_Y
    lda #39
    sta TEXT_X
    lda #CYAN
    sta TEXT_COLOR
    lda #137            ; invert I
    sta TEXT_CHAR
    jsr TEXT_DRAW_CHAR

    ; color
    lda #WHITE
    sta TEXT_COLOR
    ; y
    lda #1
    sta TEXT_Y

    ; x 0
    lda #0
    sta TEXT_X
    ; str ptr
    ldx SUN_TYPE
    lda SUN_TYPE_STRING_LUT_LOW, x
    sta TEXT_STRING_PTR
    lda SUN_TYPE_STRING_LUT_HIGH, x
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

    ; x 1
    ldx ORBITS_SLOT_1_X
    inx
    stx TEXT_X
    ; string ptr
    lda #<ORBITS_SLOT_1_BUFFER
    sta TEXT_STRING_PTR
    lda #>ORBITS_SLOT_1_BUFFER
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

    ; x 2
    ldx ORBITS_SLOT_2_X
    inx
    stx TEXT_X
    ; string ptr
    lda #<ORBITS_SLOT_2_BUFFER
    sta TEXT_STRING_PTR
    lda #>ORBITS_SLOT_2_BUFFER
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

    ; x 3
    ldx ORBITS_SLOT_3_X
    inx
    stx TEXT_X
    ; string ptr
    lda #<ORBITS_SLOT_3_BUFFER
    sta TEXT_STRING_PTR
    lda #>ORBITS_SLOT_3_BUFFER
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

    ; x 4
    ldx ORBITS_SLOT_4_X
    inx
    stx TEXT_X
    ; string ptr
    lda #<ORBITS_SLOT_4_BUFFER
    sta TEXT_STRING_PTR
    lda #>ORBITS_SLOT_4_BUFFER
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

    ; x 5
    ldx ORBITS_SLOT_5_X
    inx
    stx TEXT_X
    ; string ptr
    lda #<ORBITS_SLOT_5_BUFFER
    sta TEXT_STRING_PTR
    lda #>ORBITS_SLOT_5_BUFFER
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

    ; x 6
    ldx ORBITS_SLOT_6_X
    inx
    stx TEXT_X
    ; string ptr
    lda #<ORBITS_SLOT_6_BUFFER
    sta TEXT_STRING_PTR
    lda #>ORBITS_SLOT_6_BUFFER
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

    ; x 7
    ldx ORBITS_SLOT_7_X
    inx
    stx TEXT_X
    ; string ptr
    lda #<ORBITS_SLOT_7_BUFFER
    sta TEXT_STRING_PTR
    lda #>ORBITS_SLOT_7_BUFFER
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

    ; x 8
    ldx ORBITS_SLOT_8_X
    inx
    stx TEXT_X
    ; string ptr
    lda #<ORBITS_SLOT_8_BUFFER
    sta TEXT_STRING_PTR
    lda #>ORBITS_SLOT_8_BUFFER
    sta TEXT_STRING_PTR+1
    jsr TEXT_CENTER_STRING_VERT
    jsr TEXT_DRAW_STRING_VERT

; into...
ORBITS_GAME_LOOP:
    ; i info
    lda #KEY_I_ROW
    sta CIA1_PRA

    lda CIA1_PRB
    and #KEY_I_COL  ; check pressed
    bne +           ; not pressed info
-
    lda CIA1_PRB
    and #KEY_I_COL  ; check released
    beq -
    jmp SCREEN_SYSTEM_SHOW
+
    jmp ORBITS_GAME_LOOP


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
    !byte >PLANET_SHOW_SLOT_2
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
    !byte 87, 42, 90, 86, 46, 43, 81, 81    

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

