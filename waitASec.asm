;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  gera uma espera de 'B' ciclos do VDP (não se esqueça de zerar JIFFY)
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
waitASec:
            proc
            ld a,(JIFFY)
            cp b
            ret z                         ; sai da rotina
            jr waitASec
            endp
