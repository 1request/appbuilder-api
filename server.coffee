express     = require 'express'
app         = express()
bodyParser  = require 'body-parser'

app.use bodyParser()

port = process.env.PORT || 8080

router = express.Router()

router.get '/', (req, res) ->
  res.send({message: 'welcome to appbuilder api'})

app.use '/api', router

app.listen port
console.log 'running on port ' + port