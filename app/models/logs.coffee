mongoose  = require 'mongoose'
Schema    = mongoose.Schema

LogSchema = new Schema
  uuid:     String
  major:    String
  minor:    String
  deviceId: String
  time:     Number

module.exports = mongoose.model 'Log', LogSchema