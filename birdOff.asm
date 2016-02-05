;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  arranco o pássaro da tela
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
birdOff:
            proc
            
            ld a,192                    ; Um valor que não atrapalha ninguém
            ld bc,16                    ; 16/4 = 4, quatro sprites
            ld hl,6912                  ; início da tabela de sprites
            call FILVRM                 ; preenche com zero!

            ret                         ; sai da rotina
            endp
