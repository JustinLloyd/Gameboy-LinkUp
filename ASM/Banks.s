					INCLUDE	"Banks.i"


;********************************************************************
; NAME:	Not Applicable												*
;																	*
; This brief and weird piece of code places a single byte that		*
; contains the current bank # at ROM address $7FFF in ever ROM bank	*
; above 0 (1 through to last bank). The value can then be read out	*
; and the current ROM bank # determined easily.						*
;																	*
; This code is redundant if the latest version of XLINK is used.	*
;																	*
;********************************************************************

;bankCount			SET		1
;					REPT	k_BK_LAST
;					SECTION "BankNum\@",DATA[$7FFF],BANK[bankCount]
;					DB		bankCount
;bankCount = bankCount + 1
;					ENDR
;					PURGE	bankCount
