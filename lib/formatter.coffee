###
todo - Todos in the CLI like what.
Veselin Todorov <hi[at]vesln.com>
MIT License.
###

# Dependencies.
colors = require 'colors'

# Formatter.
formatter = module.exports

# Formats an item.
formatter.format = (item, num) ->

  if item.done
    '√'.green

  else
    '✖'.red

  return "  "
  +  "#"
  + (num + 1)
  + "  "
  + state
  + "  "
  + item.text
