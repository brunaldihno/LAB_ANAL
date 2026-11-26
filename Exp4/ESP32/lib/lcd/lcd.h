#ifndef LCD_H
#define LCD_H

#include <Arduino.h>




#define LCD_RS_PIN  21 
#define LCD_RW_PIN  26
#define LCD_EN_PIN  22
#define LCD_D4_PIN  18
#define LCD_D5_PIN  19   
#define LCD_D6_PIN  23      
#define LCD_D7_PIN  27   

#define LCD_REFRESH_MS  50

void lcd_init();
void lcd_cmd(uint8_t cmd);
void lcd_dat(uint8_t dat);



class LCD {
public:
  void begin();
  void sendData(float sp, float tp, float dy);
};

#endif
