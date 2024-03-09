CAT=cat
ECHO=echo
EMULATOR=openmsx
OUTFILE=flapbird
PASMO=pasmo
RM=rm -f
MACHINE=-machine msx1

.PHONY: clean default rom superclean test

default:
	make rom

bin:
	${PASMO} -d -v -1 --err __binary.asm output/${OUTFILE}.bin |\
	tee ${OUTFILE}.log 2> ${OUTFILE}.err

rom:
	${PASMO} -d -v -1 --err __cartridge.asm output/${OUTFILE}.rom |\
	tee ${OUTFILE}.log 2> ${OUTFILE}.err

test: rom
	${EMULATOR} ${MACHINE} output/${OUTFILE}.rom

clean:
	${RM} -f output/${OUTFILE}.bin output/${OUTFILE}.rom 2>/dev/null

superclean:
	${RM} -f output/${OUTFILE}.bin output/${OUTFILE}.rom ${OUTFILE}.log ${OUTFILE}.err 2>/dev/null

