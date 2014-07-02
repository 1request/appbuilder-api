mongoose  = require 'mongoose'
Schema    = mongoose.Schema

appBuilderConn = mongoose.createConnection 'mongodb://localhost:27017/meteor-test'

LogSchema = new Schema
  _id:      false
  uuid:     String
  appKey:   String
  major:    Number
  minor:    Number
  deviceId: String
  time:     Number

module.exports = appBuilderConn.model 'Log', LogSchema