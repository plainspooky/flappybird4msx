;
;   Flappy Bird for MSX
;   The annoying and pathetic bird flapping on your MSX :)
;   Copyright (C) 2014-2024 Giovanni Nunes <giovanni.nunes@gmail.com>
;
;   This program is free software: you can redistribute it and/or modify
;   it under the terms of the GNU General Public License as published by
;   the Free Software Foundation, either version 3 of the License, or
;   (at your option) any later version.
;
;   This program is distributed in the hope that it will be useful,
;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;   GNU General Public License for more details.
;
;   You should have received a copy of the GNU General Public License
;   along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
;   >>>  Flappy Bird is a original game released in 2013 by .GEARS  <<<
;

            include "config.asm"

gameArea:   equ $8000
ramArea:    equ $e000

            org gameArea-7

            db $fe                      ; MSX-BASIC binary header
            dw startCode                ; start address
            dw endCode                  ; end address
            dw execCode                 ; execution address
startCode:
            db "CW"                     ; "Crunchworks"
            db "01"                     ; "Flappybird"
            db __VERSION+48             ; code version (1 byte)
            db __RELEASE+65             ; code release (1 byte)

execCode:
            include "main.asm"

endCode:
            end
