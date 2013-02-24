levelup = require("levelup")

# 1) Create our database, supply location and options.
#    This will create or open the underlying LevelDB store.
db = levelup("./mydb")

# 2) put a key & value
db.put "name", "LevelUP", (err) ->
  return console.log("Ooops!", err)  if err # some kind of I/O error

  # 3) fetch by key
  db.get "name", (err, value) ->
    return console.log("Ooops!", err)  if err # likely the key was not found

    # ta da!
    console.log "name=" + value


