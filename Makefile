CAT=cat
ECHO=echo
EMULATOR=openmsx
MAINFILE=main.asm
OUTFILE=flapbird
PASMO=pasmo
RM=rm -f
MACHINE=

.PHONY: bload clean default rom superclean test

default:
	make rom

rom:
	${PASMO} -d -v -1 --err \
			 --equ "TARGET=0" \
             ${MAINFILE} ${OUTFILE}.rom |\
        	 tee ${OUTFILE}.log 2> ${OUTFILE}.err

bload:
	${PASMO} -d -v -1 --err \
			 --equ "TARGET=1" \
		     ${MAINFILE} ${OUTFILE}.bin |\
			 tee ${OUTFILE}.log 2> ${OUTFILE}.err

test:
	${EMULATOR} ${MACHINE} ${OUTFILE}.rom

clean:
	${RM} -f ${OUTFILE}.bin ${OUTFILE}.rom 2>/dev/null

superclean:
	${RM} -f ${OUTFILE}.bin ${OUTFILE}.err ${OUTFILE}.log ${OUTFILE}.rom 2>/dev/null
