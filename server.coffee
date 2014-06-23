express     = require 'express'
bodyParser  = require 'body-parser'
mongoose    = require 'mongoose'
Log         = require './app/models/log'
MobileApp   = require './app/models/mobile_app'
Beacon      = require './app/models/beacon'
Tag         = require './app/models/tag'
Contact     = require './app/models/contact'
_           = require 'lodash-node'

app = express()

app.use bodyParser.urlencoded()
app.use bodyParser.json()

port = process.env.PORT || 8080

router = express.Router()
app.all '*', (req, res, next) ->
  res.header 'Access-Control-Allow-Origin', "*"
  res.header "Access-Control-Allow-Headers", "X-Requested-With, Content-Type"
  next()

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

router.route '/contacts'
  .post (req, res) ->
    contact           = new Contact()
    contact._id       = mongoose.Types.ObjectId().toHexString()
    contact.name      = req.body.name
    contact.email     = req.body.email
    contact.message   = req.body.message

    contact.save (error) ->
      if error
        res.send error
      res.json {message: 'contact created!'}

router.route '/mobile_apps/:appKey'
  .get (req, res) ->
    getMobileApp = () ->
      MobileApp
        .findOne({ appKey: req.params.appKey })
        .lean()
        .exec (error, mobileApp) ->
          if error then res.send error else getTags(mobileApp)

    getTags = (mobileApp) ->
      tags = mobileApp.tags
      if tags
        Tag
          .find({_id: { $in: tags } })
          .lean()
          .exec (error, tags) ->
            if error
              res.send error
            else
              beaconIds = _.uniq(_.flatten(_.pluck tags, 'beacons'))
              getBeacons(beaconIds)
      else
        res.json({message: 'no beacon is set for this app'})

    getBeacons = (beacons) ->
      Beacon
        .find({ _id: { $in: beacons } })
        .lean()
        .select('uuid major minor -_id')
        .exec (error, beacons) ->
          if error then res.send error else res.json { beacons: beacons }

    getMobileApp()

app.use '/api', router

app.listen port

console.log 'running on port ' + port