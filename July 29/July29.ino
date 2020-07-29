
void setup() {
  Serial.begin(9600);
}

void loop() {
  // sending values of potentiometer by serial communication (potentiometer at pin A0)
  Serial.println(analogRead(A0));
  // wait for stabilization
  delay(10);
}
