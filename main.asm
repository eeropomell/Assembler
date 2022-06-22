%include "macro.asm"
%include "opcode.asm"

section .bss 
    line resb 10
    instructionT resb 1
    notfound resb 1
    symbol resb 10

    dest resb 6
    comp resb 6
    jump resb 6

    op resb 64

A_INSTRUCTION equ 0
C_INSTRUCTION equ 1
L_INSTRUCTION equ 2


section .data
    filename db "file.asm", 0
    opfile db "opcode.txt", 0
    reset times 10 db 0
    opcode db "0000000000000000"


section .text
    global _start 
        

    _start:
        openfile filename
        push rax

        call readfile
        xor ecx, ecx
        .loop:
            inc ecx

            call getline
            call getline
            push line
            call instructionType
            cmp byte [instructionT], C_INSTRUCTION
            jne skip

            call getDetails
            mov edi, opcode
            mov al, "1"
            mov ecx, 3
            repe stosb
            inc edi
            call compop
            mov esi, op
            mov ecx, 6
            repe movsb
            cmp byte [dest], 0
            jz nodest
            call destop
            mov esi, op
            mov ecx, 3
            repe movsb
            nodest:
            cmp byte [jump], 0
            jz skip
            call jumpop
            mov esi, op
            mov ecx, 3
            repe movsb      
            skip:
            print opcode, 16
            

            
            
            
            
  

            
            endloop:

            
            

            
            

        end:
        
        
                   

        exit

        instructionType:
            mov edi, [rsp + 8]
            inc edi
            
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
          
        getDetails:
            mov edi, [rsp + 8]
            inc edi                ; get first byte
            mov esi, edi
            
            xor eax, eax
            hasDest:
                mov ecx, 10
                mov al, "="
                repne scasb
                cmp byte [edi], 0
                jz getComp
                              
                mov edi, dest
                getDest:
                    movsb
                    cmp byte [esi], "="
                    jne getDest
                    inc esi
        
            getComp:
                mov edi, comp
                .loop:
                    movsb
                    cmp byte [esi], ";"
                    je getJump
                    cmp byte [esi], 0
                    jnz .loop
                    jmp out
            getJump:
            inc esi
            mov edi, jump
                .loop:
                    movsb
                    cmp byte [esi], 0
                    jnz .loop  
            out:
            ret


        getSymbol: 
            
            mov esi, [rsp + 8]                  ; line
            add esi, 2                          ; skip @ or (
            mov edi, symbol
            
            .loop:
                cmp byte [esi], ")"
                je .end
                cmp byte [esi], 0
                je .end
                cmp byte [esi], 10
                je .end
                movsb
                jmp .loop 
            .end:

            ret
            
        getline:
            call clear              ; clears the previous line

            whitespace:             ; remove whitespace from file
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

        clear:
            mov edi, line
            mov al, 0
            mov ecx, 10
            repe stosb
            sub edi, 9                     ; index back to first byte of line
            ret 



; nasm -gdwarf -f elf64 main.asm
; ld -g -o main main.o -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -m elf_x86_64
; ld -m elf_x86_64 -g -o main main.o
