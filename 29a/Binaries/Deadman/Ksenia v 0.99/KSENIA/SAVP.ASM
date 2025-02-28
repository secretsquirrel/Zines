                        model   tiny
                        codeseg
                        org     100h
                        .386

 start:                 mov     ax,18ddh
                        int     21h
                        cmp     ax,0303h
                        jne     no_in_mem

                        mov     ah,9
                        lea     dx,vir_found
                        int     21h
                        int     20h

 no_in_mem:             mov     ax,3
                        int     10h
                        mov     ah,1
                        mov     ch,100000b
                        int     10h

                        push    ds 0
                        pop     ds
                        mov     word ptr ds:[24h*4],offset int24
                        mov     word ptr ds:[24h*4+2],cs
                        pop     ds
                        lea     dx,copyright
                        call    screen
                        mov     ah,3
                        mov     bh,0
                        int     10h
                        mov     cur_pos,dx

                        mov     si,81h
 up_reg_comline:        lodsb
                        cmp     al,61h
                        jb      ok_reg
                        cmp     al,7ah
                        ja      ok_reg
                        sub     al,20h
 ok_reg:                mov     byte ptr [si-1],al
                        cmp     al,0dh
                        jne     up_reg_comline

                        mov     si,81h
 ignore_space:          lodsb
                        cmp     al,0dh
                        je      help
                        cmp     al,20h
                        je      ignore_space
                        dec     si
                        mov     dx,si
                        mov     al,0dh
                        mov     di,81h
                        mov     cx,0ffffh
                        repne   scasb
                        dec     di
                        mov     byte ptr [di],0

 get_separ:             dec     di
                        cmp     byte ptr [di],'\'
                        je      set_dots
                        cmp     byte ptr [di],':'
                        je      set_dots
                        cmp     byte ptr [di],20h
                        je      get_separ
                        jmp     aaaa

 set_dots:              mov     word ptr [di+1],'.*'
                        mov     word ptr [di+3],'*'

 aaaa:                  call    collect
                        jc      report
                        push    dx
                        mov     dx,cur_pos
                        mov     ah,2
                        mov     bh,0
                        int     10h
                        pop     dx
                        dec     dx
                        call    screen
                        inc     dx
                        push    dx
                        mov     ah,3
                        mov     bh,0
                        int     10h
                        push    dx
                        lea     dx,spaces
                        call    screen
                        pop     dx
                        mov     ah,2
                        int     10h
                        pop     dx
                        call    test_infected
                        jnc     no_inf
                        call    screen
                        cmp     dx,offset virused
                        jne     no_increment
                        inc     virused_cnt
 no_increment:          mov     ah,3
                        mov     bh,0
                        int     10h
                        cmp     dh,20
                        jb      ok_pos
                        mov     ax,3
                        int     10h
                        mov     ah,1
                        mov     ch,100000b
                        int     10h
                        xor     dx,dx
 ok_pos:                mov     cur_pos,dx
 no_inf:                jmp     aaaa

 report:                push    dx
                        mov     dx,cur_pos
                        mov     bh,0
                        mov     ah,2
                        int     10h
                        lea     dx,spaces
                        call    screen
                        mov     ah,2
                        mov     bh,0
                        mov     dx,cur_pos
                        int     10h
                        pop     dx
                        movzx   eax,dx
                        lea     di,file_number
                        stc
                        call    count
                        mov     eax,virused_cnt
                        lea     di,vir_asciz
                        call    count
                        lea     dx,log
                        call    screen

                        jmp     terminate

 help:                  lea     dx,error_com_line
                        call    screen
 terminate:             mov     ax,4c00h
                        int     21h

 test_infected:         mov     ax,3d00h
                        int     21h
                        lea     dx,rerr
                        jc      quit_all
                        xchg    ax,bx
                        mov     ax,4202h
                        mov     cx,-1
                        mov     dx,-2
                        int     21h
                        mov     ah,3fh
                        mov     cx,2
                        lea     dx,two_bytes
                        int     21h
                        push    ax
                        mov     ah,3eh
                        int     21h
                        pop     ax
                        cmp     ax,2
                        clc
                        jne     quit_all
                        cmp     word ptr two_bytes,0c39dh
                        stc
                        lea     dx,virused
                        je      quit_all
                        clc
 quit_all:              ret

 two_bytes              dw      ?
                        include count.inc
                        include screen.inc
 ; --- cut here ---
; ����ணࠬ�� "collect" ��� ��宦����� 䠩��� �� �������� ��᪥
; copyright (c) 1998-99 Deadman
; �� �室�: cs:dx - ��᪠
; �� ��室� cs:dx - �������� 䠩� � �ଠ� ASCIZ+'$'
; �᫨ 䠩��� ����� ���, � cf=1 � dx = ������⢮ ��������� �� 䠩���
; �� ����୮� �맮�� ࠡ�⠥� ��� "find next"
; �� ������⢨� 䠩��� (cf=1) ��楤�� ���뢠���� � ०�� "find first"
; ����� ॣ�����: flags, dx
; ����砭��: ����ணࠬ�� ������ ���� �ᯮ������ ��᫥����, �.�. ��
; �ॡ���� ���� ��� �࠭���� DTA ��������� �����⠫����
 collect:
          push    ax bx cx si di bp ds es  ; ��࠭��� ॣ����� \dx

          mov     ah,2fh                   ; ������� � es:bx ����
          int     21h                      ; ⥪�饣� dta
          push    es bx                    ; ��࠭��� ��� � �⥪�

          push    cs cs         ; ��⠭����� ᥣ����� ॣ�����
          pop     es ds         ; ds � es �� ᥣ���� ����

          cmp     fron,0        ; ���� �맮� (find first)?
          jne     find_next

          mov     in_dx,dx      ; ��࠭��� ᬥ饭�� ��᪨ ���᪠
          mov     file_cnt,0    ; total files found: 0

          mov     si,dx              ; ������� � di ���� ��᪨
          dec     si
 col_get_eol:                        ; �饬 ��� � ��᪥
          inc     si
          cmp     byte ptr [si],0
          jne     col_get_eol        ; ��諨?

          std                   ; �饬 ��砫� ����� ��᪨ (���ਬ��, *.COM)
 get_mask:
          lodsb                 ; ����� � al ᨬ���
          cmp     al,':'        ; ࠧ����⥫�? (c:...)
          je      have_got
          cmp     al,'\'        ; \...?
          je      have_got
          cmp     si,dx         ; �᫨ 㪠���� ����� ��᪠, �.�. ��� ":" � "\"
          jae     get_mask      ; � ����� �� ��砫� ���� ᬥ饭�� �� dx
          dec     si
 have_got:
          inc     si            ; ��ࠢ������� �� ��砫� (����� std :-)
          inc     si
          mov     msk_pnt,si    ; ��࠭��� ᬥ饭��
          mov     cx,si         ; ���᫨�� ������⢮ ���� �� ��砫� ��ப�
          sub     cx,dx         ; �� ��砫� ��᪨ (�.�. ����)

          lea     di,result     ; ��४���� ���� �� ஢᪮�� ���� �
          mov     si,dx         ; ���� १���⮢
          cld
          repz    movsb
          mov     res_post,di   ; ��࠭��� ᬥ饭�� ���� ;-) ���
 find_first:
          mov     ah,4eh        ; �饬 ���� 䠩�
          jmp     $+4           ; �⮡ �� �ᯠ堡��� ah

 find_next:
          mov     ah,4fh        ; � ��� �饬 next
          push    ax dx         ; ��⠭�������� dta �� �����, 㪠�������
          mov     ah,1ah        ; � ��६����� "dta_pnt"
          mov     dx,dta_pnt
          int     21h
          pop     dx ax
          mov     cx,0ffefh and (not 1000b) ; �饬 �� ?*:%;( �஬� ��⠫����
          int     21h
          jc      check_dir     ; ���� ����� 䠩��� -> ��३� � �����
                                ; '�����'

          mov     si,dta_pnt    ; ��� ��砥� ��� � 䠬���� ���������� 䠩��
          add     si,1eh        ; �� ����� "res_post"

          push    si
          lodsb
          cmp     al,'.'
          jne     $-3
          lodsd
          pop   si
          cmp     eax,'SYS'
          je      good
          cmp     eax,'MOC'
          je      good
          cmp     eax,'EXE'
          jne     find_next
 good:

          mov     di,res_post
          lodsb
          stosb
          or      al,al
          jnz     $-4
          mov     al,'$'        ; ������ '$' � ���� ASCIZ ��ப� ���
          stosb                 ; �� �ᯮ�짮����� 9-� �㭪樥� dos
          jmp     yes_more      ; �������� 䠩�

 check_dir:
          mov     ah,4eh                ; �饬 �����
          mov     si,res_post
          mov     word ptr [si],'.*'    ; (dir)\(*.*),0
          mov     word ptr [si+2],'*'
          lea     dx,result
          mov     cx,0ffffh             ; �� ��� ⮣�, �⮡� ��直� hidden'�
 check_again:                           ; �� �᪮�짭㫨 �� ����� �����
          int     21h
          jc      cd_dotdot             ; ��� ��� ���� -> ������ �ᥢ��-CD
          mov     si,dta_pnt            ; ���� ��⨬ �, ���� �� ��
          mov     ah,4fh                ; ��ଠ�쭠� �����, ��� ��
          cmp     byte ptr [si+1eh],'.' ; 䠩� ��� (.)(..), �.�. 䨫���㥬
          je      check_again
          test    byte ptr [si+15h],10000b
          jz      check_again

          mov     si,dta_pnt            ; ��諨 ����� -> ��४����
          add     si,1eh                ; �������� � 'result'
          mov     di,res_post

          lodsb
          stosb
          or      al,al
          jnz     $-4
          mov     byte ptr [di-1],'\'   ; ����� ���
          mov     ax,di
          xchg    res_post,ax
          mov     si,dta_pnt            ; ��࠭��� 㪠��⥫� �� ����� ���
          mov     [si+43],ax            ; �।��饣� �஢��

          mov     si,msk_pnt     ; ��४���� ���� ��� ���᪠ � ���� �����
          lodsb
          stosb
          or      al,al
          jnz     $-4

          lea     dx,result      ; �饬 ᫥���騥 䠩��, ��⥬ ��⠫���
          add     dta_pnt,45
          inc     dir_cnt
          jmp     find_first

 cd_dotdot:                      ; ��� ���� ᤥ���� �ᥢ�� CD .. ��� ���᪠
          dec     dir_cnt        ; ��⠢���� 䠩��� � ����� � �।��饩
          jz      no_more        ; �����
          sub     dta_pnt,45
          mov     si,dta_pnt
          mov     dx,si
          mov     ah,1ah
          int     21h
          mov     di,[si+43]
          mov     res_post,di
          mov     ah,4fh
          jmp     check_again

 yes_more:                                  ; �뢮��� �������� 䠩�
          inc     dword ptr file_cnt        ; ������⢮ ��������� 䠩���
          clc
          mov     fron,1                    ; ᫥���騩 �맮� - find next
          lea     dx,result

 exit:    mov     bp,dx
          pop     dx ds
          pushf
          mov     ah,1ah
          int     21h
          popf
          mov     dx,bp

          pop     es ds bp di si cx bx ax
          ret

 no_more: mov     fron,0                        ; ���뢠�� ��६����
          mov     dta_pnt,offset dtaz
          mov     dir_cnt,1
          mov     dx,file_cnt                   ; �뫮 ������� dx 䠩���
          stc
          jmp     exit

 fron     db      0
 file_cnt dw      0
 dir_cnt  dw      1
 dta_pnt  dw      dtaz
 msk_pnt  dw      ?
 res_post dw      ?
 in_dx    dw      ?
          db      0ah
 result   db      100h dup (?)

; --- cut here ---


 int24:                 mov     al,3
                        iret

 vir_found              db      'Virus in memory, can''t work',0dh,0ah,24h
 copyright              db      0ah,'Speed Anti-Virus Program Copyright (C) 1998-99 Deadman',0dh,0ah,0dh,0ah,24h
 error_com_line         db      0ch,'Error in command line! Usage: SAVP <path>',0dh,0ah,24h
 log                    db      0ah,0dh,0ah,'Total files tested: '
 file_number            db      15 dup (' '),0dh,0ah
                        db      'Virused: '
 vir_asciz              db      15 dup (' '),0dh,0ah,24h
 crlf                   db      0ah,0dh,24h
 spaces                 db      0ch,100h dup (' '),24h
 virused                db      0ch,'- Virused!',0dh,0ah,24h
 rerr                   db      0ah,'- Read error!',0dh,0ah,24h
 virused_cnt            dd      0
 cur_pos                dw      ?
 dtaz:                  end     start