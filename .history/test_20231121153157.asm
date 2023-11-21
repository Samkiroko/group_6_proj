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
    call clearScreen     ; Clear the screen
    call setCursorPosition ; Set the cursor position

    ; Get the current system time
    mov ah, 2Ch ; DOS function: Get System Time
    int 21h     ; AH = 2Ch, CH = hour, CL = minute, DH = second, DL = hundredths

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

    call delay           ; Delay before the next update

    jmp main_loop  ; Repeat the loop

convertBCD:  ; Convert BCD to Decimal
    push ax    ; Save AX register
    mov ah, 0  ; Clear AH
    mov cl, 4  ; Prepare to shift the bits
    shr al, cl ; Shift the high nibble to the low nibble
    mov cl, al ; Move the lower nibble to CL
    and cl, 0Fh; Mask out the high nibble
    add al, cl ; Add the two nibbles
    pop ax     ; Restore AX register
    ret

displayDigit:  ; Display a Single Digit
    add al, 30h    ; Convert digit to ASCII
    mov ah, 0Eh    ; BIOS Teletype Output
    int 10h        ; Call BIOS - display character in AL
    ret

displayTime:  ; Display Time Routine
    ; Display Hour
    mov al, currentHour
    call splitAndDisplay
    
    ; Display Colon
    mov al, ':'
    call displayDigit

    ; Display Minute
    mov al, currentMinute
    call splitAndDisplay

    ; Display Colon
    mov al, ':'
    call displayDigit

    ; Display Second
    mov al, currentSecond
    call splitAndDisplay

    ret

splitAndDisplay:
    ; Split the two-digit number and display each digit
    push ax
    mov ah, 0
    mov cl, 4
    shr al, cl       ; Shift to get the tens digit
    call displayDigit  ; Display tens digit
    pop ax
    and al, 0Fh      ; Mask to get the units digit
    call displayDigit  ; Display units digit
    ret

clearScreen:  ; Clear the Screen
    mov ah, 0    ; Function to set video mode
    mov al, 03h  ; Mode 03h is 80x25 text mode
    int 10h      ; BIOS video interrupt
    ret

setCursorPosition:  ; Set Cursor Position
    mov ah, 02h       ; BIOS Set Cursor Position function
    mov bh, 0         ; Page number
    mov dh, [row]     ; Row
    mov dl, [column]  ; Column
    int 10h
    ret

delay:  ; Delay Loop
    mov cx, 0FFFFh ; Set loop count for the delay
delay_loop:
    nop           ; No operation (just to waste time)
    loop delay_loop
    ret

ends
end start
