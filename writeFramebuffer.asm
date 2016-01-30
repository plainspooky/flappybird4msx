;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  atualiza o framebuffer - rotina que penduro no hook HTIMI
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
writeFramebuffer:
            proc
            ld bc,640                   ; quantidade de bytes para copiar
            ld de,6144+64               ; endereço iniciual da VRAM
            ld hl,framebuff1            ; endereço do framebuffer
            call LDIRVM
            ld a,0xc9                   ; desabilito a atualização da tela por
            ld (HTIMI),a                ; interrupção com 'ret' no hook
            ret                         ; sai da rotina
            endp
