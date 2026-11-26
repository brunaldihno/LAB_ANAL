#include "lcd.h"

static void lcd_pulse() {
  digitalWrite(LCD_EN_PIN, LOW);
  delayMicroseconds(1);
  digitalWrite(LCD_EN_PIN, HIGH);
  delayMicroseconds(1);
  digitalWrite(LCD_EN_PIN, LOW);
  delayMicroseconds(100);
}

static void lcd_write4(uint8_t value) {
  digitalWrite(LCD_D4_PIN, value & 0x01);
  digitalWrite(LCD_D5_PIN, (value >> 1) & 0x01);
  digitalWrite(LCD_D6_PIN, (value >> 2) & 0x01);
  digitalWrite(LCD_D7_PIN, (value >> 3) & 0x01);
  lcd_pulse();
}

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
  delay(40);

  lcd_write4(0x03);
  delay(5);
  lcd_write4(0x03);
  delayMicroseconds(150);
  lcd_write4(0x03);
  lcd_write4(0x02);

  lcd_cmd(0x28);
  lcd_cmd(0x0C);
  lcd_cmd(0x06);
  lcd_cmd(0x01);
  delay(2);
}

void lcd_cmd(uint8_t cmd) {
  digitalWrite(LCD_RS_PIN, LOW);
  digitalWrite(LCD_RW_PIN, LOW);
  lcd_write4(cmd >> 4);
  lcd_write4(cmd & 0x0F);
}

void lcd_dat(uint8_t dat) {
  digitalWrite(LCD_RS_PIN, HIGH);
  digitalWrite(LCD_RW_PIN, LOW);
  lcd_write4(dat >> 4);
  lcd_write4(dat & 0x0F);
}

static void lcd_writeText(const char* text) {
  while (*text) {
    lcd_dat(static_cast<uint8_t>(*text));
    text++;
  }
}

LCD lcd;

void LCD::begin() {
  lcd_init();
}

void LCD::sendData() {
  char line1[17];
  char line2[17];

  snprintf(line1, sizeof(line1), "T:%5.1f SP:%5.1f", front_temp, front_setpoint);
  snprintf(line2, sizeof(line2), "D:%5.1f%%", front_duty);

  lcd_cmd(0x80);
  lcd_writeText(line1);
  lcd_cmd(0xC0);
  lcd_writeText(line2);
}