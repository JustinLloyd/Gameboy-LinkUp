;********************************************************************
;																	*
; NAME:	HARDWARE.I													*
; AUTH: JLloyd -- 99/04/12											*
; NOTES: Based on JeffF's hardware defines.							*
;																	*
;																	*
;********************************************************************


; add these registers when you have time
;TIMA_REG	(*(UBYTE *)0xFF05)	/* Timer counter */
;TMA_REG		(*(UBYTE *)0xFF06)	/* Timer modulo */
;TAC_REG		(*(UBYTE *)0xFF07)	/* Timer control */
;RP_REG		(*(UBYTE *)0xFF56)	/* IR port */


r_MBC5_ROM_SEL		EQU		$2000									; rom bank select (write here with bank # (0-63 on GBC with 8Mbit cart))
r_MBC5_ROM_SEL_MSB	EQU		$3000

r_MBC5_WRAM_SEL		EQU		$4000									; ram bank select (write here with bank # (0-7 on GBC))

k_GB_REGS			EQU		$FF00

; VRAM
; GameBoy Video RAM extends from $8000 to $A000, a total of 8KB
k_VRAM				EQU		$8000
k_VRAM_LENGTH		EQU		$2000
k_VRAM_START		EQU		k_VRAM
k_VRAM_END			EQU		((k_VRAM+k_VRAM_LENGTH)-1)

k_VRAM_BG_LOW		EQU		$9800
k_VRAM_BG_HIGH		EQU		$9C00
k_VRAM_TILE_BANK_0	EQU		$8000
k_VRAM_TILE_BANK_1	EQU		$8800
k_VRAM_TILE_BANK_2	EQU		$9000

; HIRAM
; Gameboy HIRAM extends from $FF80 to $FFFF, a total of 128 bytes
k_HIRAM				EQU		$FF80
k_HIRAM_LENGTH		EQU		$7F
k_HIRAM_START		EQU		k_HIRAM
k_HIRAM_END			EQU		((k_HIRAM+k_HIRAM_LENGTH)-1)

; WRAM
; GameBoy Work RAM extends from $C000 to $E000, a total of 8KB on
; GB and 32KB bank-switched on GBC with 8KB visible at any one time.
k_RAM				EQU		$C000									; $C000->$E000
k_RAM_LENGTH		EQU		$2000
k_RAM_START			EQU		k_RAM
k_RAM_END			EQU		((k_RAM+k_RAM_LENGTH)-1)

k_RAM_BANK_UPR		EQU		$D000
k_RAM_BANK_LENGTH	EQU		$1000
k_RAM_BANK_UPR_START	EQU	k_RAM_BANK_UPR
k_RAM_BANK_UPR_END	EQU		((k_RAM_BANK_UPR+k_RAM_BANK_LENGTH)-1)


; OAM
; GameBoy Object Attribute Map RAM extends from $FE00 to $FE9F. A
; total of 160 bytes.
k_OAMRAM			EQU		$FE00
k_OAMRAM_LENGTH		EQU		$A0
k_OAMRAM_START		EQU		k_OAMRAM
k_OAMRAM_END		EQU		((k_OAMRAM+k_OAMRAM_LENGTH)-1)

_AUD3WAVERAM		EQU		$FF30									; $FF30->$FF3F		; not sure!


k_COLOUR_GREY			EQU		3
k_COLOUR_DARK_GREY		EQU		2
k_COLOUR_LIGHT_GREY		EQU		1
k_COLOUR_TRANSPARENT	EQU		0



; --
; -- OAM flags
; --

; OAM
; GameBoy Object Attribute Map describes the attributes for sprites
; bit positions in the Object Attribute Map
k_OAM_BIT_PRIORITY	EQU		7										; object priority
k_OAM_BIT_VFLIP		EQU		6										; object vertical flip
k_OAM_BIT_HFLIP		EQU		5										; object horizontal flip
k_OAM_BIT_PAL_BANK	EQU		4										; palette bank
k_OAM_BIT_TILE_BANK	EQU		3										; tile bank
k_OAM_BIT_PAL0		EQU		2										; palette bit 0
k_OAM_BIT_PAL1		EQU		1										; palette bit 1
k_OAM_BIT_PAL2		EQU		0										; palette bit 2

; mask values in the Object Attribute Map
k_OAMM_PRIORITY	EQU		%10000000								; object priority
k_OAMM_VFLIP	EQU		%01000000								; object vertical flip
k_OAMM_HFLIP	EQU		%00100000								; object horizontal flip
k_OAMM_PAL_BANK_LO	EQU		%11101111							; palette bank #0 (OBJ0PAL)
k_OAMM_PAL_BANK_HI	EQU		%00010000							; palette bank #1 (OBJ1PAL)
k_OAMM_TILE_BANK_LO	EQU		%11110111								; tile bank #0
k_OAMM_TILE_BANK_HI	EQU		%00001000								; tile bank #1
k_OAMM_PAL		EQU		%00000111								; palette mask
k_OAMM_PAL0		EQU		%00000000								; palette 0
k_OAMM_PAL1		EQU		%00000100								; palette 1
k_OAMM_PAL2		EQU		%00000010								; palette 2
k_OAMM_PAL3		EQU		%00000110								; palette 3
k_OAMM_PAL4		EQU		%00000001								; palette 4
k_OAMM_PAL5		EQU		%00000101								; palette 5
k_OAMM_PAL6		EQU		%00000011								; palette 6
k_OAMM_PAL7		EQU		%00000111								; palette 7


;********************************************************************
; NAME: P1 -- Joypad Input											*
; INFO: $FF00, R/W													*
;																	*
; This register is used for reading the joypad buttons. Only		*
; certain bits of the register can be written to.					*
;																	*
;********************************************************************
r_P1				EQU		$FF00

k_P1F_5				EQU		%00100000								; P5 out port (write)
k_P1F_4				EQU		%00010000								; P4 out port (write)
k_P1F_3				EQU		%00001000								; P3 out port (read)
k_P1F_2				EQU		%00000100								; P2 out port (read)
k_P1F_1				EQU		%00000010								; P1 out port (read)
k_P1F_0				EQU		%00000001								; P0 out port (read)


;********************************************************************
; NAME: SB -- Serial IO Data Buffer									*
; INFO: $FF01, R/W													*
;																	*
; This register handles data for the gameboy serial port. It		*
; handles both incoming and outgoing data. To determine the			*
; direction and status, the Serial IO Control Register (SC) should	*
; be consulted.														*
;																	*
;********************************************************************
r_SB				EQU		$FF01

k_SIO_CLOCK			EQU		$01
k_SIO_TRANSMIT		EQU		$80

;********************************************************************
; NAME: SC -- Serial IO Control										*
; INFO: $FF02, R/W													*
;																	*
;********************************************************************
r_SC				EQU		$FF02


;********************************************************************
; NAME: DIV -- Timer Divider Register								*
; INFO: $FF04, R/W													*
;																	*
;********************************************************************
k_DIV				EQU		$FF04


;********************************************************************
; NAME: LCDC -- LCD Control											*
; INFO: $FF40, R/W													*
;																	*
;********************************************************************
r_LCDC				EQU		$FF40

k_LCDCM_LCD_ON		EQU		%10000000								; lcd display on
k_LCDCM_LCD_OFF		EQU		((~k_LCDCM_LCD_ON)&$00FF)			; lcd display off
k_LCDCM_WIN9C00		EQU		%01000000								; window screen display data select $9C00
k_LCDCM_WIN9800		EQU		((~k_LCDCM_WIN9C00)&$00FF)			; window screen display data select $9800
k_LCDCM_WIN_ON		EQU		%00100000								; window display on
k_LCDCM_WIN_OFF		EQU		((~k_LCDCM_WIN_ON)&$00FF)			; window display off
k_LCDCM_BG8000		EQU		%00010000								; background character data select $8000
k_LCDCM_BG8800		EQU		((~k_LCDCM_BG8000)&$00FF)			; background character data select $8800
k_LCDCM_BG9C00		EQU		%00001000								; background screen display data select $9C00
k_LCDCM_BG9800		EQU		((~k_LCDCM_BG9C00)&$00FF)			; background screen display data select $9800
k_LCDCM_OBJ16		EQU		%00000100								; object size 16 pixels
k_LCDCM_OBJ8		EQU		((~k_LCDCM_OBJ16)&$00FF)			; object size 8 pixels
k_LCDCM_OBJ_ON		EQU		%00000010								; obj display
k_LCDCM_OBJ_OFF		EQU		((~k_LCDCM_OBJ_ON)&$00FF)			; obj display
k_LCDCM_BG_ON		EQU		%00000001								; background display on
k_LCDCM_BG_OFF		EQU		((~k_LCDCM_BG_ON)&$00FF)			; background display off
																	
k_LCDCB_LCD_VIS		EQU		7										; lcd visible
k_LCDCB_WIN_DS		EQU		6										; window display data select
k_LCDCB_WIN_VIS		EQU		5										; window visible
k_LCDCB_BGD_DS		EQU		4										; background character data select
k_LCDCB_BGS_DS		EQU		3										; background screen data select
k_LCDCB_OBJ_SIZE	EQU		2										; object size (8 or 16 pixels high)
k_LCDCB_OBJ_VIS		EQU		1										; object visible
k_LCDCB_BG_VIS		EQU		0										; background visible


;********************************************************************
; NAME: STAT -- LCD Status											*
; INFO: $FF41, R/W													*
;																	*
;********************************************************************
r_STAT				EQU		$FF41

k_STATF_LYC			EQU		%01000000								; LYCEQULY coincidence (selectable)
k_STATF_MODE10		EQU		%00100000								; mode 10
k_STATF_MODE01		EQU		%00010000								; mode 01 (V-Blank)
k_STATF_MODE00		EQU		%00001000								; mode 00 (H-Blank)
k_STATF_LYCF		EQU		%00000100								; coincidence Flag
k_STATF_HB			EQU		%00000000								; H-Blank
k_STATF_VB			EQU		%00000001								; V-Blank
k_STATM_OAM			EQU		%00000010								; OAM-RAM is in use by system
k_STATM_VRAM		EQU		%00000001								; vram is in use by system
k_STATM_LCD			EQU		%00000011								; both OAM and VRAM used by system


;********************************************************************
; NAME: SCY -- Scroll Screen Y										*
; INFO: $FF42, R/W													*
;																	*
;********************************************************************
r_SCY				EQU		$FF42


;********************************************************************
; NAME: SCX -- Scroll Screen X										*
; INFO: $FF43, R/W													*
;																	*
;********************************************************************
r_SCX					EQU		$FF43


;********************************************************************
; NAME: LY -- LCDC Y Coordinate										*
; INFO: $FF44, R													*
;																	*
; This register is the current scan line value. It increments as	*
; each horizontal line of the screen is drawn. Valid values are		*
; between 0 to 153. Values 144 to 153 are the vertical blanking		*
; period.															*
;																	*
;********************************************************************
r_LY				EQU		$FF44



;********************************************************************
; NAME: LYC -- LY compare											*
; INFO: $FF45, R/W													*
;																	*
; This register is used to trigger the LCDC interrupt when the		*
; scanline currently being drawn is equal to this register. When	*
; equal the STATF_LYC flag is set in STAT.							*
;																	*
;********************************************************************
r_LYC					EQU		$FF45


; --
; -- DMA ($FF46)
; -- DMA Transfer and Start Address (W)
; --
r_DMA					EQU		$FF46

; --
; -- BGP ($FF47)
; -- BG Palette Data (W)
; --
; -- Bit 7-6 - Intensity for %11
; -- Bit 5-4 - Intensity for %10
; -- Bit 3-2 - Intensity for %01
; -- Bit 1-0 - Intensity for %00
; --
r_BGP					EQU		$FF47


; --
; -- OBP0 ($FF48)
; -- Object Palette 0 Data (W)
; --
; -- See BGP for info
; --
r_OBP0					EQU		$FF48


; --
; -- OBP1 ($FF49)
; -- Object Palette 1 Data (W)
; --
; -- See BGP for info
; --
r_OBP1					EQU		$FF49

;
; -- VRAM BANK ($FF4F)
; -- VRAM bank select (W)
r_VRAM_BANK				EQU		$FF4F
k_VRAM_BANK_LOWER		EQU		$0
k_VRAM_BANK_UPPER		EQU		$1
						
						
r_BCPS					EQU		$FF68								; BG color palette specification
r_BCPD					EQU		$FF69								; BG color palette data
r_OCPS					EQU		$FF6A								; OBJ color palette specification
r_OCPD					EQU		$FF6B								; OBJ color palette data
r_SVBK					EQU		$FF70								; WRAM bank


; --
; -- HDMA1 ($FF51)
; -- Horizontal Blanking, General Purpose DMA (W)
; --
r_HDMA1					EQU		$FF51


; --
; -- HDMA2 ($FF52)
; -- Horizontal Blanking, General Purpose DMA (W)
; --
r_HDMA2				EQU		$FF52


; --
; -- HDMA3 ($FF53)
; -- Horizontal Blanking, General Purpose DMA (W)
; --
r_HDMA3				EQU		$FF53


; --
; -- HDMA4 ($FF54)
; -- Horizontal Blanking, General Purpose DMA (W)
; --
r_HDMA4				EQU		$FF54


; --
; -- HDMA5 ($FF55)
; -- Horizontal Blanking, General Purpose DMA (R/W)
; --
r_HDMA5				EQU		$FF55


; --
; -- RP ($FF56)
; -- Infrared Communications Port (R/W)
; --
r_RP				EQU		$FF56





; --
; -- IF ($FF0F)
; -- Interrupt Flag (R/W)
; --
; -- IE ($FFFF)
; -- Interrupt Enable (R/W)
; --
r_IF	EQU $FF0F
r_IE	EQU $FFFF

k_IEF_HILO			EQU		%00010000								; Transition from High to Low of Pin number P10-P13
k_IEF_SERIAL		EQU		%00001000								; Serial I/O transfer end
k_IEF_TIMER			EQU		%00000100								; Timer Overflow
k_IEF_LCDC			EQU		%00000010								; LCDC (see STAT)
k_IEF_VBLANK		EQU		%00000001								; V-Blank


; --
; -- WY ($FF4A)
; -- Window Y Position (R/W)
; --
; -- 0 <EQU WY <EQU 143
; --
r_WY				EQU		$FF4A


; --
; -- WX ($FF4B)
; -- Window X Position (R/W)
; --
; -- 7 <EQU WX <EQU 166
; --
r_WX				EQU		$FF4B

; --
; -- KEY1 ($FF4D)
; -- CPU Speed (R/W)
; --
r_KEY1				EQU		$FF4D										; cpu speed control register




;***************************************************************************
;*
;* Sound control registers
;*
;***************************************************************************

; --
; -- AUDVOL/NR50 ($FF24)
; -- Channel control / ON-OFF / Volume (R/W)
; --
; -- Bit 7   - Vin->SO2 ON/OFF (Vin??)
; -- Bit 6-4 - SO2 output level (volume) (# 0-7)
; -- Bit 3   - Vin->SO1 ON/OFF (Vin??)
; -- Bit 2-0 - SO1 output level (volume) (# 0-7)
; --
rNR50	EQU $FF24
rAUDVOL	EQU rNR50


; --
; -- AUDTERM/NR51 ($FF25)
; -- Selection of Sound output terminal (R/W)
; --
; -- Bit 7   - Output sound 4 to SO2 terminal
; -- Bit 6   - Output sound 3 to SO2 terminal
; -- Bit 5   - Output sound 2 to SO2 terminal
; -- Bit 4   - Output sound 1 to SO2 terminal
; -- Bit 3   - Output sound 4 to SO1 terminal
; -- Bit 2   - Output sound 3 to SO1 terminal
; -- Bit 1   - Output sound 2 to SO1 terminal
; -- Bit 0   - Output sound 0 to SO1 terminal
; --
rNR51	EQU $FF25
rAUDTERM	EQU rNR51


; --
; -- AUDENA/NR52 ($FF26)
; -- Sound on/off (R/W)
; --
; -- Bit 7   - All sound on/off (sets all audio regs to 0!)
; -- Bit 3   - Sound 4 ON flag (doesn't work!)
; -- Bit 2   - Sound 3 ON flag (doesn't work!)
; -- Bit 1   - Sound 2 ON flag (doesn't work!)
; -- Bit 0   - Sound 1 ON flag (doesn't work!)
; --
rNR52	EQU $FF26
rAUDENA	EQU rNR52


;***************************************************************************
;*
;* SoundChannel #1 registers
;*
;***************************************************************************

; --
; -- AUD1SWEEP/NR10 ($FF10)
; -- Sweep register (R/W)
; --
; -- Bit 6-4 - Sweep Time
; -- Bit 3   - Sweep Increase/Decrease
; --           0: Addition    (frequency increases???)
; --           1: Subtraction (frequency increases???)
; -- Bit 2-0 - Number of sweep shift (# 0-7)
; -- Sweep Time: (n*7.8ms)
; --
rNR10	EQU $FF10
rAUD1SWEEP	EQU rNR10


; --
; -- AUD1LEN/NR11 ($FF11)
; -- Sound length/Wave pattern duty (R/W)
; --
; -- Bit 7-6 - Wave Pattern Duty (00:12.5% 01:25% 10:50% 11:75%)
; -- Bit 5-0 - Sound length data (# 0-63)
; --
rNR11	EQU $FF11
rAUD1LEN	EQU rNR11


; --
; -- AUD1ENV/NR12 ($FF12)
; -- Envelope (R/W)
; --
; -- Bit 7-4 - Initial value of envelope
; -- Bit 3   - Envelope UP/DOWN
; --           0: Decrease
; --           1: Range of increase
; -- Bit 2-0 - Number of envelope sweep (# 0-7)
; --
rNR12	EQU $FF12
rAUD1ENV	EQU rNR12


; --
; -- AUD1LOW/NR13 ($FF13)
; -- Frequency lo (W)
; --
rNR13	EQU $FF13
rAUD1LOW	EQU rNR13


; --
; -- AUD1HIGH/NR14 ($FF14)
; -- Frequency hi (W)
; --
; -- Bit 7   - Initial (when set, sound restarts)
; -- Bit 6   - Counter/consecutive selection
; -- Bit 2-0 - Frequency's higher 3 bits
; --
rNR14	EQU $FF14
rAUD1HIGH	EQU rNR14


;***************************************************************************
;*
;* SoundChannel #2 registers
;*
;***************************************************************************

; --
; -- AUD2LEN/NR21 ($FF16)
; -- Sound Length; Wave Pattern Duty (R/W)
; --
; -- see AUD1LEN for info
; --
rNR21	EQU $FF16
rAUD2LEN	EQU rNR21


; --
; -- AUD2ENV/NR22 ($FF17)
; -- Envelope (R/W)
; --
; -- see AUD1ENV for info
; --
rNR22	EQU $FF17
rAUD2ENV	EQU rNR22


; --
; -- AUD2LOW/NR23 ($FF18)
; -- Frequency lo (W)
; --
rNR23	EQU $FF18
rAUD2LOW	EQU rNR23


; --
; -- AUD2HIGH/NR24 ($FF19)
; -- Frequency hi (W)
; --
; -- see AUD1HIGH for info
; --
rNR24	EQU $FF19
rAUD2HIGH	EQU rNR24


;***************************************************************************
;*
;* SoundChannel #3 registers
;*
;***************************************************************************

; --
; -- AUD3ENA/NR30 ($FF1A)
; -- Sound on/off (R/W)
; --
; -- Bit 7   - Sound ON/OFF (1EQUON,0EQUOFF)
; --
rNR30	EQU $FF1A
rAUD3ENA	EQU rNR30


; --
; -- AUD3LEN/NR31 ($FF1B)
; -- Sound length (R/W)
; --
; -- Bit 7-0 - Sound length
; --
rNR31	EQU $FF1B
rAUD3LEN	EQU rNR31


; --
; -- AUD3LEVEL/NR32 ($FF1C)
; -- Select output level
; --
; -- Bit 6-5 - Select output level
; --           00: 0/1 (mute)
; --           01: 1/1
; --           10: 1/2
; --           11: 1/4
; --
rNR32	EQU $FF1C
rAUD3LEVEL	EQU rNR32


; --
; -- AUD3LOW/NR33 ($FF1D)
; -- Frequency lo (W)
; --
; -- see AUD1LOW for info
; --
rNR33	EQU $FF1D
rAUD3LOW	EQU rNR33


; --
; -- AUD3HIGH/NR34 ($FF1E)
; -- Frequency hi (W)
; --
; -- see AUD1HIGH for info
; --
rNR34	EQU $FF1E
rAUD3HIGH	EQU rNR34


; --
; -- AUD4LEN/NR41 ($FF20)
; -- Sound length (R/W)
; --
; -- Bit 5-0 - Sound length data (# 0-63)
; --
rNR41	EQU $FF20
rAUD4LEN	EQU rNR41


; --
; -- AUD4ENV/NR42 ($FF21)
; -- Envelope (R/W)
; --
; -- see AUD1ENV for info
; --
rNR42	EQU $FF21
rAUD4ENV	EQU rNR42


; --
; -- AUD4POLY/NR42 ($FF22)
; -- Polynomial counter (R/W)
; --
; -- Bit 7-4 - Selection of the shift clock frequency of the (scf)
; --           polynomial counter (0000-1101)
; --           freqEQUdrf*1/2^scf (not sure)
; -- Bit 3 -   Selection of the polynomial counter's step
; --           0: 15 steps
; --           1: 7 steps
; -- Bit 2-0 - Selection of the dividing ratio of frequencies (drf)
; --           000: f/4   001: f/8   010: f/16  011: f/24
; --           100: f/32  101: f/40  110: f/48  111: f/56  (fEQU4.194304 Mhz)
; --
rNR42_2	EQU $FF22
rAUD4POLY	EQU rNR42_2


; --
; -- AUD4GO/NR43 ($FF23)
; -- (has wrong name and value (ff30) in Dr.Pan's doc!)
; --
; -- Bit 7 -   Inital
; -- Bit 6 -   Counter/consecutive selection
; --
rNR43	EQU $FF23
rAUD4GO	EQU rNR43	; silly name!


k_GB_VRAM_W_PIX		EQU		256										; width of vram in pixels
k_GB_VRAM_H_PIX		EQU		256										; height of vram in pixel
k_GB_VRAM_W_BYTE	EQU		32										; width of vram in bytes
k_GB_VRAM_H_BYTE	EQU		32										; height of vram in bytes

k_GB_SCR_W_PIX		EQU		160										; width of visible screen in pixels
k_GB_SCR_H_PIX		EQU		144										; height of visible screen in pixels
k_GB_SCR_W_BYTE		EQU		20										; width of visible screen in bytes
k_GB_SCR_H_BYTE		EQU		18										; height of visible screen in bytes
k_GB_SCR_CTR_X		EQU		(k_GB_SCR_W_PIX/2)						; horizontal center of gameboy screen in pixels
k_GB_SCR_CTR_Y		EQU		(k_GB_SCR_H_PIX/2)						; vertical center of gameboy screen in pixels
