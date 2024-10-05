.686
.model flat,stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
var_b dd 0
outputString db 50 dup(0)
inputString db 50 dup(0)
inputHandle dd 0 ; Variavel para armazenar o handle de entrada
outputHandle dd 0 ; Variavel para armazenar o handle de saida
console_count dd 0 ; Variavel para armazenar caracteres lidos/escritos na console
tamanho_string dd 0 ; Variavel para armazenar tamanho de string terminada em 0

.code

start:
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax

    invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr console_count, NULL
    invoke StrLen, addr inputString
    mov tamanho_string, eax

    mov esi, offset inputString
proximo:
    mov al, [esi]
    inc esi
    cmp al, 13
    jne proximo
    dec esi
    xor al, al
    mov [esi], al

    invoke atodw, offset inputString
    MOV dword ptr [var_b],eax

    ADD dword ptr [var_b], 10

    invoke dwtoa, var_b, offset outputString

    invoke WriteConsole, outputHandle, addr outputString, tamanho_string, addr console_count, NULL
    invoke ExitProcess, 0
end start



