mongoose  = require 'mongoose'
Schema    = mongoose.Schema

appBuilderConn = mongoose.createConnection 'mongodb://localhost:27017/meteor-test'

TagSchema = new Schema
  _id:        false
  text:       String
  beacons:
    type: String
    ref:  'Beacon'
  userId:     String
  createdAt:  Number
  updatedAt:  Number

module.exports = appBuilderConn.model 'Tag', TagSchema