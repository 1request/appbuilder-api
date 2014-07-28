mongoose        = require 'mongoose'
common          = require '../../common'
config          = common.config()
Schema          = mongoose.Schema

appBuilderConn = mongoose.createConnection config.mongo_path

AreaSchema = new Schema
  _id:        false
  name:       String
  image:      String
  position:   String
  appKey:     String
  url:        String
  createdAt:  Number
  updatedAt:  Number

module.exports = appBuilderConn.model 'Area', AreaSchema