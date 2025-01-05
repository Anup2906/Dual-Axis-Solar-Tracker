;====================================================================
; Main.asm file with two DC motors controlled by four LDRs
; 
; Created:   Wed Nov 13 2024
; Processor: AT89C51
; Compiler:  ASEM-51 (Proteus)
;====================================================================

$NOMOD51                 ; Disable default 8051 register bank and interrupt definitions
$INCLUDE (8051.MCU)      ; Include standard 8051 microcontroller definitions

;====================================================================
; DEFINITIONS
;====================================================================
MOTOR1_A EQU P2.0        ; Define Motor 1 control pin A
MOTOR1_B EQU P2.1        ; Define Motor 1 control pin B
MOTOR2_A EQU P2.2        ; Define Motor 2 control pin A
MOTOR2_B EQU P2.3        ; Define Motor 2 control pin B

;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================
ORG 0H                   ; Start program execution from address 0x00

; Initialize ports for input and output
MOV P1, #0FFH            ; Set Port 1 as input (for LDR sensors)
MOV P2, #00H             ; Set Port 2 as output and initialize to 0 (motors stopped)

BACK: 
    MOV P2, #00H         ; Ensure both motors are stopped at the start

    ; MOTOR 1 CONTROL SECTION
    ; Check the status of LDR sensors connected to P1.0 and P1.1
    JB P1.0, MOTOR1_CHECK_P1_1   ; If P1.0 is high, jump to MOTOR1_CHECK_P1_1
    JB P1.1, MOTOR1_CHECK_P1_0   ; If P1.1 is high, jump to MOTOR1_CHECK_P1_0
    ; If neither P1.0 nor P1.1 is high, reset Motor 1
    SJMP MOTOR1_RESET

MOTOR1_CHECK_P1_1:
    JB P1.1, MOTOR1_STOP         ; If P1.1 is also high, stop Motor 1
    SJMP MOTOR1_ANTICLOCKWISE    ; If only P1.0 is high, rotate Motor 1 anticlockwise

MOTOR1_CHECK_P1_0:
    JB P1.0, MOTOR1_STOP         ; If P1.0 is also high, stop Motor 1
    SJMP MOTOR1_CLOCKWISE        ; If only P1.1 is high, rotate Motor 1 clockwise

MOTOR1_STOP:
    CLR MOTOR1_A                 ; Clear Motor 1 pin A (stop signal)
    CLR MOTOR1_B                 ; Clear Motor 1 pin B (stop signal)
    SJMP MOTOR2_CONTROL          ; Proceed to Motor 2 control section

MOTOR1_CLOCKWISE:
    SETB MOTOR1_A                ; Set Motor 1 pin A for clockwise rotation
    CLR MOTOR1_B                 ; Clear Motor 1 pin B
    ACALL DELAY                  ; Call delay subroutine
    SJMP MOTOR2_CONTROL          ; Proceed to Motor 2 control section

MOTOR1_ANTICLOCKWISE:
    CLR MOTOR1_A                 ; Clear Motor 1 pin A
    SETB MOTOR1_B                ; Set Motor 1 pin B for anticlockwise rotation
    ACALL DELAY                  ; Call delay subroutine
    SJMP MOTOR2_CONTROL          ; Proceed to Motor 2 control section

MOTOR1_RESET:
    CLR MOTOR1_A                 ; Reset Motor 1 pin A
    CLR MOTOR1_B                 ; Reset Motor 1 pin B
    SJMP MOTOR2_CONTROL          ; Proceed to Motor 2 control section

; MOTOR 2 CONTROL SECTION
MOTOR2_CONTROL:
    ; Check the status of LDR sensors connected to P1.2 and P1.3
    JB P1.2, MOTOR2_CHECK_P1_3   ; If P1.2 is high, jump to MOTOR2_CHECK_P1_3
    JB P1.3, MOTOR2_CHECK_P1_2   ; If P1.3 is high, jump to MOTOR2_CHECK_P1_2
    ; If neither P1.2 nor P1.3 is high, reset Motor 2
    SJMP MOTOR2_RESET

MOTOR2_CHECK_P1_3:
    JB P1.3, MOTOR2_STOP         ; If P1.3 is also high, stop Motor 2
    SJMP MOTOR2_CLOCKWISE        ; If only P1.2 is high, rotate Motor 2 clockwise

MOTOR2_CHECK_P1_2:
    JB P1.2, MOTOR2_STOP         ; If P1.2 is also high, stop Motor 2
    SJMP MOTOR2_ANTICLOCKWISE    ; If only P1.3 is high, rotate Motor 2 anticlockwise

MOTOR2_STOP:
    CLR MOTOR2_A                 ; Clear Motor 2 pin A (stop signal)
    CLR MOTOR2_B                 ; Clear Motor 2 pin B (stop signal)
    SJMP BACK                    ; Loop back to start

MOTOR2_CLOCKWISE:
    SETB MOTOR2_A                ; Set Motor 2 pin A for clockwise rotation
    CLR MOTOR2_B                 ; Clear Motor 2 pin B
    ACALL DELAY                  ; Call delay subroutine
    SJMP BACK                    ; Loop back to start

MOTOR2_ANTICLOCKWISE:
    CLR MOTOR2_A                 ; Clear Motor 2 pin A
    SETB MOTOR2_B                ; Set Motor 2 pin B for anticlockwise rotation
    ACALL DELAY                  ; Call delay subroutine
    SJMP BACK                    ; Loop back to start

MOTOR2_RESET:
    CLR MOTOR2_A                 ; Reset Motor 2 pin A
    CLR MOTOR2_B                 ; Reset Motor 2 pin B
    SJMP BACK                    ; Loop back to start

; DELAY SUBROUTINE
DELAY:
    MOV R0, #255                 ; Load R0 with a count value for delay
HERE: DJNZ R0, HERE              ; Decrement R0 and loop until it reaches 0
    RET                          ; Return from subroutine

END                              ; End of program
