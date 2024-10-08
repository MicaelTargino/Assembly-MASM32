.686                               ; Use the 686 (32-bit) instruction set.
.model flat, stdcall                ; Use the flat memory model and the standard calling convention.
option casemap :none                ; Make labels and variable names case-sensitive.

; Include necessary headers for Windows API and MSVCRT (C runtime) functions.
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data                               ; Start of the data segment for variables.
    start_value dd 1000             ; Initialize `start_value` with 1000 (starting value for the loop).
    divisor dd 11                   ; Define the divisor (11) for the division operations.
    outputString db 50 dup(0)
    outputHandle dd 0
    console_count dd 0
    tam_string dd 0

.code                               ; Start of the code segment where the logic is implemented.
start:
    ; Get the output handle (keyboard) using GetStdHandle API function.
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax  ; Store the output handle in the outputHandle variable.

    ; Load the initial value `start_value` (1000) into `ebx` (the current value to check in the loop).
    MOV ebx, dword ptr [start_value]

    ; Set the loop counter to 1000 in `ecx`. This will allow for 1000 iterations, from 1000 to 1999.
    MOV ecx, 1000

loopStart:
    ; Compare the current value in `ebx` with 1999.
    ; If `ebx` is greater than 1999, exit the loop.
    CMP ebx, 1999
    JA exitTheProgram               ; Jump to `exitTheProgram` if `ebx > 1999`.

    ; Load the divisor (11) into `esi` for division.
    MOV esi, 11
    
    ; Move the current value of `ebx` (the number to be checked) into `eax` (required for division).
    MOV eax, ebx

    ; Zero out the `edx` register (needed for division as the remainder will be stored in `edx`).
    XOR edx, edx

    ; Divide `eax` by `esi` (11), storing the quotient in `eax` and the remainder in `edx`.
    DIV esi

    ; Compare the remainder (`edx`) with 5.
    ; If the remainder is not 5, skip the printing and go to the next iteration.
    CMP edx, 5
    JNE skip                        ; If `edx != 5`, jump to `skip` label.

    ; Backup EAX, ECX, EDX before calling dwtoa
    push eax
    push ecx
    push edx
    invoke dwtoa, ebx, offset outputString
    ; Restore EAX, ECX, EDX after dwtoa
    pop edx
    pop ecx
    pop eax

    ; Backup EAX, ECX, EDX before calling StrLen
    push eax
    push ecx
    push edx
    invoke StrLen, addr outputString
    mov tam_string, eax  ; Store the string length in `tam_string`
    
    ; Load the base address of outputString into ESI
    lea esi, [outputString]
    
    ; Add tam_string to ESI to get the next available position in the string
    add esi, tam_string
    mov byte ptr [esi], 32               ; Add a space after the number
    inc esi                                ; Move to the next byte
    mov byte ptr [esi], 0                  ; Add null terminator after the space
    
    ; Restore EAX, ECX, EDX after StrLen
    pop edx
    pop ecx
    pop eax

    ; Backup EAX, ECX, EDX before calling WriteConsole
    push eax
    push ecx
    push edx
    ADD dword ptr [tam_string], 1
    invoke WriteConsole, outputHandle, addr outputString, tam_string, addr console_count, NULL
    ; Restore EAX, ECX, EDX after WriteConsole
    pop edx
    pop ecx
    pop eax

skip:
    ; Increment `ebx` to check the next number.
    INC ebx

    ; Decrement the loop counter and repeat the loop if `ecx` is not zero.
    dec ecx                     ; Decrement the loop counter manually.
    JNZ loopStart               ; Jump back to `loopStart` if `ecx` is not zero.

exitTheProgram:
    ; Exit the program.
    invoke ExitProcess, 0           ; Use the Windows API function `ExitProcess` to terminate the program.

end start                           ; End of the program with `start` as the entry point.
