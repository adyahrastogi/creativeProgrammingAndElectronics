
/*
   Adyah Rastogi
   Creative Programming and Electronics
   July 27- Musical Instrument
*/
#include <Servo.h>


// Defining the frequencies for the notes used for the project
int noteG =  784;
int noteA =  880;
int noteB = 988;
int noteC =  1047;
int noSound = 0;

// Keeps track of what note should be played currently
int currentNote = noSound;
//200 ms between every note
int noteLength = 200;


// Initializing pin locations of every sensor
int noteGButton = 5;
int noteAButton = 7;
int noteBButton = 6;
int noteCButton = 4;

// Piezo Buzzer pin location
int buzzer = 8;


// Initializing the button states for every button sensor (pressed or not pressed)
int buttonStateG = digitalRead(noteGButton);
int buttonStateA = digitalRead(noteAButton);
int buttonStateB = digitalRead(noteBButton);
int buttonStateC = digitalRead(noteCButton);

// Servo object that is used to ring the bell
Servo bellRinger;

// Keeps track of servo position
int pos = 0;
// Tells if the servo should be moving, based on light sensor values
boolean isRunning = false;
// Light sensor value, used to keep track of whether the servo should be moving
int sensorValue;

void setup() {
  // Setting button pins to input
  pinMode(noteGButton, INPUT);
  pinMode(noteAButton, INPUT);
  pinMode(noteBButton, INPUT);
  pinMode(noteCButton, INPUT);


  // Attaches the bell ringer servo to pin 12
  bellRinger.attach(12);
  // sets the light sensor value to the value of the pin
  sensorValue = analogRead(A2);
}


void loop() {
  // Checks for buttons being pressed and plays notes based on the buttons' states
  checkButtonState();
  buttonPressed();
  tone(buzzer, currentNote, noteLength);
  // Checks the light sensor value and based on the value, changes the position of the servo to ring the bell
  checkLightSensor();
  if (isRunning) {
    ringBell();
    // Set isRunning to false to make sure the servo only moves when specified by the light sensor
    isRunning = false;
  }
}

// When called, updates the button states of each of the four buttons
void checkButtonState() {
  buttonStateG = digitalRead(noteGButton);
  buttonStateA = digitalRead(noteAButton);
  buttonStateB = digitalRead(noteBButton);
  buttonStateC = digitalRead(noteCButton);
}

// When called, checks if a button is pressed and also sets the frequency for the current note to play respectively
void buttonPressed() {
  if (buttonStateG == 1) {
    currentNote = noteG;
  }
  else if (buttonStateA == 1) {
    currentNote = noteA;
  }
  else if (buttonStateB == 1) {
    currentNote = noteB;
  }
  else if (buttonStateC) {
    currentNote = noteC;
  }
  else {
    currentNote = noSound;
  }
}

// When called, moves the servo position to ring the bell
void ringBell() {
  for (pos = 90; pos <= 180; pos += 4) { // Starts the servo at 90 degrees and moves until 180 degrees
    // Step of 4 degrees until the end (quick, so that the bell is rung)

    // Actually sets the value of the servo to the new position every iteration of the loop
    bellRinger.write(pos);
    // Waits for the servo to reach the position
    delay(15);
  }
  for (pos = 180; pos >= 90; pos -= 4) { // Returns the servo from 180 degrees to 90 degrees
    // Sets the value of the servo to the new position every iteration of the loop
    bellRinger.write(pos);
    // Waits for the servo to reach the position
    delay(15);
  }
}

// When called, updates the value of the light sensor value
void checkLightSensor() {
  sensorValue = analogRead(A2);
  // If the sensor value if less than 500, it is being covered, so whenever the light sensor is covered, the bell rings
  if (sensorValue < 500) {
    isRunning = true;
  }

}
