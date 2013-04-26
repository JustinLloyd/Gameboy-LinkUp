					INCLUDE	"Standard.i"
					INCLUDE	"GlobalData.i"
					INCLUDE	"Initialise.i"


					SECTION "Local Vars",HRAM[k_HIRAM]
localVars0:			DS		16																										;[BEN REMOVE]
localVars1:			DS		16																										;[BEN REMOVE]
localVars2:			DS		16																										;[BEN REMOVE]
localVars3:			DS		16																										;[BEN REMOVE]

					SECTION	"GlobalData",BSS[$C000]					; must absolutely, positively, be here
g_cpuType:			DS		1										; gameboy console type id										[BEN REMOVE]
g_stack:			DS		254										; reserve 255 bytes for stack (must be on a 255 byte boundary)	[BEN REMOVE]
g_stackTop:															; top of stack													[BEN REMOVE]
					DT_VARS
g_vblFrameCount:	DS		2										; VBL frame counter												[BEN REMOVE]
g_vblDone:			DS		1										; vbl flag (true=vbl is complete)								[BEN REMOVE]

					DT_VARS
; these two buffers contain the next packet to send, and the last packet received
;g_receivePacket:	DS		k_PACKET_LENGTH							; data that has been received
;g_sendPacket:		DS		k_PACKET_LENGTH							; data that is ready to transmit
; these two buffers should never be accessed by the game program
; these are the "live" transmit/receive buffers
g_connectState:		DS		1										; serial connection state, $00 = no connection established, $01 = connection, $02 = no remote gameboy, $03 = connection lost
g_isServer:			DS		1										; $01 = SERVER, $02 = CLIENT
g_packetNumber:		DS		1										; packet number for sync detection
g_packetIndex:		DS		1										; current rx/tx index in to packet data
g_isSIOComplete:	DS		1										; is serial I/O complete?
g_isSIOError:		DS		1										; was there a serial I/O error?
;					SECTION	"ReceiveBuffer",BSS[$C100]				; must absolutely, positively, be on a 256 byte boundary
;g_rxBuffer:			DS		k_PACKET_LENGTH+1						; data that is being received
;					SECTION	"TransmitBuffer",BSS[$C200]				; must absolutely, positively, be on a 256 byte boundary
;g_txBuffer:			DS		k_PACKET_LENGTH+1						; data that is being transmitted


					DT_DATA
; temporary palette for displaying debug messages
LinkPalette:		DW		(2<<10)|(2<<5)|(2),(5<<10)|(5<<5)|(5),(10<<10)|(10<<5)|(10),$7FFF										;[BEN REMOVE]
