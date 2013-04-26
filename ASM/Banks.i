					IF		!DEF(__BANKS_I__)
__BANKS_I__			SET		1
					INCLUDE	"Conditional.i"

k_BANK_NUMBER			EQU		$7FFF								; address where current bank # can be found

						RSSET	0
k_BANK_GAME				RB		1									; bank #0
k_BK_LAST				RB		0									; bank #1 -- last bank # used, must be at end of list


;********************************************************************
; NAME: FT_INTR (macro)												*
; AUTH:	JLloyd -- 99/04/01											*
;																	*
; This macro sets the section in the assembler to that used by		*
; interrupt routines.												*
;																	*
;********************************************************************

FT_INTR:			MACRO
					SECTION	"INTR\@",HOME
					ENDM


;********************************************************************
; NAME: FT_GAME (macro)												*
; AUTH:	JLloyd -- 99/04/01											*
;																	*
; This macro sets the section in the assembler to that used by		*
; utility routines.													*
;																	*
;********************************************************************

FT_GAME:			MACRO
					SECTION	"GAME\@",HOME
					ENDM

;********************************************************************
; NAME: DT_VARS (macro)												*
; AUTH:	JLloyd -- 99/04/01											*
;																	*
; This macro sets the section in the assembler to that used by		*
; global variables.													*
;																	*
;********************************************************************
DT_VARS:			MACRO
					SECTION	"VARS\@",BSS
					ENDM

;********************************************************************
; NAME: DT_DATA (macro)												*
; AUTH:	JLloyd -- 99/04/01											*
;																	*
; This macro sets the section in the assembler to that used by		*
; regular data.														*
;																	*
;********************************************************************
DT_DATA:			MACRO
					SECTION	"DATA\@",HOME
					ENDM

					ENDC
