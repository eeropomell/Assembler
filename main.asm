%include "macro.asm"

section .bss 
    line resb 10

section .data
    filename db "file.asm", 0
    

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
            print line, 10
            print newline, 1

            cmp byte [esi], 0
            jnz .loop

        end:
        
            
            
     

        exit

        getline:
            mov edi, line
            xor eax, eax
            and [edi], eax

            whitespace:
                cmp byte [esi], 10              ; increment byte incase its a newline
                jne .loop
                inc esi
                jmp whitespace


            .loop:
                cmp byte [esi], 10
                je return
                cmp byte [esi], 32
                je return
                cmp byte [esi], 0
                je return

                mov al, [esi]
                mov [edi], al
                inc esi
                inc edi
                jmp .loop
            
            return:
                inc esi
                ret

        readfile:
            mov eax, SYSREAD
            mov edi, [rsp + 8]
            mov esi, buffer
            mov edx, 320
            syscall
            ret
        exit



; nasm -gdwarf -f elf64 main.asm
; ld -g -o main main.o -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -m elf_x86_64
; ld -m elf_x86_64 -g -o main main.o
