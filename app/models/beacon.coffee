mongoose  = require 'mongoose'
Schema    = mongoose.Schema

appBuilderConn = mongoose.createConnection 'mongodb://localhost:27017/meteor-test'

BeaconSchema = new Schema
  _id:        false
  userId:     String
  uuid:       String
  major:      Number
  minor:      Number
  tags:
    type: String
    ref:  'Tag'
  notes:      String
  createdAt:  Number
  updatedAt:  Number

module.exports = appBuilderConn.model 'Beacon', BeaconSchema