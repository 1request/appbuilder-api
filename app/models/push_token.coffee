mongoose  = require 'mongoose'
common    = require '../../common'
config    = common.config()
Schema    = mongoose.Schema

appBuilderConn = mongoose.createConnection config.mongo_path

PushTokenSchema = new Schema
  _id:        false
  appKey:     String
  deviceId:   String
  pushType:   String
  pushToken:  String
  createdAt:  Number
, collection: 'pushTokens'

module.exports = appBuilderConn.model 'PushToken', PushTokenSchema