
					IF		!DEF(__UTILITY_I__)
__UTILITY_I__		SET		1

					GLOBAL	SetBGP
					GLOBAL	SetSpriteData
					GLOBAL	LCD_Off
					GLOBAL	LCD_On
					GLOBAL	MemoryZeroSmall
					GLOBAL	MemoryZeroBig
					GLOBAL	WaitUntilVBLDone
					GLOBAL	LoadTileData
					GLOBAL	DoubleSpeed


k_TRUE				EQU		$01
k_FALSE				EQU		$00


;********************************************************************
; NAME:	WaitForVBLDone												*
;																	*
;																	*
;********************************************************************

WaitForVBLDone:		MACRO
					XOR		A										; clear vbl done flag
					LD		[g_vblDone],A							; store vbl done flag
.WaitForVBL\@:		HALT											; wait for an interrupt to occur
					NOP												; always nop after halt
					LD		A,[g_vblDone]							; pick up vbl done flag
																	; warning: we may lose a vbl intr if it occurs now
					OR		A										; is vbl done flag set?
					JR		Z,.WaitForVBL\@							; no, it wasn't a vbl intr, wait for next interrupt
					XOR		A										; clear vbl done flag
					LD		[g_vblDone],A							; store vbl done flag
					ENDM


;************************************************************************
;																		*
; NAME:	WaitForVRAM (MACRO)												*
; REGS:	A																*
;																		*
; This macro waits until VRAM is available.								*
;																		*
;************************************************************************

WaitForVRAM:		MACRO
.WaitLoop\@			LDH		A,[r_STAT]								; pick up current lcd status ($41)
					AND		2										; is vram available? (bit 1)
					JR		NZ,.WaitLoop\@							; no, loop until it is
					ENDM


;************************************************************************
;																		*
; NAME:	SHOW_BG (MACRO)													*
; REGS:	A																*
;																		*
; This macro turns on the background.									*
;																		*
;************************************************************************

SHOW_BG:			MACRO
					LDH		A,[r_LCDC]								; pick up current value of lcd controller ($40)
					OR		k_LCDCM_BG_ON							; turn on background (bit 0)
					LDH		[r_LCDC],A								; store modified lcd controller ($40)
					ENDM

;************************************************************************
;																		*
; NAME:	HIDE_BG (MACRO)													*
; REGS:	A																*
;																		*
; This macro turns off the background.									*
;																		*
;************************************************************************

HIDE_BG:			MACRO
					LDH		A,[r_LCDC]								; pick up current value of lcd controller ($40)
					AND		k_LCDCM_BG_OFF							; turn off background (bit 0)
					LDH		[r_LCDC],A								; store modified lcd controller ($40)
					ENDM

;************************************************************************
;																		*
; NAME:	VRAMBANK (MACRO)												*
; REGS:	AF																*
;																		*
; This macro sets the VRAM bank to the specified bank					*
;																		*
;************************************************************************

VRAMBANK:			MACRO
__bank				EQUS	STRTRIM(STRUPR("\1"))					; interpret macro parameter
					IF		(STRCMP("{__bank}","0")==0)				; is bank 0 specified?
						XOR		A									; set vram bank to 0
					ELSE
						IF		(STRCMP("{__bank}","1")==0)			; is bank 1 specified?
							LD		A,1								; set vram bank to 1
						ELSE
							FAIL "Parameter supplied must be 0 or 1 for the desired vram bank"
						ENDC
					ENDC

					LDH		[r_VRAM_BANK],A							; store vram bank # in vram bank register ($4F)
					PURGE	__bank									; forget temporary macro variable
					ENDM


;************************************************************************
;																		*
; NAME:	PUSHALL (MACRO)													*
;																		*
; This macro pushes all of the registers on to the stack.				*
;																		*
;************************************************************************

PUSHALL:			MACRO
					PUSH	AF										; save register
					PUSH	BC										; save register
					PUSH	DE										; save register
					PUSH	HL										; save register (HL must always be last register to be pushed on stack)
					ENDM

;************************************************************************
;																		*
; NAME:	POPALL (MACRO)													*
;																		*
; This macro pops all of the registers from the the stack.				*
;																		*
;************************************************************************

POPALL:				MACRO
					POP		HL										; restore register
					POP		DE										; restore register
					POP		BC										; restore register
					POP		AF										; restore register
					ENDM


BREAK:				MACRO
					IF		k_BLDOPT_DEBUG==1
					LD		B,B
					ENDC
					ENDM


					ENDC											; UTILITY_INC
