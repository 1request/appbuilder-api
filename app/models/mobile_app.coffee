mongoose  = require 'mongoose'
common    = require '../../common'
config    = common.config()
Schema    = mongoose.Schema

appBuilderConn = mongoose.createConnection config.mongo_path

MobileAppSchema = new Schema
  _id:        false
  userId:     String
  title:      String
  imageUrls:  Array
  appKey:     String
  zones:
    type: String
    ref:  'Zone'
  createdAt:  Number
  updatedAt:  Number
, collection: 'mobileApps'

module.exports = appBuilderConn.model 'MobileApp', MobileAppSchema