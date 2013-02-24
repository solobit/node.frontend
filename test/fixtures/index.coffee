
fixtures = exports
assert = require("assert")
commandful = require("../../node_modules/commandful")
resourceful = require("resourceful")
http = require("http")

#
# Create a new Creature resource using the Resourceful library
#
fixtures.Creature = resourceful.define("creature", ->
  self = this
  @commandful = true

  #
  # Specify a storage engine
  #
  #this.use('memory');
  @use "couchdb",
    database: "test3"


  #
  # Specify some properties with validation
  #
  @string "type",
    default: "dragon"

  @string "description"

  #
  # Specify timestamp properties
  #
  @number "life",
    default: 10

  @feed = (_id, options, callback) ->
    self.get _id, (err, creature) ->
      return callback(err)  if err
      life = creature.life + 1
      self.update _id,
        life: life
      , (err, result) ->
        callback null, result.id + " has been fed. life is: " + result.life



  @feed.remote = true
  @hit = (_id, options, callback) ->
    self.get _id, (err, creature) ->
      return callback(err)  if err
      life = creature.life - 1
      self.update _id,
        life: life
      , (err, result) ->
        callback null, result.id + " has been hit. life is: " + result.life



  @hit.remote = true
  @_die = (food) ->

    #
    # Remark: We'll consider the _die function "private",
    # in the sense that commandful will not expose it
    #
    console.log "creature died."
)

#
# _die is not set to remote, so it won't be exposed
#

#
# Create a new Creature resource using the Resourceful library
#
fixtures.User = resourceful.define("user", ->

  #
  # Specify a storage engine
  #
  @use "memory"
  @string "name"

  #
  # Specify some properties with validation
  #
  @string "email",
    format: "email"
    required: true


  #
  # Specify a Number type
  #
  @number "age",
    message: "is not a valid age"


  #
  # Specify timestamp properties
  #
  @timestamps()
)
fixtures.Album = resourceful.define("album", ->

  #this.use('couchdb', {database: "test3" })
  @commandful = true
  @use "memory"
  @string "title"
)
fixtures.Song = resourceful.define("song", ->
  @commandful = true

  #this.use('couchdb', {database: "test3" })
  @use "memory"
  @number "bpm"
  @string "description"
  @string "title"
  @bool "playing",
    default: false

)
fixtures.Song.play = ->
  @playing = true

fixtures.Song.play.remote = true
fixtures.Song.pause = ->
  @playing = false

fixtures.Song.pause.remote = true
fixtures.Song._encode = ->


#
# Consider this a "private" method,
# in that it won't be exposed through commandful
#
fixtures.Song.parent "album"
