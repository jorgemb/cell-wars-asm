:: Cleans all intermediate files writen during the assembly process. This includes files
:: with the .OBJ, .LST, .MAT and .EXE extensions.
ECHO OFF

del *.obj
del *.lst
del *.map
del *.exe

ECHO Cleaned all intermediate files (*.obj, *.lst, *.map, *.exe)
ECHO ON