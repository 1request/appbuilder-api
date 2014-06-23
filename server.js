// Generated by CoffeeScript 1.7.1
(function() {
  var Beacon, Contact, Log, MobileApp, Tag, app, bodyParser, express, mongoose, port, router, _;

  express = require('express');

  bodyParser = require('body-parser');

  mongoose = require('mongoose');

  Log = require('./app/models/log');

  MobileApp = require('./app/models/mobile_app');

  Beacon = require('./app/models/beacon');

  Tag = require('./app/models/tag');

  Contact = require('./app/models/contact');

  _ = require('lodash-node');

  app = express();

  app.use(bodyParser.urlencoded());

  app.use(bodyParser.json());

  port = process.env.PORT || 8080;

  router = express.Router();

  app.all('*', function(req, res, next) {
    res.header('Access-Control-Allow-Origin', "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With, Content-Type");
    return next();
  });

  router.use(function(req, res, next) {
    console.log('something is happening.');
    return next();
  });

  router.get('/', function(req, res) {
    return res.json({
      message: 'welcome to appbuilder api'
    });
  });

  router.route('/logs').post(function(req, res) {
    var log;
    log = new Log();
    log._id = mongoose.Types.ObjectId().toHexString();
    log.uuid = req.body.uuid;
    log.major = req.body.major;
    log.minor = req.body.minor;
    log.deviceId = req.body.deviceId;
    log.time = req.body.time;
    return log.save(function(error) {
      if (error) {
        res.send(error);
      }
      return res.json({
        message: 'Log created!'
      });
    });
  });

  router.route('/contacts').post(function(req, res) {
    var contact;
    contact = new Contact();
    contact._id = mongoose.Types.ObjectId().toHexString();
    contact.name = req.body.name;
    contact.email = req.body.email;
    contact.message = req.body.message;
    return contact.save(function(error) {
      if (error) {
        res.send(error);
      }
      return res.json({
        message: 'contact created!'
      });
    });
  });

  router.route('/mobile_apps/:appKey').get(function(req, res) {
    var getBeacons, getMobileApp, getTags;
    getMobileApp = function() {
      return MobileApp.findOne({
        appKey: req.params.appKey
      }).lean().exec(function(error, mobileApp) {
        if (error) {
          return res.send(error);
        } else {
          return getTags(mobileApp);
        }
      });
    };
    getTags = function(mobileApp) {
      var tags;
      tags = mobileApp.tags;
      if (tags) {
        return Tag.find({
          _id: {
            $in: tags
          }
        }).lean().exec(function(error, tags) {
          var beaconIds;
          if (error) {
            return res.send(error);
          } else {
            beaconIds = _.uniq(_.flatten(_.pluck(tags, 'beacons')));
            return getBeacons(beaconIds);
          }
        });
      } else {
        return res.json({
          message: 'no beacon is set for this app'
        });
      }
    };
    getBeacons = function(beacons) {
      return Beacon.find({
        _id: {
          $in: beacons
        }
      }).lean().select('uuid major minor -_id').exec(function(error, beacons) {
        if (error) {
          return res.send(error);
        } else {
          return res.json({
            beacons: beacons
          });
        }
      });
    };
    return getMobileApp();
  });

  app.use('/api', router);

  app.listen(port);

  console.log('running on port ' + port);

}).call(this);

//# sourceMappingURL=server.map
