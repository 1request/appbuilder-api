mongoose        = require 'mongoose'
common          = require '../../common'
config          = common.config()
Schema          = mongoose.Schema

appBuilderConn = mongoose.createConnection config.mongo_path

BeaconSchema = new Schema
  _id:        false
  userId:     String
  uuid:       String
  major:      Number
  minor:      Number
  zones:
    type: String
    ref:  'Zone'
  notes:      String
  createdAt:  Number
  updatedAt:  Number

module.exports = appBuilderConn.model 'Beacon', BeaconSchema