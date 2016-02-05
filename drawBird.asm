;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  desenha o pássaro e cuida da alternância de quadros
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
drawBird:
            proc

            local drawBirdNext

            ld a,(birdY)                ; pego a posição da ave para colocar na tela

            dec a                       ; diminuo em 1, um bug notório da tabela de
                                        ; sprites do TMS99x8 armazeno a posição em B

            ld b,a

            ld a,(birdFrame)            ; pego o quadro correspondente a posição do pássaro

            sla a
            sla a
            sla a
            sla a                       ; multiplico por 16 (4x SHIFT LEFT)

            ld c,a                      ; armazeno em C

            ld hl,birdBuffer            ; aponto para o frame buffer do pássaro

            ld a,0                      ; zero A

drawBirdNext:
            ld (hl),b                   ; atualizo a posição Y do pássaro

            inc hl
            inc hl                      ; avanço para a próxima posição

            ld (hl),c                   ; atualizo o sprite

            inc c
            inc c
            inc c                       ; não existe "add c,4"
            inc c                       ; é feio mas assim faço C=C+4

            inc hl
            inc hl                      ; avanço para a próxima posição

            inc a
            cp 4
            jr nz,drawBirdNext          ; se A!=4, ir para drawBird0

            ld a,(birdFrame)
            inc a
            and 3
            ld (birdFrame),a            ; atualizo o frame, a animação tem 4

            ld bc,16
            ld de,6912
            ld hl,birdBuffer
            call LDIRVM                 ; jogo estes 16 bytes na VRAM

            ret                         ; sai da rotina

            endp
