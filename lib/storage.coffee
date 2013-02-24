#!
# * todo - Todos in the CLI like what.
# *
# * Veselin Todorov <hi@vesln.com>
# * MIT License.
#

# Dependencies.
Storr = require "storr"
path = require "path"

# ## not used yet / sync
Cubby = require 'cubby'
cubby = new Cubby()
cubby.set 'foo', 'bar'




# Database path.
db = path.join(process.env.HOME, '.todo', 'db.json')



# Storage.
storage = module.exports = new Storr db
#storage.source =
storage.set "items", { "foo": true }, (err) ->
  storage.save (err) ->
    throw err  if err
