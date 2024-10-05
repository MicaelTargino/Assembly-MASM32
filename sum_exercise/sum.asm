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

sum:
    push ebp
    mov ebp, esp
    sub esp, 8

    mov edx, dword ptr [ebp+8]
    mov ecx, dword ptr [ebp+12]
    XOR eax, eax
    ADD ecx, edx   
    ADD eax, ecx

    mov esp, ebp
    pop ebp
    ret 8

start:
    MOV eax, dword ptr [var_b]
    
    push dword ptr [var_c]
    push eax
    call sum

    push 100
    push eax
    call sum
     
    printf("Valor de A: %d", eax)

    invoke ExitProcess, 0
end start
