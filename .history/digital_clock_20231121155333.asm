data segment
     ; ASCII representations for digits 0-9
    zero    db "0", "$"
    one     db "1", "$"
    two     db "2", "$"
    three   db "3", "$"
    four    db "4", "$"
    five    db "5", "$"
    six     db "6", "$"
    seven   db "7", "$"
    eight   db "8", "$"
    nine    db "9", "$"

    current_hour db 0
    current_minute db 0
    current_second db 0
    ; ... other variables as needed
ends

code segment
assume cs:code, ds:data

start:
    ; Initialize the data segment
    mov ax, data
    mov ds, ax

    ; Main loop
main_loop:
    ; Fetch current time and check if it needs updating
    ; ... (your existing time fetching and comparison logic)

    ; Clear the screen and print the time
    call clear_screen    
    call print_time

    ; Delay for controlled update rate
    ; ... (your delay logic)

    jmp main_loop  ; Loop back

print_time:
    ; Print hours
    mov al, current_hour
    call print_digit

    ; Print colon
    mov dl, ':'
    call display_character

    ; Print minutes
    mov al, current_minute
    call print_digit

    ; Print colon
    mov dl, ':'
    call display_character

    ; Print seconds
    mov al, current_second
    call print_digit

    ret

print_digit:
    ; Your existing logic for printing a digit
    ; ...

    ret

display_character:
    ; Display a single character in DL
    mov ah, 02h
    int 21h
    ret

clear_screen:
    ; Clear the screen
    ; ...

    ret

    ; Other routines as necessary...

ends
end start
