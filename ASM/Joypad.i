					IF		!DEF(__JOYPAD_I__)
__JOYPAD_I__		SET		1

					GLOBAL	ScanJoypad
					GLOBAL	g_joypadStatus
					GLOBAL	g_joypadChange

k_JOYPAD_START		EQU		$80
k_JOYPAD_SELECT		EQU		$40
k_JOYPAD_B			EQU		$20
k_JOYPAD_A			EQU		$10
k_JOYPAD_DOWN		EQU		$08
k_JOYPAD_UP			EQU		$04
k_JOYPAD_LEFT		EQU		$02
k_JOYPAD_RIGHT		EQU		$01

;
; Read current status of joypad
ReadJoypad:			MACRO
					LD		A,[g_joypadStatus]
					ENDM

;
; Read joypad status and determine which keys have been pressed since last read
ReadJoypadChange:	MACRO
					LD		A,[g_joypadChange]
					ENDM

					ENDC