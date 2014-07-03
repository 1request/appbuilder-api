mongoose  = require 'mongoose'
common    = require '../../common'
config    = common.config()
Schema    = mongoose.Schema

appBuilderConn = mongoose.createConnection config.mongo_path

LogSchema = new Schema
  _id:      false
  uuid:     String
  appKey:   String
  major:    Number
  minor:    Number
  deviceId: String
  time:     Number

module.exports = appBuilderConn.model 'Log', LogSchema