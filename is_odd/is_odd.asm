.686                              ; Set the processor to use the 686 (32-bit instructions).
.model flat, stdcall               ; Use the flat memory model and the standard calling convention.
option casemap :none               ; Make labels and variable names case-sensitive.

; Include necessary headers for Windows API and MSVCRT (C runtime) functions.
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

.data                              ; Start of the data segment for static variables.
    num dd 81                      ; Initialize a variable `num` with the value 81 (the number to check).

.code                              ; Start of the code segment where the program logic resides.
start:
    ; Move the value of `num` (81) into the `eax` register.
    MOV eax, dword ptr [num]       

    ; Perform a bitwise AND operation between `eax` and 1.
    ; This checks if the least significant bit (LSB) is 1.
    ; - If the result is 0, the number is even.
    ; - If the result is 1, the number is odd.
    AND eax, 1                     

    ; Check if the result of `AND eax, 1` is zero.
    ; - If zero (`eax == 0`), jump to the `isEven` label.
    ; - If non-zero, continue to the next instruction (`isOdd`).
    JZ isEven                      

isOdd:
    ; Print "Number is odd" if the number is odd.
    printf("Number is odd")        

    ; Jump to the `exitTheProgram` label to end the program.
    JMP exitTheProgram             

isEven:
    ; Print "Number is even" if the number is even.
    printf("Number is even")       

exitTheProgram:
    ; Exit the program by calling the `ExitProcess` function.
    invoke ExitProcess, 0          

end start                          ; End of the program with `start` as the entry point.
