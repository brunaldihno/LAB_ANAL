let socket;

function connectWebSocket() {

    socket = new WebSocket(
        'ws://' + location.host + '/ws'
    );

    socket.onopen = function() {

        document.getElementById(
            'connection'
        ).textContent = 'CONECTADO';

    };

    socket.onclose = function() {

        document.getElementById(
            'connection'
        ).textContent = 'DESCONECTADO';

        setTimeout(connectWebSocket, 2000);

    };

    socket.onmessage = function(event) {

        const data = JSON.parse(event.data);

        document.getElementById(
            'temperature'
        ).textContent = data.temperature;

        if (document.activeElement.id !== 'setpoint') {
            document.getElementById(
                'setpoint'
            ).value = data.setpoint;
        }

        document.getElementById(
            'ledStatus'
        ).textContent =
            data.led ? 'ENCENDIDO' : 'APAGADO';

    };

}

function writeSetpoint() {

    if (socket.readyState !== WebSocket.OPEN)
        return;

    const value = document.getElementById(
        'setpoint'
    ).value;

    socket.send('SP:' + value);

}

function writeSetpoint() {

    if (socket.readyState !== WebSocket.OPEN)
        return;

    const value = document.getElementById(
        'setpoint'
    ).value;

    socket.send('SP:' + value);

}

function setLed(state) {

    if (socket.readyState !== WebSocket.OPEN)
        return;

    socket.send('LED:' + state);

}

connectWebSocket();
