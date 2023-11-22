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
    CALL ConvertAndDisplayDigit
    MOV DL, ':'
    CALL DISP
    MOV AL, alarmMinute
    CALL ConvertAndDisplayDigit

    ; Main loop
    JMP main_loop

get_two_digit_input PROC
    XOR AX, AX      ; Clear AX

    ; Read first digit
    MOV AH, 00h
    INT 16h         ; Wait for keypress
    SUB AL, '0'     ; Convert from ASCII
    MOV BL, AL      ; Store the first digit in BL
    MOV BH, 0       ; Clear BH to use BX as a 16-bit register

    ; Multiply BX by 10
    MOV CX, 10
    IMUL CX         ; BX = BX * 10 (result in BX)

    ; Read second digit
    MOV AH, 00h
    INT 16h         ; Wait for keypress
    SUB AL, '0'     ; Convert from ASCII

    ; Combine the two digits
    ADD BX, AX      ; BX = BX + AX (second digit)

    ; Move result to AL
    MOV AL, BL      ; AL = lower byte of BX
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
    RET
trigger_alarm ENDP

ConvertAndDisplayDigit PROC
    ; Assuming AL contains a BCD value
    PUSH AX      ; Save AX

    ; Convert high nibble (tens place)
    MOV AH, AL   ; Copy AL to AH for manipulation
    AND AH, 0F0h ; Isolate high nibble
    SHR AH, 4    ; Shift it right to get the actual number
    ADD AH, '0'  ; Convert to ASCII
    MOV DL, AH   ; Move to DL for display
    CALL DISP    ; Display high nibble (tens place)

    ; Convert low nibble (units place)
    POP AX       ; Restore original AX
    AND AL, 0Fh  ; Isolate low nibble
    ADD AL, '0'  ; Convert to ASCII
    CALL DISP    ; Display low nibble (units place)

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
