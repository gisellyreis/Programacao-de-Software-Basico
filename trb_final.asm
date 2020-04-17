%include "asm_io.inc"

segment .data

prompt1 db    "Enter the number of disks: ", 0
ori     db    "Origem ",0
des     db    "Destino ",0
msg     db    " -> ", 0

segment .bss
n       resd    1

segment .text
        global  asm_main, _hanoi, _mover
asm_main:
        enter   0,0               ; setup routine
        pusha

        mov     eax, prompt1      ; print out prompt
        call    print_string

        call    read_int          ; read integer
        mov     [n], eax          ; store into n

        push    dword  2
        push    dword  3
        push    dword  1
        mov     eax, [n]
        push    eax
        call    _hanoi
        pop     ecx
        pop     ecx
        pop     ecx
        pop     ecx
end:
        popa
        mov     eax, 0
        leave
        ret
_hanoi:
        enter   0,0

        mov     eax, [ebp+8]
        cmp     eax, 0
        jle     end_hanoi

        dec     eax
        push    dword [ebp+16]
        push    dword [ebp+20]
        push    dword [ebp+12]
        push    eax
        call    _hanoi
        
        push    dword [ebp+16]
        push    dword [ebp+12]
        push    dword [ebp+8]
        call    _mover

        push    dword [ebp+12]
        push    dword [ebp+16]
        push    dword [ebp+20]
        mov     eax, [ebp+8]
        dec     eax
        push    eax
        call    _hanoi

end_hanoi:
        leave
        ret
_mover:
        enter   0,0

        mov     eax, ori
        call    print_string
        mov     eax, [ebp+12]
        call    print_int
        mov     eax, msg
        call    print_string
        mov     eax, des
        call    print_string
        mov     eax, [ebp+16]
        call    print_int
        call    print_nl
        
        leave
        ret