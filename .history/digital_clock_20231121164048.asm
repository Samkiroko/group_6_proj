.MODEL SMALL
.DATA
    prevHour db 0
    prevMinute db 0
    prevSecond db 0

.CODE
START: 
    MOV AX, @DATA
    MOV DS, AX

main_loop:
    ; Fetch current time
    MOV AH, 2CH
    INT 21H

    ; Compare with previous time and update as needed
    CMP CH, prevHour
    JNE update_hour
    CMP CL, prevMinute
    JNE update_minute
    CMP DH, prevSecond
    JNE update_second
    JMP main_loop ; No change, skip update

update_hour:
    MOV prevHour, CH
    CALL set_cursor_hour ; Set cursor position for hour
    MOV AL, CH
    CALL ConvertAndDisplayTime
    JMP update_minute

update_minute:
    MOV prevMinute, CL
    CALL set_cursor_minute ; Adjust for minute position
    MOV AL, CL
    CALL ConvertAndDisplayTime
    JMP update_second

update_second:
    MOV prevSecond, DH
    CALL set_cursor_second ; Adjust for second position
    MOV AL, DH
    CALL ConvertAndDisplayTime

    JMP main_loop ; Repeat the loop

; Convert BCD to two separate decimal digits and display
ConvertAndDisplayTime PROC
    PUSH AX     ; Save AX register
    MOV AH, 0   ; Clear AH
    MOV CL, 4   ; Prepare to shift the bits
    SHR AL, CL  ; Shift the high nibble to the low nibble
    AND AL, 0Fh ; Isolate the low nibble (units place)
    CALL DISP   ; Display units place

    POP AX      ; Restore AX register
    AND AH, 0Fh ; Isolate the high nibble (tens place)
    CALL DISP   ; Display tens place
    RET
ConvertAndDisplayTime ENDP

; Display a single digit
DISP PROC
    ADD AL, 30h ; Convert to ASCII
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    RET
DISP ENDP

; Set cursor position procedures
set_cursor_hour PROC
    ; Position cursor for hour display
    ; Adjust row and column as appropriate
    ret
set_cursor_hour endp

set_cursor_minute PROC
    ; Position cursor for minute display
    ; Adjust row and column as appropriate
    ret
set_cursor_minute endp

set_cursor_second PROC
    ; Position cursor for second display
    ; Adjust row and column as appropriate
    ret
set_cursor_second endp

END START
