					INCLUDE	"Standard.i"
					INCLUDE "Shift.i"
					INCLUDE	"GlobalData.i"
					INCLUDE	"Font.i"


;********************************************************************
;																	*
; NAME:	LCD_Off														*
; REGS:	A															*
;																	*
; This function switches off the LCD. It takes no parameters and	*
; returns nothing. It waits until the VBL period before switching	*
; the LCD off, as per GB specs.										*
;																	*
;********************************************************************
					FT_GAME
LCD_Off:			LDH		A,[r_LCDC]								; read current value of LCD control register ($FF40)
					ADD		A										; test lcd off flag (msb), is LCD already off?
					RET		NC										; carry is not set, so lcd is off, just exit
.InsideVBL:			LDH		A,[r_LY]								; pick up current scan line # ($FF44)
					CP		$92										; inside vbl region?
					JR		NC,.InsideVBL							; yes, wait until vbl region is left
.OutsideVBL:		LDH		A,[r_LY]								; pick up current scan line # ($FF44)
					CP		$91										; inside vbl region?
					JR		C,.OutsideVBL							; no, loop until vbl region is entered
					LDH		A,[r_LCDC]								; pick up current LCD control register ($FF40)
					AND		k_LCDCM_LCD_OFF							; mask off "lcd on/off" (bit 7) control bit
					LDH		[r_LCDC],A								; switch off LCD ($FF40)
					RET												; exit function


;********************************************************************
;																	*
; NAME:	LCD_On														*
; REGS:	A															*
;																	*
; This function switches on the LCD. It takes no parameters and		*
; returns nothing.													*
;																	*
;********************************************************************
					FT_GAME
LCD_On:				LDH		A,[r_LCDC]								; read current value of LCD control register ($FF40)
					OR		k_LCDCM_LCD_ON							; mask in LCD ON control bit
					LDH		[r_LCDC],A								; switch on LCD
					RET												; exit function


;********************************************************************
;																	*
; NAME:	MemoryZeroBig												*
; I/P:		HL	-- start address to clear							*
;			BC	-- # bytes to clear									*
; REGS:	A,HL,BC														*
;																	*
;********************************************************************
					FT_GAME
MemoryZeroBig:		XOR		A										; set value to write to memory		
.ClearMemory\@:		LD		[HL+],A									; write value to memory and increment memory pointer
					DEC		C										; decrement # bytes to write
					JR		NZ,.ClearMemory
					DEC		B
					JR		NZ,.ClearMemory							; all bytes written? no, so write another byte
					RET												; exit function


;********************************************************************
;																	*
; NAME:	MemoryZeroSmall												*
; I/P:		HL	-- start address to clear							*
;			BC	-- # bytes to clear									*
; REGS:	A,HL,BC														*
;																	*
;********************************************************************
					FT_GAME
MemoryZeroSmall:	XOR		A
.ClearMemory:		LD		[HL+],A
					DEC		B
					JR		NZ,.ClearMemory
					RET


;********************************************************************
;																	*
; NAME:	SetBGP														*
; I/P:		HL	-- -> palette to set								*
;			B	-- first palette to set								*
;			C	-- # palettes to set								*
; DESTROY:	A,BC,HL,DE												*
;																	*
;********************************************************************
					FT_GAME
SetBGP:				LD      A,B										; copy start palette index											(4T)
					ADD		A										; calculate start # for current colour index (* 8)					(4T)
					ADD		A										;																	(4T)
					ADD		A										;																	(4T)
					OR		$80										; enable BCPS auto-increment bit (bit 7)							(8T)
					LD		B,A										; set start colour index											(4T)
					LD		A,C										; copy # palettes to set
					ADD		A										; * 2
					ADD		A										; * 4
					ADD		A										; * 8
					LD		C,A										; copy # palettes to set
.IndexWait:			LDH		A,[r_STAT]								; pick up lcd status register ($41)									(12T)
					AND		k_STATM_OAM								; mask "oam used by cpu" bit (bit 2)								(8T)
					JR		NZ,.IndexWait							; oam ram is available? no, loop until it is						(12/8T)
					LD		A,B										; copy first colour index											(4T)
					LDH		[r_BCPS],A								; set gb colour register to first colour index ($68)				(12T)
					LD		DE,r_BCPD								; -> gb colour register												(12T)
.PaletteLoop:		WaitForVRAM
					LD		A,[HL+]									; pick up colour data and increment pointer							(8T)
					LD		[DE],A									; store colour data in gameboy colour register ($69)				(8T)
					DEC		C										; decrement # palettes to write										(4T)
					JR		NZ,.PaletteLoop							; no, process next colour											(12T/8T)
					RET												; exit function														(16T)


;********************************************************************
;																	*
; NAME:	LoadTileData												*
; I/P:		A	-- tile data vram region to write to ($80/$88/$90)	*
;			BC	-- -> tile source data								*
;			D	-- # of tiles to load								*
;			E	-- # first tile to load								*
;																	*
; This function is for general purpose tile loading in non-speed	*
; critical functions.												*
;																	*
;********************************************************************
					FT_GAME
LoadTileData:		PUSHALL
					LD		H,0
					LD		L,E
					SLA16	HL,4
					ADD		H
					LD		H,A										; set hi-byte of tile bank address
.tileCopy:			LD		E,16									; loop counter for moving 16 bytes per tile
.rowCopy:			WaitForVRAM										; wait until vram is available
					LD		A,[BC]									; pick up tile byte to copy
					LD		[HL+], A								; store tile data in vram
					INC		BC										; increment pointer to source tile data
					DEC		E										; decrement number of rows to copy
					JR		NZ, .rowCopy							; more tile rows to copy? yes, so copy next row
					DEC		D										; decrement number of tiles to copy
					JR		NZ, .tileCopy							; more tiles to copy? yes, so copy next tile
					POPALL
					RET												; exit function


;********************************************************************
;																	*
; NAME:	DoubleSpeed													*
; REGS:	A,HL														*
;																	*
; This function switches the Colour Gameboy to double-speed mode.	*
;																	*
;********************************************************************
					FT_GAME
DoubleSpeed:		PUSH	HL
					DI
					LD		HL,r_IE
					LD		A,[HL]
					PUSH	AF 
					XOR		A
					LD		[HL],A
					LD		[r_IF],A
					LD		A,$30
					LD		[r_P1],A
					LD		A,1
					LD		[r_KEY1],A
					STOP
					POP		AF
					LD		[HL],A
					EI
					POP		HL
					RET 

