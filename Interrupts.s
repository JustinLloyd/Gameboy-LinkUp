					INCLUDE	"Standard.i"
					INCLUDE	"GlobalData.i"
					INCLUDE "Interrupts.i"

					SECTION	"Interrupt Code",BSS
g_vblIntrCode:		DS		k_MAX_INTR_SIZE
g_sioIntrCode:		DS		k_MAX_INTR_SIZE

					SECTION	"GameboyROM",HOME[$0]
					DS		$40

					SECTION	"VBL Interrupt",HOME[$40]
					JP		g_vblIntrCode							; execute vbl interrupt

					SECTION	"LCD Interrupt",HOME[$48]
					RETI											; exit interrupt

					SECTION	"Timer Interrupt",HOME[$50]
					RETI											; exit interrupt

					SECTION	"Serial Interrupt",HOME[$58]
					JP		g_sioIntrCode							; execute serial I/O interrupt

					SECTION	"Joypad Interrupt",HOME[$60]
					RETI											; exit interrupt


;********************************************************************
; NAME:	DefaultVBLInter												*
; DEST: None														*
;																	*
;																	*
;********************************************************************
					FT_INTR
DefaultVBLInter:	PUSHALL											; preserve registers
					LD		A,[g_vblFrameCount]						; pick up current frame count								(4)
					AND		$01										; mask vbl frame counter for odd/even frames				(2)
					JR		Z,.EveryFrame							; is this an even frame? yes, so don't scan the joypad		(3/2)
					CALL	ScanJoypad								; update joypad status										(6)
.EveryFrame:		LD		A,[g_vblFrameCount]						; pick up current frame count								(4)
					INC		A										; increment frame #											(1)
					LD		[g_vblFrameCount],A						; store new frame count value								(4)
					LD		A,[g_vblFrameCount+1]					; pick up current frame count								(4)
					ADC		0										; increment frame #											(1)
					LD		[g_vblFrameCount+1],A					; store new frame count value								(4)
					LD		A,$01									; indicate that vbl is complete								(2)
					LD		[g_vblDone],A							; set vbl done flag											(4)
					POPALL											; restore registers
					RETI											; exit interrupt
DefaultVBLInterEnd:


;********************************************************************
; NAME:	DefaultSIOInter												*
; DEST: None														*
;																	*
;																	*
;********************************************************************
					FT_INTR
DefaultSIOInter:	RETI											; exit interrupt
DefaultSIOInterEnd:


;********************************************************************
; NAME:	MenuSIOInter												*
; DEST: None														*
;																	*
; This function handles a serial I/O interrupt generated during the	*
; menu processing part of a game. It 
;																	*
;********************************************************************
					FT_INTR
MenuSIOInter:		PUSH	AF										; preserve register
					LDH		A,[r_SB]								; get received byte
					CP		k_CLIENT_CODE							; client code received?
					JR		NE,.NotClient							; no, so this machine is not a server
					LD		A,k_CONNECTION_ESTABLISHED				; indicate that connection is established
					LD		[g_connectState],A						; set connection code
					LD		A,k_TRUE								; set flag value
					LD		[g_isServer],A							; set is server flag to indicate this machine is server
					POP		AF										; restore register
					RETI											; exit interrupt
.NotClient:			CP		k_SERVER_CODE							; server code received?
					JR		NE,.NotServer							; no, so this machine is not a client
					LD		A,k_CONNECTION_ESTABLISHED				; indicate that connection is established
					LD		[g_connectState],A						; set connection code
					XOR		A										; clear flag value
					LD		[g_isServer],A							; clear is server flag to indicate this machine is client
					POP		AF										; restore register
					RETI											; exit interrupt
					DW		$4E4F									; pad bytes
.NotServer:			CP		$FF										; no remote gameboy code?
					JR		EQ,.NoRemote							; yes, so handle an empty connection
					CP		$00										; no remote gameboy code?
					JR		EQ,.NoRemote							; yes, so handle an empty connection
					LD		A,k_CLIENT_CODE							; set code to send to remote machine
					LDH		[r_SB],A								; place code to transmit in serial buffer
					LD		A,k_SIO_TRANSMIT						; set "ready to transmit" on serial port with external clock
					LDH		[r_SC],A								; enable transmission on serial port
					POP		AF										; restore register
					RETI											; exit function
.NoRemote:			LD		A,k_CONNECTION_NO_REMOTE				; indicate that no remote gameboy was found
					LD		[g_connectState],A						; set connection code
					POP		AF										; restore register
					RETI											; exit interrupt
MenuSIOInterEnd:


;********************************************************************
; NAME:	GameSIOInter												*
; DEST: None														*
;																	*
;																	*
;********************************************************************
					FT_INTR
GameSIOInter:		PUSH	BC										; preserve register
					PUSH	AF										; preserve register
				; get received data
					LDH		A,[r_SB]								; pick up data from serial port
					LD		B,A										; save it for later
				; packet # has been transmitted?
					LD		A,[g_packetIndex]						; pick up packet index
					CP		k_PACKET_LENGTH							; all data & frame transmitted?
					JR		EQ,.EndOfPacket							; yes, process end of packet
				; last data byte transmitted?
					CP		k_PACKET_LENGTH-1						; all data transmitted?
					JR		LT,.MoreData							; no, send more data
				; all data transmitted - transmit packet #
					INC		A										; increment packet index
					LD		[g_packetIndex],A						; store new packet index
					ADD		k_PACKET_ADDRESS-1						; add base address of packet data
					LD		C,A										; set index to store received data at
					LD		A,B										; get received data
					LD		[C],A									; store received data
					LD		A,[g_packetNumber]						; pick up packet #
					LDH		[r_SB],A								; put packet # on serial port
					LD		A,[g_isServer]							; pick up "i am server" flag
					OR		k_SIO_TRANSMIT							; bitwise-or with "begin transmission" flag
					LDH		[r_SC],A								; start serial data transmission
					POP		AF										; restore register
					POP		BC										; restore register
					RETI											; exit interrupt
					DW		$4F54,$414B,$5500						; pad bytes
				; handle end of packet transmission
.EndOfPacket:		LD		A,[g_packetNumber]						; pick up current packet #
					CP		B										; compare with received packet #
					JR		EQ,.SIOComplete							; packet numbers match? yes, so serial I/O completed ok
					LD		A,B										; get received packet #
					CP		$00										; compare with open connection code
					JR		EQ,.ConnectionLost						; connection lost? yes, so handle connection error
					CP		$FF										; compare with open connection code
					JR		EQ,.ConnectionLost						; connection lost? yes, so handle connection error
				; indicate an sio error
					LD		A,k_TRUE								; set flag to true
					LD		[g_isSIOError],A						; indicate there was a serial i/o error
					JR		.SIOComplete							; complete serial i/o
				; indicate connection has been lost
.ConnectionLost:	LD		A,k_CONNECTION_LOST						; set connection state to "connection lost"
					LD		[g_connectState],A						; store new connection state
				; indicate that sio is complete
.SIOComplete:		LD		A,k_TRUE								; set flag to true
					LD		[g_isSIOComplete],A						; indicate that serial i/o is complete
					POP		AF										; restore register
					POP		BC										; restore register
					RETI											; exit interrupt
				; store received data
.MoreData:			ADD		k_PACKET_ADDRESS						; add base address of where packet data is stored
					LD		C,A										; set index to store received data at
					LD		A,B										; get received data
					LD		[C],A									; store received data
				; transmit new data
					INC		C										; -> next data to transmit
					LD		A,[C]									; pick up data to transmit
					LDH		[r_SB],A								; place data on serial port
					LD		A,[g_isServer]							; pick up "i am server" flag
					OR		k_SIO_TRANSMIT							; bitwise-or with "begin transmission" flag
					LDH		[r_SC],A								; start serial data transmission
					LD		A,C										; get index of current packet data
					SUB		k_PACKET_ADDRESS						; subtract base address of where packet data is stored
					LD		[g_packetIndex],A						; store new packet index
.Exit:				POP		AF										; restore register
					POP		BC										; restore register
					RETI											; exit interrupt
GameSIOInterEnd:


;********************************************************************
; NAME:	InitInterrupts												*
;																	*
; This function initialises the default interrupts, it copies any	*
; required interrupt routines in to RAM at their desginated			*
; addresses. It disables interrupts by default but does not, and	*
; should never be made to, enable them. This function is designed	*
; to be called as part of the gameboy initialisation routine and	*
; interrupts should only be enabled after all other general setup	*
; is complete.														*
;																	*
;********************************************************************
					FT_GAME
InitInterrupts:		PUSHALL											; preserve registers
					DI												; disable interrupts
				; copy interrupt code to ram
					COPY_INTR	DefaultVBLInter, DefaultVBLInterEnd-DefaultVBLInter, g_vblIntrCode
				; enable interrupts
					XOR		A										; clear interrupts
					LDH		[r_IF],A								; clear all pending interrupts flags
					LD		A,k_IEF_VBLANK							; set vblank interrupts on
					LDH		[r_IE],A								; set interrupt enable flags
					EI												; re-enable interrupts
					NOP												; pause for 1 cycle
					POPALL											; restore registers
					RET												; exit function


;********************************************************************
; NAME:	InitGameInter												*
;																	*
; This function initialises the in-game interrupts, it copies any	*
; required interrupt routines in to RAM at their desginated			*
; addresses.														*
;																	*
;********************************************************************
					FT_GAME
InitGameInter:		PUSHALL											; preserve registers
					DI												; disable interrupts
				; copy interrupt code to ram
					COPY_INTR	DefaultVBLInter, DefaultVBLInterEnd-DefaultVBLInter, g_vblIntrCode
					COPY_INTR	GameSIOInter, GameSIOInterEnd-GameSIOInter, g_sioIntrCode
				; enable interrupts
					XOR		A										; clear interrupts
					LDH		[r_IF],A								; clear all pending interrupts flags
					LD		A,(k_IEF_VBLANK | k_IEF_SERIAL)			; set vblank interrupts on
					LDH		[r_IE],A								; set interrupt enable flags
					EI												; re-enable interrupts
					NOP												; pause for 1 cycle
					POPALL											; restore registers
					RET												; exit function


;********************************************************************
; NAME:	InitMenuInter												*
;																	*
; This function initialises the menu interrupts, it copies any		*
; required interrupt routines in to RAM at their desginated			*
; addresses.														*
;																	*
;********************************************************************
					FT_GAME
InitMenuInter:		PUSHALL											; preserve registers
					DI												; disable interrupts
				; copy interrupt code to ram
					COPY_INTR	DefaultVBLInter, DefaultVBLInterEnd-DefaultVBLInter, g_vblIntrCode
					COPY_INTR	MenuSIOInter, MenuSIOInterEnd-MenuSIOInter, g_sioIntrCode
				; enable interrupts
					XOR		A										; clear interrupts
					LDH		[r_IF],A								; clear all pending interrupts flags
					LD		A,(k_IEF_VBLANK | k_IEF_SERIAL)			; set vblank & sio interrupts on
					LDH		[r_IE],A								; set interrupt enable flags
					EI												; re-enable interrupts
					NOP												; pause for 1 cycle
					POPALL											; restore registers
					RET												; exit function


