

%macro strcmp 2
    push rdi
    push rdi
    push rcx
    mov edi, %1
    getStringLength edi
    mov esi, %2
    repe cmpsb
    pop rcx
    pop rsi
    pop rdi
%endmacro

section .text

strcmpArr:
    mov eax, [rsp + 8]
    mov esi, eax
    mov ecx, 0
    mov ebx, [rsp + 24]
    .intro:
        mov edi, tempString
    .move:
        movsb
        cmp byte [esi], 0
        jne .move
            print ebx, 3
            print newline, 1
            strcmp ebx, tempString
            jnz .around
            printNumber 2
            .around:
            push tempString
            push 0
            push 3
            call clear
            lea esi, [eax + 4*ecx]
            inc ecx
            cmp ecx, [rsp + 16]
            jne .intro

    ret 24
