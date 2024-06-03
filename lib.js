// require('coffee-script/register');

var pkg = require("./package.json");
var routePrefix = pkg.api;

module.exports = {
  create: function() {
    // worker
    var restify = require("restify");
    var main = require("./dist/main");

    var server = restify.createServer();

    // Enable restify plugins
    server.use(restify.plugins.bodyParser());
    server.use(restify.plugins.gzipResponse());

    // Intitialize backend, add routes
    main.initialize();
    main.addRoutes(routePrefix, server);

    return server;
  }
};
