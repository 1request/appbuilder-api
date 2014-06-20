mongoose  = require 'mongoose'
Schema    = mongoose.Schema

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

module.exports = mongoose.model 'Beacon', BeaconSchema