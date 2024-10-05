.686                            ; Specify the target processor (32-bit instructions).
.model flat, stdcall             ; Use the flat memory model and standard calling convention.
option casemap :none             ; Make labels and variable names case-sensitive.

; Include the necessary headers for Windows API and MSVCRT (C runtime) functions.
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

.data                            ; Start of the data segment to define variables.
    counter dd 100               ; Initialize counter with value 100 (loop from 1 to 100).
    accumulator dd 0             ; Initialize the accumulator to store the sum (initially 0).

.code                            ; Start of the code segment.

; Function that performs the summing operation.
sum:
    INC edx                      ; Increment `edx` (the current number in the sequence).
    ADD ebx, edx                 ; Add the value of `edx` to `ebx` (accumulator).
    XOR eax, eax                 ; Clear `eax` (set it to 0).
    ADD eax, ebx                 ; Store the updated accumulator (in `ebx`) in `eax`.
    RET                          ; Return from the function, with `eax` holding the updated sum.

; Entry point of the program.
start:
    MOV ecx, dword ptr [counter] ; Load the value of `counter` (100) into `ecx`, which controls the loop.
    MOV ebx, dword ptr [accumulator] ; Load the initial value of `accumulator` (0) into `ebx`.
    MOV edx, 0                   ; Set `edx` to 0, which is the starting value for the summing process.

loopStart:
    ; Loop to call the sum function 100 times.
    call sum                     ; Call the `sum` function, which adds the current value of `edx` to `ebx`.
    MOV ebx, eax                 ; Update `ebx` with the new value returned in `eax`.
    
    LOOP loopStart               ; Decrement `ecx` (loop counter) and repeat the loop until `ecx` reaches 0.

printResult:
    ; Use the MSVCRT printf function to display the result.
    printf("Result: %d", ebx)    ; Print the final result, stored in `ebx`, to the console.

exitTheProgram:
    ; Exit the program.
    invoke ExitProcess, 0        ; Call the Windows API function ExitProcess to terminate the program.
    
end start                        ; Mark the end of the program, with `start` as the entry point.
