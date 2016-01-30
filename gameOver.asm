;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  fim do jogo
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
birdOnGround:
            ld a,162-3
            ld (birdY),a                ; resolvo o problema quando do

gameOver:
            proc
            local gameOverSound
            local fallingBird
            local gameOverMessage
            local gameOverWait
            local gameOverNewLine
            local gameOverWait

            ld a,7
            ld e,7
            call WRTPSG                 ; sound 7,7

            ld a,6
            ld e,13
            call WRTPSG                 ; sound 6,13

            ld e,15

gameOverSound:
            ld a,8
            call WRTPSG                 ; sound 8,15

            ld hl,JIFFY
            ld (hl),0                   ; zero o temporizador

            ld b,1
            call waitASec               ; espera um pouquinho

            dec e                       ; abaixo o volume
            ld a,e

            cp -1                       ; se não for <0 fico no laço
            jr nz,gameOverSound

fallingBird:
            ld hl,JIFFY
            ld (hl),0                   ; zero o temporizador

            ld b,4                      ; 4 é o incremento e o quadro

            ld hl,birdFrame
            ld (hl),b                   ; quadro do pássaro caindo

            ld hl,birdY
            ld a,(hl)                   ; recuupera a posição atual

            add a,b                     ; aumento em 4 pontos

            ld (hl),a                   ; armazeno a nova posição

            push af                     ; guardo o valor de A

            call drawBird               ; desenha o pássaro

            ld b,1                      ; 1/60 em NTSC ou 1/50 em PAL

            call waitASec               ; faço uma pausa

            pop af                      ; recupero o valor de A

            cp 162                      ; fica no laço até ser maior
            jr c,fallingBird            ; que 162

            ld a,129                    ; caracter quadriculado
            ld bc,32*6
            ld hl,6144+32*9             ; preenche uma barra quadricu-
            call FILVRM                 ; lada no centro da tela

            ld bc,22                    ; incremento no <ENTER>
            ld hl,6144+10*32+11         ; posição inicial da tela
            ld de,gameOverText          ; padrão do "GAME OVER"

gameOverMessage:
            ld a,(de)                   ; pego o primeiro caracter
            inc de                      ; já incremento o ponteiro

            cp 0                        ; é zero?
            jr z,gameOverNewLine        ; faço a quebra de linha

            cp 1                        ; é um?
            jr z,gameOverWait           ; saio da rotina

            call WRTVRM                 ; escrevo o byte na VRAM
            inc hl                      ; incremento a posição na tela

            jr gameOverMessage          ; volto o laço

gameOverWait:
            call gplMensaWait           ; faço uma pausa de 4s

            ld a,7
            ld e,40
            call WRTPSG                 ; sound 7,40 (desligo o ruído)

            ret                         ; saio da rotina

gameOverNewLine:
            add hl,bc
            jr gameOverMessage          ; avanço uma linha!

gameOverText:
            db 0x80,0xfe,0xfe,0xfc,0xfe,0x80,0x80,0x80,0x80,0x80,0 ; "____    "
            db 0x80,0xe7,0xe1,0xed,0xe5,0xfe,0xfc,0xfe,0xfe,0x80,0 ; "GAME____"
            db 0x80,0x80,0x80,0x80,0x80,0xef,0xf6,0xe5,0xf2,0x80,0 ; "    OVER"
            db 0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,1 ; "        "

            endp
