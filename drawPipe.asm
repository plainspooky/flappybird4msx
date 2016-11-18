;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  Faz o desenho do cano no segundo frame buffer de acordo com a altura
;  *  definida em pipeSize.
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
drawPipe:
            proc

            local drawPipeLoop
            ; ...

            local drawSkyLineBlue
            local drawSkyLineCyan
            local drawSkyLine

            local tableSeven
            local pipeData
            local holeData

            xor a
            ld de,framebuff2            ; endereço do segundo framebuffer, vou
                                        ; desenhar um cano que vai do início ao
                                        ; final da tela

drawPipeLoop:
            ld hl,pipeData              ; endereço do padrão do cano
            ld bc,7                     ; comprimento da cópia
            ldir

            inc a
            cp 20
            jr nz,drawPipeLoop          ; enquanto A<20 vai para drawPipeLoop

            ld hl,framebuff2            ; aponta para o início do framebuffer

            ld a,130                    ; 130,131 : linhas ciano
                                        ; 132,133 : linhas azul

drawSkyLineCyan:
            call drawSkyLine
            inc a
            cp 132
            jr nz,drawSkyLineCyan       ; se A!=132, desenha o "céu"

            ld hl,framebuff2+18*7       ; as duas últimas linhas

drawSkyLineBlue:
            call drawSkyLine
            inc a
            cp 134
            jr nz,drawSkyLineBlue       ; se A!=133, ir para DRAWPIPE2

            ld a,(pipeSize)             ; pego o valor de pipeSize
            sla a                       ; multiplico A por 2
            ld c,a                      ; jogo na primeira metade de BC e
            ld b,0                      ; limpo a outra parte, vai que...

            ld hl,tableSeven            ; TABLE7
            add hl,bc                   ; TABLE7 = TABLE7 + BC

            ld a,(hl)
            ld c,a
            inc hl
            ld a,(hl)
            ld b,a
            ld h,b
            ld l,c                      ; ld HL,BC :-(

            ld de,framebuff2
            add hl,de
            ex de,hl                    ; framebuff2 acrescido do tamanho e em DE!

            ld hl,holeData              ; dados do padrão entre os canos

            ld bc,70                    ; tamanho do bloco 7x10
            ldir                        ; copio o bloco

            ret                         ; sai da rotina

drawSkyLine:
            ld (hl),a                   ; coloca uma das linhas do céu
            ld de,5
            add hl,de                   ; avança mais 5
            ld (hl),a
            inc hl
            ld (hl),a
            inc hl
            ret

;
;           Tabuada de 7, porque o Z80 só sabe somar! :-(
;
tableSeven:
            dw 14,21,28,35,42,49,56,63,70

;
;           Padrão dos canos (o miolo)
;
pipeData:
            db 128,140,141,142,143,128,128  ; row 0

;
;           O padrão do espaço entre canos (com as bordas)
;
holeData:
            db 134,144,145,146,147,135,128  ; row 0 (canos de cima)
            db 138,148,149,150,151,139,128  ; row 1
            db 128,128,128,128,128,128,128  ; row 2
            db 128,128,128,128,128,128,128  ; row 3
            db 128,128,128,128,128,128,128  ; row 4

            db 128,128,128,128,128,128,128  ; row 5
            db 128,128,128,128,128,128,128  ; row 6
            db 128,128,128,128,128,128,128  ; row 7
            db 138,152,153,154,155,139,128  ; row 8
            db 136,156,157,158,159,137,128  ; row 9 (canos de baixo)

            endp
