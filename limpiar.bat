:: Este archivo borra todos los archivos que son generados durante el proceso de ensamblado
:: del programa. Esto incluye a los archivos con terminacion .OBJ, .LST, .MAP y .EXE.
ECHO OFF

del *.obj
del *.lst
del *.map
del *.exe

ECHO Se borraron todos los archivos generados durante el ensamblado del programa (*.obj, *.lst, *.map, *.exe)
PAUSE