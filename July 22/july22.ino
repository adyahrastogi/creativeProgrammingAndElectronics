

int led1 = 9;           // the PWM pin the LED is attached to
int brightness = 0;    // how bright the LED is
int sensorValue = 800;
int fadeAmount;
int fadeDirection = 1;

int led2 = 6;
int count = 0;
int push = 11;
int ledState = LOW;
unsigned long previousMillis = 0;
int interval = 0;
int ledClicks = 0;

// the setup routine runs once when you press reset:
void setup() {
  // declare pin 9 to be an output:
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  Serial.begin(9600);
}

// the loop routine runs over and over again forever:
void loop() {
  controlAnalogLed();
  controlDigitalLed();
}

void controlDigitalLed() {
  unsigned long currentMillis = millis();
  ledState = LOW;
  int buttonState = digitalRead(push);
  if (buttonState == 1) {
    ledClicks = 4;
    previousMillis = currentMillis;

  }
  Serial.println(buttonState);
  if (ledClicks > 0) {
    if (ledClicks == 4) {
      interval = 0;
    } else if (ledClicks == 3) {
      interval = 100;
    }
    else if (ledClicks == 2) {
      interval = 650;
    } else if (ledClicks == 1) {
      interval = 100;
    }

    if (currentMillis - previousMillis >= interval) {
      previousMillis = currentMillis;
      ledState = HIGH;
      ledClicks--;
    }
  }
  digitalWrite(led2, ledState);
}


void controlAnalogLed() {

  // set the brightness of pin 9:
  sensorValue = analogRead(A2);

  fadeAmount =  (int) ((1100 - sensorValue) / 100);

  // change the brightness for next time through the loop:
  brightness = brightness + fadeAmount * fadeDirection;
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
