#ifndef LCD_H
#define LCD_H

#include <Arduino.h>

class LCD {
public:
    LCD();

    void iniciar();
    void saludar();
    int sumar(int a, int b);

private:
    int contador;
};

#endif
