					INCLUDE	"Conditional.i"

;********************************************************************
;																	*
; Verify that conditional version is current.						*
;																	*
;********************************************************************

					IF		DEF(k_BLDOPT_CONDITIONAL_VERSION)
						IF		k_BLDOPT_CONDITIONAL_VERSION<0001251
							FAIL	"CONDITIONAL.I is out of date. Retrieve the latest version from VSS.\n"
						ENDC
					ELSE
						FAIL	"CONDITIONAL.I is out of date. Retrieve the latest version from VSS.\n"
					ENDC

;********************************************************************
;																	*
; Display some debugging messages for the build options.			*
;																	*
;********************************************************************
					PRINTT	"\n\n\n********************************************************************\n"
					PRINTT	"LinkUp conditional build options\n\n"
					PRINTT	"********************************************************************\n\n\n\n"
