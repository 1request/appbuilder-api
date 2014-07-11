express       = require 'express'
bodyParser    = require 'body-parser'
mongoose      = require 'mongoose'
_             = require 'lodash-node'
Q             = require 'q'
util          = require 'util'

Log           = require './app/models/log'
MobileApp     = require './app/models/mobile_app'
Beacon        = require './app/models/beacon'
Zone          = require './app/models/zone'
Contact       = require './app/models/contact'
Notification  = require './app/models/notification'
PushToken     = require './app/models/push_token'

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
    log.appKey    = req.body.appKey
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
    d = Q.defer()

    getNotifications = Notification
      .where('appKey').equals(req.params.appKey)
      .where('type').equals('location')
      .lean()
      .select('action url zone trigger message area')
      .exec()

    getBeacons = (notifications) ->
      d = Q.defer()
      zoneIds = _.pluck(notifications, 'zone')
      beacons = Beacon
        .where('zones').in(zoneIds)
        .lean()
        .select('uuid major minor zones _id')
        .exec (error, result) ->
          d.resolve {notifications: notifications, beacons: result}
      d.promise

    getNotifications
      .then(getBeacons)
      .then (result) ->
        for n in result.notifications
          beacons = _.where(result.beacons, zones: [n.zone])
          attributes =
            trigger: n.trigger
            action: n.action
            area: n.area
            message: n.message
            url: n.url
          for b in beacons
            unless !!b.actions
              b = _.extend b,
                actions: [attributes]
            else
              b.actions.push attributes

        beacons = _.map result.beacons, (beacon) ->
          _.pick(beacon, ['uuid', 'major', 'minor', 'actions'])

        res.json { beacons: beacons }

router.route '/push_tokens'
  .post (req, res) ->
    pushToken           = new PushToken()
    pushToken._id       = mongoose.Types.ObjectId().toHexString()
    pushToken.appKey    = req.body.appKey
    pushToken.deviceId  = req.body.deviceId
    pushToken.pushType  = req.body.pushType
    pushToken.pushToken = req.body.pushToken
    pushToken.createdAt = new Date().valueOf()

    pushToken.save (error) ->
      if error
        res.send error
      res.json {message: 'Push token created!'}


app.use '/api', router

app.listen port

console.log 'running on port ' + port