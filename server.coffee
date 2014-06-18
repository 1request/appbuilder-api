express     = require 'express'
bodyParser  = require 'body-parser'
mongoose    = require 'mongoose'
Log         = require './app/models/log'

app = express()

mongoose.connect 'mongodb://localhost:3001/meteor'

app.use bodyParser()

port = process.env.PORT || 8080

router = express.Router()

router.get '/', (req, res) ->
  res.send({message: 'welcome to appbuilder api'})

app.use '/api', router

app.listen port
console.log 'running on port ' + port