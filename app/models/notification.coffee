mongoose  = require 'mongoose'
common    = require '../../common'
config    = common.config()
Schema    = mongoose.Schema

appBuilderConn = mongoose.createConnection config.mongo_path

NotificationSchema = new Schema
  _id:        false
  appKey:     String
  message:    String
  type:       String
  action:     String
  zone:
    type: String
    ref:  'Zone'
  createdAt:  Number

module.exports = appBuilderConn.model 'Notification', NotificationSchema