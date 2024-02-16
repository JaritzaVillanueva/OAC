; rdi = *x -> tiene valores
; rsi = *h -> tiene valores
; rdx = *y -> resultado
; rcx = long_y -> tiene valor
; r8 = long_k -> tiene valor

    global applyConv_asm
    section .text

applyConv_asm:
    mov r14, rdi ; i
    mov r10, rcx ; long_y
    mov r13, rdx
    
    xor r9, r9
    xor r12, r12
    xor r15, r15

    first_for:
        mov r9, rsi 
        mov rbx, r8 
        xorpd xmm3, xmm3 ; sum

        second_for:
            shl r12,2
            movups xmm0, [r14+r12]
            movups xmm1, [r9]
            mulps xmm0, xmm1

            movups xmm2,xmm0
            shufps xmm2,xmm2, 01001110b
            addps xmm0, xmm2

            movups xmm2,xmm0
            shufps xmm2,xmm2, 10110001b
            addps xmm0, xmm2
            addss xmm3, xmm0

            add r14, 16
            add r9, 16
            sub rbx, 4
            jnz second_for
            ola:

        movss [r13], xmm3
        add r15, rcx
        add r13, 4
        dec r10
        jnz first_for
ret
