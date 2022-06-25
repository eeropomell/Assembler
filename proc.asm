section .text



binarySearch:
    mov rbp, rsp
    push rdi
    push rcx
    push rsi
    mov eax, 0                              ; first 
    mov edx, [rbp + 8]                      ; last
    

    getMid:      
        mov ebx, edx
        sub ebx, eax
        shr ebx, 1 
        mov edi, [rbp + 24]                 ; table address
        lea rsi, [edi + 4*eax]

        mov r8d, ebx
        imul r8d, 4                         ; size of item
        add rsi, r8
       
        
        mov edi, tempString
        .move:
            movsb
            cmp byte [esi], 0
            jnz .move
        
    
        mov ecx, [rbp + 16]                 ; field to search (jump, comp, or dest)
        strcmp ecx, tempString
        jz found
        mov r9d, ebx
        dec r9d
        mov ebx, eax
        inc ebx

        mov ecx, -1
        mov rdi, [rbp + 16] 
        mov rsi, tempString
        .compare:
            inc ecx
            mov r8b, [rdi + rcx]  
            cmp r8b, [rsi + rcx]
            je .compare
            cmova eax, ebx
            cmovl edx, r9d
            jmp getMid

            

    found:
    printNumber rax
    printNumber rbx
    
        

    pop rsi
    pop rcx
    pop rdi

    ret 24

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