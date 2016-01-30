;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  faz a atualização dos canos na tela
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
rotatePipe:
            proc
            local drawNewPipe
            local drawAPipe
            local drawAGap

            ld a,(pipeGap)
            cp GAP
            jr nz,drawAPipe              ; pipeGap<>GAP, vá pra rotatePipe1

            call random                 ; sorteio a altura dos canos
            and 7                       ; só preciso de valores entr 0 e 6

            cp 7                        ; A é igual a 7?
            jr nz,drawNewPipe           ; é diferente sigo para rotatePipe0
            dec a                       ; senão, subtraio de 1

drawNewPipe:
            ld (pipeSize),a             ; armazeno a altura dos canos
            call drawPipe               ; desenho os canos em framebuffer2

            xor a                       ; zero A
            ld (pipeGap),a              ; armazeno em pipeGap
            dec a                       ; A agora será -1
            ld (pipeFrame),a             ; armazeno em pipeFrameE

drawAPipe:
            ld a,(pipeGap)              ; carrego o valor de pipeGap
            cp 0
            jr nz,drawAGap              ; se 0 estou no espaço entre canos

            ld a,(pipeFrame)             ; carrego o quadro do cano
            inc a                       ; incremento
            ld (pipeFrame),a             ; atualizo para fazer o próximo

drawAGap:
            ld a,(pipeFrame)             ; verifico o quadro do cano
            cp 6                        ; é 6?
            ret nz

            ld a,(pipeGap)
            inc a
            ld (pipeGap),a

            ret                         ; sai da rotina

            endp
