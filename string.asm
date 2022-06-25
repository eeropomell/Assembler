

%macro strcmp 2
    push rdi
    push rsi
    push rcx
    push rbx
    push rdx
    push rax
    mov edi, %1
    mov esi, %2
    getStringLength edi
    mov eax, ecx
    getStringLength esi
    
    cmp eax, ecx
    jne %%out

    repe cmpsb
    %%out:
    pop rax
    pop rdx
    pop rbx
    pop rcx
    pop rsi
    pop rdi
%endmacro

section .text

strcmpArr:
     
    mov ecx, 1
    mov rsi, [rsp + 8]
    mov rbx, [rsp + 16]
    .intro:
        mov rdi, tempString
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
        mov rax, [rsp + 8]
        mov rdx, [rsp + 32]
        imul rdx, rcx
        lea rsi, [rax + rdx]
        inc ecx
        
        cmp rsi, [rsp + 24]
        jnge .intro
        mov ecx, 11

    .match:
        push tempString
        push 0
        push 6
        call clear
    
    
    ret 32
