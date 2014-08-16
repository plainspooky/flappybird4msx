CAT=cat
ECHO=echo
OUTFILE=flapbird
PASMO=pasmo
RM=rm -f

.PHONY: default bin rom clean superclean

default:
	${ECHO} "Try bin or rom to build."

bin:
	${ECHO} "TARGET: equ 1" > ./output/t_${OUTFILE}.asm

	${CAT} ./source/flapbird.asm >> output/t_${OUTFILE}.asm

	${PASMO} -d -v ./output/t_${OUTFILE}.asm ${OUTFILE}.bin >./output/b_${OUTFILE}.txt 2>./output/b_${OUTFILE}.err

rom:
	${ECHO} "TARGET: equ 0" > ./output/t_${OUTFILE}.asm

	${CAT} ./source/flapbird.asm >> output/t_${OUTFILE}.asm

	${PASMO} -d -v ./output/t_${OUTFILE}.asm ${OUTFILE}.rom >./output/r_${OUTFILE}.txt 2>./output/r_${OUTFILE}.err

clean:
	${RM} ./output/*

superclean:
	${RM} ./output/*
	${RM} flapbird.rom flapbird.bin
