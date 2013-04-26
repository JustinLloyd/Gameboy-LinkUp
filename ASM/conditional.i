						IF		!DEF(__CONDITIONAL_I__)
__CONDITIONAL_I__		SET		0

;**********************************************************************************
;
; Conditional build flags version number.
; Update the following EQUate value whenever a new conditional flag is added.
;
;**********************************************************************************

k_BLDOPT_CONDITIONAL_VERSION	EQU		0001251							; version # of conditional flags

;**********************************************************************************
;
; Programmer/Designer specific options.
;
;**********************************************************************************

k_BLDOPT_JustinL		EQU		1										; define this if compiled on JustinL's machine

;**********************************************************************************
;
; Debugging options for programmers.
;
;**********************************************************************************

k_BLDOPT_DEBUG			EQU		1										; define this for a debug build


						ENDC
