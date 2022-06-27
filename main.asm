%include "macro.asm"
%include "opcode.asm"
%include "symbolTable.asm"


section .bss 
    line resb 20
    instructionT resb 1
    symbol resb 10

    comp resb 6
    jump resb 6
    dest resb 6

    symbolTable resb 1000
    symbolCodes resb 1000


    fileptr resb 64
    totalBytes resb 4
    bytenum resb 4

A_INSTRUCTION equ 0
C_INSTRUCTION equ 1
L_INSTRUCTION equ 2


section .data
    filename db "file.asm", 0
    opcode db "0000000000000000"
    
    lastround db false

section .text
    global _start 
        
    _start:
        
        openfile filename
        push rax            ; file descriptor

        call readfile       
        call initSymbolTable

        firstWave:
            push qword [totalBytes]
            push qword [bytenum]
            push qword [fileptr]

            mov r10, 0
            .line:
            inc r10

            call getline
            xor eax, eax
            cmp byte [line + 1], "("
            jne .iteration

            call getSymbol
            
            push 8
            push symbolTable
            push symbol
            push r15
            call binarySearch

            push tempString
            push 0
            push 10
            call clear
                    
            numberToString r10d, tempString   
            
            push qword [symbol]
            push qword [edi]
            call addSymbol

            .iteration:

            push symbol 
            push 0
            push 10
            call clear

            cmp byte [lastround], true
            jne .line
            
            mov byte [lastround], false
            pop qword [fileptr]
            pop qword [bytenum]
            pop qword [totalBytes]
      
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
            call compOP                         ; opcode for comp field
            add al, 30h
            mov [opcode + 3], al
            push comp 
            push 6
            call fill
            
            cmp byte [dest], 0                  ; destination field is optional
            jz nodest
            call destOP        
            push dest
            push 3
            call fill   
            jmp jumpfield  

            nodest:
            add edi, 3                          ; fill adds 3 to edi so do it here if fill isnt called

            jumpfield:
            cmp byte [jump], 0                  ; jump field is optional
            jz cleanup
            
            call jumpOP            
            push jump
            push 3
            call fill
            
            cleanup:    
            push comp                            ; clears comp, dest and jump field
            push 0
            push 18                              ; clear 18 bytes which is comp, dest and jump
            call clear

            jmp iteration

            a_instruction:
            call getSymbol                       ; for example @150 symbol = "150"

            cmp byte [symbol], "0"
            jl handle 
            cmp byte [symbol], "9"
            jg handle 
            jmp donthandle

            handle:
            call symbolOP
            donthandle:
             
            stringToNumber symbol
            call binaryString
            
            push symbol                          ; clear symbol for next iteration
            push 0
            push 10
            call clear

            iteration:   
                
                print newline, 1
                
                push opcode                      ; clear opcode for next iteration
                push "0"
                push 16
                call clear

                cmp byte [lastround], true       ; true if end of file
                jne main
                
        theEnd:
        exit

        binaryString:                               ; convert A instruction to binary version
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
    
            mov eax, C_INSTRUCTION
            mov ebx, A_INSTRUCTION 
            mov ecx, L_INSTRUCTION
            cmp byte [edi], "@"
            cmove eax, ebx
            cmp byte [edi], "("
            cmove eax, ecx
            mov [instructionT], eax
            
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
            mov byte [jump + 3], 0
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
            push 20
            call clear              ; clears the previous line
            sub edi, 19              ; get back to starting index

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
            push rax
            mov edi, [rbp + 24]         ; address to be cleared
            mov al, [rbp + 16]          
            mov ecx, [rbp + 8]
            repe stosb
      
            pop rax
            pop rcx
            pop rsi
            ret 24




