
# MIPS Stacker
![Title Screen](img/title_screen.gif)
## An endless 2D stacker game implemented with MIPS using the MARS 4.5.1 Bitmap and Keyboard MMIO Simulator
Created by: Brad Johnson

Class: CS 2340.002 - Computer Architecture

## Objective
Try to stack the moving blocks as high as possible. When a block isn't placed on the stack, it's game over!

## Setup Instructions
1. Open Bitmap display `(Tools > Bitmap Display)`

	a. Set pixel dimensions to `16x16` 
	
	b. Set display dimensions to `512x512`
	
	c. Use `$gp` as base address
	
	d. Resize the bitmap window so the entire bitmap display is shown 
	
	e. Connect Bitmap Display to MIPS
3. Open Keyboard MMIO Simulator `(Tools > Keyboard and Display MMIO Simulator)`
	
	a. Connect Keyboard to MIPS
4. (optionally) Turn up your computer sound level to hear the sound effects
5. Assemble the file `main.asm`
6. Run the program

## Controls
* Press `spacebar` to place down the moving block onto the stack
* All other keys ignored

## Gameplay
* When prompted to choose the game difficulty, input the number into the input box that corresponds to the difficulty you wish to play:
	* `1` - "Noobie Stacker" (Easy)
	* `2` - "Mediocre Stacker" (Medium)
	* `3` - "Stacking Mastermind" (Hard)
	* `4` - "Lol. Good luck." (Impossible)
	
		![Prompt to choose your difficulty](img/choose_difficulty.png)
* After choosing your difficulty, the title screen is removed and gameplay immediately begins.

	![Gameplay begins](img/game_start.gif)
* Press the `spacebar` in the Keyboard MMIO simulator to place down the block on top of the stack

	![Gameplay](img/gameplay.gif)

* If you try to place the block when it's not above the stack, it's game over! You will hear the iconic sad trombone sound, so you can really absorb the shame of losing.
* The game over message, along with your score, will be displayed in a dialog window.

	![Game over](img/game_over.png)
* After your score is displayed, you will then be prompted to choose whether to play again.

	![Prompt to play again](img/play_again.png)

  * If `Yes` is chosen, you will be prompted to choose the difficulty, and the game will start over.
  * If `No` is chosen, a goodbye message is displayed
  
	![Goodbye message](img/goodbye.png)

## Game Logic
```mermaid
flowchart TD
A((START)) --> B[/Display initial\nstack block/]
subgraph Display initial stack block
B -.-> Ba(Draw one row) --> Bc(Pause for GAME_DELAY ms) --> Bd{Drawn\nINITIAL_BLOCK_HEIGHT\nrows yet?}
Bd -- NO --> Ba
end
Bd -- YES --> C
subgraph Draw Title Screen
C[/Draw the title screen/] -.-> D
D(Draw each letter in 'MIPS'\n in blue color) --> E(Draw the word 'STACKER'\n in white color) --> F(Underline 'STACKER'\nin blue color) --> G(Flash the color of 'STACKER'\n between yellow and white)
end
subgraph Choose Difficulty
G --> choosediff{{Popup input dialog to choose the difficulty}}
choosediff -- Input == 1 --> easy[Set GAME_DELAY to 75 ms]
choosediff -- Input == 2 --> med[Set GAME_DELAY to 50 ms]
choosediff -- Input == 3 --> hard[Set GAME_DELAY to 25 ms]
choosediff -- Input == 4 --> impos[Set GAME_DELAY to 10 ms]
end
removed{Has the title screen\n been removed yet?}
easy --> removed
med --> removed
hard --> removed
impos --> removed
removed -- NO --> I
removed -- YES --> drawleft
subgraph Remove Title Screen
I[/Remove Title Screen/]
I -.-> J(Draw over each letter of \n'MIPS' in black color) --> K(Draw over 'STACKER' in black color) --> L(Remove the underline)
end
L --> drawleft(Draw new block from the left side of the screen) 
drawleft -- Set current direction to right: +1 --> N(Move the block in current direction)
subgraph Animate Block
N --> O{Reached the end\n of the screen?}
O -- NO --> Q[/Check for input/]
O -- YES --> R(Negate the current direction)
R --> Q
Q --> S{Spacebar key\nentered?}
S -- NO --> T(Pause for GAME_DELAY ms)
T --> N
end
subgraph Place Block on Stack
S -- YES --> U[/Place down block on the stack/] 
U -.-> V{Right edge of block < Left edge of stack\nOR\nLeft edge of block > Right edge of stack?}
V -- NO --> remove(Remove parts of block\n hanging off the stack) --> sound(Play woodblock sound) --> score(Increment score by 1) --> height(Increase current Y position\nby BLOCK_HEIGHT) --> checkheight{Y position past half\n the screen height?}
checkheight -- NO --> checkdir{Just drew block from left?}
checkheight -- YES --> moveup(Move entire stack \ndown by BLOCK_HEIGHT)
end
checkdir -- YES --> drawright(Draw new block from right side of screen)
checkdir -- NO --> drawleft
drawright -- Set current direction to left: -1 --> N
moveup --> checkdir
subgraph Game Over
V -- YES --> gameover[/Game is over/] -.-> Va(Play sad trombone sound) --> Vb(Popup 'game over' dialog\nand score count) -- dialog closed --> Vc(Popup 'play again?' dialog) --> playagain{User wishes to\nplay again?}
playagain -- YES --> restscore(Set score to 0) --> clear(Clear the screen) 
clear --> choosediff
playagain -- NO --> goodbye(Popup 'goodbye' dialog)
end
goodbye --> done((END))
```