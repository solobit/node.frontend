#!
# * todo - Todos in the CLI like what.
# *
# * Veselin Todorov <hi@vesln.com>
# * MIT License.
#

# Dependencies.
commandful  = require 'commandful'
flatiron    = require 'flatiron'

# Application
app = module.exports = flatiron.app

app.use flatiron.plugins.cli,
  usage: [
    "",
    "sb :: Solobit Command Line Power Tool",
    "",
    "Usage:",
    "",
    "       sb add todo <task>   - Adds new item.",
    "       sb init              - Initialize data directory",
    "       sb show todo         - Lists not finished items.",
    "       sb rm 1              - Removes #1 item.",
    "       sb check 1           - Marks #1 item as done.",
    "       sb undo 1            - Marks #1 item as not done yet.",
    "       sb clear             - Clears the whole list.",
    "       sb version           - Lib version.",
    "       sb export            - Export items to file.",
    "",
    "Author: Veselin Todorov <hi@vesln.com>",
    ""
    ],
  argv:
    login:
      alias: 'l',
      description: 'Login to use',
      string: true
    verbosity:
      alias: 'V'
      description: 'Verbosity level of console output'
      boolean: true
    display:
      alias: 'a'
      description: 'All. Show everything we know. Applies to info objects.'
      boolean: true

solobit = require '../lib/resources/solobit'

app.use flatiron.plugins.resourceful

app.resources =
  BaseAsset: solobit.BaseAsset
  Collection: solobit.Collection
  Category: solobit.Category

app.use commandful


###
app.router.on 'foo', ->
  app.log.info 'a custom foo route.'
###
