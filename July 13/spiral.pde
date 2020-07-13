/* Adyah Rastogi
Creative Programming and Electronics Summer 2020
Professor Michael Shiloh
Description: 
July 13 Assignment: Creates spirals of different colors
*/

void setup() {
  size(3150, 1000);
  smooth();
  background(255, 239, 219);
  noLoop();
} 

void draw() {
  //leftmost group of spirals (oranges & yellows)
  createSpiral(220, 10.1, 1.005, 500, 500, 30, 30, 1., 232, 115, 26, 70, 1); 
  createSpiral(220, 10.2, 1.01, 500, 500, 30, 30, 1., 235, 174, 52, 70, 1);
  createSpiral(220, 10.3, 1.015, 500, 500, 30, 30, 1., 237, 195, 71, 70, 1.);

  //middle group of spirals (blues & greens)
  createSpiral(220, 10.1, 1.005, 1500, 500, 30, 30, 1., 82, 170, 94, 50, 1); 
  createSpiral(220, 10.2, 1.01, 1500, 500, 30, 30, 1., 58, 174, 216, 100, 1);
  createSpiral(220, 10.3, 1.015, 1500, 500, 30, 30, 1., 82, 170, 138, 100, 1.);

  //rightmost group of spirals (purple-ish + greens)
  createSpiral(220, 10.1, 1.005, 2500, 500, 30, 30, 1., 125, 134, 156, 100, 1); 
  createSpiral(220, 10.2, 1.01, 2500, 500, 30, 30, 1., 162, 171, 171, 100, 1);
  createSpiral(220, 10.3, 1.015, 2500, 500, 30, 30, 1., 180, 196, 174, 100, 1.);
}

void createSpiral(float degreesToRotate, float initExtraDegreesToRotate, float extraDegreesToRotate, int startX, int startY, 
  int currentX, int currentY, float scale, int redVal, int greenVal, int blueVal, int opacity, float strokeWeight) {
  strokeWeight(strokeWeight);

  for (int i = 0; i<31; i++) {
    pushMatrix();
    translate(startX, startY);
    rotate(radians(degreesToRotate));
    scale(scale);
    //set line color & opacity
    stroke(redVal, greenVal, blueVal, opacity);
    //draw line from new origin (after rotation and translations) to specified point
    line(0, 0, currentX, currentY);
    //set start values to the specified point (in order to translate to this point in the next iteration)
    startX = currentX;
    startY = currentY;
    //increase opacity at a faster rate once the 15th line is drawn
    if (i>15) {
      opacity += 8;
    } else {
      opacity += 4;
    }
    //before the fourth line is drawn, increase the scale by 0.025 every iteration
    if (i<4) {
      scale+=.025;
      degreesToRotate += initExtraDegreesToRotate; //increased so that the angles aren't too small in the beginning
    }
    //unless the degreesToRotate exceeds 300, add more every iteration (keeps the spiral growing)
    if (degreesToRotate <= 300) {
      degreesToRotate += extraDegreesToRotate;
    }
  }
  /* the limit for pushMatrix() is 32 calls- need to revert the grid back to how it started in order 
   be able to call the createSprial() function several times */
  for (int i = 0; i<31; i++) {
    popMatrix();
  }
}
