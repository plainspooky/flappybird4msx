;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  beep personalizado usado para indicar as opções selecionadas no jogo
;  *  -- um sol, na quinta oitava -- play "o5g"
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
soundBeep:
            proc
            xor a
            ld hl,JIFFY
            ld (hl),a                   ; zera o timer do VDP

            ld e,0x8f                   ; valor
            ld a,0                      ; registrador 0
            call WRTPSG                 ; sound 0,143

            ld e,0                      ; valor
            ld a,1                      ; registrador 1
            call WRTPSG                 ; sound 1,0

            ld a,15                     ; valor do volume
soundVolume:
            ld e,a
            ld a,8                      ; registrador 8
            call WRTPSG                 ; sound 8,E

            ld a,e
            sbc a,(hl)                  ; o menos significativa de JIFFY

            jr nc,soundVolume           ; sim, uso o temporizador como
                                        ; ajuste do volume do canal

            ld a,8
            ld e,0
            call WRTPSG                 ; sound 8,0

            ret                         ; saio da rotina
            endp
