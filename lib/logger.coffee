
# Node core
fs        = require 'fs'
path      = require 'path'

# Flatiron dependencies
winston   = require 'winston'             # System logbook
analyzer  = require 'require-analyzer'   # File dependency

#
# Logging levels
#
config =
  levels:
    silly: 0
    verbose: 1
    info: 2
    data: 3
    warn: 4
    debug: 5
    error: 6

  colors:
    silly: "magenta"
    verbose: "cyan"
    info: "green"
    data: "grey"
    warn: "yellow"
    debug: "blue"
    error: "red"

# Expose object (module) instance to public
logger = module.exports = new (winston.Logger)(
  transports: [
    new (winston.transports.Console)(colorize: true, level: 'error')
    new (winston.transports.File)(filename: path.join process.env.HOME, '.todo', 'todo.log')
    #new (winston.transports.Webhook)(host: 'localhost', port: 8080, path: '/collectdata')
  ]
  exceptionHandlers: [
    new (winston.transports.Console)(colorize: true, json: true)
    new winston.transports.File(filename: path.join process.env.HOME, '.todo', 'error.log')
  ]

  levels: config.levels
  colors: config.colors
)





logger.on 'live', (err, cb) ->
  logger.data "hello"

#logger.on 'error', (err) ->
#  logger.error err
# logger.emitErrs = false

#throw new Error("Hello, winston!")


