

; Matrix lookup table mapping hardware indices directly to C64 Screen Codes
BB_KEY_MATRIX
;          Col 0  Col 1  Col 2  Col 3  Col 4  Col 5  Col 6  Col 7
;          -------------------------------------------------------
; Row 0:   DEL    RET    CRSR   F7     F1     F3     F5     CRSR
!byte      $ff,   $fe,   $00,   $00,   $00,   $00,   $00,   $00
; Row 1:   3      W      A      4      Z      S      E      SHIFT
!byte      $33,   $17,   $01,   $34,   $1a,   $13,   $05,   $00
; Row 2:   5      R      D      6      C      F      T      X
!byte      $35,   $12,   $04,   $36,   $03,   $06,   $14,   $18
; Row 3:   7      Y      G      8      B      H      U      V
!byte      $37,   $19,   $07,   $38,   $02,   $08,   $15,   $16
; Row 4:   9      I      J      0      M      K      O      N
!byte      $39,   $09,   $0a,   $30,   $0d,   $0b,   $0f,   $0e
; Row 5:   +      P      L      -      .      :      @      ,
!byte      $2b,   $10,   $0c,   $2d,   $2e,   $00,   $00,   $2c
; Row 6:   pound  *      ;      HOME   SHIFT  =      ^      /
!byte      $23,   $2a,   $3b,   $00,   $00,   $3d,   $00,   $2e
; Row 7:   1      left   CTRL   2      SPACE  C=     Q      STOP
!byte      $31,   $00,   $00,   $32,   $20,   $00,   $11,   $00

BB_MAX_CHARS = 20
BB_TEXT_ENTRY_BUFFER
    !fill BB_MAX_CHARS+1, 0
BB_KEY_PRESSED
    !byte 0
BB_LAST_KEY_PRESSED
    !byte 0    
BB_CHAR_COUNT
    !byte 0
BB_TEXT_BLANK
    !scr ">                      <", 0
BB_TEXT_ENTRY_PRE_POP       ; if not zero, caller has provided entry text in BB_TEXT_ENTRY_BUFFER and has set BB_CHAR_COUNT
    !byte 0
