.MODEL SMALL
.DATA
    prevHour db 0
    prevMinute db 0
    alarmHour db ?
    alarmMinute db ?
    alarmSet db 0
    inputPromptHour db 'Enter alarm hour (00-23): $'
    inputPromptMinute db 'Enter alarm minute (00-59): $'
    beepFreq dw 750  ; Frequency for beep sound
    beepDuration dw 5 ; Duration for beep sound

.CODE
START: 
    MOV AX, @DATA
    MOV DS, AX

    ; Get alarm hour input
    MOV AH, 09h
    MOV DX, OFFSET inputPromptHour
    INT 21h
    CALL get_two_digit_input
    MOV alarmHour, AL

    ; Get alarm minute input
    MOV AH, 09h
    MOV DX, OFFSET inputPromptMinute
    INT 21h
    CALL get_two_digit_input
    MOV alarmMinute, AL

    ; Set alarm
    MOV alarmSet, 1

    ; Main loop
    JMP main_loop

get_two_digit_input PROC
    ; Read first digit
    MOV AH, 00h
    INT 16h
    SUB AL, '0'
    MOV BL, AL  ; Store first digit in BL

    ; Multiply BL by 10 (shift left by one position in decimal)
    MOV AH, 0
    MOV AL, BL
    MOV CL, 1
    SHL AX, CL  ; AX = BL * 10

    ; Read second digit
    MOV AH, 00h
    INT 16h
    SUB AL, '0'

    ; Add second digit to AX
    ADD AX, AL  ; AX = AX + AL

    ; Return result in AL
    MOV AL, AH
    RET
get_two_digit_input ENDP

main_loop:
    ; Fetch current time
    MOV AH, 2CH
    INT 21H       ; CH = hour, CL = minute in BCD format

    ; Compare with previous time and update as needed
    CMP CH, prevHour
    JNE update_hour
    JMP check_minute

update_hour:
    MOV prevHour, CH
    CALL set_cursor_hour
    MOV AL, CH
    CALL ConvertAndDisplayDigit
    JMP check_minute

check_minute:
    CMP CL, prevMinute
    JNE update_minute
    JMP alarm_check

update_minute:
    MOV prevMinute, CL
    CALL set_cursor_minute
    MOV AL, CL
    CALL ConvertAndDisplayDigit
    JMP alarm_check

alarm_check:
    CMP alarmSet, 1
    JNE main_loop
    CMP CH, alarmHour
    JNE main_loop
    CMP CL, alarmMinute
    JNE main_loop
    CALL trigger_alarm
    JMP main_loop

trigger_alarm PROC
    MOV AX, 0B40h  ; Function to play sound
    MOV BX, beepFreq
    MOV CX, beepDuration
    INT 10h        ; BIOS video service for sound
    RET
trigger_alarm ENDP

ConvertAndDisplayDigit PROC
    ; ... [Conversion and display logic as before] ...
    RET
ConvertAndDisplayDigit ENDP

DISP PROC
    ; ... [Single digit display logic as before] ...
    RET
DISP ENDP

set_cursor_hour PROC
    ; ... [Cursor positioning for hour as before] ...
    RET
set_cursor_hour ENDP

set_cursor_minute PROC
    ; ... [Cursor positioning for minute as before] ...
    RET
set_cursor_minute ENDP

END START
