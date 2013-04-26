					INCLUDE	"standard.i"

	
;********************************************************************
;																	*
; NAME:	MemCopyBig													*
; I/P:		HL	-- -> source addr									*
;			BC	-- -> destination addr								*
;			DE	-- length of data to copy							*
;																	*
; This function copies a block of memory from the specified source	*
; to the specified destination address. It takes three parameters,	*
; a data source address, a data destination address, and the length *
; of the data block to copy. It does not check for overlapping		*
; regions of memory.												*
;																	*
;********************************************************************
					FT_GAME
MemCopyBig:			PUSHALL											; preserve registers
.CopyData:			LD		A,[HL+]									; pick up next source byte
					LD		[BC],A									; store at next destination location
					INC		BC										; increment destination pointer
					DEC		DE										; decrement length counter
					LD		A,E										; get lsb of length remaining
					OR		D										; combine with msb of length remaining
					JR		NZ,.CopyData							; zero length? no, so copy another byte
					POPALL											; restore registers
					RET												; exit function
