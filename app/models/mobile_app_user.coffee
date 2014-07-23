mongoose  = require 'mongoose'
common    = require '../../common'
config    = common.config()
Schema    = mongoose.Schema

appBuilderConn = mongoose.createConnection config.mongo_path

MobileAppUserSchema = new Schema
  _id:        false
  appKey:     String
  deviceId:   String
  token:      String
  deviceType: String
  createdAt:  Number
  updatedAt:  Number
, collection: 'mobileAppUsers'

module.exports = appBuilderConn.model 'MobileApp', MobileAppSchema