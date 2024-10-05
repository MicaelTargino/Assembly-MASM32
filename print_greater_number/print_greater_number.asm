.686                              ; Use the 686 (32-bit) instruction set.
.model flat, stdcall               ; Use the flat memory model and the standard calling convention.
option casemap :none               ; Make labels and variable names case-sensitive.

; Include necessary headers for Windows API and MSVCRT (C runtime) functions.
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data                              ; Start of the data segment for storing variables.
    num_1 dd 100                   ; Initialize the first number (`num_1`) with the value 100.
    num_2 dd 200                   ; Initialize the second number (`num_2`) with the value 200.
    greater_num dd ?               ; A variable to store the greater number, initially uninitialized (?).
    inputString db 50 dup(0)  ;  Variable to store the input console handle. 
    outputString db 50 dup(0) ; Variable to store the output console handle 
    inputHandle dd 0  ; Variable to store the input console handle.
    outputHandle dd 0  ; Variable to store the output console handle.
    console_count dd 0              ; Variable to store the count of characters read/written.
    tamanho_string1 dd 0             ; Variable to store the length of the input string.
    tamanho_string2 dd 0             ; Variable to store the length of the input string.

.code                              ; Start of the code segment where the program logic is defined.
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

    mov tamanho_string1, eax 

    ; Prepare to trim the newline character (carriage return) from the input string.
    mov esi, offset inputString  ; Load the address of the input string into ESI register.

proximo1:
    mov al, [esi]                ; Load the current byte (character) from the input string.
    inc esi                      ; Move to the next character.
    cmp al, 13                   ; Compare the character with carriage return (ASCII 13).
    jne proximo1                 ; If it's not a carriage return, continue the loop.
    dec esi                      ; If it is, go back one step (to point to the last valid character).
    xor al, al                   ; Zero out the AL register (used to mark the end of the string).
    mov [esi], al                ; Set the null terminator (`0x00`) at the end of the string.

    ; Convert the string to a DWORD using atodw (a MASM32 helper function).
    invoke atodw, offset inputString
    MOV dword ptr [num_1], eax ; Store the converted number in the counter variable.

    ; Read a string from the console using ReadConsole API function.
    ; This will store the string in inputString.
    invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr console_count, NULL

    ; Calculate the length of the input string using StrLen (a MASM32 helper function).
    invoke StrLen, addr inputString

    mov tamanho_string2, eax 

    ; Prepare to trim the newline character (carriage return) from the input string.
    mov esi, offset inputString  ; Load the address of the input string into ESI register.

proximo2:
    mov al, [esi]                ; Load the current byte (character) from the input string.
    inc esi                      ; Move to the next character.
    cmp al, 13                   ; Compare the character with carriage return (ASCII 13).
    jne proximo2                  ; If it's not a carriage return, continue the loop.
    dec esi                      ; If it is, go back one step (to point to the last valid character).
    xor al, al                   ; Zero out the AL register (used to mark the end of the string).
    mov [esi], al                ; Set the null terminator (`0x00`) at the end of the string.

    ; Convert the string to a DWORD using atodw (a MASM32 helper function).
    invoke atodw, offset inputString
    MOV dword ptr [num_2], eax ; Store the converted number in the counter variable.


    ; Load the value of `num_1` (100) into the `eax` register for comparison.
    MOV eax, dword ptr [num_1]
    
    ; Load the value of `num_2` (200) into the `ebx` register for comparison.
    MOV ebx, dword ptr [num_2]

    ; Compare the value in `eax` (num_1) with the value in `ebx` (num_2).
    CMP eax, ebx

    ; If `eax` is greater than `ebx` (num_1 > num_2), jump to `setNum1AsBigger`.
    JA setNum1AsBigger              ; JA (Jump Above) checks if num_1 is greater than num_2.

    ; If `eax` is less than or equal to `ebx`, jump to `setNum2AsBigger`.
    JBE setNum2AsBigger             ; JBE (Jump Below or Equal) checks if num_1 is less than or equal to num_2.

; This label is reached if `num_1` is greater than `num_2`.
setNum1AsBigger:
    ; Store the value of `num_1` (currently in `eax`) into the `greater_num` variable.
    MOV dword ptr [greater_num], eax
    ; After setting `greater_num`, jump to `printGreaterNumber` to print the result.
    JMP printGreaterNumber

; This label is reached if `num_2` is greater than or equal to `num_1`.
setNum2AsBigger:
    ; Store the value of `num_2` (currently in `ebx`) into the `greater_num` variable.
    MOV dword ptr [greater_num], ebx

; This label handles printing the greater number.
printGreaterNumber:

    ; Convert the modified DWORD back into a string using dwtoa (a MASM32 helper function).
    invoke dwtoa, dword ptr[greater_num], offset outputString

    invoke StrLen, addr outputString
    mov tamanho_string1, eax      ; Store the length of the input string in tamanho_string.

    ; Use the `printf` function to print "Number is greater: <greater_num>".
    invoke WriteConsole, outputHandle, addr outputString, tamanho_string1, addr console_count, NULL 

; Exit the program gracefully.
exitTheProgram:
    ; Use the `ExitProcess` API function to terminate the program.
    invoke ExitProcess, 0

end start                          ; Mark the end of the program, with `start` as the entry point.
