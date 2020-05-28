;
;  Flappy Bird for MSX -- version 1.G
;  The annoying and pathetic bird flapping on your MSX :)
;
;  (C) 2014-2020 Giovanni dos Reis Nunes <giovanni.nunes@gmail.com>
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
;  >>>  Flappy Bird is a original game released in 2013 by .GEARS  <<<
;
            include "library/msx1bios.asm"
            include "library/msx1variables.asm"
            include "library/msx1hooks.asm"

PAL:        equ  5                      ; 1/10s em 50Hz (PAL-B/G/N)
NTSC:       equ  6                      ; 1/10s em 60Hz (NTSC & PAL-M)
GAP:        equ  6                      ; espaço entre os canos
VOLUME      equ 11                      ; volume da campanhia dos pontos
MAXU:       equ 12                      ; incremento máximo para a subida
MAXD:       equ 12                      ; incremendo maximo para a descida

            call initVar                ; inicializa as variáveis
            call initEnv                ; inicializa o ambiente do jogo
            call ENASCR                 ; religa tela (desligada em "InitEnv")

            call cwLogo                 ; chama a animação da abertura
            call gplMensa               ; exibe o aviso da GNU/GPL

            call clearScore             ; zera a pontuação

gameLoop:
            call prepareScreen          ; preparo a tela
            call startScreen            ; menu principal
            
            call clearScore             ; zera a pontuação
            call printScore             ; e atualiza a pontuação na tela
            
            call game                   ; e que o jogo comece!
            jr gameLoop                 ; volta para o laço do jogo

            include "birdOff.asm"
            include "cwLogo.asm"
            include "drawBird.asm"
            include "drawPipe.asm"
            include "game.asm"
            include "gameOver.asm"
            include "gplMensa.asm"
            include "initEnv.asm"
            include "initVar.asm"
            include "playRing.asm"
            include "prepareScreen.asm"
            include "printScore.asm"
            include "random.asm"
            include "rotateDecoration.asm"
            include "rotatePipe.asm"
            include "soundBeep.asm"
            include "startScreen.asm"
            include "threeLdirvm.asm"
            include "turboMode.asm"
            include "updateFramebuffer.asm"
            include "waitASec.asm"
            include "writeFramebuffer.asm"
;
; MSX rulez a lot!
;
