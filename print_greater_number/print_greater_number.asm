.686                              ; Use the 686 (32-bit) instruction set.
.model flat, stdcall               ; Use the flat memory model and the standard calling convention.
option casemap :none               ; Make labels and variable names case-sensitive.

; Include necessary headers for Windows API and MSVCRT (C runtime) functions.
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

.data                              ; Start of the data segment for storing variables.
    num_1 dd 100                   ; Initialize the first number (`num_1`) with the value 100.
    num_2 dd 200                   ; Initialize the second number (`num_2`) with the value 200.
    greater_num dd ?               ; A variable to store the greater number, initially uninitialized (?).

.code                              ; Start of the code segment where the program logic is defined.
start:
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
    ; Use the `printf` function to print "Number is greater: <greater_num>".
    printf("Number is greater: %d\n", greater_num)

; Exit the program gracefully.
exitTheProgram:
    ; Use the `ExitProcess` API function to terminate the program.
    invoke ExitProcess, 0

end start                          ; Mark the end of the program, with `start` as the entry point.
