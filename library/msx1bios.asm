;
; MSX1-BIOS ROUTINES
; Version 0.1
;
CHKRAM:		equ 0x0000			; Partida (boot) 
RDSLT:		equ 0x000C			; Lê dado de qualquer slot
WRSLT:		equ 0x0014			; Escreve dado em qualquer slot
CALSLT:		equ 0x001C			; Chama rotina em qualquer slot
DCOMPR:		equ 0x0020			; Compara DE e HL
ENASLT:		equ 0x0024			; Mapeia slot
CALLF:		equ 0x0030			; Chama rotina em qualquer slot (inline)
KEYINT:		equ 0x0038			; Manipulador de interrupção padrão
INITIO:		equ 0x003B			; Inicializa PSG e porta de impressora
INIFNK:		equ 0x003E			; Inicializa strings das teclas de função
DISSCR:		equ 0x0041			; Desativa tela
ENASCR:		equ 0x0044			; Ativa tela
WRTVDP:		equ 0x0047			; Escreve em registrador do VDP
RDVRM:		equ 0x004A			; Lê byte da VRAM
WRTVRM:		equ 0x004D			; Escreve byte na VRAM
SETRD:		equ 0x0050			; Prepara VDP para leitura
SETWRT:		equ 0x0053			; Prepara VDP para escrita
FILVRM:		equ 0x0056			; Preenche bloco da VRAM
LDIRMV:		equ 0x0059			; Copia bloco da VRAM para a RAM
LDIRVM:		equ 0x005C			; Copia bloco da RAM para a VRAM
CHGMOD:		equ 0x005F			; Altera modo do VDP
CHGCLR:		equ 0x0062			; Altera cores do VDP
NMI:		equ 0x0066			; Manipulador da NMI
CLRSPR:		equ 0x0069			; Limpa todos os sprites
INITXT:		equ 0x006C			; Inicializa VDP em modo texto 40x24
INIT32:		equ 0x006F			; Inicializa VDP em modo texto 32x24
INIGRP:		equ 0x0072			; Inicializa VDP em modo gráfico 256x192
INIMLT:		equ 0x0075			; Inicializa VDP em modo multicolorido 64x48
CALPAT:		equ 0x0084			; Calcula endereço da imagem do sprite
CALATR:		equ 0x0087			; Calcula endereço do atributo do sprite
GSPSIZ:		equ 0x008A			; Obtém tamanho do sprite
GRPPRT:		equ 0x008D			; Escreve caractere na tela gráfica
GICINI:		equ 0x0090			; Inicializa PSG
WRTPSG:		equ 0x0093			; Escreve em registrador do PSG
RDPSG:		equ 0x0096			; Lê registrador do PSG
STRTMS:		equ 0x0099			; Desempilha fila musical
CHSNS:		equ 0x009C			; Verifica buffer do teclado
CHGET:		equ 0x009F			; Obtém caractere do buffer do teclado
CHPUT:		equ 0x00A2			; Escreve caractere na tela
LPTOUT:		equ 0x00A5			; Imprime caractere na porta de impressora
LPTSTT:		equ 0x00A8			; Teste de status da impressora
PINLIN:		equ 0x00AE			; Lê uma linha do console
INLIN:		equ 0x00B1			; Lê uma linha do console
QINLIN:		equ 0x00B4			; Lê uma linha do console
BREAKX:		equ 0x00B7			; Verifica Ctrl+Stop
BEEP:		equ 0x00C0			; Emite beep
CLS:		equ 0x00C3			; Limpa tela
POSIT:		equ 0x00C6			; Posiciona cursor
ERAFNK:		equ 0x00CC			; Apaga a linha das teclas de função
DSPFNK:		equ 0x00CF			; Mostra a linha das teclas de função
TOTEXT:		equ 0x00D2			; Retorna VDP ao modo texto
GTSTCK:		equ 0x00D5			; Lê status do joystick
GTTRIG:		equ 0x00D8			; Lê status do botão do joystick
GTPAD:		equ 0x00DB			; Lê status do tablet
GTPDL:		equ 0x00DE			; Lê status do paddle
TAPION:		equ 0x00E1			; Aciona entrada de fita
TAPIN:		equ 0x00E4			; Lê entrada de fita
TAPIOF:		equ 0x00E7			; Desliga entrada de fita
TAPOON:		equ 0x00EA			; Aciona saída de fita
TAPOUT:		equ 0x00ED			; Escreve na saída de fita
TAPOOF:		equ 0x00F0			; Desliga saída de fita
STMOTR:		equ 0x00F3			; Controla motor da unidade de fita
LFTQ:		equ 0x00F6			; Verifica espaço em fila musical
PUTQ:		equ 0x00F9			; Coloca byte em fila musical
RIGHTC:		equ 0x00FC			; Move endereço de pixel à direita
LEFTC:		equ 0x00FF			; Move endereço de pixel à esquerda
UPC:		equ 0x0102			; Move endereço de pixel acima
TUPC:		equ 0x0105			; Testa e move endereço de pixel acima
DOWNC:		equ 0x0108			; Move endereço de pixel abaixo
TDOWNC:		equ 0x010B			; Testa e Move endereço de pixel abaixo
SCALXY:		equ 0x010E			; "Clipa" coordenadas gráficas
MAPXYC:		equ 0x0111			; Converte coordenadas do modo gráfico
FETCHC:		equ 0x0114			; Obtém endereço físico do pixel atual
STOREC:		equ 0x0117			; Armazena endereço físico do pixel atual
SETATR:		equ 0x011A			; Muda cor de desenho
READC:		equ 0x011D			; Lê atributo do pixel atual
SETC:		equ 0x0120			; Muda atributo do pixel atual
NSETCX:		equ 0x0123			; Muda atributo de uma sequência de pixels
CHGCAP:		equ 0x0132			; Altera LED do CAPS LOCK
CHGSND:		equ 0x0135			; Altera o estado do click do teclado
RSLREG:		equ 0x0138			; Lê registrador do slot primário
WSLREG:		equ 0x013B			; Escreve registrador do slot primário
RDVDP:		equ 0x013E			; Lê registrador de status do VDP
SNSMAT:		equ 0x0141			; Lê linha da matriz de teclado
KILBUF:		equ 0x0156			; Limpa buffer do teclado
CALBAS:		equ 0x0159			; Chama rotina BASIC a partir de qualquer slot
