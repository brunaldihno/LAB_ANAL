#include <Arduino.h>

// put function declarations here:
int myFunction(int, int);
HardwareSerial MySerial(1);
const int TX_PIN = 25;

const uint16_t mensajes[] = {
  0x0CE4,
  0x0672,
  0x0000,
  0x0672
};

const int NUM_MENSAJES = 4;



void setup() {
  Serial.begin(115200);
  MySerial.begin(9600, SERIAL_8N1, -1, TX_PIN);
}

void loop() {
  static int indice = 0;

  uint16_t mensaje = mensajes[indice];

  // Enviar 2 bytes, LSB primero
  MySerial.write((uint8_t)(mensaje >> 8));    // Byte alto
  MySerial.write((uint8_t)(mensaje & 0xFF));  // Byte bajo

  // Serial.println("mensaje");
  // Siguiente mensaje
  indice = (indice + 1) % NUM_MENSAJES;

  delay(2000);
}

// put function definitions here:
int myFunction(int x, int y) {
  return x + y;
}
