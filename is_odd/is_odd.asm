.686                              ; Set the processor to use the 686 (32-bit instructions).
.model flat, stdcall               ; Use the flat memory model and the standard calling convention.
option casemap :none               ; Make labels and variable names case-sensitive.

; Include necessary headers for Windows API and MSVCRT (C runtime) functions.
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data                              ; Start of the data segment for static variables.
    num dd 0                      ; Initialize a variable `num` with the value 0 (the number to check).
    inputString db 50 dup(0)  ;  Variable to store the input console handle. 
    oddOutputString db "Number is Odd", 0 
    evenOutputString db "Number is Even", 0
    inputHandle dd 0  ; Variable to store the input console handle.
    outputHandle dd 0  ; Variable to store the output console handle.
    console_count dd 0              ; Variable to store the count of characters read/written.
    tamanho_string dd 0             ; Variable to store the length of the input string.


.code                              ; Start of the code segment where the program logic resides.
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
    MOV dword ptr [num], eax ; Store the converted number in the counter variable.

    ; Move the value of `num` (0) into the `eax` register.
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
    invoke StrLen, addr oddOutputString

    mov tamanho_string, eax      ; Store the length of the input string in tamanho_string.
    
    ; Print "Number is odd" if the number is odd.
    invoke WriteConsole, outputHandle, addr oddOutputString, tamanho_string, addr console_count, NULL      

    ; Jump to the `exitTheProgram` label to end the program.
    JMP exitTheProgram             

isEven:
    invoke StrLen, addr evenOutputString

    mov tamanho_string, eax      ; Store the length of the input string in tamanho_string.
    
    ; Print "Number is even" if the number is even.
    invoke WriteConsole, outputHandle, addr evenOutputString, tamanho_string, addr console_count, NULL       

exitTheProgram:
    ; Exit the program by calling the `ExitProcess` function.
    invoke ExitProcess, 0          

end start                          ; End of the program with `start` as the entry point.
