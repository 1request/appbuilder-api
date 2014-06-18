express     = require 'express'
bodyParser  = require 'body-parser'
mongoose    = require 'mongoose'
Log         = require './app/models/logs'

app = express()

mongoose.connect 'mongodb://localhost:3001/meteor'

app.use bodyParser.urlencoded()
app.use bodyParser.json()

port = process.env.PORT || 8080

router = express.Router()

router.use (req, res, next) ->
  console.log 'something is happening.'
  next()

router.get '/', (req, res) ->
  res.json({message: 'welcome to appbuilder api'})

app.use '/api', router

router.route '/logs'
  .post (req, res) ->
    log           = new Log()
    log._id       = mongoose.Types.ObjectId().toHexString()
    log.uuid      = req.body.uuid
    log.major     = req.body.major
    log.minor     = req.body.minor
    log.deviceId  = req.body.deviceId
    log.time      = req.body.time

    log.save (error) ->
      if error
        res.send error
      res.json {message: 'Log created!'}

app.listen port
console.log 'running on port ' + port