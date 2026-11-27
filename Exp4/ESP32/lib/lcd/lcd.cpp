// lcd.cpp — VERSIÓN DE PRUEBA
// Solo muestra un texto fijo para comprobar que el LCD y las conexiones funcionan.
// Usa el mismo lcd.h de siempre y no necesita ninguna variable del main.

#include "lcd.h"
// =====================================
// PROTOCOLO 4 BITS
// =====================================

// Pulso en Enable: el LCD lee D4..D7 cuando E baja de 1 a 0
static void lcd_pulse() {
  digitalWrite(LCD_EN_PIN, LOW);
  delayMicroseconds(1);
  digitalWrite(LCD_EN_PIN, HIGH);
  delayMicroseconds(1);
  digitalWrite(LCD_EN_PIN, LOW);
  delayMicroseconds(100);
} 

// Pone 4 bits en D4..D7 y da el pulso
static void lcd_write4(uint8_t value) {
  digitalWrite(LCD_D4_PIN, value & 0x01);
  digitalWrite(LCD_D5_PIN, (value >> 1) & 0x01);
  digitalWrite(LCD_D6_PIN, (value >> 2) & 0x01);
  digitalWrite(LCD_D7_PIN, (value >> 3) & 0x01);
  lcd_pulse();
}

// Envía un comando (RS = 0)
void lcd_cmd(uint8_t cmd) {
  digitalWrite(LCD_RS_PIN, LOW);
  digitalWrite(LCD_RW_PIN, LOW);
  lcd_write4(cmd >> 4);
  lcd_write4(cmd & 0x0F);
}

// Envía un dato / letra (RS = 1)
void lcd_dat(uint8_t dat) {
  digitalWrite(LCD_RS_PIN, HIGH);
  digitalWrite(LCD_RW_PIN, LOW);
  lcd_write4(dat >> 4);
  lcd_write4(dat & 0x0F);
}

// Inicializa el LCD en modo 4 bits, 2 líneas
void lcd_init() {
  pinMode(LCD_RS_PIN, OUTPUT);
  pinMode(LCD_RW_PIN, OUTPUT);
  pinMode(LCD_EN_PIN, OUTPUT);
  pinMode(LCD_D4_PIN, OUTPUT);
  pinMode(LCD_D5_PIN, OUTPUT);
  pinMode(LCD_D6_PIN, OUTPUT);
  pinMode(LCD_D7_PIN, OUTPUT);

  digitalWrite(LCD_RW_PIN, LOW);
  digitalWrite(LCD_RS_PIN, LOW);
  digitalWrite(LCD_EN_PIN, LOW);
  delay(50);

  lcd_write4(0x03);
  delay(5);
  lcd_write4(0x03);
  delayMicroseconds(150);
  lcd_write4(0x03);
  lcd_write4(0x02);        // desde aquí: modo 4 bits

  lcd_cmd(0x28);           // 4 bits, 2 líneas
  lcd_cmd(0x0C);           // display on, cursor off
  lcd_cmd(0x06);           // cursor avanza a la derecha
  lcd_cmd(0x01);           // limpiar
  delay(2);
}

// Escribe un texto letra por letra
static void lcd_writeText(const char* text) {
  while (*text) {
    lcd_dat(static_cast<uint8_t>(*text));
    text++;
  }
}

// =====================================
// OBJETO lcd (lo que llama el main)
// =====================================

// Inicializa y escribe el texto de prueba UNA vez
void LCD::begin() {
  lcd_init();
};

float LCD::Interpolar(const float* xs, const float* ys, int n, float data){
  if (data <= xs[0])     return ys[0];
  if (data >= xs[n - 1]) return ys[n - 1];

  for (int i = 0; i < n - 1; i++) {
    if (data < xs[i + 1]) {
      float m = (ys[i + 1] - ys[i]) / (xs[i + 1] - xs[i]);
      return ys[i] + (data - xs[i]) * m;
    };
    }; 
    return 0;
  };

const float X[] = {0, 25, 50, 75, 100};
const float Y[] = {0, 216, 372, 456, 502};



void LCD::SplitFloat(float f, char* out) {
  if (f < 0)    f = 0;       // limitar al rango que se puede mostrar
  if (f > 99.9) f = 99.9;

  int n = (int)(f * 10 + 0.5f);   // 23.7 -> 237, y evita el error 23.6999

  int decena  = n / 100;          // 2
  int unidad  = (n / 10) % 10;    // 3
  int decimal = n % 10;           // 7

  out[0] = '0' + decena;
  out[1] = '0' + unidad;
  out[2] = '.';
  out[3] = '0' + decimal;
  out[4] = '\0';
};


void LCD::SplitFloat_mW (float f, char* out) {
  if (f < 0)    f = 0;       // limitar al rango que se puede mostrar
  if (f > 99.9) f = 99.9;

  int n = (int)(f * 10 + 0.5f);   // 23.7 -> 237, y evita el error 23.6999

  int decena  = n / 100;          // 2
  int unidad  = (n / 10) % 10;    // 3
  int decimal = n % 10;           // 7

  out[0] = '0' + decena;
  out[1] = '0' + unidad;
  out[2] = '0' + decimal;
  out[3] = '\0';
};


void LCD::sendData(float sp, float tp, float dy){

  char sp_str[5];
  char tp_str[5];
  char dy_str[4];
  float valor = Interpolar(X, Y, 5, dy);
  SplitFloat(sp, sp_str);
  SplitFloat(tp, tp_str);
  SplitFloat_mW(valor/10, dy_str);

  lcd_cmd(0x80);
  lcd_writeText("T:");
  lcd_writeText(tp_str);
  lcd_writeText("C  R:");
  lcd_writeText(sp_str);
  lcd_writeText("C");


  lcd_cmd(0xC0);
  lcd_writeText("P:");
  lcd_writeText(dy_str);
  lcd_writeText("mW");

}