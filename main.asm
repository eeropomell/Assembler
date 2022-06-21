%include "macro.asm"

section .bss 
    line resb 10
    instructionT resb 1

    symbol resb 10

    dest resb 4
    comp resb 4
    jump resb 4

A_INSTRUCTION equ 0
C_INSTRUCTION equ 1
L_INSTRUCTION equ 2


section .data
    filename db "file.asm", 0
    reset times 10 db 0



section .text
    global _start 
        

    _start:
        openfile filename
        push rax
        xor ecx, ecx

        call readfile
        xor ecx, ecx
        .loop:
            inc ecx
            
            call getline
            call getline

            print line, 10
            
            
            
            
            
            
            
    
            
            endloop:

            
            
            

            cmp byte [esi], 0
            
            

        end:
        
        
                   

        exit

        instructionType:
            mov edi, [rsp + 8]
            cmp byte [edi], "@"                             ; @xxx = A_INSTRUCTION
            jne .around1
            mov byte [instructionT], A_INSTRUCTION
            jmp .end
            .around1: 
            cmp byte [edi], "("                             ; (label) = L_INSTRUCTION
            jne .around2
            mov byte [instructionT], L_INSTRUCTION
            jmp .end
            .around2:
            mov byte [instructionT], C_INSTRUCTION          ; default = C_INSTRUCTION
            .end:
            
            ret 

    
        getCharacter:
            mov esi, [rsp + 24]
            mov al, [rsp + 16]
            
            cmp byte [rsp + 16], "D"            ; skip first loop, if getting dest
            je string

            .loop:
                cmp byte [esi], 0
                jz .out
                inc esi
                cmp byte [esi], al
                jne .loop
            .out:
            inc esi
            string:
            mov edi, [rsp + 8]
            mov al, [esi]
            .loop:
                cmp byte [esi], 0
                jz .end
                cmp byte [esi], ";"
                je .end
                cmp byte [esi], "="
                je .end
                movsb  
                jmp .loop
            
            .end:   
            ret



        getSymbol: 
            
            mov edi, [rsp + 8]                  ; line
            inc edi                             ; skip @ or (
            mov esi, symbol
            
            .loop:
                cmp byte [edi], ")"
                je .end
                cmp byte [edi], 0
                je .end
                cmp byte [edi], 10
                je .end
                mov al, [edi]
                mov [esi], al
                inc esi
                inc edi
                jmp .loop 
            .end:

            ret
            

            

        getline:
           
            mov edi, line

            
            push line
            call clearname
            




            whitespace:
            cmp byte [esi], 10
            jne .loop
            inc esi
            jmp whitespace
            

            .loop:
                movsb
                cmp byte [esi], 10
                jne .loop
        ret

        readfile:
            mov eax, SYSREAD
            mov edi, [rsp + 8]
            mov esi, buffer
            mov edx, 320
            syscall
            ret
       

        clearname:
            mov rbp, rsp
            push rdi
            push rsi
            mov edi, reset
            mov esi, [rsp + 8]

            .loop:
                movsb
                cmp byte [esi], 0
                jnz .loop
            pop rsi
            pop rdi
          
            ret 8



; nasm -gdwarf -f elf64 main.asm
; ld -g -o main main.o -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -m elf_x86_64
; ld -m elf_x86_64 -g -o main main.o
