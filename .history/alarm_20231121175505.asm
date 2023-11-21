.MODEL SMALL
.DATA
    prevHour db 0
    prevMinute db 0
    alarmHour db 10 ; Alarm hour for testing
    alarmMinute db 30 ; Alarm minute for testing
    alarmSet db 1 ; Flag to indicate if the alarm is set
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

ConvertAndDisplayDigit PROC
    AAM          ; Convert BCD to two separate digits (AH = tens, AL = units)
    PUSH AX      ; Save AX

    MOV AL, AH   ; Display tens digit
    CALL DISP

    POP AX       ; Restore original AX
    MOV AL, AL   ; Display units digit
    CALL DISP

    RET
ConvertAndDisplayDigit ENDP

DISP PROC
    ADD AL, 30h  ; Convert digit to ASCII
    MOV DL, AL   ; DL = character to display
    MOV AH, 02H  ; Function to display a character
    INT 21H      ; Display the character
    RET
DISP ENDP

set_cursor_hour PROC
    mov ah, 02h
    mov bh, 0
    mov dh, 12  ; Row for hour display (adjust if necessary)
    mov dl, 30  ; Column for hour (adjust if necessary)
    int 10h
    RET
set_cursor_hour ENDP

set_cursor_minute PROC
    mov ah, 02h
    mov bh, 0
    mov dh, 12  ; Row for minute display (same as hour)
    mov dl, 33  ; Column for minute (adjust if necessary)
    int 10h
    RET
set_cursor_minute ENDP

END START
