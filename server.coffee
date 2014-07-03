express     = require 'express'
bodyParser  = require 'body-parser'
mongoose    = require 'mongoose'
Log         = require './app/models/log'
MobileApp   = require './app/models/mobile_app'
Beacon      = require './app/models/beacon'
Zone        = require './app/models/zone'
Contact     = require './app/models/contact'
Notification = require './app/models/notification'
_           = require 'lodash-node'
Q           = require 'q'
util        = require 'util'
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
  .get (req, res) ->
    Log.find (error, logs) ->
      if error then res.send error else res.json { logs: logs }

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

    getMobileApp = MobileApp
      .findOne(appKey: req.params.appKey)
      .lean()
      .select('zones')
      .exec()

    getZones = (mobileApp) ->
      Zone
        .where('_id').in(mobileApp.zones)
        .lean()
        .exec()

    getBeacons = (zones) ->
      Beacon
        .where('zones').in(zones)
        .lean()
        .select('uuid major minor zones _id')
        .exec()

    getNotifications = Notification
      .where('appKey').equals(req.params.appKey)
      .where('type').equals('location')
      .lean()
      .select('action url zone')
      .exec()

    Q.all([getMobileApp.then(getZones).then(getBeacons), getNotifications]).spread (beacons, notifications) ->
      for n in notifications
        filteredBeacons = _.where(beacons, { zones: [n.zone]})
        for b in filteredBeacons
          idx = _.findIndex beacons, (beacon) ->
            b._id is beacon._id
          unless !!b.actions
            beacons[idx] = _.extend b, { actions: [action: n.action, url: n.url] }
          else
            b.actions.push {action: n.action, url: n.url}
            beacons[idx] = b
      beacons = _.map beacons, (beacon) ->
        _.pick(beacon, ['uuid', 'major', 'minor', 'actions'])

      res.json { beacons: beacons }

app.use '/api', router

app.listen port

console.log 'running on port ' + port