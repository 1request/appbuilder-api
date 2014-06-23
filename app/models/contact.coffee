mongoose  = require 'mongoose'
Schema    = mongoose.Schema

contactsConn   = mongoose.createConnection 'mongodb://localhost:27017/contacts'

ContactSchema = new Schema
  _id:        false
  name:       String
  email:      String
  message:    String

module.exports = contactsConn.model 'Contact', ContactSchema