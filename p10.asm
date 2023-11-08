%include "pc_io.inc"
section .data
    NL: db  13,10
    NL_L:    equ $-NL
    captureTag: db "Ingresa Una Cadena: ",0
    outputPuts: db "Salida En Terminal De Puts: ",0
    outputHex: db "Salida En Terminal De PrintHex: ",0
    outputDec: db "Salida En Terminal De PrintDec: ",0

section .bss
    tmp resb 12
    stLen resb 4
    num resb 4
    cad resb 256
    cadDec resb 256

section .text
global _start:
    _start:
    ;Captura De La Cadena
    mov edx,captureTag
    call puts
    call gets

    ; Salida Con Puts
    mov edx,outputPuts 
    call puts
    mov edx,esi
    call puts
    call new_line

    ;Llamada a Atoi (st2Num con otro nombre)
    mov ecx,[stLen]
    call atoi
    ;Salida Con PrintHex
    mov edx,outputHex
    call puts
    call printHex
    call new_line

    ;Salida Con PrintDec
    mov edx,outputDec
    call puts
    call printDec
    call new_line

    ;Exit Call
    mov eax,1
    mov ebx,0
    int 0x80

gets:
    push ebx
    push ecx
    push edx
    push edi
    lea esi,tmp
    mov eax,3
    mov ebx,0
    mov ecx,esi
    mov edx,12
    int 0x80
    call len
    pop edi
    pop edx
    pop ecx
    pop ebx
    ret

len: 
    pushad
    xor ecx,ecx
    lea edi,tmp
    lea esi,stLen
    .check:
        cmp byte[edi],'*'
        jz .stlen
        inc ecx
        inc edi
        jmp .check
    .stlen:
        mov byte[edi],0
        mov [esi],ecx
    popad
    ret

atoi:
    push ebx
    push ecx
    push edx
    push edi
    push esi
    xor ebx,ebx
    lea esi,tmp
    .next:
        movzx eax,byte[esi]
        inc esi
        sub al,'0'
        imul ebx,10
        add ebx,eax
        loop .next
    mov eax,ebx
    lea edx,num
    mov [edx],eax
    pop esi
    pop edi
    pop edx
    pop ecx
    pop ebx
    ret

limpiarCadena:
    push esi
    push edi
    mov esi,[cadDec]
    xor esi,esi
    lea edi,cadDec
    mov [edi],esi
    pop edi
    pop esi
    ret

printDec:
    pushad
    mov ebx,0xA
    xor edx,edx
    mov ecx,10
    mov esi,cadDec
    call limpiarCadena
    .convert:
        xor edx,edx
        div ebx
        add dl,'0'
        mov [esi+ecx],dl
        loop .convert
    mov eax,4
    mov ebx,1
    mov ecx,cadDec
    mov edx,12
    int 0x80
    popad
    ret

;Subrutinas Auxiliares
printBin:
    pushad
    mov edi,eax
    mov ecx,32
    .cycle:
        xor al,al
        shl edi,1
        adc al,'0'
        call putchar
        loop .cycle
    popad
    ret

new_line:
    pushad
    mov eax, 4
    mov ebx, 1
    mov ecx, NL
    mov edx, NL_L
    int 0x80
    popad
    ret

printHex:
    pushad
    lea esi,cad
    mov edx, eax
    mov ebx, 0fh
    mov cl, 28
    .nxt: shr eax,cl
    .msk: and eax,ebx
    cmp al, 9
    jbe .menor
    add al,7
    .menor:add al,'0'
    mov byte [esi],al
    inc esi
    mov eax, edx
    cmp cl, 0
    je .print
    sub cl, 4
    cmp cl, 0
    ja .nxt
    je .msk
    .print: mov eax, 4
    mov ebx, 1
    sub esi, 8
    mov ecx, esi
    mov edx, 8
    int 80h
    popad
    ret

clearReg:
    xor eax,eax ; Limpieza De Registros
    xor ebx,ebx
    xor ecx,ecx
    xor edx,edx
    ret