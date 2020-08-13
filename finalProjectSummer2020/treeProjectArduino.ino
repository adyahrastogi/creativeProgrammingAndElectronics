const int potentiometer = A1;	//pin potentiometer is connected to
const int light = A2;	//pin photoresistor is connected to

void setup() {
  Serial.begin(9600);
}

void loop() {
  Serial.print(analogRead(potentiometer)); //prints the potentiometer values
  Serial.print(",");
  Serial.println(analogRead(light)); //prints the photoresistor values
}
