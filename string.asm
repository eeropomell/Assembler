

%macro strcmp 2
    push rdi
    push rdi
    push rcx
    push rbx
    mov edi, %1
    mov esi, %2
    getStringLength edi
    mov eax, ecx
    getStringLength esi
    cmp eax, ecx
    jne %%out
    repe cmpsb
    %%out:
    
    pop rbx
    pop rcx
    pop rsi
    pop rdi
%endmacro

section .text

strcmpArr:
     
    mov ecx, 1
    mov esi, [rsp + 8]
    mov ebx, [rsp + 16]
    .intro:
        mov edi, tempString
        .move:
            movsb
            cmp byte [esi], 0
            jne .move
        strcmp ebx, tempString
        jz .match
        push tempString
        push 0
        push 6
        call clear
        mov eax, [rsp + 8]
        lea esi, [eax + 8*ecx]
        inc ecx
        
        cmp esi, arrayEnd
        jne .intro
    .match:
    
    ret 16
