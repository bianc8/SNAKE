## GIOCA / PLAY

Play the game of Snake

![gameplay](https://github.com/enricBiancott0/SNAKE/blob/main/images/game.png?raw=true)

# Usage
When the program is open on Dosbox, we can see a Menu screen with many options:

![tutorial](https://github.com/enricBiancott0/SNAKE/blob/main/images/menu.png?raw=true)

## Tutorial

Use the arrows to select "TUTORIAL" to get an overview of the game

To control the snake, use WASD keys

To exit the tutorial and start playing, click the Esc button

# Installation and working program

Download and install [Dosbox](https://www.dosbox.com/download.php?main=1)

Drag the EXP.COM executable on Dosbox
![tutorial](https://github.com/enricBiancott0/SNAKE/blob/main/images/example.gif?raw=true)

## Classifica

To be implemented

## Exit

To exit the game 

# Build your own executable 

## Requirements
Dosbox installed on your machine

## Compile
To compile do these steps:
open dosbox and mount directory where programs are located, in my case I have EXP.asm on directory path on volume d:

Mount directory:

Z:\> mount d d:\path

Visit the mounted directory:

Z:\> d:

Compile using Turbo Assembler:

D:\> tasm snake.asm

To produce executable file, link object file and macros, using Turbo Linker

We are using /t param because we specify in assembly the use of ".model tiny" so the executable file will be a .COM and not a .exe

D:\> tlink snake.obj /t


## Execute

To execute the compiled program, just do:

D:\> snake.com

## Debug [EXTRA]
If you want to debug the program, use Turbo Debugger:

D:\> td snake.COM

## Authors

Enrico Biancotto

Valerio Grave
