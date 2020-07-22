/* Adyah Rastogi
    Creative Programming and Electronics- July 22
*/
int led1 = 9; //blue LED pin
int brightness = 0; //keeps track of brightness level
int sensorValue = 800; //what the value of sensor is initially, chosen because 800 is what the value usually is
int fadeAmount; //what interval to add every time looped
int fadeDirection = 1; //keeps track of becoming brighter or dimmer

int led2 = 6; //red LED pin
int push = 11; //switch pin
int ledState = LOW; //initial state
unsigned long previousMillis = 0; //keeps track of time (blinkWithoutDelay)
int interval = 0; //how much time between blinks
int ledClicks = 0; //how many times the led has blinked

// the setup routine runs once when you press reset:
void setup() {
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  controlAnalogLed(); //blue LED that fades in and out faster when less light, slower when more light
  controlDigitalLed(); //red LED that blinks 2 times, pauses, then blinks another two times, similar to a heartbeat
}

//allows the LED to blink two times, waits, then another two times once the switch is pressed
void controlDigitalLed() {
  unsigned long currentMillis = millis(); //current time (blinkWithoutDelay)
  ledState = LOW;
  int buttonState = digitalRead(push); //the following is done every time the button is pressed
  if (buttonState == 1) {
    ledClicks = 4;
    previousMillis = currentMillis;

  }
  Serial.println(buttonState);
  if (ledClicks > 0) {
    if (ledClicks == 4) { //first blink right as the switch is pressed
      interval = 0;
    } else if (ledClicks == 3) {
      interval = 100; //second blink soon after the first one
    }
    else if (ledClicks == 2) {
      interval = 650; //third blink after .65 seconds (small pause)
    } else if (ledClicks == 1) {
      interval = 100; //fourth blink soon after the third, like a series of 2 heartbeats
    }

    if (currentMillis - previousMillis >= interval) {
      previousMillis = currentMillis;
      ledState = HIGH; //sets the led to high brightness (on)
      ledClicks--; //controls which blink (out of the four) is running
    }
  }
  digitalWrite(led2, ledState);
}

//fades the led in and out faster when there is less light, and slower when there is more light
void controlAnalogLed() {

  sensorValue = analogRead(A2); //setting  sensorValue to the value of the photoresistor is

  //controls how fast the fading in and out is
  fadeAmount =  (int) ((1100 - sensorValue) / 100); //sensorValue is subtracted from 1100, because this is the max value (for me)

  // change the brightness for next time through the loop:
  brightness = brightness + fadeAmount * fadeDirection;

  //makes sure that the brightness never becomes less than 0 or greater than 255
  if (brightness < 0) { 
    brightness = 0;
  }
  if (brightness > 255) {
    brightness = 255;
  }

  // reverse the direction of the fading at the ends of the fade:
  if (brightness <= 0 || brightness >= 255) {
    fadeDirection = -fadeDirection;
  }

  analogWrite(led1, brightness);
  Serial.println(sensorValue);
}
