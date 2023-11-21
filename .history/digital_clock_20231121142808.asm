data segment
    currentHour db 0
    currentMinute db 0
    currentSecond db 0
ends

code segment
start:
    ; Initialize the data segment
    mov ax, data
    mov ds, ax

    ; Get the current system time
    mov ah, 2Ch ; DOS function: Get System Time
    int 21h     ; AH = 2Ch, CH = hour, CL = minute, DH = second, DL = hundredths

    ; Store the time in variables
    mov currentHour, ch
    mov currentMinute, cl
    mov currentSecond, dh

    ; Your code continues here...
    ; For example, convert and display these values, handle user input, etc.

    ; Exit program (DOS function call)
    mov ah, 4Ch
    int 21h

ends
end start
