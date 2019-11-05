;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  Copia os dados da RAM para os três terços da VRAM
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
threeLdirvm:
            proc
            local execLdirvm

            call execLdirvm

            ld a,0x08
            add a,d                     ; o mesmo que DE=DE+0x0800
            ld d,a
            call execLdirvm

            ld a,0x08
            add a,d                     ; faço outro DE=DE+0x0800
            ld d,a
execLdirvm:
            push bc
            push de
            push hl
            call LDIRVM
            pop hl
            pop de
            pop bc

            ret                         ; sai da rotina
            endp
