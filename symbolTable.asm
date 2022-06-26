


section .data
    screen dq "SCREEN"
    screenCode dq "16384"
    kbdCode dq "24576"
    
section .text
    initSymbolTable:
        mov r15, 22                     ; table length
        mov r14, 16                     ; first variable's value

        mov qword [symbolTable], "ARG"
        mov qword [symbolTable + 8], "KBD"
        mov qword [symbolTable + 16], "LCL"
        mov qword [symbolTable + 24], "R0"
        mov qword [symbolTable + 32], "R1"
        mov qword [symbolTable + 40], "R10"
        mov qword [symbolTable + 48], "R11"
        mov qword [symbolTable + 56], "R12"
        mov qword [symbolTable + 64], "R13"
        mov qword [symbolTable + 72], "R14"
        mov qword [symbolTable + 80], "R15"
        mov qword [symbolTable + 88], "R2"
        mov qword [symbolTable + 96], "R3"
        mov qword [symbolTable + 104], "R4"
        mov qword [symbolTable + 112], "R5"
        mov qword [symbolTable + 120], "R6"
        mov qword [symbolTable + 128], "R7"
        mov qword [symbolTable + 136], "R8"
        mov qword [symbolTable + 144], "R9"
        mov rax, [screen]
        mov qword [symbolTable + 152], rax         
        mov qword [symbolTable + 160], "SP"
        mov qword [symbolTable + 168], "THAT"
        mov qword [symbolTable + 176], "THIS"


        mov qword [symbolCodes], "2"
        mov rax, [kbdCode]
        mov qword [symbolCodes + 8], rax
        mov qword [symbolCodes + 16], "1"
        mov qword [symbolCodes + 24], "0"
        mov qword [symbolCodes + 32], "1"
        mov qword [symbolCodes + 40], "10"
        mov qword [symbolCodes + 48], "11"
        mov qword [symbolCodes + 56], "12"
        mov qword [symbolCodes + 64], "13"
        mov qword [symbolCodes + 72], "14"
        mov qword [symbolCodes + 80], "15"
        mov qword [symbolCodes + 88], "2"
        mov qword [symbolCodes + 96], "3"
        mov qword [symbolCodes + 104], "4"
        mov qword [symbolCodes + 112], "5"
        mov qword [symbolCodes + 120], "6"
        mov qword [symbolCodes + 128], "7"
        mov qword [symbolCodes + 136], "8"
        mov qword [symbolCodes + 144], "9"
        mov rax, [screenCode]
        mov qword [symbolCodes + 152], rax
        mov qword [symbolCodes + 160], "0"
        mov qword [symbolCodes + 168], "3"
        mov qword [symbolCodes + 176], "4"
        ret    