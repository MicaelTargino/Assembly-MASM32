.686                               ; Use the 686 (32-bit) instruction set.
.model flat, stdcall                ; Use the flat memory model and the standard calling convention.
option casemap :none                ; Make labels and variable names case-sensitive.

; Include necessary headers for Windows API and MSVCRT (C runtime) functions.
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

.data                               ; Start of the data segment for variables.
    start_value dd 1000             ; Initialize `start_value` with 1000 (starting value for the loop).
    divisor dd 11                   ; Define the divisor (11) for the division operations.

.code                               ; Start of the code segment where the logic is implemented.
start:
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

    ; If the remainder is 5, print the current value of `ebx`.
    printf("%d\n", ebx)

skip:
    ; Increment `ebx` to check the next number.
    INC ebx

    ; Decrement the loop counter `ecx` and repeat the loop if `ecx` is not zero.
    LOOP loopStart                  ; Loop back to `loopStart` until `ecx == 0`.

exitTheProgram:
    ; Exit the program.
    invoke ExitProcess, 0           ; Use the Windows API function `ExitProcess` to terminate the program.

end start                           ; End of the program with `start` as the entry point.
