
ArrayList<Branch> currentBranchLayer = new ArrayList<Branch>();
ArrayList<Branch> nextBranchLayer = new ArrayList<Branch>();

import processing.serial.*;

float numBranches = 2;        // red value
float light = 0;      // green value
float button = 0;       // blue value

float potentAngleDelta = 0;

Serial myPort;

int iteration = 0;
int maxIterations = 11;

void setup() {
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[4], 9600);
  myPort.bufferUntil('\n');

  size(600, 600);
  smooth();

  currentBranchLayer.add(new Branch(0, 0, 0, 100));
  background(255);
}

void draw() {
  strokeWeight(calculateStrokeweight(iteration));
  stroke(143, 133, 120);
  translate(width/2, height);
  rotate(radians(180));
  if (iteration < maxIterations) {
    for (int j = 0; j < currentBranchLayer.size(); j++) {
      Branch currentBranch = currentBranchLayer.get(j);
      line(currentBranch.x1, currentBranch.y1, currentBranch.x2, currentBranch.y2);
    }
    for (int j = 0; j < currentBranchLayer.size(); j++) {
      float lightRandom = random(0.1,1.0);
      if (light*lightRandom > 100/(iteration+1)) {

        Branch currentBranch = currentBranchLayer.get(j);
        noStroke();
        fill(255);
        float flowerDiameter = random(2.0, 6.0);
        float flowerTransparency = random(100, 255);
        circle(currentBranch.x2, currentBranch.y2, flowerDiameter);
        fill(247, 181, 171, flowerTransparency);
        circle(currentBranch.x2, currentBranch.y2, flowerDiameter);
      }
    }

    if (iteration < maxIterations-1) {
      for (int j = 0; j < currentBranchLayer.size(); j++) {
        Branch currentBranch = currentBranchLayer.get(j);
        for (int k = 0; k < numBranches; k++) {
          float multiplier = random(0.431, 1.0);
          float newLen = currentBranch.len * multiplier;

          float angleDelta = potentAngleDelta + random(-PI/7, PI/7);
          float newAngle = currentBranch.angle + angleDelta;

          Branch newBranch = new Branch(currentBranch.x2, currentBranch.y2, newAngle, newLen);
          nextBranchLayer.add(newBranch);
        }
      }

      currentBranchLayer.clear();
      currentBranchLayer.addAll(nextBranchLayer);
      nextBranchLayer.clear();
    }
  }
  if (iteration >= maxIterations) {
    for (int j = 0; j < currentBranchLayer.size(); j++) {

      if (light > 50) {

        Branch currentBranch = currentBranchLayer.get(j);
        noStroke();
        fill(255);
        float flowerDiameter = random(2.0, 6.0);
        float flowerTransparency = random(100, 255);
        circle(currentBranch.x2, currentBranch.y2, flowerDiameter);
        fill(247, 181, 171, flowerTransparency);
        circle(currentBranch.x2, currentBranch.y2, flowerDiameter);
      }
    }
  }

  delay(1000);
  iteration++;
}

float calculateStrokeweight(int generation) {
  return max(1, (6 - generation));
}

//mostly from arduino code (virtualColorMixer)
void serialEvent(Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
    // split the string on the commas and convert the resulting substrings
    // into an integer array:
    float[] values = float(split(inString, ","));
    // if the array has at least three elements, you know you got the whole
    // thing.  Put the numbers in the color variables:
    if (values.length >= 3) {
      // map them to the range 0-255:
      potentAngleDelta = map(values[0], 0, 1023, -PI/7, PI/7);
      light = map(values[1], 300, 1023, 0, 100);
      button = values[2];
    }
    println(potentAngleDelta);
  }
}

class Branch {
  int x1;
  int y1;

  int x2;
  int y2;

  float angle; //stored for ease of use
  float len; // stored for ease of use

  Branch(int x1, int y1, float angle, float len) {
    this.x1 = x1;
    this.y1 = y1;

    this.x2 = int(x1 + len*sin(angle));
    this.y2 = int(y1 + len*cos(angle));

    this.len = len;
    this.angle = angle;
  }

  String toString() {
    return "("+x1+", "+y1+") -> ("+x2+", "+y2+"). Len: "+len+", Angle: "+angle+")";
  }
}
