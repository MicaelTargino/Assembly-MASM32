.686                            ; Specify the target processor (32-bit instructions).
.model flat, stdcall             ; Use the flat memory model and standard calling convention.
option casemap :none             ; Make labels and variable names case-sensitive.

; Include the necessary headers for Windows API and MSVCRT (C runtime) functions.
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib


.data                            ; Start of the data segment to define variables.
    counter dd 0               ; Initialize counter with value 0 (loop from 1 to n, based on users input).
    accumulator dd 0             ; Initialize the accumulator to store the sum (initially 0).
    inputString db 50 dup(0)  ;  Variable to store the input console handle. 
    outputString db 50 dup(0)  ;  Variable to store the output console handle. 
    inputHandle dd 0  ; Variable to store the input console handle.
    outputHandle dd 0  ; Variable to store the output console handle.
    console_count dd 0              ; Variable to store the count of characters read/written.
    tamanho_string dd 0             ; Variable to store the length of the input string.
    

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
    ; Get the input handle (keyboard) using GetStdHandle API function.
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax  ; Store the input handle in the inputHandle variable.

    ; Get the output handle (keyboard) using GetStdHandle API function.
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax  ; Store the output handle in the outputHandle variable.

    ; Read a string from the console using ReadConsole API function.
    ; This will store the string in inputString.
    invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr console_count, NULL

    ; Calculate the length of the input string using StrLen (a MASM32 helper function).
    invoke StrLen, addr inputString

    mov tamanho_string, eax      ; Store the length of the input string in tamanho_string.

    ; Prepare to trim the newline character (carriage return) from the input string.
    mov esi, offset inputString  ; Load the address of the input string into ESI register.

proximo:
    mov al, [esi]                ; Load the current byte (character) from the input string.
    inc esi                      ; Move to the next character.
    cmp al, 13                   ; Compare the character with carriage return (ASCII 13).
    jne proximo                  ; If it's not a carriage return, continue the loop.
    dec esi                      ; If it is, go back one step (to point to the last valid character).
    xor al, al                   ; Zero out the AL register (used to mark the end of the string).
    mov [esi], al                ; Set the null terminator (`0x00`) at the end of the string.

    ; Convert the string to a DWORD using atodw (a MASM32 helper function).
    invoke atodw, offset inputString
    MOV dword ptr [counter], eax ; Store the converted number in the counter variable.

    MOV ecx, dword ptr [counter] ; Load the value of `counter` into `ecx`, which controls the loop.
    MOV ebx, dword ptr [accumulator] ; Load the initial value of `accumulator` (0) into `ebx`.
    MOV edx, 0                   ; Set `edx` to 0, which is the starting value for the summing process.

loopStart:
    ; Loop to call the sum function n times.
    call sum                     ; Call the `sum` function, which adds the current value of `edx` to `ebx`.
    
    LOOP loopStart               ; Decrement `ecx` (loop counter) and repeat the loop until `ecx` reaches 0.

printResult:
    ; Convert the modified DWORD back into a string using dwtoa (a MASM32 helper function).
    invoke dwtoa, ebx, offset outputString

    ; Write the string representation of the modified DWORD to the console using WriteConsole.
    invoke WriteConsole, outputHandle, addr outputString, tamanho_string, addr console_count, NULL

exitTheProgram:
    ; Exit the program.
    invoke ExitProcess, 0        ; Call the Windows API function ExitProcess to terminate the program.
    
end start                        ; Mark the end of the program, with `start` as the entry point.
