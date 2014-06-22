mongoose  = require 'mongoose'
Schema    = mongoose.Schema

ContactSchema = new Schema
  _id:        false
  name:       String
  email:      String
  message:    String

module.exports = mongoose.model 'Contact', ContactSchema