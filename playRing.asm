;
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;  *
;  *  rotina que cuida do som da pontuação
;  *
;  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
playRing:
            proc
            cp VOLUME                   ; se não estou em VOLUME
            jr nz,reduceVolume          ; vou para a segunda parte

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
            ld (ringRing),a             ; atualiza para a 2ª parte

            ret                         ; sai da rotina

reduceVolume:
            ld b,a                      ; salva o volume

            ld a,8
            ld e,b
            call WRTPSG                 ; sound 8,B

            ld a,0
            ld e,75
            call WRTPSG                 ; sound 0,75

            ld a,b                      ; pego o volume salvo

            dec a                       ; diminuo em um

            ld (ringRing),a             ; guardo o novo estado

            cp 0                        ; cheguei em 0?
            ret nz                      ; voltarei aqui no próximo laço

            ld a,8
            ld e,0
            call WRTPSG                 ; sound 8,0 (desligo o som)

            ld a,0
            ld (ringRing),a             ; desliga o toque de campainha

            ret                         ; sai da rotina
            endp
