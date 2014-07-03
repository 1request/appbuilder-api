mongoose  = require 'mongoose'
common    = require '../../common'
config    = common.config()
Schema    = mongoose.Schema

contactsConn   = mongoose.createConnection config.mongo_path

ContactSchema = new Schema
  _id:        false
  name:       String
  email:      String
  message:    String

module.exports = contactsConn.model 'Contact', ContactSchema