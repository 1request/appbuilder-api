// Generated by CoffeeScript 1.7.1
(function() {
  var env;

  env = require('./env.json');

  exports.config = function() {
    var node_env;
    node_env = process.env.NODE_ENV || 'development';
    return env[node_env];
  };

}).call(this);

//# sourceMappingURL=common.map
