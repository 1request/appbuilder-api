mongoose  = require 'mongoose'
Schema    = mongoose.Schema

TagSchema = new Schema
  _id:        false
  text:       String
  beacons:
    type: String
    ref:  'Beacon'
  userId:     String
  createdAt:  Number
  updatedAt:  Number

module.exports = mongoose.model 'Tag', TagSchema