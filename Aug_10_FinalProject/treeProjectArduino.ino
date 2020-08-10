
const int potentiometer = A1;	
const int light = A2;	
const int button = 11;		

void setup() {
  Serial.begin(9600);
}

void loop() {
  Serial.print(analogRead(potentiometer));
  Serial.print(",");
  Serial.print(analogRead(light));
  Serial.print(",");
  Serial.println(digitalRead(button));
}
