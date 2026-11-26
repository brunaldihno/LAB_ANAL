
const MAX_SAMPLES = 200;

let websocket = null;

// Buffers de los gráficos
const temperatureBuffer = [];
const dutyBuffer = [];

// Referencias a los gráficos
let temperatureChart = null;
let dutyChart = null;


// --------------------------------------------------
// INICIALIZAR GRAFICOS
// --------------------------------------------------

function initializeCharts() {

    const temperatureContext =
        document.getElementById("temperatureChart");

    const dutyContext =
        document.getElementById("dutyChart");

    const commonOptions = {
        responsive: true,
        maintainAspectRatio: false,
        animation: false,

        scales: {
            x: {
                title: {
                    display: true,
                    text: "Tiempo"
                }
            },

            y: {
                beginAtZero: false
            }
        },

        plugins: {
            legend: {
                display: false
            }
        }
    };

    temperatureChart = new Chart(temperatureContext, {
        type: "line",

        data: {
            labels: [],
            datasets: [{
                label: "Temperatura",
                data: [],
                borderWidth: 2,
                pointRadius: 0,
                tension: 0.1
            }]
        },

        options: commonOptions
    });

    dutyChart = new Chart(dutyContext, {
        type: "line",

        data: {
            labels: [],
            datasets: [{
                label: "Duty",
                data: [],
                borderWidth: 2,
                pointRadius: 0,
                tension: 0.1
            }]
        },

        options: commonOptions
    });
}


// --------------------------------------------------
// WEBSOCKET
// --------------------------------------------------

function connectWebSocket() {

    const protocol =
        window.location.protocol === "https:" ? "wss:" : "ws:";

    websocket = new WebSocket(
        protocol + "//" + window.location.host + "/ws"
    );

    websocket.onopen = function () {
        updateConnectionStatus(true);
        console.log("WebSocket conectado");
    };

    websocket.onclose = function () {
        updateConnectionStatus(false);
        console.log("WebSocket desconectado");

        setTimeout(connectWebSocket, 2000);
    };

    websocket.onerror = function (error) {
        console.error("Error WebSocket:", error);
        websocket.close();
    };

    websocket.onmessage = function (event) {

        try {
            const data = JSON.parse(event.data);
            updateInterface(data);
        }
        catch (error) {
            console.error("Error procesando JSON:", error);
        }
    };
}


function updateConnectionStatus(connected) {

    const status =
        document.getElementById("connectionStatus");

    if (connected) {
        status.textContent = "Conectado";
        status.className = "status connected";
    }
    else {
        status.textContent = "Desconectado";
        status.className = "status disconnected";
    }
}


// --------------------------------------------------
// ENVIAR NUEVOS PARAMETROS AL ESP32
// --------------------------------------------------

function saveParameter(parameter) {

    if (!websocket || websocket.readyState !== WebSocket.OPEN) {
        alert("No hay conexión con el ESP32");
        return;
    }

    let inputId;

    switch (parameter) {

        case "SETPOINT":
            inputId = "setpointInput";
            break;

        case "KP":
            inputId = "kpInput";
            break;

        case "KI":
            inputId = "kiInput";
            break;

        default:
            return;
    }

    const input = document.getElementById(inputId);
    const value = input.value.trim();

    if (value === "" || !Number.isFinite(Number(value))) {
        alert("Ingresa un valor numérico válido");
        return;
    }

    // Protocolo: PARAMETRO:VALOR
    websocket.send(parameter + ":" + value);

    input.value = "";
}


// --------------------------------------------------
// ACTUALIZAR SHOWBOX Y GRAFICOS
// --------------------------------------------------

function updateInterface(data) {

    // Actualizar SHOWBOX de INPUTS
    document.getElementById("setpointValue").textContent =
        Number(data.setpoint).toFixed(2);

    document.getElementById("kpValue").textContent =
        Number(data.kp).toFixed(2);

    document.getElementById("kiValue").textContent =
        Number(data.ki).toFixed(2);


    // Actualizar SHOWBOX de OUTPUTS
    document.getElementById("temperatureValue").textContent =
        Number(data.temp).toFixed(2);

    document.getElementById("dutyValue").textContent =
        Number(data.duty).toFixed(2);


    // Agregar muestras a los buffers
    addTemperatureSample(data.timestamp, data.temp);
    addDutySample(data.timestamp, data.duty);
}


// --------------------------------------------------
// BUFFER DE TEMPERATURA
// --------------------------------------------------

function addTemperatureSample(timestamp, temperature) {

    temperatureBuffer.push({
        timestamp: timestamp,
        value: temperature
    });

    if (temperatureBuffer.length > MAX_SAMPLES) {
        temperatureBuffer.shift();
    }

    updateTemperatureChart();
}


// --------------------------------------------------
// BUFFER DE DUTY
// --------------------------------------------------

function addDutySample(timestamp, duty) {

    dutyBuffer.push({
        timestamp: timestamp,
        value: duty
    });

    if (dutyBuffer.length > MAX_SAMPLES) {
        dutyBuffer.shift();
    }

    updateDutyChart();
}


// --------------------------------------------------
// ACTUALIZAR GRAFICO DE TEMPERATURA
// --------------------------------------------------

function updateTemperatureChart() {

    if (!temperatureChart) return;

    temperatureChart.data.labels =
        temperatureBuffer.map(point => point.timestamp);

    temperatureChart.data.datasets[0].data =
        temperatureBuffer.map(point => point.value);

    temperatureChart.update("none");
}


// --------------------------------------------------
// ACTUALIZAR GRAFICO DE DUTY
// --------------------------------------------------

function updateDutyChart() {

    if (!dutyChart) return;

    dutyChart.data.labels =
        dutyBuffer.map(point => point.timestamp);

    dutyChart.data.datasets[0].data =
        dutyBuffer.map(point => point.value);

    dutyChart.update("none");
}


// --------------------------------------------------
// INICIO
// --------------------------------------------------

window.addEventListener("load", function () {

    initializeCharts();
    connectWebSocket();

});
