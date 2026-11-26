#include "lcd.h"

LCD::LCD() {
    contador = 0;
}

void LCD::iniciar() {
    Serial.println("MiControlador iniciado");
}

void LCD::saludar() {
    Serial.println("Hola desde mi libreria!");
    contador++;
}

int LCD::sumar(int a, int b) {
    return a + b;
}
