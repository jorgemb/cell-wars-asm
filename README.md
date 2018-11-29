# cell-wars-asm

## History
This game was written in collaboration with Eddy Omar Castro at Universidad del Valle de Guatemala. It was a project for a class called Assembler Workshop, and had the objective of learning how to write x86 assembler with graphics in the form of a game.
The game was inspired after another one called [Phage Wars]( https://armorgames.com/play/2675/phage-wars) developed by Armor Games. The game objective is trying to conquer all the cells in the screen by moving viruses from one cell to the next. When the player transports viruses from one cell half of them stay and the other half move to the objective. If the target cell is conquered by the player the number of viruses is summed to the already in place, if is neutral or conquered by the enemy (the other player), a battle begins. In a battle outside viruses are subtracted from the viruses in the cell, if the number reaches zero or less then the cell is conquered.
The game uses mouse controller for one player:
-	Left click selects a cell
-	Right click moves viruses to the target cell
And keyboard for the other one:
-	Press the number of the cell to select
-	Press shift+number of the target cell to move viruses to target


## Prerrequisites
In order to use you will need:
- [DOSBox 0.72 or greater](https://www.dosbox.com/)
- Turbo Assembler (harder to find, so it's included)

Install and run DOSBox. Mount your working directory with something like this:
```dos
mount x C:\path\to\your\directory
```

Extract the contents of tasm.zip and add the binary folder to the path:
```dos
set path=%path%;x:\tasm\bin\
```

Compile, link and run with the following lines:
```dos
tasm.exe /l /zi main.asm
tlink.exe /v main.obj
main.exe
```

And finally, run main.exe.

Instructions are currently in spanish, however I'll be translating to english in the future.
