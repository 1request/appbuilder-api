mongoose  = require 'mongoose'
common    = require '../../common'
config    = common.config()
Schema    = mongoose.Schema

appBuilderConn = mongoose.createConnection config.mongo_path

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