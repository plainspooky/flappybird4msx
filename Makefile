CAT=cat
ECHO=echo
EMULATOR=openmsx
OUTFILE=flapbird
PASMO=pasmo
RM=rm -f
MACHINE=-machine msx1

.PHONY: bload clean default rom superclean test

default:
	make rom

bin:
	${PASMO} -d -v -1 --err __binary.asm ${OUTFILE}.bin |\
	tee ${OUTFILE}.log 2> ${OUTFILE}.err

rom:
	${PASMO} -d -v -1 --err __cartridge.asm ${OUTFILE}.rom |\
	tee ${OUTFILE}.log 2> ${OUTFILE}.err

test:
	${EMULATOR} ${MACHINE} ${OUTFILE}.rom

clean:
	${RM} -f ${OUTFILE}.bin ${OUTFILE}.rom 2>/dev/null

superclean:
	${RM} -f ${OUTFILE}.bin ${OUTFILE}.err ${OUTFILE}.log ${OUTFILE}.rom 2>/dev/null

