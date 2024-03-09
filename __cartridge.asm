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

romSize:    equ 8192
romArea:    equ $4000
ramArea:    equ $e000

            org romArea

            db "AB"                     ; cartridge header
            dw startCode                ; execution address
            db "CW"                     ; "Crunchworks"
            db "01"                     ; "Flappybird"
            db __VERSION+48             ; code version (1 byte)
            db __RELEASE+65             ; code release (1 byte)
            ds 6,0                      ; left blank, don't touch!
startCode:
            include "main.asm"

romPad:
            ds romSize-(romPad-romArea),0  ; pad to fit in ROM size

            end
