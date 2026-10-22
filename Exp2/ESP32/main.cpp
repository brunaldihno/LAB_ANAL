#include <Arduino.h>

HardwareSerial MySerial(1);
const int TX_PIN = 25;
const int ADC_PIN = 34;

void setup() {
  MySerial.begin(115200, SERIAL_8N1, -1, TX_PIN);
}

void loop() {
  uint16_t mv = analogReadMilliVolts(ADC_PIN);

  uint8_t mv_byte = (uint8_t)((mv * 255UL) / 3300UL);

  MySerial.write(mv_byte);
}
