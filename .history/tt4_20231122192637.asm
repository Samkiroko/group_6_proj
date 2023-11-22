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
    PUSH AX      ; Save AX register

    ; Extract and display hours
    MOV AH, CH   ; CH contains hours in BCD
    CALL ConvertBCDToDisplay

    ; Display colon between hours and minutes
    MOV DL, ':'
    MOV AH, 02H
    INT 21H

    ; Extract and display minutes
    MOV AH, CL   ; CL contains minutes in BCD
    CALL ConvertBCDToDisplay

    POP AX       ; Restore AX register
    RET
ConvertAndDisplayCurrentTime ENDP

ConvertAndDisplayAlarmTime PROC
    PUSH AX      ; Save AX register

    ; Extract and display alarm hours
    MOV AH, alarmHour   ; Alarm hour as decimal
    CALL ConvertDecimalToDisplay

    ; Display colon
    MOV DL, ':'
    MOV AH, 02H
    INT 21H

    ; Extract and display alarm minutes
    MOV AH, alarmMinute   ; Alarm minute as decimal
    CALL ConvertDecimalToDisplay

    POP AX       ; Restore AX register
    RET
ConvertAndDisplayAlarmTime ENDP

ConvertBCDToDisplay PROC
    ; Convert high nibble (tens place)
    PUSH AX
    MOV AL, AH
    AND AL, 0F0h
    SHR AL, 4
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    POP AX

    ; Convert low nibble (units place)
    AND AH, 0Fh
    ADD AH, '0'
    MOV DL, AH
    MOV AH, 02H
    INT 21H

    RET
ConvertBCDToDisplay ENDP

ConvertDecimalToDisplay PROC
    ; Convert decimal number to displayable format
    ; Assumes AH contains the decimal number
    MOV AL, AH
    MOV BL, 10
    DIV BL      ; AL = AH / 10, AH = AH MOD 10
    ADD AL, '0' ; Convert tens place to ASCII
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    MOV AL, AH
    ADD AL, '0' ; Convert units place to ASCII
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    RET
ConvertDecimalToDisplay ENDP

DISP PROC
    MOV AH, 02H
    INT 21H     ; Display character in DL
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
