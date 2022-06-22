

%macro exit 0
    mov rax, 60
    mov rdi, 0
    syscall
%endmacro

SYSREAD equ 0
SYSWRITE equ 1
SYSOPEN equ 2
SYSCLOSE equ 3
SYSSEEK equ 8
true equ 1
false equ 0



section .bss
    digit resb 0
    length resb 1
    number resq 1
    buffer resb 320
    buffer2 resb 10
    result resd 1
    temp resb 20
    tempString resb 20


section .data
    newline db 10
    carriage db 13
    space db 32
    minus db false
    point db false


    sign db 0
    exponent dw 0
    fraction dd 0

; for printing numbers (int)

%macro printNumber 1
    push rcx
    push rax
    push rdx
    push rbx
    push rsi
    push rdi

    mov rax, %1

    %%printInt:
        mov rcx, digit      ;set rcx to digit memory address
        mov rbx, 10         ; moving a newline into rbx
        mov [rcx], rbx      ; setting digit to rbx
        inc rcx             ; increment rcx position by one byte

    %%storeLoop:
        xor rdx, rdx        ; zero out rdx
        mov rbx, 10         
        div rbx             ; rax / rbx (10)

                            ; rdx holds the remainder of the divison
        add rdx, 48         ; add 48 to rdx to make in ascii character
                            
        mov [rcx], dl       ; get the character part of rdx
        inc rcx             ; increment digit position again

        cmp rax, 0
        jnz %%storeLoop       ; continue looping until rax is 0

    %%printLoop:
        push rcx

        ;perform sys write
        mov rax, SYSWRITE
        mov rdi, 1
        mov rsi, rcx
        mov rdx, 1
        syscall

        pop rcx
        dec rcx
        cmp rcx, digit      ; first byte of digit (10)
        jge %%printLoop
        pop rdi
        pop rsi
        pop rbx
        pop rdx
        pop rax
        pop rcx


%endmacro

%macro print 2
    push rdi
    push rax
    push rdi
    push rdx
    push rsi
    push rcx
    mov esi, %1
    mov eax, SYSWRITE
    mov edi, 1
    mov edx, %2
    syscall
    pop rcx
    pop rsi
    pop rdx
    pop rdi
    pop rax
    pop rdi
%endmacro
    
;example:
;"123"  -> starting from 1

;1 + 0 * 10  = 1
;2 + 1 * 10  = 12
;3 + 12 * 10 = 123

%macro stringToNumber 1
    push rbp
    push rcx
    push rsi
    push rax
    mov rdi, 0                 ; number stored here
    mov ebp, %1  
    mov ecx, 0 

    cmp byte [ebp], "-"
    jne %%loop
    inc ecx

    %%loop:
    xor esi, esi
    mov sil, byte [ebp + ecx]
    sub sil, 48

    cmp esi, 9                  ; if this is greater than 9 the string has ended
    jg %%exit

    mov rax, 10
    mul rdi                     ; multiply by 10
    add rsi, rax
    mov rdi, rsi

    inc ecx
    jmp %%loop

    %%exit:
        cmp byte [ebp], "-"
        jne %%around
            neg rdi
        %%around:
    pop rax
    pop rsi
    pop rcx
    pop rbp
%endmacro

%macro getStringLength 1
    mov edx, %1
    xor ecx, ecx      ;counter

    %%loop:
        mov bl, [edx + ecx]
        inc ecx

        cmp bl, 0
        je %%exit
        cmp bl, 10
        je %%exit
        jmp %%loop
    %%exit:
    sub ecx, 1
%endmacro

%macro copyString 2
    mov r8d, %1
    mov r9d, %2
    getStringLength r8d

    xor edx, edx
    loop:
        mov sil, byte [r8d + edx]
        mov byte [r9d + edx], sil
        inc edx

        cmp edx, ecx
        jng loop
%endmacro


; eax returns negative if file doesnt exist
%macro openfile 1
    mov eax, SYSOPEN
    mov rdi, %1
    mov esi, 2
    mov edx, 0777
    syscall
%endmacro


%macro newfile 1
    mov eax, SYSOPEN
    mov rdi, %1
    mov esi, 64 + 512 + 2
    mov edx, 0777
    syscall
%endmacro