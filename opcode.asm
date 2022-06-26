%include "proc.asm"

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

    predefinedTable:
        dq "ARG", "KBD", "LCL",
        dq "R0", "R1", "R10", "R11"
        dq "R12", "R13", "R14", "R15"
        dq "R2", "R3", "R4", "R5"
        dq "R6", "R7", "R8", "R9"
        dq "SCREEN", "SP", "THAT", "THIS", 0
    predefinedCodes:
        dq "2", "16384", "1", "0"
        dq "1", "10", "11", "12"
        dq "13", "14", "15", "2"
        dq "3", "4", "5", "6"
        dq "7", "8", "9", "24576"
        dq "0", "3", "4", 0


    jumpTable:
        dd "JEQ", "JGE", "JGT"
        dd "JLE", "JLT", "JMP", "JNE", 0
    jumpCodes:
        db "010", "011", "001", "110"
        db "100", "111", "101", 0

    destTable:
        dd "A", "AD", "ADM", "AM"
        dd "D", "DM", "M", "MD", 0
    destCodes:
        db "100", "110", "111", "101"
        db "010", "011", "001", "011", 0
    
    compTable:
        dd "!A", "!D", "!M", "-1", "-A", "-D", "-M"
        dd "0", "1", "A", "A+1", "A-1", "A-D", "D", "D&A"
        dd "D&M", "D+1", "D+A", "D+M", "D-1", "D-A"
        dd "D-M", "D|A", "D|M", "M", "M+1", "M-1", "M-D", 0
       
section .bss 
    tempString resb 6

section .text


    compOP:
        print comp, 6
        push 4
        push compTable
        push comp 
        push 27
        call binarySearch
        print space, 1
        mov ecx, 1
        xor eax, eax
        cmp rbx, 23
        cmovae eax, ecx
        cmp rbx, 2
        cmove eax, ecx
        cmp rbx, 6
        cmove eax, ecx
        cmp rbx, 18
        cmove eax, ecx
        cmp rbx, 21
        cmove eax, ecx
        cmp rbx, 15
        cmove eax, ecx
        printNumber rax
        
        ret

    ; OPCODE FOR JUMP
    jumpOP:
        printNumber 1
        push 4
        push jumpTable
        push jump 
        push 6                      ; last item index
        call binarySearch
        
        
        lea esi, [jumpCodes + 3*ebx]
        push jump 
        push rsi
        push 3
        call strcopy
        
        
        ret

     ; OPCODE FOR DESTINATION
    destOP:

        push 4
        push destTable
        push dest 
        push 7
        call binarySearch

        lea esi, [destCodes + 3*ebx]
        push dest
        push rsi
        push 3
        call strcopy
        
        
        push tempString
        push 0
        push 6
        call clear
        
        ret

    handlePredefined:
        push 8
        push predefinedTable
        push symbol
        push 22
        call binarySearch
        cmp ebx, 69                         ; if symbol is not predefined
        je variable
           
        lea esi, [predefinedCodes + 8*ebx]
        push symbol
        push rsi
        push 8
        call strcopy
        
        jmp endpredifined
        
        variable:

        endpredifined:
        push tempString
        push 0
        push 6
        call clear
        

        
        ret



   

