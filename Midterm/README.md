## River Runner


For my midterm project, I decided to continue working on my sailboat/river game, as I wanted to make the gameplay smoother and add more features to make it more user-friendly.

Here is a demo of the game:

![Game Demo](riverRunnerGif.gif)

**Changes & Improvements**
- Instruction/loading screen: displays the title of the game (River Runner), the game description and controls, as well as text that prompts the user to press tab to continue to the game
- Smoother flowing river: changed the framerate and tweaked numbers related to the speeding up of the game, including speeding up the boat as the river speeds up
- Sounds are played: when the user presses tab to begin the game, sounds of a flowing river throughout the game as the user is playing, and when the player crashes the boat (the sound of crashing into trees!)
- Formatting of the code: I separated everything into functions to be called in draw() for easier reference and understanding. 

**Difficulties**
Something I found challenging was making the game look smoother and speed up not too quickly or not too slowly. For this, I continued using the for-loop method I tried last week, but I changed the frame rate to suit the speeding up better. I also realized that if the boat never changes speed, it warps the sense of speed in the game; before, the boat didn't speed up to account for the quickening pace of the river. To address this, I changed the speed of the boat to match the change in speed of the river. It was also hard for me to quickly look at parts of my code for reference, as I had put it all into  draw(), so I created functions for the different tasks. 

**CREDITS**
- [Freepik's](https://www.flaticon.com/authors/freepik) boat image.
- Mark Simonson's [Atari Font](https://www.fontspace.com/atari-classic-font-f30342), which is based on the Atari 8-bit character set that is seen in many older games (and some modern games).
- Zapsplat's [sound effects](https://www.zapsplat.com).
