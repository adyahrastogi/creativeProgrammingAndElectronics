/* Adyah Rastogi
 Creative Programming and Electronics-- July 15
 Professor Michael Shiloh
 
 Description: You are a sailor trying to get through a very long river! 
 The river slowly speeds up and you must make sure not to crash!
 Use the left and right arrow keys to navigate the river.
 */

float offset = 5;
int riverWidth = 150;
float time = 0;
float speed = 30;
//stores the positions of each line in the river (to push the river down)
ArrayList<Integer> riverPosition = new ArrayList(); 
PImage boat;
float boatCorner;
int boatHeight = 400;
int riverBoundary;
PFont atari;
boolean crashed = false;
int score;

void setup() {
  size(500, 500);
  //creds to Freepik (https://www.flaticon.com/authors/freepik)
  boat = loadImage("sailboat.png");
  //game-like font
  atari = createFont("AtariFont.ttf", 16); 
  textFont(atari);
}

void draw() {
  frameRate(35);
  stroke(74, 176, 217);
  //happens once the user crashes, in order to prompt the restarting of the game 
  if (crashed) {
    noLoop(); //stops the animation
    noStroke();
    fill(245, 37, 37, 125);
    rect(100, 100, 300, 175);
    fill(255);
    //displays the text once the user crashes
    textSize(32);
    text("You lost!", width/2, height/2 - 100); 
    textSize(16);
    text("score: " + score, width/2, height/2 - 30);
    textSize(13);
    text("press tab to restart", width/2, height/2 + 10);
  } else {
    //keeps track of the score (based on time)
    score = (int)time; 
    //green background
    background(165, 209, 177);
    //starts the game with river drawn that spans the entire screen
    if (time == 0) {
      loop();
      for (int i = 500-1; i >= 0; i--) {
        //perlin noise; so that the river looks like it's naturally flowing
        offset = offset + .009;
        float riverLeftSide = (noise(offset) * width/2)+50;
        line(riverLeftSide, i, riverLeftSide+riverWidth, i+1);
        line(riverLeftSide+riverWidth, i, riverLeftSide+riverWidth, i);
        riverPosition.add(0, (int)riverLeftSide);
      }
    } 
    //after the initial screen, loads more of the river and pushes the bottom out of the screen
    //this for loop speeds the river up every 90 iterations of the draw() function
    for (int i = 0; i < (time/90)+2 && i < 12; i++) {
      offset = offset + .009;
      float riverLeftSide = (noise(offset) * width/2)+50;
      riverPosition.add(0, (int)riverLeftSide);
      riverPosition.remove(500-1);
    }
    //draws the blue colored lines of the river
    for (int i = 0; i < 500; i++) {
      int riverSide = riverPosition.get(i);
      line(riverSide, i, riverSide+riverWidth, i+1);
      line(riverSide+riverWidth, i, riverSide+riverWidth, i+1);
    }

    //stores the x value of the left edge of the river
    riverBoundary = riverPosition.get(435);   
    //sets the initial x value of the boat based on specific values of each round
    if (time == 0) {
      riverBoundary = riverPosition.get(435);
      boatCorner = -20 + riverBoundary + riverWidth/2;
    }

    //draws the boat; moves as the x value (boatCorner) changes through user input
    image(boat, boatCorner, boatHeight, 45, 45);
    //transparency of image
    tint(255, 150);

    //displays current score on bottom left of the screen
    textSize(16);
    textAlign(CENTER, BOTTOM);
    text("" + score, 35, 480);

    //checks if the boat has collided with the edge of the river
    if (riverBoundary+riverWidth <= boatCorner+45 || riverBoundary >= boatCorner) {
      crashed = true;
    }
  }

  time += 1;
}

//keeps track of the left and right values of the boat 
void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      boatCorner -= 5; //moves the boat to the left in increments of 5
    } else if (keyCode == RIGHT) {
      boatCorner += 5; //moves the boat to the right in increments of 5
    }
  }
  //happens once the user has crashed and presses the tab key to restart the game
  if (crashed && key == TAB) {
    loop();
    background(165, 209, 177);      
    time = 0;
    crashed = false;
    redraw();
  }
}
