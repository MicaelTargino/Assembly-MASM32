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
    myArray dw 1,2,3,4,5,6,7,8,9,10
    arraySize dd 10

.code
start:
    MOV ebx,0
    MOV esi, offset myArray
    MOV ecx, dword ptr [arraySize]

loopStart:
    XOR eax, eax
    MOV ax, word ptr [esi]
    ADD ebx, eax

    ADD esi, 2

    LOOP loopStart

    printf("Result: %d",ebx)
    
exitTheProgram:
    invoke ExitProcess, 0
end start
