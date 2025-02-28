                        model   tiny
                        codeseg
                        org     100h
                        .386
 v_id                   equ     8FA0h
 start:                 mov     ax,2524h
                        lea     dx,int24
                        int     21h
                        call    mon_init

 scan:                  lea     dx,masker
                        call    collect
                        jc      nextdrv
                        dec     file_cnt
                        mov     si,dx
                        lodsb
                        or      al,al
                        jnz     $-3
                        cmp     word ptr [si-4],'XE'
                        je      goodext
                        cmp     word ptr [si-4],'OC'
                        jne     scan

 goodext:               inc     file_cnt
                        mov     bp,dx
                        mov     ah,3
                        mov     bh,0
                        int     10h
                        push    dx
                        push    bp
                        mov     dx,bp

                        call    test_infected
                        jnc     no_inf

                        mov     ah,9
                        int     21h
                        pop     dx
                        mov     ah,9
                        int     21h
                        mov     ah,2
                        pop     dx
                        cmp     dh,20
                        jb      allok
                        call    mon_init
                        jmp     rty
 allok:                 int     10h
                        mov     ah,2
                        mov     dl,0ah
                        int     21h
                        mov     dl,0dh
                        int     21h
 rty:                   inc     virused_cnt
                        jmp     scan

 no_inf:                pop     dx
                        mov     ah,9
                        int     21h
                        mov     ah,2
                        pop     dx
                        int     10h
                        jmp     scan

 nextdrv:               add     totfilc,dx
                        inc     byte ptr masker
                        cmp     byte ptr masker,'E'+1
                        jnz     scan

                        movzx   eax,totfilc
                        lea     di,file_number
                        call    count
                        mov     eax,virused_cnt
                        lea     di,vir_asciz
                        call    count
                        mov     ah,9
                        lea     dx,log
                        int     21h

                        mov     ax,4c00h
                        int     21h

 test_infected:         mov     ax,3d00h
                        int     21h
                        xchg    ax,bx
                        jc      clcret

                        mov     ax,4202h
                        mov     cx,-1
                        mov     dx,-marklen
                        int     21h
                        mov     ah,3fh
                        mov     cx,marklen
                        lea     dx,buffer
                        int     21h
                        xor     cx,ax
                        jnz     clcret
                        lea     si,mark
                        lea     di,buffer
                        mov     cx,marklen
                        repe    cmpsb
                        jnz     clcret

                        lea     dx,cured
                        jmp     stcret

 clcret:                mov     ah,3eh
                        int     21h
                        clc
                        ret

 stcret:                mov     ah,3eh
                        int     21h
                        stc
                        ret
 mark                   db      '[KSENIA/Deadman]',0
 marklen                equ     $-mark

                        include count.inc
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

          mov     di,res_post
          lodsb
          stosb
          or      al,al
          jnz     $-4
 clear:   cmp     byte ptr [di],0ffh
          jz      cleared
          mov     byte ptr [di],20h
          inc     di
          jmp     clear
 cleared: mov     word ptr [di-2],0240dh
          jmp     yes_more

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
          cmp     dword ptr [si+1eh],'YCER'
          je      check_again
          cmp     dword ptr [si+1eh],'IRIV'
          je      check_again

 no_virii:
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
 result   db      100h dup (0),0ffh

; --- cut here ---


 int24:                 mov     al,3
                        iret

 mon_init:              mov     ax,3
                        int     10h
                        mov     ah,1
                        mov     ch,100000b
                        int     10h
                        lea     dx,cop
                        mov     ah,9
                        int     21h
       mov     ax,1856h
       int     21h
        cmp     ax,3265h        ; AX=3265 - �����, �� ����� ����� 㦥 �

                        jnz     initret
                        lea     dx,mem
                        mov     ah,9
                        int     21h
                        xor     ax,ax
                        int     16h
                        xor     ax,ax
                        int     21h
 initret:               ret

 totfilc                dw      0
 cop                    db      "[KSENIA] Virus Finder",0dh,0ah,24h
 mem                    db      "Virus found in memory",0dh,0ah,24h
 masker                 db      "C:\*.*",0
 log                    db      0dh
                        db      '------------------------------------',0dh,0ah
                        db      'Total files tested: '
 file_number            db      15 dup (' '),0dh,0ah
                        db      'Infected: '
 vir_asciz              db      15 dup (' '),0dh,0ah,24h
 cured                  db      'Infected - ',24h
 virused_cnt            dd      0
 buffer                 db      4096 dup (?)
 dtaz                   db      4096 dup (?)

                        end     start
