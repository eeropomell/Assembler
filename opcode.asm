

section .data


    null db "null", 0
    M db "M", 0
    D db "D", 0
    DM db "DM", 0
    A db "A", 0
    AM DB "AM", 0
    AD db "AD", 0
    ADM db "ADM", 0


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


section .text
    
%macro strcmp 2
    push rdi
    mov edi, %1
    getStringLength edi
    mov esi, %2
    repe cmpsb
    pop rdi
%endmacro

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


    ; OPCODE FOR DESTINATION
    destop:
      
        strcmp dest, null
        jnz n1
        mov dword [op], "000"
        jmp finish
        n1:
        strcmp dest, D
        jnz n2
        mov dword [op], "010"
        jmp finish
        n2:
        strcmp dest, M
        jnz n3
        mov dword [op], "001"
        jmp finish
        n3:
        strcmp dest, A 
        jnz n4
        mov dword [op], "100"
        jmp finish
        n4:
        strcmp dest, DM
        jnz n5
        mov dword [op], "011"
        jmp finish
        n5:
        strcmp dest, AM
        jnz n6
        mov dword [op], "101"
        jmp finish
        n6:
        strcmp dest, AD
        jnz n7
        mov dword [op], "110"
        jmp finish
        n7:
        strcmp dest, ADM
        jnz finish
        mov dword [op], "111"

        finish:
     
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


        



        
        
        

        
        
        
        
        
        
        
        

        
        
  
        

        ret
