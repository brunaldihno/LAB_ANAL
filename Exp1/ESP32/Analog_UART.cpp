#include <Arduino.h>

HardwareSerial MySerial(1);
const int TX_PIN = 25;
const int ADC_PIN = 34;

void setup() {
  //Serial.begin(115200);
  MySerial.begin(9600, SERIAL_8N1, -1, TX_PIN);
}

void loop() {
  static uint16_t mv = 0;

  mv = analogReadMilliVolts(ADC_PIN);
  
  // Enviar 2 bytes, LSB primero
  MySerial.write((uint8_t)(mv >> 8));    // Byte alto
  MySerial.write((uint8_t)(mv & 0xFF));  // Byte bajo

  //Serial.println(mv);
}
