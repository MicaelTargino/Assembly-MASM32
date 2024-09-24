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
    counter dd 100 
    accumulator dd 0
    
.code
start:
    MOV ecx, dword ptr [counter]
    MOV ebx, dword ptr [accumulator]
    MOV edx, 0    
loopStart:
    INC edx
    ADD ebx, edx
    LOOP loopStart

printResult:
    printf("Result: %d", ebx)

    
exitTheProgram:
    invoke ExitProcess, 0
end start
