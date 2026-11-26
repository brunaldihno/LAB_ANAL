#ifndef WEB_H
#define WEB_H

#include <Arduino.h>
#include <ESPAsyncWebServer.h>
#include <Preferences.h>

class Web {

public:

    Web();

    void begin();

    // Enviar datos y actualizar la página
    void sendData(
        float setpoint,
        float Kp,
        float Ki,
        float temp,
        float duty,
        float timestamp
    );

    // Obtener parámetros ingresados desde la página
    float getSetpoint();
    float getKp();
    float getKi();

private:

    AsyncWebServer server;
    AsyncWebSocket ws;

    Preferences preferences;

    // Parámetros recibidos desde la página
    float setpoint;
    float Kp;
    float Ki;

    bool savePending;

    portMUX_TYPE dataMux = portMUX_INITIALIZER_UNLOCKED;

    static Web* instance;

    static void onWebSocketEvent(
        AsyncWebSocket* server,
        AsyncWebSocketClient* client,
        AwsEventType type,
        void* arg,
        uint8_t* data,
        size_t len
    );

    void handleWebSocketEvent(
        AsyncWebSocketClient* client,
        AwsEventType type,
        void* arg,
        uint8_t* data,
        size_t len
    );

    void processMessage(const String& message);

};

extern Web web;

#endif
