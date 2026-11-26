#include "lcd.h"


float front_temp = 0;
float front_setpoint = 0;
float front_duty = 0;

void escribir(const char *texto) {
  while (*texto) {
    lcd_dat(*texto);
    texto++;
  }
}

void setup() {
  lcd_init();

  lcd_cmd(0x80);          
  escribir("AAA");    

  lcd_cmd(0xC0);              
  escribir("HOLAA");
}

void loop() {
}