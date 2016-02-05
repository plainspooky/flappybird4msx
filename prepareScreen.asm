
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  prepara a tela e inicializa o framebuffer principal
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;

prepareScreen:
            proc

            local prepareScenario
            local prepareSky
            local drawMultiples
            local corners
            local hiScoreText

            ld a,15                 ; BRANCO
            ld (FORCLR),a           ; cor da frente em branco
            ld a,5                  ; AZUL
            ld (BAKCLR),a           ; cor de fundo
            ld (BDRCLR),a           ; cor da borda
            call CHGCLR             ; agora mudo as cores da tela

            ld bc,16                ; 16 bytes a copiar
            ld de,6912+16           ; do sprite 4 em diante
            ld hl,corners           ; com posições já estão definidas
            call LDIRVM             ; arredondo os cantos da tela

            ld a,160                ; o caracter das nuvens
            ld bc,32                ; a quantidade desejada
            ld hl,6144              ; a primeira linha da tela
            call FILVRM             ; desenho a tarja branca

            ld bc,4                 ; "score->"
            ld de,6144+3            ; posição na tela
            ld hl,hiScoreText+1     ; padrão da string
            call LDIRVM             ; copio na VRAM

            ld bc,5                 ; "hiScore->"
            ld de,6144+19           ; posição na tela
            ld hl,hiScoreText       ; padrão da string
            call LDIRVM             ; copio na VRAM

            call printScore         ; aproveito e escrevo a pontuação

            ld a,165                ; o caracter do solo
            ld bc,32                ; a quantidade desejada
            ld hl,6144+23*32        ; a última linha da tela
            call FILVRM             ; desenho o solo

            ld a,0                  ; começo a desenhar a tela
            ld de,6144+22*32        ; o chão começa aqui
            ld hl,6144+1*32         ; e as nuvens aqui

prepareScenario:
            ld b,a                  ; copio A para B
            ld a,161                ; o primeiro padrão da nuvem
            call WRTVRM             ; escrevo na VRAM
            inc hl                  ; incremento HL
            inc a                   ; incremento A, para o outro caracter
            call WRTVRM             ; escrevo novamente na VRAM

            ex de,hl                ; troco DE com HL

            ld a,163                ; primeiro padrão do solo
            call WRTVRM             ; escrevo na VRAM
            inc hl                  ; incremento HL
            inc a                   ; incremento A, para o outro caracter
            call WRTVRM             ; escrevo novamente na VRAM

            ex de,hl                ; troco DE com HL

            inc hl                  ; incremento HL
            inc de                  ; incremendo DE

            ld a,b                  ; recupero o valor salvo de A
            inc a                   ; incremento A
            cp 16
            jr nz,prepareScenario   ; se A<>16, vá para INITSCR0

prepareSky:
            ld a,130                ; primeiro caracter das linhas ciano
            ld hl,6144+2*32         ; posição da tela
            call drawMultiples      ; chamo a rotina que fará o resto

            ld a,132                ; primeiro caracter das linhas azul
            ld hl,6144+20*32        ; posição da tela
            call drawMultiples      ; chamo a rotina que fará o resto

            ld a,128                ; fundo azul (CHR 128)
            ld bc,16*32             ; o que restou da tela para preencher
            ld hl,6144+4*32         ; tabela de nomes
            call FILVRM             ; preenche a tela

                                    ; Alimento framebuff1

            ld bc,32*20             ; tamanho da cópia (640 bytes)
            ld de,framebuff1        ; endereço de framebuff1
            ld hl,6144+2*32         ; posição da tela
            call LDIRMV             ; alimento framebuff1 já inicializado

                                    ; Alimento framebuff2

            ld bc,14                ; para as duas primeiras linhas de
            ld de,framebuff2        ; framebuff2
            ld hl,6144+3*32-7
            call LDIRMV

            ld bc,16*7              ; para as linhas 3 até 18 de
            ld de,framebuff2+14     ; framebuff2
            ld hl,6144+4*32
            call LDIRMV

            ld bc,14                ; para as duas últimas linhas de
            ld de,framebuff2+140-14 ; framebuff2
            ld hl,6144+21*32-7
            call LDIRMV

            ret                     ; sai da rotina

drawMultiples:
            ld bc,32                ; carrego BC com o comprimento
            push af                 ; salvo AF, o FILVRM afeta este cara
            call FILVRM             ; chamo FILVRM
            pop af                  ; recupero o AF salvo
            inc a                   ; incremento A
            ld bc,32                ; recarrego BC
            add hl,bc               ; adiciono HL com BC (próxima linha)
            call FILVRM             ; chamo FILVRM novamente
            ret

hiScoreText:
            db 190                  ; "Hi"
            db 187, 188, 189        ; "score"
            db 191                  ; "->"

corners:
            db 255,0,80,5               ; posição (0,0)
            db 255,240,84,5             ; posição (30,0)
            db 175,0,88,5               ; posição (0,22)
            db 175,240,92,5             ; posição (30,22)

            endp
