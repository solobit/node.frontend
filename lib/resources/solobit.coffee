


solobit       = exports

http          = require "http"
assert        = require "assert"
commandful    = require "commandful"
resourceful   = require "resourceful"


# <<abstract>>
# Create a new BaseAsset resource using the Resourceful library
# This abstract entity represents a generic valued asset in the domain. This can
# be a machine, piece of paper, strategy or idea (abstract concept) etc.
solobit.BaseAsset = resourceful.define("BaseAsset", ->

  self = @

  @commandful = true

  @use "memory"

  @string "type",
    default: "computer program"

  @string "description"

  @number "rating",
    default: 10


  @rate = (_id, options, callback) ->
    self.get _id, (err, BaseAsset) ->
      return callback(err)  if err
      rating = BaseAsset.rating + 1
      self.update _id,
        rating: rating
      , (err, result) ->
        callback null, result.id + " has been increased. experience is: " + result.rating

  @rate.remote = true
  @poll = (_id, options, callback) ->
    self.get _id, (err, BaseAsset) ->
      return callback(err)  if err
      rating = BaseAsset.rating - 1
      self.update _id,
        rating: rating
      , (err, result) ->
        callback null, result.id + " has been decreased. experience is: " + result.rating

  @poll.remote = true
  @_die = (food) ->
    # _die is not set to remote, so it won't be exposed
    # Remark: We'll consider the _die function "private",
    # in the sense that commandful will not expose it
    console.log "BaseAsset died."
)





#
# Create a new BaseAsset resource using the Resourceful library
#
solobit.User = resourceful.define("user", ->

  # Specify a storage engine
  @use "memory"
  @string "name"

  # Specify some properties with validation
  @string "email",
    format: "email"
    required: true

  # Specify a Number type
  @number "age",
    message: "is not a valid age"

  # Specify timestamp properties
  @timestamps()
)

solobit.Collection = resourceful.define("Collection", ->

  #this.use('couchdb', {database: "test3" })
  @commandful = true
  @use "memory"
  @string "title"
)

solobit.Category = resourceful.define("Category", ->
  @commandful = true

  #this.use('couchdb', {database: "test3" })
  @use "memory"
  @number "bpm"
  @string "description"
  @string "title"
  @bool "playing",
    default: false

)
solobit.Category.play = ->
  @playing = true

solobit.Category.play.remote = true
solobit.Category.pause = ->
  @playing = false

solobit.Category.pause.remote = true
solobit.Category._encode = ->


#
# Consider this a "private" method,
# in that it won't be exposed through commandful
#
solobit.Category.parent "Collection"
