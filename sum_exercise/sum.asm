.686                              ; Use the 686 (32-bit) instruction set (32-bit x86 architecture).
.model flat, stdcall               ; Use the flat memory model and the standard calling convention.
option casemap :none               ; Make labels and variable names case-sensitive.

; Include necessary headers for Windows API and MSVCRT (C runtime) functions.
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

.data                              ; Start of the data segment for variables.
    var_b dd 20                    ; Initialize `var_b` with the value 20.
    var_c dd 30                    ; Initialize `var_c` with the value 30.

.code                              ; Start of the code segment where the logic resides.

; Define a function `sum` to sum two values.
sum:
    push ebp                       ; Save the base pointer (EBP) on the stack.
    mov ebp, esp                   ; Set the base pointer (EBP) to the current stack pointer (ESP).
    sub esp, 8                     ; Allocate 8 bytes on the stack (not strictly necessary here but typically used for local variables).

    ; Retrieve the function parameters.
    ; The first argument is at [ebp+8] (because EBP points to the old EBP, and return address is above that).
    mov edx, dword ptr [ebp+8]     ; Move the first argument into `edx`.
    ; The second argument is at [ebp+12].
    mov ecx, dword ptr [ebp+12]    ; Move the second argument into `ecx`.
    
    ; Add the two values together.
    XOR eax, eax                   ; Clear `eax` (optional, but safe practice).
    ADD ecx, edx                   ; Add `edx` (first argument) to `ecx` (second argument).
    ADD eax, ecx                   ; Store the result in `eax`.

    ; Clean up and return.
    mov esp, ebp                   ; Restore the stack pointer (ESP) to the value of EBP.
    pop ebp                        ; Restore the base pointer (EBP).
    ret 8                          ; Return and clean up the 8 bytes of arguments pushed on the stack (2 arguments, 4 bytes each).

; The start of the main program.
start:
    ; Load `var_b` (value 20) into `eax`.
    MOV eax, dword ptr [var_b]
    
    ; Push `var_c` (value 30) onto the stack (to be used as the second argument).
    push dword ptr [var_c]
    ; Push `var_b` (value 20, stored in `eax`) onto the stack (first argument).
    push eax
    ; Call the `sum` function to add `var_b` and `var_c`.
    call sum

    ; After the first `sum` call, `eax` holds the result of 20 + 30 = 50.
    
    ; Push 100 (third number) onto the stack.
    push 100
    ; Push the result of the previous sum (stored in `eax`, which is 50) onto the stack.
    push eax
    ; Call the `sum` function again to add 100 and 50.
    call sum
    
    ; After this second `sum` call, `eax` now holds the result of 50 + 100 = 150.

    ; Print the final result (`eax` = 150).
    printf("Valor de A: %d", eax)

    ; Exit the program by calling `ExitProcess`.
    invoke ExitProcess, 0

end start                          ; End of the program, with `start` as the entry point.
