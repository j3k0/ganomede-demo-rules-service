require('coffee-script/register');

var pkg = require("./package.json");
var routePrefix = pkg.api;

module.exports = {
  create: function() {
    // worker
    var restify = require("restify");
    var main = require("./src/main");

    var server = restify.createServer();

    // Enable restify plugins
    server.use(restify.bodyParser());
    server.use(restify.gzipResponse());

    // Intitialize backend, add routes
    main.initialize();
    main.addRoutes(routePrefix, server);

    return server;
  }
};
