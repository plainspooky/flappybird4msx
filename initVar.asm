;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  inicializa as variáveis do programa
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
birdY:      equ ramArea
birdFrame:  equ ramArea+1
birdUp:     equ ramArea+2
birdDown:   equ ramArea+3
pipeFrame:  equ ramArea+4
pipeSize:   equ ramArea+5
pipeGap:    equ ramArea+6
ringRing:   equ ramArea+7
score:      equ ramArea+8               ; 16-bit
hiScore:    equ ramArea+10              ; 16-bit
vdpCycle1:  equ ramArea+12
vdpCycle5:  equ ramArea+13
rndSeed:    equ ramArea+14
birdBuffer: equ ramArea+15              ; coordenadas do pássaro
framebuff3: equ birdBuffer+32           ; o 3º framebuffer (64 bytes)
framebuff2: equ framebuff3+64           ; o 2º framebuffer (140 bytes)
framebuff1: equ framebuff2+140          ; o 1º framebuffer (640 bytes)
videoData:  equ framebuff3

initVar:
            proc

            local birdDraw

            xor a                       ; zero A

            ld (birdY),a                ; altura do pássaro
            ld (birdFrame),a                ; frame atual do pássaro
            ld (birdUp),a               ; decremento (a subida)
            ld (birdDown),a             ; incremento (a descida)

            ld (pipeFrame),a             ; frame atual dos canos
            ld (pipeSize),a             ; altura dos canos na tela
            ld (pipeGap),a              ; espaço entre os canos na tela

            ld (ringRing),a             ; flag do som de pontuação

            ld hl,0                     ; recorde do dia (sempre zero)
            ld (hiScore),hl

                                        ; temporização para NTSC e PAL-M
            ld a,NTSC
            ld (vdpCycle1),a            ; a princípio 6 -- 1/10s

            ld a,NTSC*10
            ld (vdpCycle5),a            ; a princípio 60 - 1s

            ld bc,32
            ld hl,birdDraw
            ld de,birdBuffer            ; copia as coordenadas do pás-
            ldir                        ; saro para a RAM

            ret                         ; sai da rotina

birdDraw:
            db 0,88,0,1                 ; contorno (em preto)
            db 0,88,0,8                 ; bico (em vermelho)
            db 0,88,0,10                ; corpo (em amarelo)
            db 0,88,0,15                ; olhos e asas (em branco)

            endp
