exports._sendToWs = (ws) => (msg) => () => {
  return new Promise((res, rej) => {
    ws.send(JSON.stringify(msg));
    res();
  });
};
