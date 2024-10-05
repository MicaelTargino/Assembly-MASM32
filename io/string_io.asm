.686                          ; Set the processor to use the 686 (32-bit) instruction set.
.model flat,stdcall            ; Use the flat memory model and the standard calling convention.
option casemap:none            ; Make labels and variable names case-sensitive.

; Include necessary headers and libraries for using Windows API functions and MASM32 functions.
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data                          ; Start of the data segment for storing static data (variables).
var_b dd 0                     ; A variable to store the converted DWORD value (32-bit integer).
inputString db 50 dup(0)        ; A buffer to store the input string from the console (50 characters max).
inputHandle dd 0               ; A variable to store the handle for console input (keyboard).
outputHandle dd 0              ; A variable to store the handle for console output (screen).
console_count dd 0             ; A variable to store the number of characters read or written to the console.
tamanho_string dd 0            ; A variable to store the length of the input string (calculated length).

.code                          ; Start of the code segment, where the program logic resides.
start:
    ; Get the handle for console input (keyboard) using GetStdHandle API function.
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax        ; Store the input handle in the inputHandle variable.

    ; Get the handle for console output (screen) using GetStdHandle API function.
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax       ; Store the output handle in the outputHandle variable.

    ; Read a string from the console using ReadConsole API function.
    ; - inputHandle: the handle to read input from (keyboard).
    ; - inputString: the address where the input string will be stored.
    ; - sizeof inputString: the size of the buffer (50 bytes).
    ; - console_count: stores the number of characters read.
    invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr console_count, NULL

    ; Calculate the length of the input string using the StrLen (MASM32 helper function).
    ; StrLen returns the length of the string in `eax`.
    invoke StrLen, addr inputString
    mov tamanho_string, eax     ; Store the length of the input string in tamanho_string.

    ; Convert the input string (ASCII) to a DWORD (32-bit integer) using atodw (MASM32 helper function).
    ; The result (converted number) is stored in `eax`.
    invoke atodw, offset inputString
    mov dword ptr [var_b], eax  ; Store the converted value in the var_b variable.

    ; Write the DWORD value stored in var_b to the console using WriteConsole.
    ; - outputHandle: the handle to write to (console output).
    ; - addr var_b: address of the DWORD variable (but this is problematic, as WriteConsole expects a string).
    ; - tamanho_string: number of bytes to write (but the size of a DWORD is 4 bytes, not the string length).
    ; - console_count: stores the number of characters written to the console.
    invoke WriteConsole, outputHandle, addr var_b, tamanho_string, addr console_count, NULL

    ; Terminate the process using ExitProcess API function.
    invoke ExitProcess, 0

end start                      ; Mark the end of the program with 'start' as the entry point.
