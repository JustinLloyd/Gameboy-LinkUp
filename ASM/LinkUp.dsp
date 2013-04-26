# Microsoft Developer Studio Project File - Name="LinkUp" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) External Target" 0x0106

CFG=LinkUp - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "LinkUp.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "LinkUp.mak" CFG="LinkUp - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "LinkUp - Win32 Release" (based on "Win32 (x86) External Target")
!MESSAGE "LinkUp - Win32 Debug" (based on "Win32 (x86) External Target")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""$/LinkUp/Asm", DGDAAAAA"
# PROP Scc_LocalPath "."

!IF  "$(CFG)" == "LinkUp - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Cmd_Line "NMAKE /f LinkUp.mak"
# PROP BASE Rebuild_Opt "/a"
# PROP BASE Target_File "LinkUp.exe"
# PROP BASE Bsc_Name "LinkUp.bsc"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Cmd_Line "nmake /f "LinkUp.mak""
# PROP Rebuild_Opt "/a"
# PROP Target_File "LinkUp.exe"
# PROP Bsc_Name ""
# PROP Target_Dir ""

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Cmd_Line "NMAKE /f LinkUp.mak"
# PROP BASE Rebuild_Opt "/a"
# PROP BASE Target_File "LinkUp.exe"
# PROP BASE Bsc_Name "LinkUp.bsc"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Cmd_Line "c:\gameboy\bin\make -a -c -f "makefile.mk""
# PROP Rebuild_Opt "-B"
# PROP Target_File "LinkUp.gb"
# PROP Bsc_Name ""
# PROP Target_Dir ""

!ENDIF 

# Begin Target

# Name "LinkUp - Win32 Release"
# Name "LinkUp - Win32 Debug"

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

!ENDIF 

# Begin Group "Libraries"

# PROP Default_Filter "*.s;*.i"
# Begin Source File

SOURCE=.\CopyData.i

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\CopyData.s

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"
# PROP Ignore_Default_Tool 1

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\hardware.i

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\Joypad.i

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\Joypad.s

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\ROMHeader.i

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\ROMHeader.S

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\Shift.i

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\Utility.i

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\Utility.s

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# End Group
# Begin Group "LinkUp"

# PROP Default_Filter "*.s;*.i"
# Begin Source File

SOURCE=.\Banks.i

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\Banks.s

!IF  "$(CFG)" == "LinkUp - Win32 Release"

# PROP Intermediate_Dir "Debug"
# PROP Ignore_Default_Tool 1

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"
# PROP Ignore_Default_Tool 1

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\conditional.i

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\Conditional.s

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"
# PROP Ignore_Default_Tool 1

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\Font.i

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\Font.s

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\Initialise.i

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\Initialise.s

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\Interrupts.i

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\Interrupts.s

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\LinkUp.i
# End Source File
# Begin Source File

SOURCE=.\LinkUp.S
# End Source File
# Begin Source File

SOURCE=.\Standard.i

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# End Group
# Begin Group "Build Files"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\backup.bat

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\Dep.txt

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\g.bat

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\LINKFILE.lik

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\output\LinkUp.map
# End Source File
# Begin Source File

SOURCE=.\LinkUp.sym

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\M.bat

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\makefile.mk

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=".\Programmer Notes.txt"

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# End Group
# Begin Group "Data"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\FontData.i

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\FontData.s

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\GlobalData.i

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\GlobalData.S

!IF  "$(CFG)" == "LinkUp - Win32 Release"

!ELSEIF  "$(CFG)" == "LinkUp - Win32 Debug"

# PROP Intermediate_Dir "Output"

!ENDIF 

# End Source File
# End Group
# End Target
# End Project
