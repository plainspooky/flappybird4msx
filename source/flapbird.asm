;
;  Flappy Bird for MSX : flapbird.asm - rev.B
;
;  The annoying and pathetic bird flapping its wings in your MSX :)
;  
;  Copyright 2014 Giovanni dos Reis Nunes <giovanni.nunes@gmail.com>
;  
;  This program is free software; you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation; either version 2 of the License, or
;  (at your option) any later version.
;  
;  This program is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU General Public License for more details.
;  
;  You should have received a copy of the GNU General Public License
;  along with this program; if not, write to the Free Software
;  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
;  MA 02110-1301, USA.
;  

;
;  Flappy Bird is a original game released in 2013 by .GEARS
;

;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
;  To build, use:
;
;  "make rom" to build a ROM image or "make bin" to build a BIN file
;
;  Pasmo can be downloaded in http://pasmo.speccy.org/
;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;
;  Comments bellow will be in portuguese. My peace of mind needs that!
;

INCLUDE     ./library/msx1bios.asm
INCLUDE     ./library/msx1variables.asm

HTIMI:      equ 0xFD9F                  ; interrupção do VDP do MSX

;
;  Algumas constantes importantes utilizadas durante o jogo
;
PAL:        equ  5                      ; 1/10s em 50Hz (PAL-x)
NTSC:       equ  6                      ; 1/10s em 60Hz (NTSC & PAL-M)
            
GAP:        equ  6                      ; espaço entre os canos
            
VOLUME      equ 11                      ; volume da campanhia dos pontos
            
MAXU:       equ 12                      ; incremento máximo para a subida
MAXD:       equ 12                      ; incremendo maximo para a descida
            
ROMSIZE:    equ 8192                    ; o tamanho que a ROM deve ter
ROMAREA:    equ 0x8000                  ; minha ROM começa aqui
RAMAREA:    equ 0xe000                  ; inicio da área de variáveis

;
;  Minha área de variáveis, como este jogo é um cartucho ROM eu preci-
;  so é colocá-las em algum lugar onde com certeza tenho RAM, ou se-
;  ja, em 0xE000 -- dica do Felipe Antoniosi!
;
BIRDY:      equ RAMAREA
BIRDF:      equ RAMAREA+1
BIRDUP:     equ RAMAREA+2
BIRDDOWN:   equ RAMAREA+3
            
PIPEFRAM:   equ RAMAREA+4
PIPESIZE:   equ RAMAREA+5
PIPEGAP:    equ RAMAREA+6
            
RINGRING:   equ RAMAREA+7
            
SCORE:      equ RAMAREA+8               ; 16-bit
HISCORE:    equ RAMAREA+10              ; 16-bit
VDPCICLE1:  equ RAMAREA+12
VDPCICLE5:  equ RAMAREA+13
            
RNDSEED:    equ RAMAREA+14
            
BIRDBUF:    equ RAMAREA+15              ; coordenadas do pássaro
            
FRMBUF3:    equ BIRDBUF+32              ; o 3º framebuffer (64 bytes)
FRMBUF2:    equ FRMBUF3+64              ; o 2º framebuffer (140 bytes)
FRMBUF1:    equ FRMBUF2+140             ; o 1º framebuffer (640 bytes)

            org ROMAREA

if TARGET=0
            ;
            ; para montar como ROM
            ;
            db "AB"                     ; identifica como ROM
            dw START                    ; endereço de execução
            db "CW01B"                  ; string de identificação
else
            ;
            ; para montar como BIN
            ;
            db 0xfe
            dw START
            dw ROMPAD
            dw START
endif

START:      call INITVAR                ; inializa as variáveis em RAM
            
            call INITENV                ; inicializa o ambiente do jogo
            
            call CWLOGO                 ; chama a animação da abertura
            
            call GPLMENSA               ; exibe o aviso da GNU/GPL
            
GAMELOOP:   ld hl,-1
            ld (SCORE),hl               ; zero o SCORE
            
            call PREPSCR                ; preparo a tela
            
            call STARTSCR               ; menu principal
            
            call GAME                   ; e que o jogo comece!
            
            jr GAMELOOP                 ; volta para o laço do jogo

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  arranco o pássaro da tela
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
BIRDOFF:    ld a,192                    ; Um valor que não atrapalha ninguém
            ld bc,16                    ; 16/4 = 4, quatro sprites
            ld hl,6912                  ; início da tabela de sprites
            call FILVRM                 ; preenche com zero!
            
            ret                         ; sai da rotina

;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  abertura da Crunchworks
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
CWLOGORPT:  equ FRMBUF3                 ; posição atual no laço
CWLOGOPOS1: equ FRMBUF3+1               ; primeira linha na tela
CWLOGOPOS2: equ FRMBUF3+3               ; a segunda linha na tela

CWLOGO:     ld hl,0
            ld (CWLOGOPOS1),hl          ; a primeira linha na tela
            ld (CWLOGOPOS2),hl          ; a primeira linha na tela
            
            xor a                       ; zero A
            
            ld (CWLOGORPT),a            ; aproveiro para zera a posição
                                        ; do laço
            
            ld bc,768                   ; 768 bytes
            ld hl,6144                  ; começando em 6144
            call FILVRM                 ; limpo a tela
            
            ld hl,6144+2*32+9           ; início da parte de cima
            ld (CWLOGOPOS1),hl
            
            ld hl,6144+21*32+9          ; início da parte de baixo
            ld (CWLOGOPOS2),hl
            
            xor a
            
CWLOGO0:    ld hl,JIFFY
            ld (hl),0                   ; zera o timer do VDP
            
            ld (CWLOGORPT),a            ; salva o valor do contador
            
            ld bc,14                    ; número de bytes a copiar
            ld de,(CWLOGOPOS1)          ; posição na VRAM
            ld hl,CWLOGODATA            ; posição na RAM
            
            call LDIRVM                 ; copia a parte superior
            
            ld bc,14                    ; número de bytes a copiar
            ld de,(CWLOGOPOS2)          ; posição na VRAM
            ld hl,CWLOGODATA+14         ; posição na RAM
            
            call LDIRVM                 ; copia a parte inferior
            
            ld de,32                    ; meu incremento/decremento
            
            ld hl,(CWLOGOPOS1)          ; recupera a posição atual
            add hl,de                   ; uma linha abaixo + um caracter
            ld (CWLOGOPOS1),hl          ; armazena a nova posição
            
            ld hl,(CWLOGOPOS2)          ; recupera a posição atual
            sbc hl,de                   ; uma linha acima - um caracter
            ld (CWLOGOPOS2),hl          ; armazena a nova posição
            
            ld hl,VDPCICLE1
            ld b,(hl)                   ; pega intervalo de temporização
            sra b                       ; divido por dois
            call WAITASEC               ; espera um pouquinho
            
            ld a,(CWLOGORPT)            ; recupera o contador
            inc a                       ; incrementa o contador
            
            cp 10
            jr nz,CWLOGO0               ; se A<10, vá para CWLOGO0
            
                                        ; apaga o rastro do logotipo
            
            xor a                       ; zera A
            ld bc,288                   ; comprimento de 288 bytes
            ld hl,6144+2*32             ; posição inicial
            call FILVRM
            
            xor a                       ; zera A
            ld bc,288                   ; comprimeiro de 288 bytes
            ld hl,6144+13*32            ; posição inicial
            call FILVRM
            
            jp GPLMENSA2                ; economizo meu código :)
            
CWLOGODATA: db 01,02,00,00,00,00,03     ; primeira linha do logo
            db 00,00,00,00,03,00,00
            
            db 04,05,06,07,08,09,10     ; segunda linha do logo
            db 11,12,13,14,15,16,17

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  desenha o pássaro e cuida da alternância de quadros
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
DRAWBIRD:   ld a,(BIRDY)                ; pego a posição da ave para colocar na tela

            dec a                       ; diminuo em 1, um bug notório da tabela de sprites do TMS99x8
            ld b,a                      ; armazeno a posição em B
            
            ld a,(BIRDF)                ; pego o quadro correspondente a posição do pássaro
            
            sla a
            sla a
            sla a
            sla a                       ; multiplico por 16 (4x SHIFT LEFT)
            
            ld c,a                      ; armazeno em C
            
            ld hl,BIRDBUF               ; aponto para o frame buffer do pássaro
            
            ld a,0
            
DRAWBIRD0:  ld (hl),b                   ; atualizo a posição Y do pássaro
            
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
            jr nz,DRAWBIRD0             ; se A!=4, ir para DRAWBIRD0
            
            ld a,(BIRDF)
            inc a
            and 3
            ld (BIRDF),a                ; atualizo o frame, a animação tem 4
            
            ld bc,16
            ld de,6912
            ld hl,BIRDBUF
            call LDIRVM                 ; jogo estes 16 bytes na VRAM
            
            ret                         ; sai da rotina

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  Faz o desenho do cano no segundo frame buffer de acordo com a altura
;  *  definida em PIPESIZE.
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
DRAWPIPE:   ld a,0
            ld de,FRMBUF2               ; endereço do segundo framebuffer, vou
                                        ; desenhar um cano que vai do início ao
                                        ; final da tela
            
DRAWPIPE0:  ld hl,PIPEDATA              ; endereço do padrão do cano
            ld bc,7                     ; comprimento da cópia
            ldir                        ; 8?
            
            inc a
            cp 20
            jr nz,DRAWPIPE0             ; se A<20, ir para DRAWPIPE0
            
            ld hl,FRMBUF2               ; aponta para o início
            
            ld a,130                    ; 130,131 : linhas ciano
                                        ; 132,133 : linhas azul
            
DRAWPIPE1:  call DRAWPIPE3
            inc a
            cp 132
            jr nz,DRAWPIPE1             ; se A!=132, ir para DRAWPIPE1
            
            ld hl,FRMBUF2+18*7          ; as duas últimas linhas
            
DRAWPIPE2:  call DRAWPIPE3
            inc a
            cp 134
            jr nz,DRAWPIPE2             ; se A!=133, ir para DRAWPIPE2
            
            ld a,(PIPESIZE)             ; pego o valor de PIPESIZE
            
            sla a                       ; multiplico A por 2
            
            ld c,a                      ; jogo na primeira metade de BC e
            
            ld b,0                      ; limpo a outra parte, vai que...
            
            ld hl,TABLE7                ; TABLE7
            add hl,bc                   ; TABLE7 = TABLE7 + BC
            
            ld a,(hl)
            ld c,a
            inc hl
            ld a,(hl)
            ld b,a
            ld h,b
            ld l,c                      ; ld HL,BC :-(
            
            ld de,FRMBUF2
            add hl,de
            ex de,hl                    ; FRMBUF2 acrescido do tamanho e em DE!
            
            ld hl,HOLEDATA              ; dados do padrão entre os canos
            
            ld bc,70                    ; tamanho do bloco 7x10
            ldir                        ; copio o bloco
            
            ret
            
DRAWPIPE3:  ld (hl),a                   ; coloca uma das linhas
            ld de,5
            add hl,de                   ; avança mais 5
            ld (hl),a
            inc hl
            ld (hl),a
            inc hl
            ret                         ; sai da rotina

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  o jogo propriamente dito está aqui (ela é quase críptica!)
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
GAME:       call SNDBEEP                ; emito um beep
            
            call WRITEFB
            
            ld hl,BIRDY                 ; pássaro na altura inicial
            ld (hl),88                  ; (centro da tela)
            
            xor a                       ; zero o acumulador
            
            ld (BIRDF),a                ; o frame atual do pássaro
            
            ld (BIRDUP),a               ; zero o decremento (a subida)
            
            ld (BIRDDOWN),a             ; zero o incremento (a descida)
            
            ld (RINGRING),a             ; desligo o flag da campainha
            
            ld (PIPEGAP),a              ; zero o contador de espaço entre os canos
            
            dec a
            
            ld (PIPEFRAM),a             ; "zero" (com -1) o frame dos canos
            
            ;
            ; dica do Ricardo Bittencourt de pendurar a rotina de atuali-
            ; zação da tela no hook HTIMI fazendo com que os dados com a
            ; nova tela sejam enviados quando o VDP não estiver ocupado
            ; desenhando a tela.
            ;
            
            ld de,WRITEFB               ; rotina que atualiza a tela
            
            ld a,0xc9                   ; deveria ser CALL mas é RET
            ld (HTIMI),a
            
            ld a,e                      ; 'ss' de WRITEFB
            ld (HTIMI+1),a
            
            ld a,d                      ; 'tt' de WRITEFB
            ld (HTIMI+2),a
            
            ld a,0xc9                   ; RET (outro RET)
            ld (HTIMI+3),a
            
GAME0:      ld hl,JIFFY
            ld (hl),0                   ; zero o temporizador
                        
            call ROTPIPE                ; rotaciono os canos
            
            call UPDATEFB               ; atualizo o framebuffer
            
            call DRAWBIRD               ; desenho o pássaro
            
            call ROTDECOR               ; rotaciono a decoração
            
            ld a,(NEWKEY+8)             ; linha 8 da matriz de teclado
            bit 0,a                     ; barra de espaços pressionada?
            jp nz,GAME5                 ; senão, vou pra GAME6
            
            ld a,(BIRDDOWN)             ; o pássaro desce
            cp MAXD                     ; é igual ao incremento máximo?
            call nz,GAME9               ; se não for eu adiciono em 1
            ld (BIRDDOWN),a             ; armazeno o valor de descida
            xor a                       ; zero A
            ld (BIRDUP),a               ; armazeno em 0 o valor de subida
            
            jr GAME6
            
GAME5:      ld a,(BIRDUP)               ; o pássaro sobe
            cp MAXU                     ; é igual ao incremento máximo?
            call nz,GAME9               ; se não for eu adiciono em 1
            ld (BIRDUP),a               ; armazeno o valor de subida
            xor a                       ; zero A
            ld (BIRDDOWN),a             ; armazeno em 0 o valor de descida
            
GAME6:      ld de,BIRDDOWN              ; aponto DE para BIRDDOWN
            ld hl,BIRDUP                ; aponto HL para BIRDUP
            ld a,(BIRDY)                ; leio a posição atual do pássaro
            add a,(hl)                  ; adiciono o que o faz descer
            ex de,hl                    ; troco DE com HL
            sub (hl)                    ; subtraio o que o faz subir
            ld (BIRDY),a                ; guardo a nova posição do pássaro
            
            cp 4
            jp c,GAMEOVER               ; bati no teto, fim do jogo
            
            cp 168
            jp nc,GAMEOVER6             ; bati no chão, fim do jogo
            
            ld a,(FRMBUF1+11)           ; verifico se em (11,0) há um caracter
            cp 143                      ; específico de cano (143)
            call z,PRNTSCOR             ; Se for, é hora de pontuar.
            
            ld a,(RINGRING)             ; verifica se é hora momento de to-
            cp 0                        ; car a campainha da pontuação
            call nz,PLAYRING
            
            ld a,(BIRDY)                ; leio a altura atual do pássaro
            add a,4                     ; ajusto a altura
            
            and 0xf8                    ; retiro a parte desnecessária
            
            ld hl,4
            ld de,4
            
GAME7:      add hl,de                   ; e multiplico por 4
            dec a
            cp 0
            jr nz,GAME7
            
            ld de,6144+9                ; 10 ou 9?
            add hl,de
            call RDVRM                  ; vejo na VRAM o que tem na
                                        ; frente do pássaro
            cp 139
            jp nc,GAMEOVER
            
            ld de,32
            add hl,de
            call RDVRM                  ; vejo na posição abaixo.
            
            cp 139
            jp nc,GAMEOVER
            
            ld a,0xcd                   ; habilito a atualização da tela
            ld (HTIMI),a                ; por interrupção, roda 1x e só!
            
            ld hl,VDPCICLE1
            ld b,(hl)
            call WAITASEC               ; aguardo 1/10s
            
            jp GAME0
            
GAME9:      inc a                       ; hora de incrementar :-)
            ret                         ; está fora do lugar, não remover!

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  fim do jogo
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
GAMEOVER:   ld a,7
            ld e,7
            call WRTPSG                 ; sound 7,7
            
            ld a,6
            ld e,13
            call WRTPSG                 ; sound 6,13
            
            ld e,15
GAMEOVER0:  ld a,8
            call WRTPSG                 ; sound 8,15
            
            ld hl,JIFFY
            ld (hl),0                   ; zero o temporizador
            
            ld b,1
            call WAITASEC               ; espera um pouquinho
            
            dec e                       ; abaixo o volume
            ld a,e
            
            cp -1                       ; se não for <0 fico no laço
            jr nz, GAMEOVER0
            
GAMEOVER1:  ld hl,JIFFY
            ld (hl),0                   ; zero o temporizador
            
            ld b,4                      ; 4 é o incremento e o quadro
            
            ld hl,BIRDF
            ld (hl),b                   ; quadro do pássaro caindo
            
            ld hl,BIRDY
            ld a,(hl)                   ; recuupera a posição atual
            
            add a,b                     ; aumento em 4 pontos
            
            ld (hl),a                   ; armazeno a nova posição
            
            push af                     ; guardo o valor de A
            
            call DRAWBIRD               ; desenha o pássaro
            
            ld b,1                      ; 1/60 em NTSC ou 1/50 em PAL
            
            call WAITASEC               ; faço uma pausa
            
            pop af                      ; recupero o valor de A
            
            cp 162                      ; fica no laço até ser maior
            jr c,GAMEOVER1              ; que 162
            
            ld a,129                    ; caracter quadriculado
            ld bc,32*6
            ld hl,6144+32*9             ; preenche uma barra quadricu-
            call FILVRM                 ; lada no centro da tela
            
            ld bc,22                    ; incremento no <ENTER>
            
            ld hl,6144+10*32+11         ; posição inicial da tela
            ld de,GAMEOVER5             ; padrão do "GAME OVER"
            
GAMEOVER2:  ld a,(de)                   ; pego o primeiro caracter

            inc de                      ; já incremento o ponteiro
            
            cp 0                        ; é zero?
            jr z,GAMEOVER4              ; faço a quebra de linha
            
            cp 1                        ; é um?
            jr z,GAMEOVER3              ; saio da rotina
            
            call WRTVRM                 ; escrevo o byte na VRAM
            inc hl                      ; incremento a posição na tela
            
            jr GAMEOVER2                ; volto o laço
            
GAMEOVER3:  call GPLMENSA2              ; faço uma pausa de 4s
            
            ld a,7
            ld e,40
            call WRTPSG                 ; sound 7,40 (desligo o ruído)
            
            ret                         ; saio da rotina

GAMEOVER4:  add hl,bc
            jr GAMEOVER2                ; avanço uma linha!

GAMEOVER5:  db 0x80,0xfe,0xfe,0xfc,0xfe,0x80,0x80,0x80,0x80,0x80,0 ; "____    "
            db 0x80,0xe7,0xe1,0xed,0xe5,0xfe,0xfc,0xfe,0xfe,0x80,0 ; "GAME____"
            db 0x80,0x80,0x80,0x80,0x80,0xef,0xf6,0xe5,0xf2,0x80,0 ; "    OVER"
            db 0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,1 ; "        "

GAMEOVER6:  ld a,162-3
            ld (BIRDY),a                ; resolvo o problema quando do
            jp GAMEOVER                 ; choque com o solo


;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  mensagem da GPL
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
GPLMENSA:   ld de,GPLMENSA3-1           ; emdereço da mensagem, ou quase
            
GPLMENSAN:  ld hl,6144+23*32+3          ; posição inicial na tela
            
GPLMENSA0:  inc de                      ; incremento DE
            ld a,(de)                   ; coloco em A o conteúdo de DE
            cp 1                        ; não é um?
            jr z,GPLMENSA2              ; ainda tem trabalho, volto
            cp 0                        ; é zero?
            jr z,GPLMENSA1              ; preciso pular uma linha
            call WRTVRM                 ; escrevo A na VRAM
            inc hl                      ; incremento HL
            jr GPLMENSA0                ; faço o loop
            
GPLMENSA1:  push de                     ; salva DE por enquanto
            
            ld bc,768-32                ; da linha 1 até a 23
            ld de,FRMBUF3               ; uso todos os FRMBUFx
            ld hl,6144+32               ; A partir de (0,1)
            call LDIRMV                 ; copio para RAM
            
            ld bc,768-32                ; mesma quantidade de bytes
            ld de,6144                  ; no começo da tela
            ld hl,FRMBUF3               ; armazenado em FRMBUFx
            call LDIRVM                 ; copio para a VRAM
            
            ld a,32                     ; caracter de espaço
            ld bc,32                    ; 32 caracteres (uma linha)
            ld hl,6144+23*32            ; em (0,23)
            call FILVRM                 ; preencho a VRAM
            
            pop de                      ; recupero DE
            
            jr GPLMENSAN                ; volto para a posição inicial
            
GPLMENSA2:  ld a,(VDPCICLE5)            ; A=x
            add a,a                     ; A=A+A
            add a,a                     ; A=2A+A 
            add a,a                     ; A=3A+A (o máximo ~4s)
            
            ld hl,JIFFY
            ld (hl),0                   ; zero o temporizador
            
            ld b,a
            call WAITASEC
            
            ret                         ; sai da rotina
            
GPLMENSA3:  db 0,0,0,0,0,0,0,0,0,0,0
            db "FLAPPY BIRD for MSX rev.B",0
            db "(c)2014 by Crunchworks",0
            db 0
            db "This program is free soft-",0
            db "ware; you can redistribute",0
            db "it and/or modify it under",0
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

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  inicializa o ambiente
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
INITENV:    call TURBOMODE          ; é um turbo R? pare de sofrer!
            
            call BEEP               ; bipo (e zero os registros do PSG)
            
            call DISSCR             ; desligo a exibição da tela
            
            ld a,(JIFFY+1)          ; inicializo a semente do meu gerador
            ld (RNDSEED),a          ; de números pseudo-aleatórios
            
            ld a,(0x002b)           ; leio a versão do MSX na ROM
            bit 7,a                 ; se o bit 7 for 1 é 50Hz senão é 60Hz
            jr z, INITENV0          ; sendo 0 eu sigo adiante
            
            ld a,PAL                ; defino o novo valor para PAL
            ld (VDPCICLE1),a        ; o valor para 1/10s em PAL
            
            ld a,PAL*10             ; 1/10*10=1, certo?
            ld (VDPCICLE5),a        ; o valor é o de 1s em PAL
            
INITENV0:   xor a                   ; A=0
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
            ld hl,PATERNS           ; localização na RAM
            
            call LDIRVM             ; copio a tabela de padrões
            
            ld bc,2048              ; 2048 bytes a copiar
            ld de,8192              ; tabela de atributos na VRAM
            ld hl,ATTRIBS           ; localização na RAM
            
            call LDIRVM             ; copio a tabela de atributos
            
            ld bc,768               ; 768 bytes a copiar
            ld de,14336             ; tabela de sprites na VRAM
            ld hl,SPRITES           ; localização na RAM
            
            call LDIRVM             ; copio a tabela de sprites
            
            call ENASCR             ; religo a tela
            
            ret                     ; sai da rotina

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  inicializa as variáveis do programa
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
INITVAR:    xor a                       ; zero A
            
            ld (BIRDY),a                ; altura do pássaro
            ld (BIRDF),a                ; frame atual do pássaro
            ld (BIRDUP),a               ; decremento (a subida)
            ld (BIRDDOWN),a             ; incremento (a descida)
            
            ld (PIPEFRAM),a             ; frame atual dos canos
            ld (PIPESIZE),a             ; altura dos canos na tela
            ld (PIPEGAP),a              ; espaço entre os canos na tela
            
            ld (RINGRING),a             ; flag do som de pontuação
            
            ld hl,0                     ; recorde do dia (sempre zero)
            ld (HISCORE),hl
            
                                        ; temporização para NTSC e PAL-M
            ld a,NTSC
            ld (VDPCICLE1),a            ; a princípio 6 -- 1/10s
            
            ld a,NTSC*10
            ld (VDPCICLE5),a            ; a princípio 60 - 1s
            
            ld bc,32
            ld hl,BIRDRAW
            ld de,BIRDBUF               ; copia as coordenadas do pás-
            ldir                        ; saro para a RAM
            
            ret                         ; sai da rotina

;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *   Copia uma área da VRAM para outra (usa a mesma sintaxe do LDIR)
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
;LDIRVV:    call RDVRM                  ; leio o byte na VRAM
;           ex de,hl                    ; troco DE com HL
;           call WRTVRM                 ; gravo o byte na VRAM
;           ex de,hl                    ; (des)troco DE com HL
;           inc de                      ; incremento DE
;           cpi                         ; cp A,(HL) + inc HL + dec BC
;           jp PE,LDIRVV
;           ret

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  rotina que cuida do som da pontuação
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
PLAYRING:   cp VOLUME                   ; se não estou em VOLUME
            jr nz,PLAYRING0             ; vou para a segunda parte
            
            ld a,0
            ld e,95
            call WRTPSG                 ; sound 0,95
            
            ld a,1
            ld e,0
            call WRTPSG                 ; sound 1,0
            
            ld a,8
            ld e,VOLUME
            call WRTPSG                 ; sound 8,10
            
            ld a,VOLUME-1
            ld (RINGRING),a             ; atualiza para a 2ª parte
            
            ret                         ; sai da rotina
            
PLAYRING0:  ld b,a                      ; salva o volume
            
            ld a,8
            ld e,b
            call WRTPSG                 ; sound 8,B
            
            ld a,0
            ld e,75
            call WRTPSG                 ; sound 0,75
            
            ld a,b                      ; pego o volume salvo
            
            dec a                       ; diminuo em um
            
            ld (RINGRING),a             ; guardo o novo estado
            
            cp 0                        ; cheguei em 0?
            ret nz                      ; voltarei aqui no próximo laço
            
            ld a,8
            ld e,0
            call WRTPSG                 ; sound 8,0 (desligo o som)
            
            ld a,0
            ld (RINGRING),a             ; desliga o toque de campainha
            
            ret                         ; sai da rotina

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  prepara a tela e inicializa o framebuffer principal
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
PREPSCR:    ld a,15                 ; BRANCO
            ld (FORCLR),a           ; cor da frente em branco
            ld a,5                  ; AZUL
            ld (BAKCLR),a           ; cor de fundo
            ld (BDRCLR),a           ; cor da borda
            call CHGCLR             ; agora mudo as cores da tela
            
            ld bc,16                ; 16 bytes a copiar
            ld de,6912+16           ; do sprite 4 em diante
            ld hl,CORNERS           ; com posições já estão definidas
            call LDIRVM             ; arredondo os cantos da tela
            
            ld a,160                ; o caracter das nuvens
            ld bc,32                ; a quantidade desejada
            ld hl,6144              ; a primeira linha da tela
            call FILVRM             ; desenho a tarja branca
            
            ld bc,4                 ; "Score->"
            ld de,6144+3            ; posição na tela
            ld hl,PREPSCR3+1        ; padrão da string
            call LDIRVM             ; copio na VRAM
            
            ld bc,5                 ; "HiScore->"
            ld de,6144+19           ; posição na tela
            ld hl,PREPSCR3          ; padrão da string
            call LDIRVM             ; copio na VRAM
            
            call PRNTSCOR           ; aproveita e escreve a pontuação
            
            ld a,165                ; o caracter do solo
            ld bc,32                ; a quantidade desejada
            ld hl,6144+23*32        ; a última linha da tela
            call FILVRM             ; desenho o solo
            
            ld a,0                  ; começo a desenhar a tela
            ld de,6144+22*32        ; o chão começa aqui
            ld hl,6144+1*32         ; e as nuvens aqui
            
PREPSCR0:   ld b,a                  ; copio A para B
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
            jr nz,PREPSCR0          ; se A<>16, vá para INITSCR0
            
PREPSCR1:   ld a,130                ; primeiro caracter das linhas ciano
            ld hl,6144+2*32         ; posição da tela
            call PREPSCR2           ; chamo a rotina que fará o resto
            
            ld a,132                ; primeiro caracter das linhas azul
            ld hl,6144+20*32        ; posição da tela
            call PREPSCR2           ; chamo a rotina que fará o resto
            
            ld a,128                ; fundo azul (CHR 128)
            ld bc,16*32             ; o que restou da tela para preencher
            ld hl,6144+4*32         ; tabela de nomes
            call FILVRM             ; preenche a tela
            
                                    ; Alimento FRMBUF1
            
            ld bc,32*20             ; tamanho da cópia (640 bytes)
            ld de,FRMBUF1           ; endereço de FRMBUF1
            ld hl,6144+2*32         ; posição da tela
            call LDIRMV             ; alimento FRMBUF1 já inicializado
            
                                    ; Alimento FRMBUF2
            
            ld bc,14                ; para as duas primeiras linhas de
            ld de,FRMBUF2           ; FRMBUF2
            ld hl,6144+3*32-7
            call LDIRMV
            
            ld bc,16*7              ; para as linhas 3 até 18 de
            ld de,FRMBUF2+14        ; FRMBUF2
            ld hl,6144+4*32
            call LDIRMV
            
            ld bc,14                ; para as duas últimas linhas de
            ld de,FRMBUF2+140-14    ; FRMBUF2
            ld hl,6144+21*32-7
            call LDIRMV
            
            ret                     ; sai da rotina
            
PREPSCR2:   ld bc,32                ; carrego BC com o comprimento
            push af                 ; salvo AF, o FILVRM afeta este cara
            call FILVRM             ; chamo FILVRM
            pop af                  ; recupero o AF salvo
            inc a                   ; incremento A
            ld bc,32                ; recarrego BC
            add hl,bc               ; adiciono HL com BC (próxima linha)
            call FILVRM             ; chamo FILVRM novamente
            ret
            
PREPSCR3:   db 190                  ; "Hi"
            db 187, 188, 189        ; "Score"
            db 191                  ; "->"

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  imprime a pontuação, adaptado da rotina de escrita de números de 16-bit
;  *  orginal de Milos "baze" Bazelides <baze_at_baze_au_com> e disponível em:
;  *  http://baze.au.com/misc/z80bits.html
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
PRNTSCOR:   ld hl,(SCORE)               ; recupero o valor atual da pontuação
            inc hl                      ; incremento a pontuação
            ld (SCORE),hl               ; armazeno a pontuação
            ld de,FRMBUF3               ; área temporária para escrever
            call PRNTSCOR2              ; escrevo os números lá
            
            ld bc,5                     ; até 5 dígitos
            ld de,6144+7                ; posição na tela
            ld hl,FRMBUF3
            call LDIRVM                 ; atualizo a pontuação na tela
            
            ld hl,(HISCORE)             ; leio o recorde
            ld de,(SCORE)               ; leio novamenre a pontuação
            sbc hl,de                   ; subtraio um com o outro
            jr nc,PRNTSCOR1             ; o recorde não é maior
            
            ld (HISCORE),de             ; armazeno o novo recorde
            
PRNTSCOR1:  ld hl,(HISCORE)
            ld de,FRMBUF3               ; área temporária para escrever
            call PRNTSCOR2
            
            ld bc,5                     ; até 5 dígitos
            ld de,6144+24               ; posição na tela
            ld hl,FRMBUF3
            call LDIRVM                 ; atualizo o recorde na tela
            
            ld a,11
            ld (RINGRING),a             ; habilita o som da pontuação
            
            ret                         ; sai da rotina
            
PRNTSCOR2:  ld bc,-10000
            call PRNTSCOR3
            ld bc,-1000
            call PRNTSCOR3
            ld bc,-100
            call PRNTSCOR3
            ld c,-10
            call PRNTSCOR3
            ld c,b
            
PRNTSCOR3:  ld a,176                    ; o caracter anterior ao '0'
            
PRNTSCOR4:  inc a
            add hl,bc
            jr c,PRNTSCOR4
            sbc hl,bc
            ld (de),a
            inc de
            ret

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  gerador de números pseudo-aleatórios levemente adaptada do código ori-
;  *  ginal de Milos "baze" Bazelides <baze_at_baze_au_com> e disponível em:
;  *  http://baze.au.com/misc/z80bits.html
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
RANDOM:     ld a,(BIRDY)                ; uma das seed é o BIRDY!
            ld b,a
            ld a,(RNDSEED)              ; mas eu tenho outro SEED
            add a,a
            add a,a
            add a,b
            inc a
            ld (RNDSEED),a              ; guardo o valor
            
            ret                         ; fim da rotina

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  faz a rotação de 2 em 2 pixels no padrão do solo.
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
ROTDECOR:   ld bc,16                    ; os caracteres das NUVENS
            ld de,FRMBUF3
            ld hl,161*8                 ; caracteres 161 e 162
            call LDIRMV                 ; copio o padrão das nuvens da VRAM
            
            ld bc,8                     ; um caracter
            ld de,FRMBUF3+24            ; cópia de 161 ao lado de 162
            ld hl,FRMBUF3               ; aqui é o 161
            ldir
            
            ld bc,8                     ; um caracter
            ld de,FRMBUF3+16            ; cópia de 162 ao lado de 161
            ldir                        ; não defino HL, ele há está em 162
            
            ld de,FRMBUF3               ; DE fica no caracter
            ld hl,FRMBUF3+16            ; HL fica no espelho
            ld a,0                      ; meu contador
            
ROTDECOR0:  push af                     ; salvo o contador
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
            jr nz,ROTDECOR0             ; se não volto para ROTDECOR0
            
            ld bc,16                    ; os caracteres do CHÃO
            ld de,FRMBUF3+16
            ld hl,163*8                 ; caracteres 163 e 164
            call LDIRMV                 ; copio o padrão de solo da VRAM
            
            ld a,(FRMBUF3+16)
            ld (FRMBUF3+32),a           ; pego o primeiro byte, jogo no final
            
            ld a,(FRMBUF3+17)
            ld (FRMBUF3+33),a           ; pego o segundo byte, jogo no final+1
            
            ld bc,16
            ld de,FRMBUF3+16
            ld hl,FRMBUF3+18
            ldir                        ; ajusto para ficar contíguo
            
            ld bc,32
            ld de,161*8
            ld hl,FRMBUF3
            call LDIRVM                 ; devolvo o padrão deslocado à VRAM
            
            ret                         ; sai da rotina

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  faz a atualização dos canos na tela
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
ROTPIPE:    ld a,(PIPEGAP)
            cp GAP
            jr nz,ROTPIPE1              ; PIPEGAP<>GAP, vá pra ROTPIPE1
            
            call RANDOM                 ; sorteio a altura dos canos
            and 7                       ; só preciso de valores entr 0 e 6
            
            cp 7                        ; A é igual a 7?
            jr nz,ROTPIPE0              ; é diferente sigo para ROTPIPE0
            dec a                       ; senão, subtraio de 1
            
ROTPIPE0:   ld (PIPESIZE),a             ; armazeno a altura dos canos
            
            call DRAWPIPE               ; desenho os canos em framebuffer2
            
            xor a                       ; zero A
            ld (PIPEGAP),a              ; armazeno em PIPEGAP
            dec a                       ; A agora será -1
            ld (PIPEFRAM),a             ; armazeno em PIPEFRAME
            
ROTPIPE1:   ld a,(PIPEGAP)              ; carrego o valor de PIPEGAP
            cp 0
            jr nz,ROTPIPE2              ; se 0 estou no espaço entre canos
            
            ld a,(PIPEFRAM)             ; carrego o quadro do cano
            inc a                       ; incremento 
            ld (PIPEFRAM),a             ; atualizo para fazer o próximo
            
ROTPIPE2:   ld a,(PIPEFRAM)             ; verifico o quadro do cano
            cp 6                        ; é 6?
            ret nz
            
            ld a,(PIPEGAP)
            inc a
            ld (PIPEGAP),a
            
            ret                         ; sai da rotina

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  beep personalizado usado para indicar as opções selecionadas no jogo
;  *  -- um sol, na quinta oitava -- play "o5g"
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
SNDBEEP:    xor a
            ld hl,JIFFY
            ld (hl),a                   ; zera o timer do VDP
            
            ld e,0x8f                   ; valor
            ld a,0                      ; registrador 0
            call WRTPSG                 ; sound 0,143
            
            ld e,0                      ; valor
            ld a,1                      ; registrador 1
            call WRTPSG                 ; sound 1,0
            
            ld a,15                     ; valor do volume
SNDBEEP0:   ld e,a
            ld a,8                      ; registrador 8
            call WRTPSG                 ; sound 8,E
            
            ld a,e
            sbc a,(hl)                  ; o menos significativa de JIFFY
            
            jr nc,SNDBEEP0              ; sim, uso o temporizador como
                                        ; ajuste do volume do canal
            
            ld a,8
            ld e,0
            call WRTPSG                 ; sound 8,0
            
            ret                         ; saio da rotina

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  a tela de abertura do jogo
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
STARTSCR:   call BIRDOFF                ; removo o pássaro da tela
            
            ld bc,160                   ; a imagem com o logotipo do jogo
            ld de,6144+4*32             ; na 4ª linha da tela
            ld hl,STARTSCR3
            call LDIRVM                 ; copio para a VRAM
            
            ld a,166                    ; insiro o "for MSX"
            ld hl,6144+9*32+18          ; posição na VRAM
STARTSCR0:  call WRTVRM
            
            inc a                       ; incremento A
            inc hl                      ; incremento a posição
            cp 173                      ; é 173?
            call z,STARTSCR2            ; mudo de linha
            cp 177                      ; é 177?
            jr nz,STARTSCR0             ; se não for volto ao laço
            
            ld bc,64                    ; o texto "PRESS SPACE TO START"
            ld de,6144+11*32            ; na 11ª linha da tela
            ld hl,STARTSCR3+160
            call LDIRVM                 ; copio para a VRAM
            
            ld bc,128                   ; o texto "ORIGINAL ... WORKS"
            ld de,6144+15*32            ; na 15ª linha da tela
            ld hl,STARTSCR3+160+64
            call LDIRVM                 ; copio para a VRAM

            call KILBUF                 ; limpo o buffer do teclado
            
STARTSCR1:  ld hl,JIFFY
            ld (hl),0                   ; zero o temporizador

            ld hl,VDPCICLE1
            ld b,(hl)
            call WAITASEC               ; aguardo 1/10s
                        
            ld a,(NEWKEY+8)             ; linha 8 da matriz do teclado
            
            bit 0,a                     ; barra de espaço sendo pressionada?
            ret z                       ; se foi, sai do loop
            
            jr STARTSCR1
            
STARTSCR2:  ld hl,6144+10*32+21
            ret

STARTSCR3:  INCBIN ./binary/screen.inc

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  habilita o modo R800 ROM se eu estiver rodando em um turbo R, rotina de
;  *  Timo Nyyrikki -- http://www.msx.org/wiki/R800_Programming#BIOS_routines
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
TURBOMODE:  ld a,(0x002d)               ; byte de ID do MSX
            cp 3                        ; é turbo R?
            ret nz                      ; se não for vai embora
            
            ld a,(0x0180)               ; rotina CHGCPU
            cp 0C3h
            
            ld a,0x81                   ; modo R800 ROM
            
            call z,0x0180
            
            ret                         ; sai da rotina

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  rotaciona tela do primeiro framebuffer, completa com um trecho do segun-
;  *  do framebuffer
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
UPDATEFB:   ld a,0                      ; número de linhas a rotacionar
            ld de,FRMBUF1               ; primeira posição do framebuffer
            ld hl,FRMBUF1+1             ; o sujeito ao lado
            
UPDATEFB0:  ld bc,31                    ; tamanho de colunas da tela menos 1
            ldir                        ; copia o bloco de memória
            inc de                      ; avanço para o começo da próxima linha
            inc hl                      ; e também para o próximo vizinho
            inc a                       ; incremento o contador
            cp 20
            jr nz,UPDATEFB0             ; se A!=20, vá para UPDATEFB0
            
            ld hl,PIPEFRAM
            ld c,(hl)                   ; carrego o frame na primeira parte d BC
            ld b,0                      ; zero a segunda parte de BC
            
            ld hl,FRMBUF2               ; aponto para o framebuffer 2 (origem)
            add hl,bc                   ; acrescento o frame que preciso
            ex de,hl                    ; coloco a origem atualizada em DE
            
            ld hl,FRMBUF1+31            ; aponto HL para framebuffer 1 (destino)
            ld a,0
            
UPDATEFB1:  push af                     ; salvo A por enquanto
            
            ld a,(de)                   ; pego A na origem
            ld (hl),a                   ; gravo A em destino
            
            ld bc,7
            ex de,hl                    ; troco DE com HL
            add hl,bc                   ; somo HL (que é DE) com BC
            ex de,hl                    ; troco DE com HL (huhu) e DE=DE+7
            
            ld bc,32
            add hl,bc                   ; HL=HL+32
            
            pop af                      ; recupero o A original (o contador do laço)
            
            inc a
            cp 20
            jr nz,UPDATEFB1             ; se A!=20, vá para UPDATEFB1
            
            ret                         ; sai da rotina

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  gera uma espera de 'B' ciclos do VDP (não se esqueça de zerar JIFFY)
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
WAITASEC:   ld a,(JIFFY)
            cp b
            ret z                       ; sai da rotina
            jr WAITASEC

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  atualiza o framebuffer - rotina que penduro no hook HTIMI
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
WRITEFB:    ld bc,640
            ld de,6144+64
            ld hl,FRMBUF1
            call LDIRVM
            
            ld a,0xc9                   ; desabilito a atualização da
            ld (HTIMI),a                ; tela por interrupção
            
            ret

;
;  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
;  #
;  #  ÁREA DE TRABALHO (IMAGENS E COISAS RELACIONADAS)
;  # 
;  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
;

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  a tabela de padrões (2048 bytes)
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
PATERNS:    INCBIN ./binary/patterns.inc

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  a tabela de atributos (2048 bytes)
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
ATTRIBS:    INCBIN ./binary/attributes.inc

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  a tabela de sprites (768 bytes)
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
SPRITES:    INCBIN ./binary/sprites.inc

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  as coordenadas iniciais dos sprites do pássaro
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
BIRDRAW:    db 0,88,0,1                 ; contorno (em preto)
            db 0,88,0,8                 ; bico (em vermelho)
            db 0,88,0,10                ; corpo (em amarelo)
            db 0,88,0,15                ; olhos e asas (em branco)

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  os cantos arredondados na tela (32 bytes)
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
CORNERS:    db 255,0,80,5               ; posição (0,0)
            db 255,240,84,5             ; posição (30,0)
            db 175,0,88,5               ; posição (0,22)
            db 175,240,92,5             ; posição (30,22)

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  o padrão dos canos (o miolo)
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
PIPEDATA:   db 128,140,141,142,143,128,128  ; row 0

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  o padrão do espaço entre canos (com as bordas)
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
HOLEDATA:   db 134,144,145,146,147,135,128  ; row 0 (canos de cima)
            db 138,148,149,150,151,139,128  ; row 1
            db 128,128,128,128,128,128,128  ; row 2
            db 128,128,128,128,128,128,128  ; row 3
            db 128,128,128,128,128,128,128  ; row 4 
            
            db 128,128,128,128,128,128,128  ; row 5
            db 128,128,128,128,128,128,128  ; row 6
            db 128,128,128,128,128,128,128  ; row 7
            db 138,152,153,154,155,139,128  ; row 8
            db 136,156,157,158,159,137,128  ; row 9 (canos de baixo)

;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  tabuada de 7, porque o Z80 só sabe somar! :-(
;  * 
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
TABLE7:     dw 14,21,28,35,42,49,56,63,70

;
;  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
;  #
;  #  RECHEIO DE ESPAÇOS EM BRANCO PARA GERAR UMA ROM COM O TAMNHO EXATO
;  # 
;  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
;
ROMPAD:

if TARGET=0
            rept ROMSIZE-(ROMPAD-ROMAREA)
            db 0
            endm
endif

END

;
; MSX rulez a lot!
;
