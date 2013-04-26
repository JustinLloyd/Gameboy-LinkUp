					IF		!DEF(__GLOBALDATA_I__)
__GLOBALDATA_I__	SET		1

					GLOBAL	g_stack
					GLOBAL	g_stackTop
					GLOBAL	g_vblFrameCount
					GLOBAL	g_cpuType
					GLOBAL	g_vblDone
;					GLOBAL	g_receivePacket
;					GLOBAL	g_sendPacket
					GLOBAL	g_isServer
					GLOBAL	g_packetNumber
					GLOBAL	g_packetIndex
					GLOBAL	g_connectState
;					GLOBAL	g_rxBuffer
;					GLOBAL	g_txBuffer
					GLOBAL	g_isSIOComplete
					GLOBAL	g_isSIOError
					GLOBAL	LinkPalette

k_CONNECT_TIMEOUT	EQU		60*30									; wait 30 seconds for connection to timeout
							RSRESET
k_CONNECTION_NONE			RB	1									; connection is not yet established
k_CONNECTION_ESTABLISHED	RB	1									; connection with remote gameboy is established
k_CONNECTION_NO_REMOTE		RB	1									; there is no remote gameboy
k_CONNECTION_LOST			RB	1									; connection with remote gameboy has been lost

k_PACKET_ID_START	EQU		$01										; starting packet #
k_PACKET_ID_END		EQU		$7F										; ending packet #

k_PACKET_ADDRESS	EQU		$81										; start address where packet is stored/retrieved in hiram

; don't mess around with these codes
; if you do alter their values, DO NOT!!! use either $00 or $FF
k_SERVER_CODE		EQU		$01										; "I.M. Server" transmit code
k_CLIENT_CODE		EQU		$FE										; "I.R. Client" transmit code
k_PACKET_LENGTH		EQU		2										; length of transmission packet, must be less than 15 per video frame

				; local variables
g_localVars0		EQU		k_HIRAM
g_localVars1		EQU		k_HIRAM+16
g_localVars2		EQU		k_HIRAM+32
g_localVars3		EQU		k_HIRAM+48
g_localVars4		EQU		k_HIRAM+64

					ENDC
