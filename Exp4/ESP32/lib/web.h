#ifndef WEB_H
#define WEB_H

#include <Arduino.h>
#include <ESPAsyncWebServer.h>
#include <Preferences.h>

class Web {

public:

    // Inicialización del servidor
    bool begin();

    // Envío de datos al navegador
    void sendData();

    // Actualización de variables desde main.cpp
    void setTemperature(float value);

    // Lectura de setpoints
    float getSetpoint1();
    float getSetpoint2();

    // Lectura del estado del LED
    bool getLedState();

private:

    // Servidor y WebSocket
    AsyncWebServer server{80};
    AsyncWebSocket ws{"/ws"};

    // Almacenamiento no volátil
    Preferences preferences;

    // Variables compartidas
    float temperatura = 25.5;
    float setpoint_1 = 30.0;
    float setpoint_2 = 35.0;

    bool ledState = false;

    // Sincronización entre tareas
    portMUX_TYPE dataMux = portMUX_INITIALIZER_UNLOCKED;

    // Pin de LED
    const int LED_PIN = LED_BUILTIN;

    // Configuración WiFi
    const char* ssid = "ESP32_CONTROL";
    const char* password = "12345678";

    // Callback WebSocket
    static void onWebSocketEvent(
        AsyncWebSocket *server,
        AsyncWebSocketClient *client,
        AwsEventType type,
        void *arg,
        uint8_t *data,
        size_t len
    );

    // Procesamiento de mensajes
    void handleWebSocketEvent(
        AsyncWebSocketClient *client,
        AwsEventType type,
        void *arg,
        uint8_t *data,
        size_t len
    );

    // Procesamiento de comandos
    void processMessage(const char* msg);

    // Instancia utilizada por el callback estático
    static Web* instance;
};

// Instancia global
extern Web web;

#endif
