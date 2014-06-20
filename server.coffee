express     = require 'express'
bodyParser  = require 'body-parser'
mongoose    = require 'mongoose'
Log         = require './app/models/log'
MobileApp   = require './app/models/mobile_app'
Beacon      = require './app/models/beacon'
Tag         = require './app/models/tag'
_           = require 'lodash-node'
app = express()

mongoose.connect 'mongodb://localhost:3001/meteor'

app.use bodyParser.urlencoded()
app.use bodyParser.json()

port = process.env.PORT || 4000

router = express.Router()

router.use (req, res, next) ->
  console.log 'something is happening.'
  next()

router.get '/', (req, res) ->
  res.json({message: 'welcome to appbuilder api'})

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

router.route '/mobile_apps/:appKey'
  .get (req, res) ->
    getMobileApp = () ->
      MobileApp
        .findOne({ appKey: req.params.appKey })
        .lean()
        .exec (error, mobileApp) ->
          getTags(mobileApp)

    getTags = (mobileApp) ->
      tags = mobileApp.tags
      Tag
        .find({_id: { $in: tags } })
        .lean()
        .exec (error, tags) ->
          beaconIds = _.uniq(_.flatten(_.pluck tags, 'beacons'))
          getBeacons(beaconIds)

    getBeacons = (beacons) ->
      Beacon
        .find({ _id: { $in: beacons } })
        .lean()
        .select('uuid major minor -_id')
        .exec (error, beacons) ->
          res.json { beacons: beacons }

    getMobileApp()

app.use '/api', router

app.listen port

console.log 'running on port ' + port