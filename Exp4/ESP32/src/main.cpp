#include <Arduino.h>
#include "web.h"
#include "lcd.h"

// =====================================
// CONFIGURACIÓN
// =====================================

#define PWM_PIN  25
#define ADC_PIN  34

#define CONTROL_FREQ 100
#define WEB_FREQ     20

#define MIN_DUTY 0
#define BASE_DUTY 50
#define MAX_DUTY 100

#define DUTY_2_PWM 2.55

// =====================================
// VARIABLES
// =====================================

// variables de frontend (web y lcd)

float front_temp = 20.0;
float front_duty = 50.0;

float front_setpoint = 30.0;
float front_Kp = 1.0;
float front_Ki = 1.0;

uint32_t tiempo = 0;
float timestamp = 0.0;

LCD lcd;

// variables de backend (controlador)

float back_setpoint = 30.0;
float back_Kp = 1.0;
float back_Ki = 1.0;

float back_filtered_temp = 20.0;
float measured_temp = 20.0;

float integral = 0.0;

float a = 0.9;

float temp_gain = 46.15;
float temp_offest = 6.7;

float back_duty = 50.0;

float pwm_value = 127.5;

uint32_t last_time = 0;
uint32_t current_time = 0;
float dt = 0;

uint32_t milivolts = 0;

float error = 0;

// variables de traspaso

portMUX_TYPE controlMux = portMUX_INITIALIZER_UNLOCKED;

float trans_temp = 20;
float trans_duty = 50;
float trans_Kp = 1;
float trans_Ki = 1;
float trans_setpoint = 30.0;

// =====================================
// Función de Control
// =====================================

void controlTask(void *parameter) {

    last_time = micros(); 

    const TickType_t period = pdMS_TO_TICKS(10);

    TickType_t lastWakeTime = xTaskGetTickCount();

    while (true) {

        milivolts = analogReadMilliVolts(ADC_PIN);
        measured_temp = (float)milivolts / temp_gain + temp_offest;
        back_filtered_temp = a * back_filtered_temp + (1.0 - a) * measured_temp;

        current_time = micros();
        dt = (current_time - last_time) / 1000000.0f;
        last_time = current_time;

        // =================================
        // LEER VARIABLES COMPARTIDAS
        // =================================

        portENTER_CRITICAL(&controlMux);

        back_setpoint = trans_setpoint;
        back_Kp = trans_Kp;
        back_Ki = trans_Ki;

        portEXIT_CRITICAL(&controlMux);

        // =================================
        // CONTROL PID
        // =================================

        error = back_filtered_temp - back_setpoint;

        integral += back_Ki * error * dt;

        integral = constrain(integral, -(float)MAX_DUTY/2, (float)MAX_DUTY/2);

        back_duty = back_Kp * error + integral + (float)BASE_DUTY;
        back_duty = constrain(back_duty, (float)MIN_DUTY, (float)MAX_DUTY);

        pwm_value = back_duty * DUTY_2_PWM;

        // =================================
        // ACTUACIÓN
        // =================================

        analogWrite(PWM_PIN, (int)pwm_value);


        // =================================
        // PUBLICAR VARIABLES
        // =================================

        portENTER_CRITICAL(&controlMux);

        trans_temp = back_filtered_temp;
        trans_duty = back_duty;

        portEXIT_CRITICAL(&controlMux);

        // =================================
        // ESPERAR SIGUIENTE CICLO
        // =================================

        vTaskDelayUntil(&lastWakeTime, period);

    }

}

// =====================================
// Función de Control
// =====================================


void webTask(void *parameter) {

    const TickType_t period = pdMS_TO_TICKS(50);

    TickType_t lastWakeTime = xTaskGetTickCount();

    while (true) {

        // =================================
        // PUBLICAR TEMPERATURA
        // =================================

        front_setpoint = web.getSetpoint();
        front_Kp = web.getKp();
        front_Ki = web.getKi();

        portENTER_CRITICAL(&controlMux);

        trans_setpoint = front_setpoint;
        trans_Kp = front_Kp;
        trans_Ki = front_Ki;
        front_duty = trans_duty;
        front_temp = trans_temp;

        portEXIT_CRITICAL(&controlMux);

        tiempo = millis();
        timestamp =(float)tiempo / 1000.0f;

        // Enviar información
        web.sendData(
            front_setpoint,
            front_Kp,
            front_Ki,
            front_temp,
            front_duty,
            timestamp
        );

        lcd.sendData(30.3, 20.6, 16.6);

        // =================================
        // ESPERAR SIGUIENTE CICLO
        // =================================

        vTaskDelayUntil(&lastWakeTime, period);

    }

}


// =====================================
// SETUP
// =====================================

void setup() {

    Serial.begin(115200);

    // =================================
    // HARDWARE
    // =================================

    pinMode(PWM_PIN, OUTPUT);

    analogReadResolution(12);

    // =================================
    // MÓDULOS
    // =================================

    web.begin();

    lcd.begin();

    // =================================
    // TAREA DE CONTROL
    // =================================

    xTaskCreatePinnedToCore(
        controlTask,
        "Control",
        4096,
        NULL,
        4,
        NULL,
        1
    );

    // =================================
    // TAREA WEB
    // =================================

    xTaskCreatePinnedToCore(
        webTask,
        "Web",
        6144,
        NULL,
        1,
        NULL,
        0
    );

}

void loop() {

    vTaskDelay(portMAX_DELAY);

}