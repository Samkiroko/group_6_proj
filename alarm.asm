.MODEL SMALL
.DATA
    prevHour db 0
    prevMinute db 0
    alarmHour db 10 ; Set alarm hour for testing
    alarmMinute db 30 ; Set alarm minute for testing
    alarmSet db 1 ; Alarm is set
    alarmMsg db 'Alarm!$', 0DH, 0AH, '$' ; Alarm message

.CODE
START: 
    MOV AX, @DATA
    MOV DS, AX

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
    ; Display colon after hour
    MOV DL, ':'
    MOV AH, 02H
    INT 21H
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
    ; Check if alarm is set and if current time matches alarm time
    CMP alarmSet, 1
    JNE main_loop ; Skip alarm check if not set
    CMP CH, alarmHour
    JNE main_loop ; Skip if hours don't match
    CMP CL, alarmMinute
    JNE main_loop ; Skip if minutes don't match
    CALL trigger_alarm

    JMP main_loop

trigger_alarm PROC
    ; Perform the desired action when the alarm triggers
    MOV AH, 09h ; Display string function
    MOV DX, OFFSET alarmMsg ; Offset of message
    INT 21h
    RET
trigger_alarm ENDP

ConvertAndDisplayDigit PROC
    ; ... [Conversion and display logic] ...
    RET
ConvertAndDisplayDigit ENDP

DISP PROC
    ; ... [Single digit display logic] ...
    RET
DISP ENDP

set_cursor_hour PROC
    ; ... [Cursor positioning for hour] ...
    RET
set_cursor_hour ENDP

set_cursor_minute PROC
    ; ... [Cursor positioning for minute] ...
    RET
set_cursor_minute ENDP

END START
