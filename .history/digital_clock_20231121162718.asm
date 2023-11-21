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
    CALL hour
    JMP update_minute

update_minute:
    MOV prevMinute, CL
    CALL set_center_cursor_minute ; Adjust for minute position
    MOV AL, CL
    CALL minutes
    JMP update_second

update_second:
    MOV prevSecond, DH
    CALL set_center_cursor_second ; Adjust for second position
    MOV AL, DH
    CALL seconds

    JMP main_loop ; Repeat the loop

HOUR:
    MOV AH, 2CH
    INT 21H
    MOV AL, CH
    AAM
    MOV BX, AX
    CALL DISP
    MOV DL, ':'
    MOV AH, 02H
    INT 21H
    RET

MINUTES:
    MOV AH, 2CH
    INT 21H
    MOV AL, CL
    AAM
    MOV BX, AX
    CALL DISP
    MOV DL, ':'
    MOV AH, 02H
    INT 21H
    RET

SECONDS:
    MOV AH, 2CH
    INT 21H
    MOV AL, DH
    AAM
    MOV BX, AX
    CALL DISP
    RET

DISP PROC
    MOV DL, BH
    ADD DL, 30H
    MOV AH, 02H
    INT 21H
    MOV DL, BL
    ADD DL, 30H
    MOV AH, 02H
    INT 21H
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
