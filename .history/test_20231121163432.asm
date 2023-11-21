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
    CALL set_center_cursor_hour ; Set cursor position for hour
    MOV AL, CH
    CALL ConvertAndDisplayTime
    JMP update_minute

update_minute:
    MOV prevMinute, CL
    CALL set_center_cursor_minute ; Adjust for minute position
    MOV AL, CL
    CALL ConvertAndDisplayTime
    JMP update_second

update_second:
    MOV prevSecond, DH
    CALL set_center_cursor_second ; Adjust for second position
    MOV AL, DH
    CALL ConvertAndDisplayTime

    JMP main_loop ; Repeat the loop

ConvertAndDisplayTime PROC
    ; Assuming AL has the BCD value
    AAM         ; Convert BCD to two separate digits
    PUSH AX     ; Save AX

    MOV AL, AH  ; High digit (tens)
    CALL DISP

    POP AX      ; Restore original value
    MOV AL, AL  ; Low digit (units)
    CALL DISP

    RET
ConvertAndDisplayTime ENDP

DISP PROC
    ; Display a single digit
    ADD AL, 30H ; Convert to ASCII
    MOV DL, AL  ; Load digit to DL for display
    MOV AH, 02H ; Function to display character
    INT 21H     ; Display the character
    RET
DISP ENDP

set_center_cursor_hour proc
    ; Position cursor for hour display
    ; Adjust row and column as appropriate
    ret
set_center_cursor_hour endp

set_center_cursor_minute proc
    ; Position cursor for minute display
    ; Adjust row and column as appropriate
    ret
set_center_cursor_minute endp

set_center_cursor_second proc
    ; Position cursor for second display
    ; Adjust row and column as appropriate
    ret
set_center_cursor_second endp

END START
