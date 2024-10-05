.686                              ; Use the 686 (32-bit) instruction set (targeting 32-bit x86 architecture).
.model flat, stdcall               ; Use the flat memory model and the standard calling convention.
option casemap :none               ; Make labels and variable names case-sensitive.

; Include necessary headers for Windows API and MSVCRT (C runtime) functions.
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

.data                              ; Start of the data segment for variables and arrays.
    myArray dw 1,2,3,4,5,6,7,8,9,10  ; Declare an array of 10 16-bit words (shorts).
    arraySize dd 10                ; Store the size of the array (10 elements).

.code                              ; Start of the code segment where the logic resides.
start:
    ; Initialize `ebx` to 0 to store the sum of array elements.
    MOV ebx, 0

    ; Load the starting address of `myArray` into `esi` (which will be used to iterate through the array).
    MOV esi, offset myArray

    ; Load the size of the array (10) into `ecx`, which will act as the loop counter.
    MOV ecx, dword ptr [arraySize]

loopStart:
    ; Clear `eax` to avoid issues with the higher bits (since we are dealing with 16-bit words).
    XOR eax, eax

    ; Move the current 16-bit array element (pointed by `esi`) into `ax` (lower half of `eax`).
    MOV ax, word ptr [esi]

    ; Add the value of the current element (in `eax`) to the sum stored in `ebx`.
    ADD ebx, eax

    ; Increment the array pointer by 2 bytes (size of a 16-bit word) to point to the next element.
    ADD esi, 2

    ; Decrement the loop counter (`ecx`) and loop back to `loopStart` if `ecx` is not zero.
    LOOP loopStart

    ; Print the result (the sum) using the `printf` function.
    printf("Result: %d", ebx)

exitTheProgram:
    ; Exit the program by calling the `ExitProcess` API function.
    invoke ExitProcess, 0

end start                          ; End of the program, with `start` as the entry point.
