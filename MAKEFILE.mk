# General Defines
# ======================================================================

#
# general declares


#
# comment out the following line for a release build
DEFDEBUG =-DDEBUG

#
# include directories, add any extra include paths here
INCDIRS =-ic:\gameboy\include\

# Compiler/Assembler/Linker Options
# ======================================================================
GBDK2RGB=c:\gameboy\bin\gbdk2rgbds.exe
CC=c:\gameboy\sdk\bin\lcc
ASM=c:\gameboy\bin\rgbasm.exe 
#ASM=c:\work\gameboy\rgbasm\debug\rgbasm.exe 
LINK=c:\gameboy\bin\xlink.exe
FIXUP=c:\gameboy\bin\rgbfix.exe

CCOPTIONS=-A -Wa-l -c
ASMOPTIONS =-rd -dDep.txt
LINKOPTS =-i -mLinkUp.map -nLinkUp.sym
FIXUPOPTS =-o -pff -v -b19

OUTDIR=output

# Project Files
# ======================================================================
OBJS =	$(OUTDIR)\LinkUp.obj \
	$(OUTDIR)\ROMHeader.obj \
	$(OUTDIR)\Utility.obj \
	$(OUTDIR)\Initialise.obj \
	$(OUTDIR)\Joypad.obj \
	$(OUTDIR)\GlobalData.obj \
	$(OUTDIR)\Font.obj \
	$(OUTDIR)\FontData.obj \
	$(OUTDIR)\CopyData.obj \
	$(OUTDIR)\Interrupts.obj \
	$(OUTDIR)\Banks.obj


# Project Targets (default)
# ======================================================================
$(OUTDIR)\LinkUp.gb: 	$(OBJS)
	copy "linkfile.lik" $(OUTDIR)
	cd output
	$(LINK) $(LINKOPTS) linkfile.lik
	$(FIXUP) $(FIXUPOPTS) LinkUp.gb
	copy LinkUp.gb "c:\gameboy\no$$gmb\slot\LinkUp.gb"
	copy LinkUp.sym "c:\gameboy\no$$gmb\slot\LinkUp.sym"

#	copy LinkUp.gb "\\miyuki\slot\LinkUp.gb"
#	copy LinkUp.sym "\\miyuki\slot\LinkUp.sym"


# Other Targets
# ======================================================================
clean:
	del dep.txt
	cd output
	del *.obj
	del *.o
	del *.gb


# Implicit Rules
# ======================================================================
.c.obj:
	$(CC) $(CCOPTIONS) -A -c -o $&.o $&.c
	$(GBDK2RGB) $&.o $&.obj

.s.obj:
	$(ASM) $(ASMOPTIONS) -o$(OUTDIR)\$&.obj $&.S

.asm.obj:
	$(ASM) $(ASMOPTIONS) -o$(OUTDIR)\$&.obj $&.ASM

.z80.obj:
	$(ASM) $(ASMOPTIONS) -o$(OUTDIR)\$&.obj $&.Z80

#.c.s:
#	$(CC) -A -S $&.c


# Build Dependencies
# ======================================================================


$(OUTDIR)\LinkUp.obj: LinkUp.S
$(OUTDIR)\ROMHeader.obj: ROMHeader.S ROMHeader.I
$(OUTDIR)\Utility.obj: Utility.S Utility.I
$(OUTDIR)\Initialise.obj: Initialise.S Initialise.I
$(OUTDIR)\Joypad.obj: Joypad.S Joypad.I
$(OUTDIR)\GlobalData.obj: GlobalData.S GlobalData.I
$(OUTDIR)\Font.obj: Font.S Font.I
$(OUTDIR)\FontData.obj: FontData.S
$(OUTDIR)\CopyData.obj: CopyData.S
$(OUTDIR)\Interrupts.obj: Interrupts.S
$(OUTDIR)\Banks.obj: Banks.S
