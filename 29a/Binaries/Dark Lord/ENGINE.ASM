.286
locals __
.model small, pascal
.code
public engine
public randomize
include engine.inc
randomize:
    mov ah, 2CH
    int 21h
    mov cs:[a], cx
    mov cs:[b], dx
    ret   
random:
    push bx cx dx
    push ax
    mov ax, 0
    org $-2
A   dw  0
    mov bx, 0
    org $-2
B   dw  0
    mov cx, ax
    mov dx, 8405h
    mul dx
    shl cx, 3
    add ch, cl
    add dx, cx
    add dx, bx
    shl bx, 2
    add dx, bx
    add dh, bl
    mov cl, 5  
    shl bx, cl
    add dh, bl
    add ax, 1
    adc dx, 0
    mov 2 ptr cs:[A], ax
    mov 2 ptr cs:[B], dx
    pop bx
    mov cx, dx
    mul bx
    mov ax, cx
    mov cx, dx
    mul bx
    add ax, cx
    adc dx, 0
    xchg ax, dx
    pop dx cx bx
    ret
one_byte:
    clc
    cld
    cli
    cmc
    sti
    nop
    stc
    std
    sahf
ob_len = ($-one_byte)
buffer:
end