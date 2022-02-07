exports.getWssHand = (conf) => () => {
  var wss = null;
  return new Promise((res, rej) => {
    if (wss) return res(wss);
    var { WebSocketServer } = require("ws");
    wss = new WebSocketServer({ port: conf.port });
    res(wss);
  });
};

exports.setWssOnConn = (wss) => (back) => () => {
  return new Promise((res, rej) => {
    wss.on("connection", function (ws) {
      back(ws)();
    });
    res();
  });
};
exports.setWsOnDisConn = (ws) => (back) => () => {
  return new Promise((res, rej) => {
    ws.on("close", function () {
      back(ws)();
    });
    res();
  });
};
exports.setWsOnPlay = (ws) => (back) => () => {
  return new Promise((res, rej) => {
    ws.on("message", function (msg) {
      var obj = JSON.parse(msg.toString());
      if (obj.cmd == "play") {
        back();
      }
    });
    res();
  });
};
exports.setWsOnStop = (ws) => (back) => () => {
  return new Promise((res, rej) => {
    ws.on("message", function (msg) {
      var obj = JSON.parse(msg.toString());
      if (obj.cmd == "stop") {
        back();
      }
    });
    res();
  });
};
exports.setWsOnGoto = (ws) => (back) => () => {
  return new Promise((res, rej) => {
    ws.on("message", function (msg) {
      var obj = JSON.parse(msg.toString());
      if (obj.cmd == "goto") {
        back(obj.data)();
      }
    });
    res();
  });
};
exports.addId = (ws) => () => {
  return new Promise((res, rej) => {
    var uuid = require("uuid");
    var r = Object.create(ws);
    r.id = uuid.v4();
    res(r);
  });
};

var arr = [];
exports.getAllLink = () => {
  return new Promise((res, rej) => {
    res(arr);
  });
};
exports.addLink = (ws) => () => {
  return new Promise((res, rej) => {
    arr.push(ws);
    res();
  });
};
exports.delLink = (ws) => () => {
  return new Promise((res, rej) => {
    arr = arr.filter((a) => a.id != ws.id);
    res();
  });
};
exports.getLinkNum = () => {
  return new Promise((res, rej) => {
    res(arr.length);
  });
};
