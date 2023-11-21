.MODEL SMALL
.DATA
    prevHour db 0
    prevMinute db 0
    prevSecond db 0

.CODE
START: 
    MOV AX, @DATA
    MOV DS, AX

    ; Main loop for continuous update
main_loop:
    ; Fetch current time and check if it needs updating
    MOV AH, 2CH
    INT 21H

    ; Compare with previous time
    CMP CH, prevHour
    JE check_minute ; Jump if hour is the same
    JMP update_time

check_minute:
    CMP CL, prevMinute
    JE check_second ; Jump if minute is the same
    JMP update_time

check_second:
    CMP DH, prevSecond
    JE main_loop ; Jump if second is the same, no update needed

update_time:
    ; Update previous time
    MOV prevHour, CH
    MOV prevMinute, CL
    MOV prevSecond, DH

    ; Clear Screen and center cursor before printing new time
    CALL clear_screen
    CALL set_center_cursor
    CALL hour
    CALL minutes
    CALL seconds

    JMP main_loop ; Repeat the loop

; Hour Part
HOUR:
    MOV AH, 2CH
    INT 21H
    MOV AL, CH
    AAM
    MOV BX, AX
    CALL DISP
    MOV DL, ':'
    MOV AH, 02H
    INT 21H
    RET

; Minutes Part
MINUTES:
    MOV AH, 2CH
    INT 21H
    MOV AL, CL
    AAM
    MOV BX, AX
    CALL DISP
    MOV DL, ':'
    MOV AH, 02H
    INT 21H
    RET

; Seconds Part
SECONDS:
    MOV AH, 2CH
    INT 21H
    MOV AL, DH
    AAM
    MOV BX, AX
    CALL DISP
    RET

; Display Part
DISP PROC
    MOV DL, BH
    ADD DL, 30H
    MOV AH, 02H
    INT 21H
    MOV DL, BL
    ADD DL, 30H
    MOV AH, 02H
    INT 21H
    RET
DISP ENDP

; Set Cursor to Center of Screen for Time Display
set_center_cursor proc
    mov ah, 02h       ; BIOS Set Cursor Position function
    mov bh, 0         ; Page number
    mov dh, 12        ; Row (approximately middle of the screen)
    mov dl, 36        ; Column (calculated center)
    int 10h           ; Call BIOS
    ret
set_center_cursor endp

clear_screen:
    ; Clear the screen
    MOV AH, 0
    MOV AL, 3
    INT 10H
    RET

END START
