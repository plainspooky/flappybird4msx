;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  faz a rotação de 2 em 2 pixels no padrão do solo.
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
rotateDecoration:
            proc

            local rotateClouds

            ld bc,16                    ; os caracteres das NUVENS
            ld de,framebuff3
            ld hl,161*8                 ; caracteres 161 e 162
            call LDIRMV                 ; copio o padrão das nuvens da VRAM

            ld bc,8                     ; um caracter
            ld de,framebuff3+24         ; cópia de 161 ao lado de 162
            ld hl,framebuff3            ; aqui é o 161
            ldir

            ld bc,8                     ; um caracter
            ld de,framebuff3+16         ; cópia de 162 ao lado de 161
            ldir                        ; não defino HL, ele há está em 162

            ld de,framebuff3            ; DE fica no caracter
            ld hl,framebuff3+16         ; HL fica no espelho
            ld a,0                      ; meu contador

rotateClouds:
            push af                     ; salvo o contador
            ld a,(de)                   ; copio o conteúdo em DE
            sla a
            sla a                       ; rotaciono 2x para esquerda

            ld b,(hl)                   ; copio o conteúdo de HL
            srl b
            srl b
            srl b
            srl b
            srl b
            srl b                       ; rotaciono 6x para a direita
            or b                        ; A or B (junto os dois)
            ld (de),a                   ; armazeno na RAM

            inc hl                      ; incremento HL

            inc de                      ; incremento DE

            pop af                      ; recupero o contador

            inc a                       ; incremento
            cp 16                       ; é 16?
            jr nz,rotateClouds             ; se não volto para rotateDecoration0

            ld bc,16                    ; os caracteres do CHÃO
            ld de,framebuff3+16
            ld hl,163*8                 ; caracteres 163 e 164
            call LDIRMV                 ; copio o padrão de solo da VRAM

            ld a,(framebuff3+16)
            ld (framebuff3+32),a           ; pego o primeiro byte, jogo no final

            ld a,(framebuff3+17)
            ld (framebuff3+33),a           ; pego o segundo byte, jogo no final+1

            ld bc,16
            ld de,framebuff3+16
            ld hl,framebuff3+18
            ldir                        ; ajusto para ficar contíguo

            ld bc,32
            ld de,161*8
            ld hl,framebuff3
            call LDIRVM                 ; devolvo o padrão deslocado à VRAM

            ret                         ; sai da rotina

            endp
