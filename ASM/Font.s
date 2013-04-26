					INCLUDE	"Banks.i"
					INCLUDE	"Font.i"
					INCLUDE	"FontData.i"
					INCLUDE "Hardware.i"
					INCLUDE "Utility.i"
					INCLUDE "Shift.i"

k_NEWLINE			EQU		$0D										; ASCII code to output a new line
k_CURSOR_HOME		EQU		$0C										; ASCII code to move cursor to top-left of screen
k_CURSOR_RIGHT		EQU		$01										; non-ASCII code to move cursor right one column

k_FONT_ATTRIB		EQU		$00										; attribute to use when printing
k_FONT_BASE			EQU		$00										; base tile # to add to character #
k_FONT_VRAM			EQU		$80										; vram address to place font data at
k_FONT_BANK			EQU		0										; vram bank # to place font data at

;********************************************************************
;																	*
; Local Module Variables											*
;																	*
;********************************************************************
					DT_VARS
PrintCol:			DS	1											; current column to print at
PrintRow:			DS	1											; current row to print at


;********************************************************************
; NAME:	InitFont													*
;																	*
; This function initialises the font system. It loads the font tile	*
; set to the VRAM, and places the cursor at the top-left corner of	*
; the screen.														*
;																	*
;********************************************************************
					FT_GAME
InitFont:			IF k_FONT_BANK==0
					VRAMBANK	0									; select vram bank #0
					ELSE
					VRAMBANK	1									; select vram bank #1
					ENDC
					LD		E,k_FONT_BASE							; tile # to place font data at
					LD		D,37									; # tiles to load
					LD		A,k_FONT_VRAM							; -> vram address to load font data to
					LD		BC,FontData								; -> font data
					CALL	LoadTileData							; load font tiles to vram
					CALL	CursorHome								; place cursor at top-left of screen
					RET												; exit function


;********************************************************************
; NAME:	CursorHome													*
;																	*
; This function moves the cursor to the top-left corner of the		*
; screen.															*
;																	*
;********************************************************************
					FT_GAME
CursorHome:			PUSH	AF										; preserve register
					XOR		A										; clear column & row
					LD		[PrintCol],A							; set column to zero
					LD		[PrintRow],A							; set row to zero
					POP		AF										; restore register
					RET												; exit function


;********************************************************************
; NAME:	CursorRight													*
;																	*
; This function moves the cursor right by one character. It wraps	*
; the column around the screen if it reaches the right-hand edge.	*
;																	*
;********************************************************************
					FT_GAME
CursorRight:		PUSH	AF										; preserve register
					LD		A,[PrintCol]							; pick up current column #
					INC		A										; increment column #
					AND		$1F										; ensure that column # stays on screen
					LD		[PrintCol],A							; store new value of column #
					POP		AF										; restore register
					RET												; exit function


;********************************************************************
; NAME:	PrintString													*
; I/P:	HL	--	-> null-terminated string							*
;																	*
; This function prints a string to the screen at the current cursor	*
; position. It does not handle screen wrap. It interprets new line	*
; and cursor movement if it is in the string.						*
;																	*
;********************************************************************
					FT_GAME
PrintString:		PUSH	HL										; preserve register
					PUSH	AF										; preserve register
.Print:				LD		A,[HL+]									; pick up next character to print
				; null terminator?
					OR		A										; test character code
					JR		Z,.Exit									; is current character == NULL? yes, so end of string, exit function
				; new line command?
					CP		k_NEWLINE								; is current character == CR?
					JR		NE,.NotNewline							; no, so try a different character
					CALL	NewLine									; move cursor to new line
					JR		.Print									; print next character
				; cursor home command?
.NotNewline:		CP		k_CURSOR_HOME							; is current character == CLS?
					JR		NE,.NotHome								; no, so try a different character
					CALL	CursorHome								; move cursor to home position
					JR		.Print									; print next character
				; cursor right command?
.NotHome:			CP		k_CURSOR_RIGHT							; is current character == CURSOR RIGHT?
					JR		NE,.NotCursorRight						; no, so try a different character
					CALL	CursorRight								; move cursor one character space right
					JR		.Print									; print next character
				; output characters
.NotCursorRight:	CALL	PrintChar								; display current character
					JR		.Print									; print next character
.Exit:				POP		AF										; restore register
					POP		HL										; restore register
					RET												; exit function


;********************************************************************
; NAME:	PrintChar													*
; I/P:	A	-- ASCII code of character to display					*
;																	*
; This function prints a character on the screen. It takes a single	*
; parameter that is the character to be printed. The character must	*
; be one of the printable characters between ASCII code 32 and 126.	*
; The correct VRAM address is calculated from the cursor column &	*
; row.																*
;																	*
;********************************************************************
					FT_GAME
PrintChar:			PUSHALL											; preserve registers
				; translate ASCII char to local font
					LD		C,A										; get character to display
					LD		B,0										; set msb of character offset
					LD		HL,CharLookup							; -> character translation table
					ADD		HL,BC									; add character to display
					LD		C,[HL]									; pick up character tile #
				; calculate VRAM address
					LD		A,[PrintRow]							; pick up current row # of cursor
					LD		E,A										; set lsb of vram address
					LD		D,0										; set msb of vram address
					SLA16	DE,5									; * 32 to get vram row
					LD		A,[PrintCol]							; pick up current col # of cursor
					ADD		E										; add lsb of vram row
					LD		E,A										; set new lsb of vram address
					LD		A,0										; set msb of current col #
					ADC		D										; add msb of vram row
					LD		D,A										; set new msb of vram address
					LD		HL,k_VRAM_BG_LOW						; -> vram background
					ADD		HL,DE									; add calculated vram offset
				; set tile attribute
					VRAMBANK	1									; switch to vram bank #1
.SetPalette1:		WaitForVRAM										; wait for vram access
					LD		[HL],k_FONT_ATTRIB						; set vram tile attribute
				; set tile index
					VRAMBANK	0									; switch to vram bank #0
.SetPalette2:		WaitForVRAM										; wait for vram access
					LD		A,C										; get character code
					ADD		k_FONT_BASE								; add base tile # of font data
					LD		[HL],A									; place tile # into vram
					CALL	CursorRight								; move cursor right one character place
					POPALL											; restore registers
					RET												; exit function


;********************************************************************
; NAME:	GotoXY														*
; I/P:	B	-- column number to move cursor to						*
;		C	-- row number to move cursor to							*
;																	*
; This function moves the cursor the specified column & row number.	*
; It takes two parameters, the column number and row number of the	*
; new cursor position. Range checking is performed to ensure that	*
; the values remain in the VRAM region.								*
;																	*
;********************************************************************
					FT_GAME
GotoXY:				PUSH	AF										; preserve register
					LD		A,B										; get specified column #
					AND		$1F										; make sure it stays in range
					LD		[PrintCol],A							; store new column #
					LD		A,C										; get row #
					AND		$1F										; make sure it stays in range
					LD		[PrintRow],A							; store new row #
					POP		AF										; restore register
					RET												; exit function


;********************************************************************
; NAME:	NewLine														*
;																	*
; This function moves the cursor to the beginning of the next row.	*
; It ensures that the row wraps around correctly on the screen.		*
;																	*
;********************************************************************
					FT_GAME
NewLine:			PUSH	AF										; preserve register
					XOR		A										; set zero value for col #
					LD		[PrintCol],A							; store new col #
					LD		A,[PrintRow]							; pick up row #
					INC		A										; increment row #
					AND		$1F										; make sure row # wraps around on vram
					LD		[PrintRow],A							; store new row #
					POP		AF										; restore register
					RET												; exit function


;********************************************************************
; NAME:	LineFeed													*
;																	*
; This function outputs a line feed. It moves the row that the next	*
; character will be displayed at down, one screen row. If the edge	*
; of the screen is reached, it will wrap around to the top of the	*
; screen.															*
;																	*
;********************************************************************
					FT_GAME
LineFeed:			PUSH	AF										; preserve register
					LD		A,[PrintRow]							; pick up current row #
					INC		A										; move down one row
					AND		$1F										; make sure row # wraps around on vram
					LD		[PrintRow],A							; store new row #
					POP		AF										; restore register
					RET												; exit function


;********************************************************************
; NAME:	CarriageReturn												*
;																	*
; This function outputs a carriage return. It moves the column that	*
; the next character will be displayed at, to the far left-hand		*
; side of the screen.												*
;																	*
;********************************************************************
					FT_GAME
CarriageReturn:		PUSH	AF										; preserve register
					XOR		A										; set zero value for col #
					LD		[PrintCol],A							; store new column #
					POP		AF										; restore register
					RET												; exit function
