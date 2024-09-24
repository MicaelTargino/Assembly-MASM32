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
    num_1 dd 100
    num_2 dd 200
    greater_num dd ?

.code
start:    
    MOV eax, dword ptr [num_1]
    MOV ebx, dword ptr [num_2]

    CMP eax, ebx

    JA setNum1AsBigger

    JBE setNum2AsBigger    

setNum1AsBigger:
    MOV dword ptr [greater_num], eax
    JMP printGreaterNumber

setNum2AsBigger:
    MOV dword ptr [greater_num], ebx

printGreaterNumber:
    printf("Number is greater: %d\n", greater_num)
    
exitTheProgram:
    invoke ExitProcess, 0
end start
