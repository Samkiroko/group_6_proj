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
    CALL ConvertAndDisplayAlarmTime

    ; Main loop
    JMP main_loop

get_two_digit_input PROC
    ; ... [Your existing get_two_digit_input procedure] ...
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
    CALL ConvertAndDisplayCurrentTime
    JMP check_minute

check_minute:
    CMP CL, prevMinute
    JNE update_minute
    JMP alarm_check

update_minute:
    MOV prevMinute, CL
    CALL set_cursor_minute
    CALL ConvertAndDisplayCurrentTime
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
    MOV AH, 09h
    MOV DX, OFFSET alarmMsg
    INT 21h
    RET
trigger_alarm ENDP

ConvertAndDisplayCurrentTime PROC
    ; ... [Your ConvertAndDisplayCurrentTime procedure] ...
    RET
ConvertAndDisplayCurrentTime ENDP

ConvertAndDisplayAlarmTime PROC
    ; ... [Your ConvertAndDisplayAlarmTime procedure] ...
    RET
ConvertAndDisplayAlarmTime ENDP

ConvertBCDToDisplay PROC
    ; ... [Your ConvertBCDToDisplay procedure] ...
    RET
ConvertBCDToDisplay ENDP

DISP PROC
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    RET
DISP ENDP

set_cursor_hour PROC
    mov ah, 02h
    mov bh, 0
    mov dh, 12
    mov dl, 30
    int 10h
    RET
set_cursor_hour ENDP

set_cursor_minute PROC
    mov ah, 02h
    mov bh, 0
    mov dh, 12
    mov dl, 33
    int 10h
    RET
set_cursor_minute ENDP

END START
