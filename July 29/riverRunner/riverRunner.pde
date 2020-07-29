/* Adyah Rastogi
 Creative Programming and Electronics-- July 15
 Professor Michael Shiloh
 
 Description: You are a sailor trying to get through a very long river! 
 The river slowly speeds up and you must make sure not to crash!
 Use the left and right arrow keys to navigate the river.
 */
import processing.sound.*;
import processing.serial.*;


Serial arduinoPort;  //serial port of arduino
float inByte = 0;

float previousInByte;
//keeps track of if the boat should move left or right, based on potentiometer's starting value
float initialPotVal;
//for Perlin noise
float offset = 5;
//width of the river 
int riverWidth = 150;
//time elapsed in the game
float time = 0;
//stores the positions of each line in the river (to push the river down)
ArrayList<Integer> riverPosition = new ArrayList(); 
//image of the boat
PImage boat;
//where the base of the boat is in the picture (to tell when it has crashed)
float boatCorner;
//the height at which the boat is displayed
int boatHeight = 400;
//the left side of the river's boundaries
int riverBoundary;
//creating the atari font
PFont atari;
//tracks the state of the boat (crashed/not crashed)
boolean crashed = false;
//updates the score during the game
int score;
//keeps track of what screen is displayed: the starting, in-game, or game end screen
String screen = "start"; 
//keeps track of the speed of the boat
int boatMovement;
//sound files
SoundFile crashSound;
SoundFile startSound;
SoundFile riverSound;

/*
  Loads images and sounds
 */
void setup() {
  size(500, 500);
  println(Serial.list());

  arduinoPort = new Serial(this, Serial.list()[4], 9600);
  arduinoPort.bufferUntil('\n');


  //creds to Freepik (https://www.flaticon.com/authors/freepik)
  boat = loadImage("sailboat.png");
  //game-like font
  atari = createFont("AtariFont.ttf", 16); 
  crashSound = new SoundFile(this, "crashSound.mp3");
  startSound = new SoundFile(this, "startSound.mp3");
  riverSound = new SoundFile(this, "riverSound.mp3");
  textFont(atari);
}

void draw() {
  frameRate(40);
  stroke(74, 176, 217);

  if (screen == "start") {
    instructionScreen();
  } else if (crashed && screen == "game over") {
    crashedScreen();
  } else if (screen == "game") {
    //green background
    backgroundColor();
    //starts the game with river drawn that spans the entire screen
    if (time == 0) {
      loop();
      initialRiver();
      updateBoat();
    }
    //after the initial screen, this loads more of the river and pushes the bottom out of the screen
    keepRiverFlowing();
    //draws the boat
    updateBoat();
    //checks if the boat has collided with the edge of the river
    riverBoundaries();
    //displays current score on bottom left of the screen
    score();
    time += 1;
  }
}

/*
  Stores and sets background color
 */
void backgroundColor() {
  background(165, 209, 177);
}
/* 
 Displays and stores the score
 */
void score() {
  score = (int)time;
  fill(255, 200);
  textSize(16);
  textAlign(CENTER, BOTTOM);
  text("" + score, 35, 480);
}

/*
  Displays first screen seen
 Shows the instructions 
 Prompts the user to press TAB to continue
 */
void instructionScreen() {
  background(180, 222, 210);
  fill(255, 50);
  noStroke();
  rect(30, 30, 440, 350);
  fill(118, 176, 175);
  textSize(32);
  textAlign(CENTER, BOTTOM);
  text("River Runner", width/2, height/2 - 150);
  tint(255, 145);
  image(boat, (width/2)-35, height/2 - 120, 70, 70);
  textSize(10);
  fill(155, 194, 171);
  text("You are a sailor trying to get through", width/2, height/2 - 20);
  text("a very long river!", width/2, height/2 - 5);
  text("Make sure not to crash into the land!", width/2, height/2 + 20);
  fill(255);
  text("Use the potentiometer to navigate", width/2, height/2 + 45); 
  text("the river", width/2, height/2 + 60);
  fill(155, 194, 171);
  text("Make sure the potentiometer's arrow", width/2, height/2 + 85);
  text("is in the middle before starting!", width/2, height/2 + 100);

  textSize(16);
  fill(118, 176, 175, 200);
  text("Press TAB to continue", width/2, height/2 + 125);
}
/*
  Draws the individual lines of the river at the specified x-value
 */
void drawRiverLines( float riverSide, int i) {
  line(riverSide, i, riverSide+riverWidth, i+1);
  line(riverSide+riverWidth, i, riverSide+riverWidth, i+1);
}

void initialRiver() {
  for (int i = 500-1; i >= 0; i--) {
    //perlin noise; so that the river looks like it's naturally flowing
    offset = offset + .009;
    float riverLeftSide = (noise(offset) * width/2)+50;
    drawRiverLines(riverLeftSide, i);
    riverPosition.add(0, (int)riverLeftSide);
  }
}

/*
  Keeps the river flowing downards by updating the ArrayList that keeps track of the river's position at each y-value
 */
void keepRiverFlowing() {
  //this for loop speeds the river up every 200 iterations of the draw() function
  for (int i = 0; i < (time/250)+1 && i < 12; i++) {
    offset = offset + .009;
    float riverLeftSide = (noise(offset) * width/2)+50;
    riverPosition.add(0, (int)riverLeftSide);
    riverPosition.remove(500-1);
  }
  //draws the blue colored lines of the river
  for (int i = 0; i < 500; i++) {
    int riverSide = riverPosition.get(i);
    drawRiverLines(riverSide, i);
  }
}

/*
  Draws the boat; moves as the x value (boatCorner) changes through user input
 Speeds up the movement of the boat as the river speeds up
 */
void updateBoat() {
  //transparency of image
  tint(255, 150);
  
  //controls the speed of the boat based on the time elapsed in the game
  /*if (time > 1000) {
   boatMovement = 8;
   } else if (time > 750) {
   boatMovement = 7;
   } else if (time > 500) {
   boatMovement = 6;
   }
   */
   
  if (time == 0) {
    //sets the initial x value of the boat based on specific values of each round
    riverBoundary = riverPosition.get(435);
    boatCorner = -20 + riverBoundary + riverWidth/2;
    boatMovement = 5;
    
    //acts as an "origin", to be able to tell what values means moving left/right based on every game
    initialPotVal = inByte/8; //is inByte/8 to scale the values down for easy gameplay
  } else {
    if (inByte != 150) {
      //updating the boatCorner variable based on the potentiometer and its initial value
      boatCorner = boatCorner + ((inByte/8)-initialPotVal);
      //updates the position of the boat based on user input 
      image(boat, boatCorner, boatHeight, 45, 45);
    }
  }
}

/*  
 Stores the x value of the left edge of the river 
 Checks if the boat has crashed into an edge of the river
 */
void riverBoundaries() {
  riverBoundary = riverPosition.get(435);   
  if (riverBoundary+riverWidth <= boatCorner+45 || riverBoundary >= boatCorner) {
    crashed = true;
    screen = "game over";
  }
}

/*
  Displays the Game Over screen with the score, and prompts the user to press a key to restart the game
 */
void crashedScreen() {
  crashSound.play();
  delay(150);
  riverSound.stop();
  delay(400);
  noLoop(); //stops the animation
  noStroke();
  fill(245, 37, 37, 125);
  rect(80, 100, 340, 175);
  fill(255);
  //displays the text once the user crashes
  textSize(32);
  text("Game Over!", width/2, height/2 - 100); 
  textSize(16);
  text("score: " + score, width/2, height/2 - 30);
  textSize(12.5);
  text("press TAB to restart", width/2, height/2 + 10);
}

/*
 Creds: Arduino's Communication -> Graph example
 Allows the arduino to communicate with Processing
 Updates inByte based on potentiometer values, then used for boat x position
 */
void serialEvent (Serial arduinoPort) {
  //gets ASCII 
  String inString = arduinoPort.readStringUntil('\n');

  if (inString != null) {
    //gets rid of any extra spaces
    inString = trim(inString);
    //turns inString to a float
    inByte = float(inString);
    //maps inByte to the width of the river
    inByte = map(inByte, 0, 1023, 0, 150);
    println(inByte);
  }
}

/*
  Keeps track of the left and right movement of the boat based on user input
 Restarts the game once the user has crashed and pressed TAB
 */
void keyPressed() {
  /* 
   if (key == CODED) {
   if (keyCode == LEFT) {
   boatCorner -= boatMovement; //moves the boat to the left in increments by boatMovement
   } else if (keyCode == RIGHT) {
   boatCorner += boatMovement; //moves the boat to the right in increments by boatMovement
   }
   }
   */
  //happens once the user has crashed and presses the tab key to restart the game
  if (crashed && key == TAB) {
    loop();
    background(165, 209, 177);      
    time = 0;
    crashed = false;
    screen = "game";
    redraw();
    riverSound.loop();
  }
  //starts the game from the instructions screen
  if (screen == "start" && key == TAB) {
    screen = "game";
    startSound.jump(1.5);
    delay(300);
    riverSound.loop();
  }
}
