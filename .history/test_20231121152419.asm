data segment
    currentHour db 0
    currentMinute db 0
    currentSecond db 0
    row db 10 ; Row position for displaying time
    column db 30 ; Column position for displaying time
ends

code segment
assume cs:code, ds:data

start:
    ; Initialize the data segment
    mov ax, data
    mov ds, ax

    ; Main loop
main_loop:
    ; Clear screen and set cursor position for each update
    call clearScreen
    call setCursorPosition

    ; Get the current system time
    mov ah, 2Ch
    int 21h

    ; Convert BCD to decimal and store in variables
    mov al, ch
    call convertBCD
    mov currentHour, al

    mov al, cl
    call convertBCD
    mov currentMinute, al

    mov al, dh
    call convertBCD
    mov currentSecond, al

    ; Display the time
    call displayTime

    ; Delay before the next update
    call delay

    jmp main_loop

    ; Exit program (this part is now unreachable, can be removed or modified)
    mov ah, 4Ch
    int 21h

; Rest of your routines (convertBCD, displayDigit, displayTime, clearScreen, setCursorPosition, delay)

ends
end start
