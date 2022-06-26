%include "proc.asm"




section .data

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
    compCodes:
        dq "110001", "001101", "110001", "111010", "110011"
        dq "001111", "110011", "101010", "111111", "110000"
        dq "110111", "110010", "000111", "001100", "000000"
        dq "000000", "011111", "000010", "000010", "001110", "010011"
        dq "010011", "010101", "010101", "110000", "110111", "110010", "000111", 0
       
section .bss 
    tempString resb 20


section .text


    compOP:
        push rdi
        push 4
        push compTable
        push comp 
        push 27
        call binarySearch
        
        lea rsi, [compCodes + 8*ebx]
        push comp 
        push rsi 
        push 6
        call strcopy
     
        xor eax, eax
        call getAcode               ; 0 or 1 depending on comp

        push tempString
        push 0
        push 20
        call clear

        pop rdi
        ret

        
    ; OPCODE FOR JUMP
    jumpOP:
        push rdi

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
        
        push tempString
        push 0
        push 20
        call clear

        pop rdi
        ret

     ; OPCODE FOR DESTINATION
    destOP:
        push rdi
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
        push 20
        call clear
        pop rdi
        ret

    symbolOP:
        push rdi

        push 8
        push symbolTable
        push symbol
        push r15                            ; table length
        call binarySearch
        

        cmp ebx, 69                         ; if symbol is not already in the table
        je newSymbol
           
        lea esi, [symbolCodes + 8*ebx]

        push symbol 
        push 0
        push 20
        call clear
        
        push symbol 
        push rsi
        push 6
        call strcopy
      
        
          
        jmp endsymbol
   
        newSymbol:
        push rax
        inc r15
        xor rdi, rdi
        
        push tempString
        push 0
        push 20
        call clear

        
        numberToString r14d, tempString
        pop rax
        push rdi  

    
        push qword [symbol]
        push qword [rdi]
        call addSymbol
        

        pop rdi                             ; r14 as string
        mov rax, [rdi]
        
        push symbol 
        push 0 
        push 20
        call clear
        
        
        mov qword [symbol], rax
        inc r14
        

        endsymbol:
        
        push tempString
        push 0
        push 20
        call clear  
        print symbol, 20
        

    pop rdi
    ret





   

