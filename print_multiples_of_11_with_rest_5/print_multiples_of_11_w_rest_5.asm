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
    start_value dd 1000
    divisor dd 11
.code
start:
    MOV ebx, dword ptr [start_value]
    MOV ecx, 1000

loopStart:
    CMP ebx, 1999
    JA exitTheProgram

    MOV esi, 11
    MOV eax, ebx
    XOR edx, edx
    DIV esi

    CMP edx, 5
    JNE skip

    printf("%d\n", ebx)

skip:
    INC ebx
    LOOP loopStart
    
exitTheProgram:
    invoke ExitProcess, 0
end start
