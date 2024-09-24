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
    var_b dd 20
    var_c dd 30

.code
start:
    MOV eax, dword ptr [var_b]
    ADD eax, dword ptr [var_c]
    ADD eax, 100
     
    printf("Valor de A: %d", eax)

    invoke ExitProcess, 0
end start
