// Generated by CoffeeScript 1.7.1
(function() {
  var AreaSchema, Schema, appBuilderConn, common, config, mongoose;

  mongoose = require('mongoose');

  common = require('../../common');

  config = common.config();

  Schema = mongoose.Schema;

  appBuilderConn = mongoose.createConnection(config.mongo_path);

  AreaSchema = new Schema({
    _id: false,
    name: String,
    imageId: String,
    appKey: String,
    createdAt: Number,
    updatedAt: Number
  });

  module.exports = appBuilderConn.model('Area', AreaSchema);

}).call(this);

//# sourceMappingURL=area.map
