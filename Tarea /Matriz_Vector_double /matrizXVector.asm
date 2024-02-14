; rdi : *A 
; rsi : *x
; rdx : *b
; rcx : N
    global matriz_vector_simd
    section .text
matriz_vector_simd:
    mov r8, rdi
    mov r10, rcx
    mov r13, rdx

    xor r9, r9
    xor r11, r11
    xor r12, r12
    xor r15, r15

    for_i:
        mov r9, rsi  ; salvar rsi, ya que dentro del for el j va ir cambiando
        mov rbx, rcx ; salvar rcx ya que tambien se reinicio el ciclo iterativo exterior
        xorpd xmm3, xmm3

    for_j:
        imul r12, rcx ; multiplicar r12 = r12*rcv / i*N
        shl r12, 3; se multiplica por 8 porque para acceder a doubles
        movapd xmm0, [r8 + r12] ; se suma i*N+j 
        movapd xmm1, [r9]
        mulpd xmm0, xmm1

        ;sumar entre valores de un vector
        movapd xmm2, xmm0
        haddpd xmm0, xmm2 ; suma horizontal de los elementos de xmm0
        addsd xmm3, xmm0

        ;que se muevan
        add r8, 16 ; rdi
        add r9, 16 ; rsi
        sub rbx, 2
    jnz for_j

        movsd [r13], xmm3
        add r15, rcx ; creo que no es necesario
        add r13, 8 ; el double son 8   - avanza
        dec r10
    jnz for_i

ret
