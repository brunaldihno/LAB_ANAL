#include "web.h"

#include <WiFi.h>
#include <LittleFS.h>
#include <math.h>
#include <stdlib.h>

// Instancia global
Web web;

// Referencia para los callbacks
Web* Web::instance = nullptr;


// =====================================
// INICIALIZACIÓN
// =====================================

bool Web::begin() {

    instance = this;

    pinMode(LED_PIN, OUTPUT);

    // ---------------------------------
    // Cargar setpoints guardados
    // ---------------------------------

    if (!preferences.begin("control", false)) {

        Serial.println("Error iniciando Preferences");

        return false;
    }

    setpoint_1 = preferences.getFloat("sp1", 30.0);
    setpoint_2 = preferences.getFloat("sp2", 35.0);

    Serial.println("Setpoints cargados:");

    Serial.println(setpoint_1);
    Serial.println(setpoint_2);


    // ---------------------------------
    // LittleFS
    // ---------------------------------

    if (!LittleFS.begin(true)) {

        Serial.println("Error montando LittleFS");

        return false;
    }

    Serial.println("LittleFS iniciado");


    // ---------------------------------
    // WiFi Access Point
    // ---------------------------------

    WiFi.mode(WIFI_AP);

    WiFi.softAP(ssid, password);

    Serial.print("IP: ");

    Serial.println(WiFi.softAPIP());


    // ---------------------------------
    // WebSocket
    // ---------------------------------

    ws.onEvent(Web::onWebSocketEvent);

    server.addHandler(&ws);


    // ---------------------------------
    // Servir archivos
    // ---------------------------------

    server.serveStatic("/", LittleFS, "/")
          .setDefaultFile("index.html")
          .setCacheControl("no-cache");


    // ---------------------------------
    // Iniciar servidor
    // ---------------------------------

    server.begin();

    Serial.println("Servidor HTTP iniciado");

    return true;
}


// =====================================
// CALLBACK WEBSOCKET
// =====================================

void Web::onWebSocketEvent(
    AsyncWebSocket *server,
    AsyncWebSocketClient *client,
    AwsEventType type,
    void *arg,
    uint8_t *data,
    size_t len
) {

    if (instance != nullptr) {

        instance->handleWebSocketEvent(
            client,
            type,
            arg,
            data,
            len
        );

    }
}


// =====================================
// PROCESAR EVENTOS
// =====================================

void Web::handleWebSocketEvent(
    AsyncWebSocketClient *client,
    AwsEventType type,
    void *arg,
    uint8_t *data,
    size_t len
) {

    if (type == WS_EVT_CONNECT) {

        Serial.printf(
            "Cliente conectado: %u\n",
            client->id()
        );

    }

    else if (type == WS_EVT_DISCONNECT) {

        Serial.printf(
            "Cliente desconectado: %u\n",
            client->id()
        );

    }

    else if (type == WS_EVT_DATA) {

        AwsFrameInfo *info = (AwsFrameInfo *)arg;

        if (
            info->final &&
            info->index == 0 &&
            info->len == len &&
            info->opcode == WS_TEXT
        ) {

            // Evitar mensajes demasiado grandes
            if (len >= 64) {
                return;
            }

            char msg[64];

            memcpy(msg, data, len);

            msg[len] = '\0';

            processMessage(msg);

        }

    }

}


// =====================================
// PROCESAMIENTO DE COMANDOS
// =====================================

void Web::processMessage(const char* msg) {

    float value;
    char* endPtr;


    // ---------------------------------
    // SETPOINT 1
    // ---------------------------------

    if (strncmp(msg, "SP1:", 4) == 0) {

        value = strtof(msg + 4, &endPtr);

        if (
            endPtr != msg + 4 &&
            *endPtr == '\0' &&
            isfinite(value) &&
            value >= 0 &&
            value <= 100
        ) {

            portENTER_CRITICAL(&dataMux);

            setpoint_1 = value;

            portEXIT_CRITICAL(&dataMux);

            preferences.putFloat("sp1", value);

            Serial.printf(
                "Setpoint 1: %.2f\n",
                value
            );

        }

    }


    // ---------------------------------
    // SETPOINT 2
    // ---------------------------------

    else if (strncmp(msg, "SP2:", 4) == 0) {

        value = strtof(msg + 4, &endPtr);

        if (
            endPtr != msg + 4 &&
            *endPtr == '\0' &&
            isfinite(value) &&
            value >= 0 &&
            value <= 100
        ) {

            portENTER_CRITICAL(&dataMux);

            setpoint_2 = value;

            portEXIT_CRITICAL(&dataMux);

            preferences.putFloat("sp2", value);

            Serial.printf(
                "Setpoint 2: %.2f\n",
                value
            );

        }

    }


    // ---------------------------------
    // LED
    // ---------------------------------

    else if (
        strcmp(msg, "LED:1") == 0 ||
        strcmp(msg, "LED:0") == 0
    ) {

        bool state = (strcmp(msg, "LED:1") == 0);

        portENTER_CRITICAL(&dataMux);

        ledState = state;

        portEXIT_CRITICAL(&dataMux);

        digitalWrite(
            LED_PIN,
            state ? HIGH : LOW
        );

    }

}


// =====================================
// ACTUALIZAR TEMPERATURA
// =====================================

void Web::setTemperature(float value) {

    portENTER_CRITICAL(&dataMux);

    temperatura = value;

    portEXIT_CRITICAL(&dataMux);

}


// =====================================
// GETTERS
// =====================================

float Web::getSetpoint1() {

    float value;

    portENTER_CRITICAL(&dataMux);

    value = setpoint_1;

    portEXIT_CRITICAL(&dataMux);

    return value;
}


float Web::getSetpoint2() {

    float value;

    portENTER_CRITICAL(&dataMux);

    value = setpoint_2;

    portEXIT_CRITICAL(&dataMux);

    return value;
}


bool Web::getLedState() {

    bool value;

    portENTER_CRITICAL(&dataMux);

    value = ledState;

    portEXIT_CRITICAL(&dataMux);

    return value;
}


// =====================================
// ENVIAR DATOS AL NAVEGADOR
// =====================================

void Web::sendData() {

    float temp;
    float sp1;
    float sp2;
    bool led;

    portENTER_CRITICAL(&dataMux);

    temp = temperatura;
    sp1 = setpoint_1;
    sp2 = setpoint_2;
    led = ledState;

    portEXIT_CRITICAL(&dataMux);


    char json[192];

    snprintf(
        json,
        sizeof(json),

        "{"
        "\"temperature\":%.2f,"
        "\"setpoint_1\":%.2f,"
        "\"setpoint_2\":%.2f,"
        "\"led\":%s"
        "}",

        temp,
        sp1,
        sp2,
        led ? "true" : "false"
    );

    ws.textAll(json);

    ws.cleanupClients();

}
