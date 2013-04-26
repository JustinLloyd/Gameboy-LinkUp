					INCLUDE	"Standard.i"
					INCLUDE	"GlobalData.i"
					INCLUDE "Initialise.i"
					INCLUDE "Font.i"
;					INCLUDE "Shift.i"
					INCLUDE "LinkUp.i"
					INCLUDE	"Interrupts.i"

					INCLUDE	"Conditional.s"

										
					GLOBAL	CodeStart

;********************************************************************
; NAME:	Messages													*
;																	*
; This data is just a list of messages that will be printed out as	*
; various communications functions are executed.					*
; They can be removed and replaced with dedicated artwork where		*
; necessary.														*
;																	*
;********************************************************************
					DT_DATA
MsgPressStart:		DB		$0C,"PRESS START FOR",$0D,"TWO PLAYER GAME",$0D,$00
MsgClient:			DB		"THIS IS CLIENT",$0D,$00
MsgServer:			DB		"THIS IS SERVER",$0D,$00
MsgFailedConnect:	DB		"FAILED CONNECT",$0D,$00
MsgConnecting:		DB		"CONNECTING",$0D,$00
MsgExchangeData:	DB		"EXCHANGE GAME DATA",$0D,$00
MsgGameBegins:		DB		"GAME STARTS",$0D,$00
MsgIOError:			DB		$0C,"          ",$0D,"          ",$0C,"IO ERROR",$0D,$00
MsgConnectionLost:	DB		$0C,"          ",$0D,"          ",$0C,"CONNECT LOST",$0D,$00
MsgLocal:			DB		$0C,$0D,$0D,$0D,$0D,$0D,$0D,$0D,"LOCAL VALUE:  ",$00
MsgRemote:			DB		$0C,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,"REMOTE VALUE: ",$00


;********************************************************************
; NAME:	CodeStart													*
; REGS:	AF,HL,BC,DE													*
;																	*
; This function is the main entry point to the game. It initialises	*
; the gameboy, sets up the levels, runs the main game loop, and		*
; handles everything else required.									*
;																	*
;********************************************************************
					SECTION "Code Start",HOME[$150]
CodeStart:			LD		SP,g_stackTop							; -> stack to stack ram
					CALL	Initialise								; initialise gameboy
					CALL	DoubleSpeed								; kick gameboy in to double-speed mode
					CALL	LCD_On									; turn on screen
.Restart:			CALL	MainMenu								; handle main menu
					CALL	PlayGame								; play game
					JP		.Restart								; game over, go back to the menus


;********************************************************************
; NAME:	MainMenu													*
;																	*
; This function is the main menu, it would have such options as		*
; "New Game", "Head To Head", "Options", etc.						*
; For now, it's just a fake menu that waits for the user to press	*
; the "Start" button on either machine to begin a two player game.	*
;																	*
;********************************************************************
					FT_GAME
MainMenu:			CALL	SerialInit								; initialise serial ports for menu
				; [BEN] -- put your "menu screens" in here
					LD		HL,MsgPressStart						; -> "press start" message
					CALL	PrintString								; display "press start" message
.MenuLoop:			WaitForVBLDone									; wait for vbl to complete
				; [BEN] -- replace this with your regular menu loop
				; has "two player" option been selected?
					LD		A,[g_joypadStatus]						; pick up current joypad state
					AND		k_JOYPAD_START							; mask for "Start" button
					JR		NZ,TwoPlayerGame						; start button pressed? yes, so start two player game
				; has a "start two player" command been received from a remote gameboy?
					LD		A,[g_connectState]						; pick up current connect state
					CP		k_CONNECTION_ESTABLISHED				; connect state = established?
					JR		EQ,RemoteTwoPlayer						; yes, so start two player game
				; [BEN] -- rest of your menu loop here
					JR		.MenuLoop								; scan keypad until user makes selection or remote gameboy starts a game


;********************************************************************
; NAME:	RemoteTwoPlayer												*
;																	*
; This code is executed when the remote gameboy has been told that	*
; a two player game is starting up. This local machine is going to	*
; be designated as the client.										*
;																	*
;********************************************************************

				; [BEN] -- you don't need a screen here, it's just for reference
RemoteTwoPlayer:	LD		HL,MsgClient							; -> "i'm the client" message
					CALL	PrintString								; display "i'm the client" message
				; [BEN] -- do any menu clean up you might want here
					JP		StartTwoPlayer							; start two player game


;********************************************************************
; NAME:	TwoPlayerGame												*
;																	*
; This function creates a connection to a remote gameboy. It is		*
; invoked by the user from the menu and the local gameboy			*
; automatically becomes the server, the remote machine becomes the	*
; client. It sends a "I AM SERVER" code to the remote gameboy,		*
; infomring it that it is now the client.							*
;																	*
;********************************************************************

TwoPlayerGame:
				; [BEN] -- display "waiting to connect" screen here
					LD		HL,MsgConnecting						; -> "waiting for connection" message
					CALL	PrintString								; display message
					LD		BC,k_CONNECT_TIMEOUT					; set # video frames before giving up connection attempt
				; send server code
.WaitForConnect:	LD		A,k_SERVER_CODE							; set server code
					LD		[r_SB],A								; set serial byte to transmit
					LD		A,k_SIO_TRANSMIT | k_SIO_CLOCK			; prepare to start serial transmission with internal clock
					LD		[r_SC],A								; begin serial I/O
					WaitForVBLDone									; wait a video frame
				; was connection established?
					LD		A,[g_connectState]						; pick up current connection state
					CP		k_CONNECTION_ESTABLISHED				; is connection established?
					JR		EQ,.Connected							; yes, so handle the new connection
				; is the link cable unplugged?
					CP		k_CONNECTION_NO_REMOTE					; is there a remote gameboy?
					JR		EQ,.NoConnection						; no, so handle an empty link
				; decrement timeout
					DEC		BC										; decrement connection timeout
					LD		A,B										; get msb of timeout
					OR		C										; combine with lsb of timeout
					JR		NZ,.WaitForConnect						; connection timed out? no, so wait another video frame
				; failed to connect
.NoConnection:		LD		HL,MsgFailedConnect						; -> "connection failed" message
					CALL	PrintString								; display message
					CALL	Sleep									; momentary pause so user can read the message
					JP		MainMenu								; begin processing menu input again
				; connected with remote
.Connected:			LD		HL,MsgServer							; -> "i am server" message
					CALL	PrintString								; display message
				; [BEN] -- exchange any initial game data here, like weapons, level selected, etc
				; start two player game
StartTwoPlayer:		LD		HL,MsgExchangeData						; -> "exchanging data" message
					CALL	PrintString								; print 
					WaitForVBLDone
				; [BEN] -- do a WaitForSIO here if you have done any data exchange
					RET												; exit function


;********************************************************************
; NAME:	Sleep														*
;																	*
; This function pauses for 10 seconds.								*
;																	*
;********************************************************************
					FT_GAME
Sleep:				PUSHALL											; preserve registers
					LD		BC,60*10								; set timeout delay of 10 seconds
.SleepLoop:			WaitForVBLDone									; wait for next vbl to complete
					DEC		BC										; decrement timeout counter
					LD		A,B										; get MSB of timeout counter
					OR		C										; bit-wise or with LSB of timeout counter
					JR		NZ,.SleepLoop							; timeout counter = 0? no, so wait another video frame
					POPALL											; restore registers
					RET												; exit function


;********************************************************************
; NAME:	SerialInit													*
;																	*
; This function initialises the serial port & interrupt ready for	*
; connection.														*
;																	*
;********************************************************************
					FT_GAME
				; prepare connection
SerialInit:			CALL	InitMenuInter							; initialise menu interrupts
					LD		A,k_CONNECTION_NONE						; set "no connection" state
					LD		[g_connectState],A						; initialise connection state
				; clear flags
					XOR		A										; clear flag
					LD		[g_isServer],A							; clear "is server" flag
					LD		[g_packetIndex],A						; clear packet index
					LD		A,k_PACKET_ID_START						; set starting # for first packet
					LD		[g_packetNumber],A						; initialise packet #
				; prepare CLIENT code for transmission
					LD		A,k_CLIENT_CODE							; set CLIENT transmission code
					LD		[r_SB],A								; place transmission byte on serial port
					LD		A,k_SIO_TRANSMIT						; set "ready to transmit" with an external clock
					LD		[r_SC],A								; set serial port
					RET												; exit function


;********************************************************************
; NAME:	SendPacket													*
;																	*
; This function begins the transmission of a data packet to the		*
; remote gameboy. At the same time, as a packet is being			*
; transmitted, a complementary packet is being received.			*
;																	*
;********************************************************************
					FT_GAME
SendPacket:			PUSH	BC										; preserve register
					PUSH	AF										; preserve register
				; increment packet #
					LD		A,[g_packetNumber]						; pick up packet #
					AND		k_PACKET_ID_END							; limit packet # to maximum value
					INC		A										; increment packet #
					LD		[g_packetNumber],A						; store new packet #
				; clear flags
					XOR		A										; clear flag
					LD		[g_isSIOComplete],A						; clear serial I/O complete flag
					LD		[g_isSIOError],A						; clear serial I/O error flag
					LD		[g_packetIndex],A						; set packet index to zero
				; prepare first byte for transmission
					ADD		k_PACKET_ADDRESS						; add offset to start of packet data
					LD		C,A										; set index of start of packet data
					LD		A,[C]									; pick up first data byte in packet
					LD		[r_SB],A								; place data on serial port
				; transmit byte
					LD		A,[g_isServer]							; pick up "is this server" flag
					OR		k_SIO_TRANSMIT							; add "begin serial transmission" flag
					LD		[r_SC],A								; begin serial transmission, internal clock if server, external clock if client
					POP		AF										; restore register
					POP		BC										; restore register
					RET												; exit function


;********************************************************************
; NAME:	WaitForSIO													*
;																	*
; This function waits for the serial I/O to complete. It detects if	*
; there was a transmission error, whether the connection was		*
; dropped or the transmission completed successfully.				*
;																	*
;********************************************************************
					FT_GAME
WaitForSIO:
				; was there an io error?
.WaitLoop:			LD		A,[g_isSIOError]						; pick up "is I/O error" flag
					OR		A										; test flag
					JR		NZ,.SIOError							; io error? yes, so report error
				; was the connection dropped?
					LD		A,[g_connectState]						; pick up connection state
					CP		k_CONNECTION_ESTABLISHED				; is the connection still established??
					JR		NE,.ConnectionLost						; no, so report connection lost
				; is io complete?
					LD		A,[g_isSIOComplete]						; pick up "is I/O complete" flag
					OR		A										; test flag
					RET		NZ										; I/O complete? yes, so stop waiting
					JR		.WaitLoop								; wait for I/O to complete
				; report an io error
.SIOError:			LD		HL,MsgIOError							; -> "io error" message
					CALL	PrintString								; display message
					CALL	Sleep									; pause so user can read message
					BREAK
					RET												; exit function
					DW		$5A4F,$4B55								; pad bytes
				; report connection lost
.ConnectionLost:	LD		HL,MsgConnectionLost					; -> "connection was lost" message
					CALL	PrintString								; display message
					CALL	Sleep									; pause so user can read message
					BREAK
					RET												; exit fucntion


;********************************************************************
; NAME:	PlayGame													*
;																	*
; This function is the main game loop.								*
;																	*
;********************************************************************
					DT_VARS
count1:				DS		1										; temporary counter variable
count2:				DS		1										; temporary counter variable
tempString:			DS		8										; temporary string
					
					FT_GAME
PlayGame:								
					LD		HL,MsgGameBegins						; -> "game begins" message
					CALL	PrintString								; display message
					WaitForVBLDone									; wait for next video frame
					CALL	InitGameInter							; initialise game interrupts
					XOR		A										; set initial value of counters
					LD		[count1],A								; set counter 1 value
					LD		[count2],A								; set counter 2 value
.GameLoop:			WaitForVBLDone									; wait for next video frame
				; [BEN] -- integrate the data received from the previous frame here
				;          or immediately after the WaitForSIO at the end of the game loop
				;
				; [BEN] -- place the data to be transmitted at $FF81 & $FF82 here
					LD		A,[count1]								; pick up counter 1
					LDH		[$FF81],A								; put counter 1 in packet
					LD		A,[count2]								; pick up counter 2
					LDH		[$FF82],A								; put counter 2 in packet
				; [BEN] -- this just adds one to a counter, just to see a transmission happening
				; A button pressed?
					LD		A,[g_joypadStatus]						; pick up joypad status
					AND		k_JOYPAD_A								; A button is pressed?
					JR		Z,.NotJoypadA							; no, so don't count up
				; increment counter 1
					LD		A,[count1]								; pick up counter 1
					INC		A										; increment counter
					AND		$0F										; mask it to keep counter value in range
					LD		[count1],A								; store new value of counter 1
				; B button pressed?
.NotJoypadA:		LD		A,[g_joypadStatus]						; pick up joypad status
					AND		k_JOYPAD_B								; B button is pressed?
					JR		Z,.NotJoypadB							; no, so don't count up
				; increment counter 2
					LD		A,[count2]								; pick up counter 2
					INC		A										; increment counter
					AND		$0F										; mask it to keep counter value in range
					LD		[count2],A								; store new value of counter 2
.NotJoypadB:
				; [BEN] -- now the packet begins transmission
					CALL	SendPacket								; start serial IO
				; [BEN] -- do regular game loop processing stuff here
					NOP
					NOP
					NOP												; not a very exciting game!!
					NOP
					NOP
				; [BEN] -- end of regular game loop
				; [BEN] -- now we should ensure the transmission has ended before proceeding
					CALL	WaitForSIO								; wait for serial IO to complete
				; [BEN] -- now copy the data that was transmitted to a safe location
				; [BEN] -- I'm using the data here, but you could wait until the next VBL before
				;          incorporating it into your game loop
					LD		HL,MsgLocal
					CALL	PrintString
					LD		A,[count1]
					ADD		65
					LD		[tempString],A
					LD		A,32
					LD		[tempString+1],A
					LD		A,[count2]
					ADD		65
					LD		[tempString+2],A
					XOR		A
					LD		[tempString+3],A
					LD		HL,tempString
					CALL	PrintString

					LD		HL,MsgRemote
					CALL	PrintString
					LD		A,[$FF81]
					ADD		65
					LD		[tempString],A
					LD		A,32
					LD		[tempString+1],A
					LD		A,[$FF82]
					ADD		65
					LD		[tempString+2],A
					XOR		A
					LD		[tempString+3],A
					LD		HL,tempString
					CALL	PrintString

				; all done, do the next game frame
					JP		.GameLoop									; stay in game loop forever
