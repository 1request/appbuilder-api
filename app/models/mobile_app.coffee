mongoose  = require 'mongoose'
Schema    = mongoose.Schema

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

module.exports = mongoose.model 'MobileApp', MobileAppSchema