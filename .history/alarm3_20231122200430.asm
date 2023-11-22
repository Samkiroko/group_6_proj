.MODEL SMALL
.DATA
    prevHour db 0
    prevMinute db 0
    alarmHour db 19    ; Hardcoded alarm hour, e.g., 19 (7 PM)
    alarmMinute db 55  ; Hardcoded alarm minute, e.g., 55
    alarmSet db 1      ; Alarm is set
    alarmMsg db 'Alarm!$', 0DH, 0AH, '$'
    setAlarmMsg db 'Alarm time: 19:55$', 0DH, 0AH, '$'

.CODE
START: 
    MOV AX, @DATA
    MOV DS, AX

    ; Display set alarm time at the top of the screen
    CALL set_cursor_top
    MOV AH, 09h
    MOV DX, OFFSET setAlarmMsg
    INT 21h

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

set_cursor_top PROC
    mov ah, 02h
    mov bh, 0
    mov dh, 0   ; Top of the screen (row 0)
    mov dl, 0   ; Leftmost column
    int 10h
    RET
set_cursor_top ENDP

END START
