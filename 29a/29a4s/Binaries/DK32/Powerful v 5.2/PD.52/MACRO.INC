;컴컴컴컴컴컴컴컴� Macro 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
push_all_register MACRO                                       ;�
        pusha                                                 ;�
        push      es ds                                       ;�
        endm                                                  ;�
pop_all_register  MACRO                                       ;�
        pop       ds es                                       ;�
        popa                                                  ;�
        endm                                                  ;�
push_all_register_withf MACRO                                 ;�
        pusha                                                 ;�
        pushf                                                 ;�
        push      es ds                                       ;�
        endm                                                  ;�
pop_all_register_withf  MACRO                                 ;�
        pop       ds es                                       ;�
        popf                                                  ;�
        popa                                                  ;�
        endm                                                  ;�
zero_ds MACRO                                                 ;�
        push     0000h                                        ;�
        pop      ds                                           ;�
        endm                                                  ;�
zero_es MACRO                                                 ;�
        push     0000h                                        ;�
        pop      es                                           ;�
        endm                                                  ;�
set_ds_BC00 MACRO                                             ;�
        push     0bc00h                                       ;�
        pop      ds                                           ;�
        endm                                                  ;�
set_es_BC00 MACRO                                             ;�
        push     0bc00h                                       ;�
        pop      es                                           ;�
        endm                                                  ;�
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
