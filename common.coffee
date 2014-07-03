env = require './env.json'

exports.config = ->
  node_env = process.env.NODE_ENV || 'development'
  env[node_env]