.686                           ; Use 32-bit instructions (targeting 32-bit x86 architecture).
.model flat,stdcall             ; Flat memory model and standard calling convention.
option casemap:none             ; Case-sensitive for labels and variable names.

; Include the necessary headers and libraries for Windows API and MASM functions.
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data                           ; Data segment declaration for static variables.
var_b dd 0                      ; Variable to store the converted DWORD value.
outputString db 50 dup(0)        ; Buffer to store the string output of the DWORD value.
inputString db 50 dup(0)         ; Buffer to store the input string from the console.
inputHandle dd 0                ; Variable to store the input console handle.
outputHandle dd 0               ; Variable to store the output console handle.
console_count dd 0              ; Variable to store the count of characters read/written.
tamanho_string dd 0             ; Variable to store the length of the input string.

.code                           ; Code segment starts here.

start:
    ; Get the input handle (keyboard) using GetStdHandle API function.
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax         ; Store the input handle in the inputHandle variable.

    ; Get the output handle (console screen) using GetStdHandle API function.
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax        ; Store the output handle in the outputHandle variable.

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
    MOV dword ptr [var_b], eax   ; Store the converted number in the var_b variable.

    ; Add 10 to the converted DWORD value (just to test if the convertion do DWORD was correct).
    ADD dword ptr [var_b], 10

    ; Convert the modified DWORD back into a string using dwtoa (a MASM32 helper function).
    invoke dwtoa, var_b, offset outputString

    ; Write the string representation of the modified DWORD to the console using WriteConsole.
    invoke WriteConsole, outputHandle, addr outputString, tamanho_string, addr console_count, NULL

    ; Exit the process using the ExitProcess API function.
    invoke ExitProcess, 0

end start                       ; Mark the end of the program, with 'start' as the entry point.
