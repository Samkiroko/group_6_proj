.MODEL SMALL
.DATA
    prevHour db 0
    prevMinute db 0
    alarmHour db ?
    alarmMinute db ?
    alarmSet db 0
    alarmMsg db 'Alarm Time Set: $'
    inputPrompt db 'Enter alarm hour (0-9) and minute (0-9): $'
    beepFreq dw 750  ; Frequency for beep sound
    beepDuration dw 5 ; Duration for beep sound

.CODE
START: 
    MOV AX, @DATA
    MOV DS, AX

    ; Display input prompt
    MOV AH, 09h
    MOV DX, OFFSET inputPrompt
    INT 21h

    ; Get alarm hour input
    CALL get_input
    MOV alarmHour, AL

    ; Get alarm minute input
    CALL get_input
    MOV alarmMinute, AL

    ; Set alarm
    MOV alarmSet, 1

    ; Display alarm time set message
    MOV AH, 09h
    MOV DX, OFFSET alarmMsg
    INT 21h

    ; Display set alarm time
    MOV AL, alarmHour
    CALL DISP
    MOV DL, ':'
    CALL DISP
    MOV AL, alarmMinute
    CALL DISP

    ; Main loop
    JMP main_loop

get_input PROC
    MOV AH, 00h  ; Wait for keypress
    INT 16h      ; Get character from keyboard
    SUB AL, '0'  ; Convert ASCII to number
    RET
get_input ENDP

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
