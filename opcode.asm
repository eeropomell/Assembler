%include "string.asm"

section .data
    null db "null", 0
    M db "M", 0
    D db "D", 0
    DM db "DM", 0
    A db "A", 0
    AM DB "AM", 0
    AD db "AD", 0
    ADM db "ADM", 0
    MD db "MD", 0

    jJGT db "JGT", 0
    jJGE db "JGE", 0
    jJEQ db "JEQ", 0
    jJLT db "JLT", 0
    jJNE db "JNE", 0
    jJLE db "JLE", 0
    jJMP db "JMP", 0

    zero db "0", 0
    one db "1", 0
    negone db "-1", 0
    notD db "!D", 0
    notA db "!A", 0
    notM db "!M", 0
    minusD db "-D", 0
    minusA db "-A", 0
    minusM db "-M", 0
    dplus1 db "D+1", 0
    aplus1 db "A+1", 0
    mplus1 db "M+1", 0
    dminus1 db "D-1", 0
    aminus1 db "A-1", 0
    mminus1 db "M-1", 0
    dplusa db "D+A", 0
    dplusm db "D+M", 0
    dminusa db "D-A", 0
    dminusm db "D-M", 0
    aminusd db "A-D", 0
    mminusd db "M-D", 0
    danda db "D&A", 0
    dandm db "D&M", 0
    dora db "D|A", 0
    dorm db "D|M", 0


    
    destM dd "M", "MD"
    mDestEnd db 0
    mDestCode db "001", "011"
    destD dd "D", "DM"
    dDestEnd db 0
    dDestCode db "010", "011"
    destA dd "A", "AD", "AM", "ADM"
    aDestEnd db 0
    aDestCode db "100", "101" 
    


    destTable:
        dq destM
        dq mDestEnd
        dq mDestCode
        dq destD
        dq dDestEnd
        dq dDestCode
        dq destA 
        dq aDestEnd
        dq aDestCode
    

        

    

    registers dd "R0", "R1", "R2"
    dd "R3", "R4", "R5"
    dd "R6", "R7", "R8" 
    dd "R9", "R10", "R11"
    dd "R12", "R13", "R14", "R15"
    registersEnd db 0
    
    predefined dq "SCREEN", "KBD", "SP"
    dq "LCL", "ARG", "THIS", "THAT"
    predefinedEnd db 0

    t_predefined dq "16384", "24576", "0"
    dq "1", "2", "3", "4"


    jumpTable db "JEQ", "JGE", "JGT"
    db "JLE", "JLT", "JNE", "JMP", 0

    jmpPtr:
        dq jumpTable
        dq jumpTable + 15

section .bss 
    tempString resb 6

section .text


    jumpProc:
        push rdi
        push rcx
        push rsi
        xor eax, eax
        mov rbx, [jmpPtr + 8]               ; end pointer
        mov rsi, [jmpPtr]                   ; start pointer

        getMid:
            mov rdi, rbx                        
            sub rdi, rsi
            shr rdi, 1                      ; divide by 2
            lea rsi, [rsi + rdi]
            mov edi, tempString
            mov ecx, 3
            repe movsb
        print tempString, 3

        pop rsi
        pop rcx
        pop rdi
        ret
    


    handlePredefined:
        xor eax, eax
        mov esi, predefined
        mov ecx, 0   


        cmp byte [symbol], "R"
        jne skip 
        cmp byte [symbol + 1], "0"
        jl skip 
        cmp byte [symbol + 1], "9"
        jg skip

        push 4
        push registersEnd
        push symbol
        push registers
        call strcmpArr
        cmp esi, registersEnd 
        je skip2
        mov esi, symbol + 1
        mov edi, symbol
        mov ecx, 6
        repe movsb

        skip:
        cmp byte [symbol], "R"
        je skip2
        
        push 8
        push predefinedEnd
        push symbol
        push predefined
        call strcmpArr
        cmp esi, predefinedEnd
        je skip2 
        dec ecx
        push symbol
        push 0
        push 6
        call clear
      
        lea esi, [t_predefined + 8*ecx]
        mov edi, symbol
        .move:
            movsb
            cmp byte [esi], 0
            jne .move
        
        skip2:
        
        
        ret

            ; OPCODE FOR DESTINATION
    destop:
        push rdi
        push rsi
        mov edx, 0
        cmp byte [dest], "M"
        cmove r8, [destTable]
        cmove r9, [destTable + 8]
        cmove r10, [destTable + 16]
        cmp byte [dest], "D"
        cmove r8, [destTable + 24]
        cmove r9, [destTable + 32]
        cmove r10, [destTable + 40]
        cmp byte [dest], "A"
        cmove r8, [destTable + 48]
        cmove r9, [destTable + 56]
        cmove r10, [destTable + 64]

        push 4
        push r9
        push dest 
        push r8
        call strcmpArr
        dec rcx
        lea r8, [r10 + rcx]
        xor r9, r9
        mov r9b, [r8]
        mov edi, dest 
        mov esi, r8d
        mov ecx, 3
        repe movsb
        
        pop rsi
        pop rdi
        ret

    ; OPCODE FOR COMP
    compop:
        strcmp comp, zero
        jnz .n1
        mov rdx, "101010"
        mov byte [opcode + 3], "0"
        mov [op], rdx
        jmp finishcomp
        .n1:
        strcmp comp, one
        jnz .n2
        mov rdx, "111111"
        mov [op], rdx
        mov byte [opcode + 3], "0"
        jmp finishcomp
        .n2:
        strcmp comp, negone
        jnz .n3
        mov rdx, "111010"
        mov [op], rdx
        mov byte [opcode + 3], "0"
        jmp finishcomp
        .n3:
        strcmp comp, D 
        jnz .n4
        mov rdx, "001100" 
        mov [op], rdx
        mov byte [opcode + 3], "0"
        jmp finishcomp
        .n4:
        strcmp comp, A
        jnz .n5
        mov rdx, "110000"
        mov [op], rdx
        mov byte [opcode + 3], "0"
        jmp finishcomp
        .n5:
        strcmp comp, M
        jnz .n6
        mov rdx, "110000"
        mov [op], rdx
        mov byte [opcode + 3], "1"
        jmp finishcomp
        .n6:
        strcmp comp, notD
        jnz .n7
        mov rdx, "001101"
        mov [op], rdx
        mov byte [opcode + 3], "0"
        jmp finishcomp
        .n7:
        strcmp comp, notA
        jnz .n8
        mov rdx, "110001"
        mov [op], rdx
        mov byte [opcode + 3], "0"
        jmp finishcomp
        .n8:
        strcmp comp, notM
        jnz .n9
        mov rdx, "110001"
        mov [op], rdx
        mov byte [opcode + 3], "1"
        jmp finishcomp
        .n9:
        strcmp comp, minusD
        jnz .n10
        mov rdx, "001111"
        mov [op], rdx
        mov byte [opcode + 3], "0"
        jmp finishcomp
        .n10:
        strcmp comp, minusA
        jnz .n11
        mov rdx, "110011"
        mov [op], rdx
        mov byte [opcode + 3], "0"
        jmp finishcomp
        .n11:
        strcmp comp, minusM
        jnz .n12
        mov rdx, "110011"
        mov [op], rdx
        mov byte [opcode + 3], "1"
        jmp finishcomp
        .n12:
        strcmp comp, dplus1
        jnz .n13
        mov rdx, "011111"
        mov [op], rdx
        mov byte [opcode + 3], "0"
        jmp finishcomp
        .n13:
        strcmp comp, aplus1
        jnz .n14
        mov rdx, "110111"
        mov [op], rdx
        mov byte [opcode + 3], "0"
        jmp finishcomp
        .n14:
        strcmp comp, mplus1
        jnz .n15
        mov rdx, "110111"
        mov [op], rdx
        mov byte [opcode + 3], "1"
        jmp finishcomp
        .n15:
        strcmp comp, dminus1
        jnz .n16  
        mov rdx, "001110"
        mov [op], rdx
        mov byte [opcode + 3], "0"
        jmp finishcomp
        .n16:
        strcmp comp, aminus1
        jnz .n17
        mov rdx, "110010"
        mov [op], rdx
        mov byte [opcode + 3], "0"
        jmp finishcomp
        .n17:
        strcmp comp, mminus1
        jnz .n18
        mov rdx, "110010"
        mov [op], rdx
        mov byte [opcode + 3], "1"
        jmp finishcomp
        .n18:
        strcmp comp, dplusa
        jnz .n19
        mov rdx, "000010"
        mov [op], rdx
        mov byte [opcode + 3], "0"
        jmp finishcomp
        .n19:
        strcmp comp, dplusm
        jnz .n20
        mov rdx, "000010"
        mov [op], rdx
        mov byte [opcode + 3], "1"
        jmp finishcomp
        .n20:
        strcmp comp, dminusa
        jnz .n21
        mov rdx, "010011"
        mov [op], rdx
        mov byte [opcode + 3], "0"
        jmp finishcomp
        .n21:
        strcmp comp, dminusm
        jnz .n22
        mov rdx, "010011"
        mov [op], rdx
        mov byte [opcode + 3], "1"
        jmp finishcomp
        .n22:
        strcmp comp, aminusd
        jnz .n23
        mov rdx, "000111"
        mov [op], rdx
        mov byte [opcode + 3], "0"
        jmp finishcomp
        .n23:
        strcmp comp, mminusd
        jnz .n24
        mov rdx, "000111"
        mov [op], rdx
        mov byte [opcode + 3], "1"
        jmp finishcomp
        .n24:
        strcmp comp, danda
        jnz .n25
        mov rdx, "000000"
        mov [op], rdx
        mov byte [opcode + 3], "0"
        jmp finishcomp
        .n25:
        strcmp comp, dandm
        jnz .n26
        mov rdx, "000000"
        mov [op], rdx
        mov byte [opcode + 3], "1"
        jmp finishcomp
        .n26:
        strcmp comp, dora
        jnz .n27
        mov rdx, "010101"
        mov [op], rdx
        mov byte [opcode + 3], "0"
        jmp finishcomp
        .n27:
        strcmp comp, dorm
        jnz finishcomp
        mov rdx, "010101"
        mov [op], rdx
        mov byte [opcode + 3], "1"

        finishcomp:
        ret


    ; OPCODE FOR JUMP FIELD
    jumpop:
        mov byte [jump + 3], 0

        strcmp jump, jJGE
        jnz .n1
        mov dword [op], "011"
        jmp endjump
        .n1:
        strcmp jump, null
        jnz .n2
        mov dword [op], "000"
        jmp endjump
        .n2:
        strcmp jump, jJGT
        jnz .n3
        mov dword [op], "001"
        jmp endjump
        .n3:
        strcmp jump, jJLT
        jnz .n4
        mov dword [op], "100"
        jmp endjump
        .n4:
        strcmp jump, jJNE
        jnz .n5
        mov dword [op], "101"
        jmp endjump
        .n5:
        strcmp jump, jJLE
        jnz .n6
        mov dword [op], "110"
        jmp endjump
        .n6:
        strcmp jump, jJMP
        jnz endjump
        mov dword [op], "111"

        endjump:
       
        ret

