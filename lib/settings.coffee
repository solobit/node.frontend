
# ######################
nconf = require("nconf")
#


#
# Set a few variables on `nconf`.
#
nconf.set "database:host", "127.0.0.1"
nconf.set "database:port", 5984

#
# Get the entire database object from nconf. This will output
# { host: '127.0.0.1', port: 5984 }
#
console.log "foo: " + nconf.get("foo")
console.log "NODE_ENV: " + nconf.get("NODE_ENV")
console.log "database: " + nconf.get("database")

#
# Save the configuration object to disk
#
nconf.save (err) ->
  fs.readFile "./config.json", (err, data) ->
    console.dir JSON.parse(data.toString())





#
# 1. any overrides
#
nconf.overrides always: "be this value"

#
# 2. `process.env`
# 3. `process.argv`
#
nconf.env().argv()

#
# 4. Values in `config.json`
#
nconf.file "./config.json"

#
# Or with a custom name
#
nconf.file "custom", "./settings.json"

#
# Or searching from a base directory.
# Note: `name` is optional.
#
nconf.file name,
  file: "config.json"
  dir: __dirname
  search: true


#
# 5. Any default values
#
nconf.defaults "if nothing else": "use this value"


