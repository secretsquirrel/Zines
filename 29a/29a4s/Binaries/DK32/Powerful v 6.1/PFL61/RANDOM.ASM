;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; 뢱�즤젹쵟 �죖젩�洙� 笹晨젵��． 葉笹�
; 귛��:  OLD_AX
; 귣若�: 0<=NEW_AX<=OLD_AX
random_any_ax:
        mov      ax,0fffeh
random_ax:
        xchg     ax,dx
        call     random_dx
        xchg     ax,dx
        retn
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; 뢱�즤젹쵟 �죖젩�洙� 笹晨젵��． 葉笹�
; 귛��:  OLD_DX
; 귣若�: 0<=NEW_DX<=OLD_DX
random_any_dx:
        mov      dx,0fffeh
random_dx:
        push     ax bx dx
        call     init_rnd_proc
cell_for_rnd_number dw 0100h
init_rnd_proc:
        pop      bx
        imul     ax,word ptr cs:[bx],4dh
        inc      ax
        mov      word ptr cs:[bx],ax
        pop      bx
        inc      bx
        or       bx,bx
        jz       quit_from_rnd
        xor      dx,dx
        div      bx   ;DX:AX / BX  -> AX:DX
quit_from_rnd:
        pop      bx ax
        retn
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
