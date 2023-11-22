.MODEL SMALL
.DATA
    prevHour db 0
    prevMinute db 0
    alarmHour db 15    ; Hardcoded alarm hour, e.g., 15 (3 PM)
    alarmMinute db 30  ; Hardcoded alarm minute, e.g., 30
    alarmSet db 1      ; Alarm is set
    alarmMsg db 'Alarm!$', 0DH, 0AH, '$'

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
    ; Display alarm message
    MOV AH, 09h
    MOV DX, OFFSET alarmMsg
    INT 21h
    
    ; Generate a beep sound
    MOV AH, 0Bh
    MOV AL, 00h
    MOV CX, 1
    INT 10h
    RET
trigger_alarm ENDP

ConvertAndDisplayDigit PROC
    ; ... [Your existing ConvertAndDisplayDigit procedure] ...
    RET
ConvertAndDisplayDigit ENDP

; Other procedures (DISP, set_cursor_hour, set_cursor_minute) remain unchanged

END START
