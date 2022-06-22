

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


section .text
    
%macro strcmp 2
    mov edi, %1
    getStringLength edi
    mov esi, %2
    repe cmpsb
%endmacro

    ; OPCODE FOR COMP
    compop:
        print comp, 4



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
        push rdi
        mov byte [jump + 3], 0
        strcmp jump, jJGE
        jnz .n1
        mov dword [op], "011"
        .n1:
        strcmp jump, null
        jnz .n2
        mov dword [op], "000"
        .n2:
        strcmp jump, jJGT
        jnz .n3
        mov dword [op], "001"
        .n3:
        strcmp jump, jJLT
        jnz .n4
        mov dword [op], "100"
        .n4:
        strcmp jump, jJNE
        jnz .n5
        mov dword [op], "101"
        .n5:
        strcmp jump, jJLE
        jnz .n6
        mov dword [op], "110"
        .n6:
        strcmp jump, jJMP
        jnz .n7
        mov dword [op], "111"
        .n7:
        pop rdi
        ret


        



        
        
        

        
        
        
        
        
        
        
        

        
        
  
        

        ret

