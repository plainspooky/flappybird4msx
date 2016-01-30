;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *   Copia uma área da VRAM para outra (usa a mesma sintaxe do LDIR)
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
ldirVV:
            proc
            call RDVRM                  ; leio o byte na VRAM
            ex de,hl                    ; troco DE com HL
            call WRTVRM                 ; gravo o byte na VRAM
            ex de,hl                    ; (des)troco DE com HL
            inc de                      ; incremento DE
            cpi                         ; cp A,(HL) + inc HL + dec BC
            jp PE,ldirVV
            ret
            endp
