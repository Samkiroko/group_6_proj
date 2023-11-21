.MODEL SMALL
.DATA
    prevHour db 0
    prevMinute db 0
    alarmHour db ?
    alarmMinute db ?
    alarmSet db 0
    inputPromptHour db 'Enter alarm hour (0-23): $'
    inputPromptMinute db 'Enter alarm minute (0-59): $'
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
    CALL get_input
    MOV alarmHour, AL

    ; Get alarm minute input
    MOV AH, 09h
    MOV DX, OFFSET inputPromptMinute
    INT 21h
    CALL get_input
    MOV alarmMinute, AL

    ; Set alarm
    MOV alarmSet, 1

    ; Main loop
    JMP main_loop

get_input PROC
    ; Function to get multi-digit input from user
    ; This is a simplified version and needs to be expanded for full functionality
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
    ; Convert BCD to two separate digits (AH = tens, AL = units)
    AAM          
    PUSH AX      

    MOV AL, AH   ; Display tens digit
    CALL DISP

    POP AX       
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
    ; Cursor positioning for hour
    mov ah, 02h
    mov bh, 0
    mov dh, 12  ; Row for hour display
    mov dl, 30  ; Column for hour
    int 10h
    RET
set_cursor_hour ENDP

set_cursor_minute PROC
    ; Cursor positioning for minute
    mov ah, 02h
    mov bh, 0
    mov dh, 12  ; Row for minute display
    mov dl, 33  ; Column for minute
    int 10h
    RET
set_cursor_minute ENDP

END START
