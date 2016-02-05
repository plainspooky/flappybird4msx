;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  imprime a pontuação, adaptado da rotina de escrita de números de 16-bit
;  *  orginal de Milos "baze" Bazelides <baze_at_baze_au_com> e disponível em:
;  *  http://baze.au.com/misc/z80bits.html
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
printScore:
            proc
            local printHiScore

            ld hl,(score)               ; recupero o valor atual da pontuação
        rept 5
            inc hl                      ; incremento a pontuação em +5
        endm
            ld (score),hl               ; armazeno a pontuação
            ld de,framebuff3            ; área temporária para escrever

            call printNumber            ; escrevo os números lá

            ld bc,5                     ; até 5 dígitos
            ld de,6144+7                ; posição na tela
            ld hl,framebuff3
            call LDIRVM                 ; atualizo a pontuação na tela

            ld hl,(hiScore)             ; leio o recorde
            ld de,(score)               ; leio novamenre a pontuação
            sbc hl,de                   ; subtraio um com o outro
            jr nc,printHiScore           ; o recorde não é maior

            ld (hiScore),de             ; armazeno o novo recorde
printHiScore:
            ld hl,(hiScore)
            ld de,framebuff3               ; área temporária para escrever
            call printNumber

            ld bc,5                     ; até 5 dígitos
            ld de,6144+24               ; posição na tela
            ld hl,framebuff3
            call LDIRVM                 ; atualizo o recorde na tela

            ld a,12
            ld (ringRing),a             ; habilita o som da pontuação

            ret                         ; sai da rotina
            endp

beforeZero: equ 176

printNumber:
            proc

            local formatDigit
            local formatDigitLoop

            ld bc,-10000
            call formatDigit
            ld bc,-1000
            call formatDigit
            ld bc,-100
            call formatDigit
            ld c,-10
            call formatDigit
            ld c,b
formatDigit:
            ld a,beforeZero             ; o caracter anterior ao '0'

formatDigitLoop:
            inc a
            add hl,bc
            jr c,formatDigitLoop
            sbc hl,bc
            ld (de),a
            inc de
            ret                         ; sai da rotina

            endp
