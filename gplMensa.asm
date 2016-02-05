;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  Mensagem da GPL
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
gplBuffer:  equ videoData

gplMensa:
            proc
            public gplMensaWait
            local gplMensaStart
            local gplMensaPrint
            local gplMensaNewLine

            ld de,gplMensaText-1        ; emdereço da mensagem, ou quase

gplMensaStart:
            ld hl,6144+23*32+3          ; posição inicial na tela; C=0, L=23

gplMensaPrint:
            inc de                      ; incremento DE
            ld a,(de)                   ; coloco em A o conteúdo de DE
            cp 1                        ; não é um?
            jr z,gplMensaWait           ; ainda tem trabalho, volto
            cp 0                        ; é zero?
            jr z,gplMensaNewLine        ; preciso pular uma linha
            call WRTVRM                 ; escrevo A na VRAM
            inc hl                      ; incremento HL
            jr gplMensaPrint            ; faço o loop

gplMensaNewLine:
            push de                     ; salva DE por enquanto

            ld bc,768-32                ; da linha 1 até a 23
            ld de,gplBuffer             ; uso todos os videoData
            ld hl,6144+32               ; A partir de (0,1)
            call LDIRMV                 ; copio para RAM

            ld bc,768-32                ; mesma quantidade de bytes
            ld de,6144                  ; no começo da tela
            ld hl,gplBuffer             ; armazenado em videoData
            call LDIRVM                 ; copio para a VRAM

            ld a,32                     ; caracter de espaço
            ld bc,32                    ; 32 caracteres (uma linha)
            ld hl,6144+23*32            ; em (0,23)
            call FILVRM                 ; preencho a VRAM

            pop de                      ; recupero DE

            jr gplMensaStart            ; volto para a posição inicial

gplMensaWait:
            ld a,(vdpCycle5)            ; A=x
            add a,a                     ; A=A+A
            add a,a                     ; A=2A+A
            add a,a                     ; A=3A+A (o máximo ~4s)
            ld b,a
            ld hl,JIFFY
            ld (hl),0                   ; zero o temporizador
            call waitASec
            ret                         ; sai da rotina

gplMensaText:
            db 0,0,0,0,0,0,0,0,0,0,0
            db "FLAPPY BIRD for MSX "
            db 48+__VERSION,".",64+__RELEASE,0
            db "(c)2014-2016 by Crunchworks",0
            db 0
            db "it and/or modify it under",0
            db "This program is free soft-",0
            db "ware; you can redistribute",0
            db "the terms of the GNU Gen-",0
            db "eral Public License as",0
            db "published by the Free",0
            db "Software Foundation; ei-",0
            db "ther version 2 of the Li-",0
            db "cense, or (at your option)",0
            db "any later version.",0
            db 0
            db "This program is distrib-",0
            db "uted in the hope that it",0
            db "will be useful, but WITH-",0
            db "OUT ANY WARRANTY; without",0
            db "even the implied warranty",0
            db "of MERCHANTABILITY or FIT-",0
            db "NESS FOR A PARTICULAR PUR-",0
            db "POSE. See the GNU General",0
            db "Public License for more",0
            db "details.",1

            endp
