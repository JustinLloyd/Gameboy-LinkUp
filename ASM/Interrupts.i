					IF		!DEF(__INTERRUPTS_I__)
__INTERRUPTS_I__	SET		1

					GLOBAL	g_lcdIntrCode
					GLOBAL	g_vblIntrCode
					GLOBAL	InitInterrupts
					GLOBAL	InitGameInter
					GLOBAL	InitMenuInter

k_MAX_INTR_SIZE		EQU		128

COPY_INTR:			MACRO
					IF \2>k_MAX_INTR_SIZE
						FAIL	"Interrupt function is too large"
					ENDC
					LD		HL,\1
					LD		DE,\2
					LD		BC,\3
					CALL	MemCopyBig
					ENDM

					ENDC