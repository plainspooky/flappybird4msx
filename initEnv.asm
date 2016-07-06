;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  inicializa o ambiente
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
initEnv:
            proc
            local palAdjust
            local noPalAdjust
            local charPatterns
            local charAttributes
            local spritePatterns

            call turboMode          ; é um turbo R? pare de sofrer!

            call BEEP               ; bipo (e zero os registros do PSG)

            call DISSCR             ; desligo a exibição da tela

            ld a,(JIFFY+1)          ; inicializo a semente do meu gerador
            ld (rndSeed),a          ; de números pseudo-aleatórios

            ld a,(0x002b)           ; leio a versão do MSX na ROM
            bit 7,a                 ; se o bit 7 for 1 é 50Hz senão é 60Hz
            jr z, noPalAdjust       ; sendo 0 eu sigo adiante

palAdjust:
            ld a,PAL                ; defino o novo valor para PAL
            ld (vdpCycle1),a        ; o valor para 1/10s em PAL
            ld a,PAL*10             ; 1/10*10=1, certo?
            ld (vdpCycle5),a        ; o valor é o de 1s em PAL

noPalAdjust:
            xor a                   ; A=0
            ld (CLIKSW),a           ; desligo o click das teclas e

            call ERAFNK             ; desligo as teclas de função

            ld a,15                 ; BRANCO
            ld (FORCLR),a           ; cor da frente em branco
            xor a                   ; TRANSPARENTE
            ld (BAKCLR),a           ; cor de fundo
            ld (BDRCLR),a           ; cor da borda
            call CHGCLR             ; agora mudo as cores da tela

            ld a,32
            ld (LINL32),a           ; largura da tela em 32 colunas

            call INIT32             ; entro na SCREEN1

            ld a,(RG0SAV)           ; leio o valor do registro 0
            or 2
            ld b,a                  ; o novo valor fica em B
            ld c,0                  ; e o registrador em C
            call WRTVDP             ; altero o valor do registro 0

            ld a,(RG1SAV)           ; leio o valor do registro 1
            and 0xE6                ; também desligo o zoom dos sprites
            or 2                    ; e ajusto os sprites para 16x16
            ld b,a                  ; B=A
            inc c
            call WRTVDP             ; altero o valor do registro 1

            ld a,(RG3SAV)           ; leio o valor do registro 3
            ld b,0x9F
            inc c
            inc c
            call WRTVDP             ; altero o valor do registro 3

            ld a,(RG4SAV)           ; leio o valor do registro 4
            ld b,0
            inc c
            call WRTVDP             ; altero o valor do registro 4

            ld bc,2048              ; 2048 bytes a copiar
            ld de,0                 ; tabela de padrões na VRAM
            ld hl,charPatterns     ; localização na RAM
            call LDIRVM             ; copio a tabela de padrões

            ld bc,2048              ; 2048 bytes a copiar
            ld de,8192              ; tabela de atributos na VRAM
            ld hl,charAttributes    ; localização na RAM
            call LDIRVM             ; copio a tabela de atributos

            ld bc,768               ; 768 bytes a copiar
            ld de,14336             ; tabela de sprites na VRAM
            ld hl,spritePatterns    ; localização na RAM
            call LDIRVM             ; copio a tabela de sprites

            call ENASCR             ; religo a tela

            ret                     ; sai da rotina

charPatterns:
            incbin "gfx/patterns.inc"

charAttributes:
            incbin "gfx/attributes.inc"

spritePatterns:
            incbin "gfx/sprites.inc"

            endp
