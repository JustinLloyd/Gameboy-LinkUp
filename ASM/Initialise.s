					INCLUDE "Standard.i"
					INCLUDE	"GlobalData.i"
					INCLUDE "Utility.i"
					INCLUDE "Initialise.i"
					INCLUDE "Font.i"
					INCLUDE "Interrupts.i"


;************************************************************************
;																		*
; NAME:	InitMemory														*
;																		*
;************************************************************************
					FT_GAME
InitMemory:			
					PUSHALL											; save registers
				; clear bank 0 of wram from stack top to end of ram bank
					LD		HL,g_stackTop							; -> start of work ram
					LD		BC,k_RAM_BANK_LENGTH-(g_stackTop-k_RAM)	; clear 4kb of ram
					CALL	MemoryZeroBig							; clear work ram
				; clear oam ram
					LD		HL,k_OAMRAM								; -> oam ram
					LD		B,$A0									; clear 160 bytes of oam ram
					CALL	MemoryZeroSmall							; clear oam ram
				; clear hi ram
					LD		HL,k_HIRAM								; -> hi-ram
					LD		B,k_HIRAM_LENGTH						; clear 70 bytes of hi-ram (but not the stack area)
					CALL	MemoryZeroSmall							; clear hi-ram
				; clear all wram that can be bank switched
					LD		A,7										; set ram bank counter to last available ram bank
.ClearWorkRAM:		LDH		[r_SVBK],A								; switch ram bank
					LD		HL,k_RAM_BANK_UPR						; -> start of upper ram bank
					LD		BC,k_RAM_BANK_LENGTH					; set length of memory to length of one ram bank
					PUSH	AF										; save register
					CALL	MemoryZeroBig							; clear 4KB of ram
					POP		AF										; restore register
					DEC		A										; decrement ram bank counter
					JR		NZ,.ClearWorkRAM						; no, another ram bank
					LD		A,1										; 
					LDH		[r_SVBK],A								; restore ram bank that was here before entering function
					POPALL											; restore registers
					RET												; exit function


;************************************************************************
;																		*
; NAME:	InitDisplay														*
;																		*
;************************************************************************
					FT_GAME
InitDisplay:		CALL	LCD_Off									; turn display off
					XOR		A										; load #0
					LDH		[r_SCX],A								; clear background scroll X register
					LDH		[r_SCY],A								; clear background scroll Y register
					LDH		[r_STAT],A								; clear lcd status register
					LDH		[r_WY],A								; clear window y position
					LDH		[r_WX],A								; set window x position
					LDH		A,[r_LCDC]								; pick up current lcd configuration
					AND		A,k_LCDCM_BG8000						; set base tile set to use
					LDH		[r_LCDC],A								; store new lcd configuration
				; initialise a palette
					LD		HL,LinkPalette							; -> link up palette data
					LD		B,0										; load palette #0
					LD		C,1										; load 1 palette
					CALL	SetBGP									; set background palette
					RET												; exit function


;************************************************************************
;																		*
; NAME:	InitBackground													*
;																		*
;************************************************************************
					FT_GAME
InitBackground:
					SHOW_BG											; turn on background
					RET												; exit function


;************************************************************************
;																		*
; NAME:	Initialise														*
;																		*
; This is the general purpose initialisation function that is called	*
; when the Gameboy is first switched on.								*
;																		*
;************************************************************************
					FT_GAME
Initialise:			DI												; disable interrupts
					LD		D,A										; copy gameboy type
					XOR		A										; set interrupt flag to no interrupts
					LDH		[r_IE],A								; clear all interrupts
					LD		[r_IF],A								; clear all pending interrupts flags
					CALL	LCD_Off									; turn off the lcd
					CALL	InitMemory								; initialise memory
					LD		A,D										; retrieve gameboy type
					LD		[g_cpuType],A							; store gameboy type
					CALL	InitFont								; initialise font
					CALL	InitDisplay								; initialise display
					CALL	InitInterrupts							; initialise game interrupt routines
					CALL	LCD_On									; turn on lcd display
					XOR		A										; clear interrupt flag
					LD		[r_IF],A								; clear all pending interrupts flags
					EI												; enable interrupts
					NOP												; safety nop after an EI
					RET												; exit function

