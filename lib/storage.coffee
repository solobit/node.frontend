#!
# * todo - Todos in the CLI like what.
# *
# * Veselin Todorov <hi@vesln.com>
# * MIT License.
#

# Dependencies.
Storr = require "storr"
path = require "path"

# Database path.
db = path.join process.env.HOME, '.todo', 'db.json'

# Storage.
storage = module.exports = new Storr(db)
