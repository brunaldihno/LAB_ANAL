#include "web.h"

#include <LittleFS.h>
#include <WiFi.h>
#include <math.h>
#include <stdlib.h>

// --------------------------------------------------
// CONFIGURACION
// --------------------------------------------------

static const char* AP_SSID = "ESP32_CONTROL";
static const char* AP_PASSWORD = "12345678";

Web web;

Web* Web::instance = nullptr;


// --------------------------------------------------
// CONSTRUCTOR
// --------------------------------------------------

Web::Web()
    : server(80),
      ws("/ws"),
      setpoint(30.0f),
      Kp(1.0f),
      Ki(1.0f),
      savePending(false)
{
}


// --------------------------------------------------
// INICIALIZAR WEB
// --------------------------------------------------

void Web::begin() {

    instance = this;

    // Montar LittleFS
    if (!LittleFS.begin(false)) {
        Serial.println("Error montando LittleFS");
        return;
    }

    // Cargar parámetros guardados
    preferences.begin("control", false);

    setpoint = preferences.getFloat("setpoint", 30.0f);
    Kp = preferences.getFloat("kp", 1.0f);
    Ki = preferences.getFloat("ki", 1.0f);

    // Iniciar Access Point
    WiFi.mode(WIFI_AP);
    WiFi.softAP(AP_SSID, AP_PASSWORD);

    Serial.print("IP del ESP32: ");
    Serial.println(WiFi.softAPIP());

    // Configurar WebSocket
    ws.onEvent(Web::onWebSocketEvent);
    server.addHandler(&ws);

    // Servir archivos desde LittleFS
    server.serveStatic("/", LittleFS, "/")
          .setDefaultFile("index.html");

    server.begin();

    Serial.println("Servidor web iniciado");
}


// --------------------------------------------------
// EVENTO WEBSOCKET ESTATICO
// --------------------------------------------------

void Web::onWebSocketEvent(
    AsyncWebSocket* server,
    AsyncWebSocketClient* client,
    AwsEventType type,
    void* arg,
    uint8_t* data,
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


// --------------------------------------------------
// PROCESAR EVENTOS WEBSOCKET
// --------------------------------------------------

void Web::handleWebSocketEvent(
    AsyncWebSocketClient* client,
    AwsEventType type,
    void* arg,
    uint8_t* data,
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

        AwsFrameInfo* info =
            (AwsFrameInfo*)arg;

        // Solo procesar mensajes completos de texto
        if (
            info->final &&
            info->index == 0 &&
            info->len == len &&
            info->opcode == WS_TEXT
        ) {

            String message;

            message.reserve(len);

            for (size_t i = 0; i < len; i++) {
                message += (char)data[i];
            }

            processMessage(message);
        }
    }
}


// --------------------------------------------------
// PROCESAR PARAMETROS RECIBIDOS
// --------------------------------------------------

void Web::processMessage(const String& message) {

    int separator = message.indexOf(':');

    if (separator < 0) {
        return;
    }

    String parameter =
        message.substring(0, separator);

    String valueString =
        message.substring(separator + 1);

    valueString.trim();

    if (valueString.length() == 0) {
        return;
    }

    // Convertir a float
    char* endPtr = nullptr;

    float value = strtof(
        valueString.c_str(),
        &endPtr
    );

    // Validar número
    if (
        endPtr == valueString.c_str() ||
        *endPtr != '\0' ||
        !isfinite(value)
    ) {
        return;
    }

    // Actualizar parámetro compartido
    portENTER_CRITICAL(&dataMux);

    if (parameter == "SETPOINT") {
        setpoint = value;
        savePending = true;
    }

    else if (parameter == "KP") {
        Kp = value;
        savePending = true;
    }

    else if (parameter == "KI") {
        Ki = value;
        savePending = true;
    }

    portEXIT_CRITICAL(&dataMux);
}


// --------------------------------------------------
// GETTERS
// --------------------------------------------------

float Web::getSetpoint() {

    float value;

    portENTER_CRITICAL(&dataMux);
    value = setpoint;
    portEXIT_CRITICAL(&dataMux);

    return value;
}


float Web::getKp() {

    float value;

    portENTER_CRITICAL(&dataMux);
    value = Kp;
    portEXIT_CRITICAL(&dataMux);

    return value;
}


float Web::getKi() {

    float value;

    portENTER_CRITICAL(&dataMux);
    value = Ki;
    portEXIT_CRITICAL(&dataMux);

    return value;
}


// --------------------------------------------------
// ENVIAR DATOS A LA PAGINA
// --------------------------------------------------

void Web::sendData(
    float setpointValue,
    float KpValue,
    float KiValue,
    float temp,
    float duty,
    float timestamp
) {

    // Obtener una copia consistente de los parámetros
    float localSetpoint;
    float localKp;
    float localKi;
    bool pending;

    portENTER_CRITICAL(&dataMux);

    localSetpoint = setpoint;
    localKp = Kp;
    localKi = Ki;

    pending = savePending;
    savePending = false;

    portEXIT_CRITICAL(&dataMux);

    // Guardar cambios en NVS fuera de la sección crítica
    if (pending) {

        preferences.putFloat("setpoint", localSetpoint);
        preferences.putFloat("kp", localKp);
        preferences.putFloat("ki", localKi);
    }

    // Crear JSON
    String json;

    json.reserve(180);

    json = "{";

    json += "\"setpoint\":";
    json += String(setpointValue, 4);

    json += ",\"kp\":";
    json += String(KpValue, 4);

    json += ",\"ki\":";
    json += String(KiValue, 4);

    json += ",\"temp\":";
    json += String(temp, 4);

    json += ",\"duty\":";
    json += String(duty, 4);

    json += ",\"timestamp\":";
    json += String(timestamp, 4);

    json += "}";

    // Transmitir a todos los clientes conectados
    ws.textAll(json);

    // Limpiar clientes desconectados
    ws.cleanupClients();
}
