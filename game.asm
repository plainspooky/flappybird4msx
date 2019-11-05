;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  o jogo propriamente dito está aqui (ela é quase críptica!)
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
game:
            proc
            local gameStart
            local gameDownBird
            local gameUpBird
            local checkCollision
            local gameLittleMulti
            local dirtyIncrement

            call soundBeep              ; emito um beep
            call writeFramebuffer

            ld hl,birdY                 ; pássaro na altura inicial
            ld (hl),88                  ; (centro da tela)

            xor a                       ; zero o acumulador

            ld (birdFrame),a            ; o frame atual do pássaro
            ld (birdUp),a               ; zero o decremento (a subida)
            ld (birdDown),a             ; zero o incremento (a descida)
            ld (ringRing),a             ; desligo o flag da campainha
            ld (pipeGap),a              ; zero o contador de espaço entre canos
            dec a

            ld (pipeFrame),a             ; "zero" (com -1) o frame dos canos

            ;
            ; dica do Ricardo Bittencourt de pendurar a rotina de atuali-
            ; zação da tela no hook HTIMI fazendo com que os dados com a
            ; nova tela sejam enviados quando o VDP não estiver ocupado
            ; desenhando a tela.
            ;

            ld de,writeFramebuffer      ; rotina que atualiza a tela
            ld a,e                      ; 'ss' de writeFramebuffer
            ld (HTIMI+1),a
            ld a,d                      ; 'tt' de writeFramebuffer
            ld (HTIMI+2),a
            ld a,0xc9                   ; RET
            ld (HTIMI),a
            ld (HTIMI+3),a

gameStart:
            ld hl,JIFFY
            ld (hl),0                   ; zero o temporizador

            call rotatePipe             ; rotaciono os canos
            call updateFramebuffer      ; atualizo o framebuffer
            call drawBird               ; desenho o pássaro
            call rotateDecoration       ; rotaciono a decoração

            xor a
            call GTTRIG                 ; lê a barra de espaços

            ld h,a                      ; salva o valor em H

            ld a,1
            call GTTRIG                 ; lê o botão 1 do joystick 0

            or h                        ; junta as duas leituras

            cp 255                      ; é 255?
            jr nz,gameUpBird            ; faz o pássaro subir!

gameDownBird:
            ld a,(birdDown)             ; o pássaro desce
            cp MAXD                     ; é igual ao incremento máximo?
            call nz,dirtyIncrement      ; se não for eu adiciono em 1
            ld (birdDown),a             ; armazeno o valor de descida
            xor a                       ; zero A
            ld (birdUp),a               ; armazeno em 0 o valor de subida
            jr checkCollision

gameUpBird:
            ld a,(birdUp)               ; o pássaro sobe
            cp MAXU                     ; é igual ao incremento máximo?
            call nz,dirtyIncrement      ; se não for eu adiciono em 1
            ld (birdUp),a               ; armazeno o valor de subida
            xor a                       ; zero A
            ld (birdDown),a             ; armazeno em 0 o valor de descida

checkCollision:
            ld de,birdDown              ; aponto DE para birdDown
            ld hl,birdUp                ; aponto HL para birdUp
            ld a,(birdY)                ; leio a posição atual do pássaro
            add a,(hl)                  ; adiciono o que o faz descer
            ex de,hl                    ; troco DE com HL
            sub (hl)                    ; subtraio o que o faz subir
            ld (birdY),a                ; guardo a nova posição do pássaro

            cp 4
            jp c,gameOver               ; bati no teto, fim do jogo

            cp 168
            jp nc,birdOnGround          ; bati no chão, fim do jogo

            ld a,(framebuff1+11)        ; verifico se em (11,0) há um caracter
            cp 143                      ; específico de cano (143)
            call z,incrementScore       ; Se for, é hora de pontuar.

            ld a,(ringRing)             ; verifica se é hora momento de tocar
            cp 0                        ; a campainha da pontuação
            call nz,playRing

            ld a,(birdY)                ; leio a altura atual do pássaro
            add a,4                     ; ajusto a altura

            and 0xf8                    ; retiro a parte desnecessária

            ld hl,4
            ld de,4

gameLittleMulti:
            add hl,de                   ; e multiplico por 4
            dec a
            cp 0
            jr nz,gameLittleMulti

            ld de,6144+9                ; 10 ou 9?
            add hl,de
            call RDVRM                  ; vejo na VRAM o que tem na
                                        ; frente do pássaro
            cp 139
            jp nc,gameOver

            ld de,32
            add hl,de
            call RDVRM                  ; vejo na posição abaixo.

            cp 139
            jp nc,gameOver

            ld a,0xcd                   ; habilito a atualização da tela
            ld (HTIMI),a                ; por interrupção, roda 1x e só!

            ld hl,vdpCycle1
            ld b,(hl)
            call waitASec               ; aguardo 1/10s

            jp gameStart

dirtyIncrement:
            inc a                       ; hora de incrementar :-)
            ret                         ; está fora do lugar, não remover!

            endp
