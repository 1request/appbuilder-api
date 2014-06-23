mongoose  = require 'mongoose'
Schema    = mongoose.Schema

appBuilderConn = mongoose.createConnection 'mongodb://localhost:27017/meteor-test'

MobileAppSchema = new Schema
  _id:        false
  userId:     String
  title:      String
  imageUrls:  Array
  appKey:     String
  tags:
    type: String
    ref:  'Tag'
  createdAt:  Number
  updatedAt:  Number
, collection: 'mobileApps'

module.exports = appBuilderConn.model 'MobileApp', MobileAppSchema