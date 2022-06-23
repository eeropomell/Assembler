%include "macro.asm"
%include "opcode.asm"

section .bss 
    line resb 10
    instructionT resb 1
    symbol resb 10

    comp resb 6
    jump resb 6
    dest resb 6

    op resb 64

    fileptr resb 64
    totalBytes resb 4
    bytenum resb 4

A_INSTRUCTION equ 0
C_INSTRUCTION equ 1
L_INSTRUCTION equ 2


section .data
    filename db "file.asm", 0
    opfile db "opcode.txt", 0
    reset times 10 db 0
    opcode db "0000000000000000"
    
    lastround db false

section .text
    global _start 
        

    _start:
        
        openfile filename
        push rax            ; file descriptor

        call readfile       

        main: 
            call getline
            
            push line
            call instructionType        

            cmp byte [instructionT], C_INSTRUCTION          
            jne a_instruction

            call getDetails                     ; get comp, dest and jump fields   
            mov edi, opcode
            mov al, "1"                         ; first three bytes are 111
            mov ecx, 3
            repe stosb
            inc edi                      
            call compop             ; opcode for comp field
            push op
            push 6
            call fill
            
            cmp byte [dest], 0      ; destination field is optional
            jz nodest
            call destop         
            push op
            push 3
            call fill   
            jmp jumpfield  

            nodest:
            add edi, 3              ; fill adds 3 to edi so do it here if fill isnt called

            jumpfield:
            cmp byte [jump], 0      ; jump field is optional
            jz cleanup
            call jumpop             
            push op
            push 3
            call fill
            
            cleanup:    
            push comp           ; clears comp, dest and jump field
            push 0
            push 18             ; clear 18 bytes which is comp, dest and jump
            call clear

            jmp iteration

            a_instruction:
            call getSymbol          ; for example @150 symbol = "150"

            cmp byte [symbol], "0"
            jl handle 
            cmp byte [symbol], "9"
            jg handle 
            jmp donthandle

            handle:
            call handlePredefined
            donthandle:
            
             
            stringToNumber symbol
            call binaryString

            push symbol             ; clear symbol for next iteration
            push 0
            push 10
            call clear

            iteration:   
                
                print newline, 1

                push opcode             ; clear opcode for next iteration
                push "0"
                push 16
                call clear

                cmp byte [lastround], true              ; true if end of file
                jne main
                
        theEnd:

        exit

        


        binaryString:                   ; convert A instruction to binary version
            mov eax, edi
            mov ebx, 2
            mov ecx, 15
            mov edi, opcode + 15
            binary:
                cdq
                div ebx
                add dl, 48
                mov byte [edi], dl
                dec edi
                loop binary
            ret
        

        instructionType:
            mov edi, line
            .whitespace:
                cmp byte [edi], 0
                jnz .out
                inc edi
                jmp .whitespace
            .out:
    
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
          
        getDetails:                 ; get dest, comp and jump for C instruction
            mov edi, line
            inc edi                ; get first byte
            mov esi, edi
            
            xor eax, eax
            hasDest:                            ; if strings contains "=" it has the destination field
                ;                               ; example: A=M+1, destination = A
                mov ecx, 10
                mov al, "="
                repne scasb
                cmp byte [edi], 0               ; if no destination skip to the next loop
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
            
            mov esi, line
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
            mov ebx, [totalBytes]           ; needed for checking end of file
            mov esi, [fileptr]
            
            push line    
            push 0                  
            push 10
            call clear              ; clears the previous line
            sub edi, 9              ; get back to starting index

            whitespace:
            cmp byte [esi], 10
            je remove

            jmp move
            remove:
            inc esi
            inc byte [bytenum]
            jmp whitespace


            move:
                inc byte [bytenum]
                movsb 

                cmp [bytenum], ebx              ; if (current byte == totalbytes) set lastround to true
                jnge .around
                mov byte [lastround], true
                jmp .out
                .around:
                cmp byte [esi], 10
                jne move
            .out:
            mov [fileptr], esi
            ret 

        readfile:                       ; reads 30 bytes at a time until end of file
            mov byte [totalBytes], 0
            
            mov ebx, buffer
            mov eax, SYSREAD
            mov edi, [rsp + 8]              ; file descriptor
            mov esi, ebx                    ; buffer address
            mov edx, 30
            syscall
            mov qword [fileptr], buffer
            cmp eax, 0
            jz .out

            .readmore:
                add ebx, eax                    ; move buffer address the amount of bytes that were read
                add [totalBytes], eax
                mov eax, SYSREAD
                mov edi, [rsp + 8]
                mov esi, ebx                    
                mov edx, 30
                syscall
                
                cmp eax, 0              ; read until end of file
                jnz  .readmore 
            ret  
            
        .out:

        fill:                           ; fills the opcode string (edi has the opcode address)     
            mov esi, [rsp + 16]                
            mov ecx, [rsp + 8]
            repe movsb 
            ret 16       


        clear:
            
            mov rbp, rsp
            push rsi
            push rcx
            mov edi, [rbp + 24]         ; address to be cleared
            mov al, [rbp + 16]          
            mov ecx, [rbp + 8]
            repe stosb
            pop rcx
            pop rsi
            ret 24



; nasm -gdwarf -f elf64 main.asm
; ld -g -o main main.o -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -m elf_x86_64
; ld -m elf_x86_64 -g -o main main.o
; top gun
