;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  a tela de abertura do jogo
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
startScreen:
            proc
            local drawScreen
            local waitPressFire
            local changeToNextLine
            local screenData

            call birdOff                ; removo o pássaro da tela

            ld bc,160                   ; a imagem com o logotipo do jogo
            ld de,6144+4*32             ; na 4ª linha da tela
            ld hl,screenData
            call LDIRVM                 ; copio para a VRAM

            ld a,166                    ; insiro o "for MSX"
            ld hl,6144+9*32+18          ; posição na VRAM

drawScreen:
            call WRTVRM

            inc a                       ; incremento A
            inc hl                      ; incremento a posição
            cp 173                      ; é 173?
            call z,changeToNextLine         ; mudo de linha
            cp 177                      ; é 177?
            jr nz,drawScreen          ; se não for volto ao laço

            ld bc,64                    ; o texto "PRESS SPACE TO START"
            ld de,6144+11*32            ; na 11ª linha da tela
            ld hl,screenData+160
            call LDIRVM                 ; copio para a VRAM

            ld bc,128                   ; o texto "ORIGINAL ... WORKS"
            ld de,6144+15*32            ; na 15ª linha da tela
            ld hl,screenData+160+64
            call LDIRVM                 ; copio para a VRAM

            call KILBUF                 ; limpo o buffer do teclado

waitPressFire:
            ld hl,JIFFY
            ld (hl),0                   ; zero o temporizador

            ld hl,vdpCycle1
            ld b,(hl)
            call waitASec               ; aguardo 1/10s

            xor a
            call GTTRIG                 ; lê a barra de espaços

            ld h,a                      ; salva o valor em H

            ld a,1
            call GTTRIG                 ; lê o botão 1 do joystick 0

            or h                        ; junta as duas leituras

            cp 255                      ; ainda é 255?
            ret z                       ; sai da laço

            jr waitPressFire

changeToNextLine:
            ld hl,6144+10*32+21
            ret

screenData:
            incbin "gfx/screen.inc"

            endp
