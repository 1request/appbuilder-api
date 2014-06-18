mongoose  = require 'mongoose'
Schema    = mongoose.Schema

LogSchema = new Schema
  _id:      false
  uuid:     String
  major:    Number
  minor:    Number
  deviceId: String
  time:     Number

module.exports = mongoose.model 'Log', LogSchema