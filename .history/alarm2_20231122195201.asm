.MODEL SMALL
.DATA
    prevHour db 0
    prevMinute db 0
    alarmHour db 15    ; Hardcoded alarm hour, e.g., 15 (3 PM)
    alarmMinute db 30  ; Hardcoded alarm minute, e.g., 30
    alarmSet db 1      ; Alarm is set
    alarmMsg db 'Alarm!$', 0DH, 0AH, '$'
    setAlarmMsg db 'Alarm time: $'

.CODE
START: 
    MOV AX, @DATA
    MOV DS, AX

    ; Main loop
    JMP main_loop

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
    MOV AH, 09h
    MOV DX, OFFSET alarmMsg
    INT 21h
    ; Generate beep sound
    MOV AX, 0E07h
    INT 10h
    RET
trigger_alarm ENDP

ConvertAndDisplayDigit PROC
    AAM
    PUSH AX

    MOV AL, AH
    CALL DISP

    POP AX
    MOV AL, AL
    CALL DISP

    RET
ConvertAndDisplayDigit ENDP

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
