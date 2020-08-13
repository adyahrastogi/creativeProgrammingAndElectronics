/* Adyah Rastogi
 Forever Forest
 Final Project DES-INV 23
 Professor Michael Shiloh
 This program generates a forest of trees that keeps growing while taking input
 from Arduino (a potentiometer & photoresistor) for added variation
 */

import processing.serial.*;
Serial myPort;      //the port used to collect data from arduino

//store the sensor values that are received from arduino
float light = 0;      //photoresistor value, used to control growth of flowers
float potentAngleDelta = 0;      //potentiometer value, used to influence the direction the tree grows in

Tree tree1;      //first tree drawn on the screen
Tree tree2;      //second tree drawn 
Tree tree3;      //third tree drawn

boolean initialized = false;      //used to keep track of when the first tree is drawn, to draw the first 3 tree x frames apart
int firstTreeStart;      //at the beginning of the program, this is set to what frame the first tree is drawn at
int treeTimeInterval =  3;      //for the first three trees, draws the trees 3 frames apart
Tree newTree = null;      //the Tree object used to create the trees after the initial 3 trees
int col = 0;      //initializing the color of the trees


void setup() {
  //arduino to processing communication initialization
  myPort = new Serial(this, Serial.list()[4], 9600);
  myPort.bufferUntil('\n');

  //canvas 
  size(1200, 600);
  background(255);
  smooth();

  //initializing the first three trees drawn, along with their colors; each of the first 3 trees are evenly spaced on the canvas 
  tree1 = new Tree(int(width/5), 100, 110, #f7b5ab);
  tree2 = new Tree(int(width/2), 50, 110, #93c8db);
  tree3 = new Tree(int(width - width/5), 90, 110, #fada7a);
}

void draw() {
  //runs when the program begins, notes the frame count when the program begins drawing 
  if (!initialized) { 
    firstTreeStart = frameCount;
    initialized = true;
  }
  tree1.drawTree(); //draws the first tree 

  //after the interval (in frame counts), draws the second tree (named tree3 as it is the rightmost tree)
  if (frameCount > firstTreeStart + treeTimeInterval) { 
    tree3.drawTree();
  }
  //after the second tree is drawn, draws the third tree after the same interval
  if (frameCount > firstTreeStart + 2*treeTimeInterval) {
    tree2.drawTree();
  }


  //occurs after the first three trees are drawn, this is what keeps the trees redrawing and also fades the background

  //every 30 frames, creates a new tree at a random position with one of 6 colors (randomly chosen by colorPicker())
  if (frameCount % 30 == 0 ) {
    newTree = new Tree(int(random(100, 1100)), 50, 110, colorPicker());
  }
  //every 60 frames (2 trees), fades the background by drawing a semi-transparent rectangle over the background
  if (frameCount % 60 == 0) {
    noStroke();
    fill(255, 255, 255, 160);
    rect(0, 0, width, height);
  }
  //if the newTree object has been initialized, it will be drawn
  if (newTree != null) {
    newTree.drawTree();
  }

  delay(50);
}

//randomly picks a color for the new trees grown after the first three from 6 different specified colors
int colorPicker() {
  int randomPicker = floor(random(1, 7));

  if (randomPicker == 1) {
    return #f7b5ab;
  } else if (randomPicker == 2) {
    return #fada7a;
  } else if (randomPicker == 3) {
    return #93c8db;
  } else if (randomPicker == 4) {
    return #99aac4;
  } else if (randomPicker == 5) {
    return #8fab8e;
  } else if (randomPicker == 6) {
    return #a18bad;
  }

  return 0;
}

//Tree class, which creates trees out of branches (branch class below)
class Tree {

  ArrayList<Branch> currentBranchLayer = new ArrayList<Branch>();      //creates and stores tree's current layer of branches (grouped by generation)
  ArrayList<Branch> nextBranchLayer = new ArrayList<Branch>();      //creates and stores tree's previous layer of branches (grouped by generation)

  float numBranches = 2;      //the amount of branches that are produced by every new branch (ex. trunk branches into two, which each split into two more branches)

  int iteration = 0;      //synonymous to the generation of the tree branches, starts the tree at the trunk
  int maxIterations = 8;      //the maximum amount of times the branches can be drawn (limits # of generations)

  int translateVal;      //where the tree's trunk starts (x-value), user input

  int trunkSmallLim;      //the smallest the tree's thickness can be, user input
  int trunkLargeLim;      //the biggest the tree's thickness can be, user input 
  float trunk;      //based on the limits of the thickness, the size of the trunk is stored in this variable


  boolean multiColor = false;      //keeps track of if the tree has multiple colors of flowers, or not
  int col;      //the color of the flowers (the whole tree's flower if multiColor is false, if multiColor is true, then it will only be the first flower layer's color)

  //constructor
  Tree(int translateX, int small, int large, int treeColor) {
    translateVal = translateX;      //where the tree's trunk starts (x-value), user input

    trunkSmallLim = small;      //the smallest the tree's thickness can be, user input
    trunkLargeLim = large;      //the biggest the tree's thickness can be, user input 
    trunk = random(trunkSmallLim, trunkLargeLim);      //between on the limits of the thickness, the size of the trunk is randomly generated

    col = treeColor;
    int randomCol = floor(random(1, 9));      //based on random(), there is a 1/8 chance that the tree will have multiple colors of flowers
    if (randomCol == 1) {
      multiColor = true;      //if randomCol is 1, there will be several colors of flowers in the tree
    }
  }

  //method that draws the tree object
  void drawTree() {

    //randomly picks colors for every branch layer's flowers if multiColor was set to true
    if (multiColor) {
      col = colorPicker();
    }

    //tree wood color (dark brown)
    stroke(92, 75, 73);

    //based on starting trunk thickness of the tree, the thickness of the rest of the branches is decided
    strokeWeight(calculateStrokeweight(iteration));

    //translates the grid to where the trunk starts and rotates the grid (as the top right corner is (0,0)
    pushMatrix();
    translate(translateVal, height);
    rotate(radians(180));

    //draws the branch layers until the 8th generation is reached
    if (iteration < maxIterations) {

      if (iteration == 0) {
        //starts the tree with the trunk
        currentBranchLayer.add(new Branch(0, 0, 0, trunk));
      }

      //draws the branches based on their values (branch class)
      for (int j = 0; j < currentBranchLayer.size(); j++) {
        Branch currentBranch = currentBranchLayer.get(j);
        line(currentBranch.x1, currentBranch.y1, currentBranch.x2, currentBranch.y2);
      }

      //draws the flowers on the branches
      for (int j = 0; j < currentBranchLayer.size(); j++) {

        float lightR = random(0, 130);      //creates some randomness to determine if the layer of branches will have flowers or not

        if (light > 20 && (light > lightR*1.3 || light > 80)) {      //light is the value from the photoresistor, checks the conditions and then draws flowers
          Branch currentBranch = currentBranchLayer.get(j);
          noStroke();

          float flowerDiameter = random(5.0, 13.0);      //varies flower size
          float flowerTransparency = random(50, 230);      //varies flower color (by changing transparency)

          //draws the flower at the beginning of the new branch
          fill(col, flowerTransparency);
          circle(currentBranch.x1, currentBranch.y1, flowerDiameter);
        }

        //occurs at the end of a tree, so that the flowers are drawn at the ends of the branches (previously drawn at the beginning of the branches)
        if (iteration == maxIterations-1) {
          if (light > 20 && (light > lightR || light > 80)) {      //light is the value from the photoresistor, checks the conditions and then draws flowers
            Branch currentBranch = currentBranchLayer.get(j);
            noStroke();

            float flowerDiameter = random(4.0, 13.0);      //varies flower size
            float flowerTransparency = random(50, 255);      //varies flower color (by changing transparency)

            //draws the flower at the end of the last branch layer
            fill(col, flowerTransparency);
            circle(currentBranch.x2, currentBranch.y2, flowerDiameter);
          }
        }
      }

      //sets the values that affect the growth of the tree's branches
      if (iteration < maxIterations-1) {
        for (int j = 0; j < currentBranchLayer.size(); j++) {
          Branch currentBranch = currentBranchLayer.get(j);
          for (int k = 0; k < numBranches; k++) {
            //determines how big the next branch will be in relation to the current layer of branches' length
            float multiplier = random(0.6, 1.0);
            //sets the length of the new length for the next layer
            float newLen = currentBranch.len * multiplier;

            //determines the angle that the new branches should move by (based on their current values)
            float angleDelta = potentAngleDelta + random(-PI/4.5, PI/4.5);
            //sets the new angle for the next layer branch
            float newAngle = currentBranch.angle + angleDelta;

            //creates the new branches based on specified values
            Branch newBranch = new Branch(currentBranch.x2, currentBranch.y2, newAngle, newLen);
            //adds them to the next layer
            nextBranchLayer.add(newBranch);
          }
        }
        //the next branch layer becomes the current branch layer in preparation for the next generation's iteration
        currentBranchLayer.clear();
        currentBranchLayer.addAll(nextBranchLayer);
        nextBranchLayer.clear();
      }
      //steps the iteration value to continue drawing the tree
      iteration++;
    }
    popMatrix();
  }

  //method to determine the thickness of the branches (based on the starting size of the trunk)
  float calculateStrokeweight(int generation) {
    float stroke = (max(1, ((8 - generation))));
    return stroke*(trunk/100);
  }
}

//branch class, which stores information on every branch 
class Branch {
  //stores the coordinates to draw the lines with
  int x1; 
  int y1;
  int x2;
  int y2;

  float angle; 
  float len; 

  Branch(int x1, int y1, float angle, float len) {
    this.x1 = x1;
    this.y1 = y1;

    //bases the second coordinates off of the angle given by the user 
    this.x2 = int(x1 + len*sin(angle));
    this.y2 = int(y1 + len*cos(angle));

    this.len = len;
    this.angle = angle;
  }

  String toString() {
    return "("+x1+", "+y1+") -> ("+x2+", "+y2+"). Len: "+len+", Angle: "+angle+")";
  }
}

//referenced arduino example: virtualColorMixer
void serialEvent(Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    //gets rid of any extra spaces
    inString = trim(inString);
    // turns inString into an integer array
    float[] values = float(split(inString, ","));
    
    //since there are two sensors, checks if at least 2 values were received 
    if (values.length >= 2) {
      //maps potentiometer values to the range of angles that will be used by the program
      potentAngleDelta = map(values[0], 0, 1023, -PI/4.5, PI/4.5);
      //maps photoresistor values to 0-100
      light = map(values[1], 300, 1023, 0, 100);
    }
  }
}
