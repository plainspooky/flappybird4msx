;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  habilita o modo R800 ROM caso esteja rodando em um turbo R, rotina de
;  *  Timo Nyyrikki -- http://www.msx.org/wiki/R800_Programming#BIOS_routines
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
turboMode:
            proc
            local CHGCPU

CHGCPU:     equ 0x0180

            ld a,(0x002d)               ; byte de ID do MSX
            cp 3                        ; é turbo R?
            ret nz                      ; não é um turbo R, vá embora
            ld a,(CHGCPU)               ; rotina CHGCPU (BIOS do turbo R)
            cp 0xc3
            ld a,0x81                   ; modo R800 ROM
            call z,CHGCPU
            ret                         ; sai da rotina

            endp
