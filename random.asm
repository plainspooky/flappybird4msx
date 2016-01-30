;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  gerador de números pseudo-aleatórios levemente adaptada do código ori-
;  *  ginal de Milos "baze" Bazelides <baze_at_baze_au_com> e disponível em:
;  *  http://baze.au.com/misc/z80bits.html
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
random:
            proc
            ld a,(birdY)
            ld b,a
            ld a,(rndSeed)
            add a,a
            add a,a
            add a,b
            inc a
            ld (rndSeed),a              ; guardo o valor
            ret                         ; sai da rotina
            endp
