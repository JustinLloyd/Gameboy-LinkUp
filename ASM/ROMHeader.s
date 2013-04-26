;
; This is the ROM header that is attached to each GameBoy cartridge
; it is filled in with RGBFIX or similar fix-up tool

					XREF	CodeStart

; Nintendo GameBoy standard execution point after power-on-reset sequence
					SECTION	"ROM HEADER",HOME[$100]
					nop
					jp		CodeStart

NintendoLogo:		DS		48										; NINTENDO(tm) logo (filled in by RGBFIX)

GameTitle:			DB		"LINKUP         "						; name of game (filled in by RGBFIX)		
CartFlags:			DB		0										; cartridge flags 0x80 = colour, 0x00 = normal
LicenseeIDLo:		DB		0										; low-byte of licensee code (filled in by RGBFIX)
LicenseeIDHi:		DB		0										; high-byte of licensee code (filled in by RGBFIX)
CartType:			DB		0										; cartridge type, 0 = ROM ONLY (filled in by RGBFIX)
CartROMSize:		DB		0										; size of cartridge ROM (filled in by RGBFIX)
CartRAMSize:		DB		3										; size of cartridge RAM (filled in by RGBFIX)
ManufacturerID:		DW		0										; nintendo issued manufacturer ID (filled in by RGBFIX)
CartVersion:		DB		0										; cartridge version # (filled in by RGBFIX)
CartCompliment:		DB		0										; cartridge complement (filled in by RGBFIX)
CartChecksum:		DW		0										; cartridge checksum (filled in by RGBFIX)
