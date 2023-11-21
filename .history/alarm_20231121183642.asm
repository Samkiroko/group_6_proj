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
    CALL DISP
    MOV DL, ':'
    CALL DISP
    MOV AL, alarmMinute
    CALL DISP

    ; Main loop
    JMP main_loop

get_two_digit_input PROC
    ; [Your existing get_two_digit_input procedure]
    RET
get_two_digit_input ENDP

main_loop:
    ; [Your existing main loop]
    RET
main_loop ENDP

trigger_alarm PROC
    MOV AH, 09h
    MOV DX, OFFSET alarmMsg
    INT 21h
    RET
trigger_alarm ENDP

ConvertAndDisplayDigit PROC
    ; [Your existing ConvertAndDisplayDigit procedure]
    RET
ConvertAndDisplayDigit ENDP

DISP PROC
    ; [Your existing DISP procedure]
    RET
DISP ENDP

set_cursor_hour PROC
    ; [Your existing set_cursor_hour procedure]
    RET
set_cursor_hour ENDP

set_cursor_minute PROC
    ; [Your existing set_cursor_minute procedure]
    RET
set_cursor_minute ENDP

END START
