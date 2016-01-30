CAT=cat
ECHO=echo
EMULATOR=openmsx
INFILE=flappybird.asm
OUTFILE=flapbird
PASMO=pasmo
RM=rm -f
MACHINE=''

.PHONY: default clean superclean

default:
	${PASMO} -d \
             -v \
             -1 \
	         --err \
             ${INFILE} ${OUTFILE}.rom |\
        	 tee ${OUTFILE}.log 2> ${OUTFILE}.err

test:
	${EMULATOR} ${OUTFILE}.rom

clean:
	${RM} ${OUTFILE}.rom

superclean:
	${RM} -f ${OUTFILE}.rom ${OUTFILE}.log ${OUTPUT}.err
