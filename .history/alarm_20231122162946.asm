.MODEL SMALL
.DATA
    prevHour db 0
    prevMinute db 0
    alarmHour db ?
    alarmMinute db ?
    alarmSet db 0
    inputPromptHour db 'Enter alarm hour (00-23): $'
    inputPromptMinute db 'Enter alarm minute (00-59): $'
    alarmMsg db 'Alarm!$', 0DH, 0AH, '$'
    setAlarmMsg db 'Alarm time: $'

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

    ; Display set alarm time
    MOV AH, 09h
    MOV DX, OFFSET setAlarmMsg
    INT 21h
    MOV AL, alarmHour
    CALL ConvertDecimalToDisplay
    MOV DL, ':'
    CALL DISP
    MOV AL, alarmMinute
    CALL ConvertDecimalToDisplay

    ; Main loop
    JMP main_loop

get_two_digit_input PROC
    XOR AX, AX  ; Clear AX

    ; Read first digit
    MOV AH, 00h
    INT 16h     ; Wait for keypress
    SUB AL, '0' ; Convert from ASCII to number
    MOV BL, AL  ; Store the first digit in BL

    ; Multiply first digit by 10
    MOV AL, BL
    MOV BL, 10
    IMUL BL     ; AX = AL * BL

    ; Read second digit
    MOV AH, 00h
    INT 16h     ; Wait for keypress
    SUB AL, '0' ; Convert from ASCII to number
    ADD AH, AL  ; Add the second digit to AH (result of multiplication in AH)

    ; Move result to AL
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
    CALL ConvertBCDToDisplay

check_minute:
    CMP CL, prevMinute
    JNE update_minute
    JMP alarm_check

update_minute:
    MOV prevMinute, CL
    CALL set_cursor_minute
    MOV AL, CL
    CALL ConvertBCDToDisplay

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
    MOV AH, 09h
    MOV DX, OFFSET alarmMsg
    INT 21h
    RET
trigger_alarm ENDP

ConvertBCDToDisplay PROC
    ; ... [Your existing ConvertBCDToDisplay procedure] ...
    RET
ConvertBCDToDisplay ENDP

ConvertDecimalToDisplay PROC
    ; ... [Procedure to convert and display decimal numbers] ...
    RET
ConvertDecimalToDisplay ENDP

DISP PROC
    ; ... [Your existing DISP procedure] ...
    RET
DISP ENDP

set_cursor_hour PROC
    ; ... [Your existing set_cursor_hour procedure] ...
    RET
set_cursor_hour ENDP

set_cursor_minute PROC
    ; ... [Your existing set_cursor_minute procedure] ...
    RET
set_cursor_minute ENDP

END START
