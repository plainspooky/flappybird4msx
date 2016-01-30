;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  rotaciona tela do primeiro framebuffer, completa com um trecho do segun-
;  *  do framebuffer
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
updateFramebuffer:
            proc
            local scrollBufferToLeft
            local copyPipePattern

            xor a                       ; número de linhas a rotacionar
            ld de,framebuff1            ; primeira posição do framebuffer
            ld hl,framebuff1+1          ; o sujeito ao lado

scrollBufferToLeft:
            ld bc,31                    ; tamanho de colunas da tela menos 1
            ldir                        ; copia o bloco de memória
            inc de                      ; avanço para o começo da próxima linha
            inc hl                      ; e também para o próximo vizinho
            inc a                       ; incremento o contador
            cp 20
            jr nz,scrollBufferToLeft    ; se A!=20, vá para scrollBufferToLeft

            ld hl,pipeFrame
            ld c,(hl)                   ; carrego o frame na primeira parte d BC
            ld b,0                      ; zero a segunda parte de BC

            ld hl,framebuff2            ; aponto para o framebuffer 2 (origem)
            add hl,bc                   ; acrescento o frame que preciso
            ex de,hl                    ; coloco a origem atualizada em DE

            ld hl,framebuff1+31         ; aponto HL para framebuffer 1 (destino)
            ld a,0

copyPipePattern:
            push af                     ; salvo A por enquanto

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
            jr nz,copyPipePattern       ; se A!=20, vá para copyPipePattern

            ret                         ; sai da rotina
            endp
