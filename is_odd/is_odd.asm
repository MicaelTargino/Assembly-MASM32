.686
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

.data
    num dd 81

.code
start:
    MOV eax, dword ptr [num]
    AND eax, 1 

    JZ isEven

isOdd:
    printf("Number is odd")
    JMP exitTheProgram

isEven:
    printf("Number is even")

    
exitTheProgram:
    invoke ExitProcess, 0
end start
