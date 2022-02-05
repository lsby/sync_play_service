exports.getWssPort = () => {
  return new Promise((res, rej) => {
    var argv = require("minimist")(process.argv.slice(2));
    if (argv.wssPort) return res(argv.wssPort);
    rej("获取wss端口失败");
  });
};
