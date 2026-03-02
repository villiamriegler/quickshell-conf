/**
 * Send a simple command to a qs socket
 *
 * @param {QsSocket} socket
 * @param {Object} command
 */
function sendSocketCommand(socket, command) {
	socket.write(JSON.stringify(command) + '\n');
	socket.flush();
}
