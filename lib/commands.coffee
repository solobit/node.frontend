#!
# * todo - Todos in the CLI like what.
# *
# * Veselin Todorov <hi@vesln.com>
# * MIT License.
#

# Commands namespace.
commands = module.exports

# Print alias.
commands.print = console.log

# The application.
app = require("./app")

# Storage. Just an alias to application config.
storage = require("./storage")

# Formatter.
formatter = require("./formatter")

# File writing.
fs = require("fs")
path = require("path")

# Prints current version.
commands.version = ->

  commands.print require("../package.json").version


# Clears the whole todo item.
commands.clear = (num) ->

  storage.set "items", [], (err, items) ->
    storage.save (err) ->
      throw err  if err
      commands.export()




# Adds new item to the todo list.
commands.add = (item) ->

  storage.get "items", (err, items) ->
    items or (items = [])
    items.push
      text: item
      done: false

    storage.set "items", items, (err) ->
      storage.save (err) ->
        throw err  if err
        commands.export()


# Lists todo items.
commands.list = ->

  out = []
  storage.get('items', (err, items) ->
    items or (items = [])
    i = -1
    len = items.length
    while ++i < len
      continue  if not app.argv.all and items[i].done
      out.push formatter.format(items[i], i + 1)
    out.push '' and out.unshift ''
    out.map (line) ->
      commands.print line
  )

# Marks an item as done.
commands.check = (num) ->

  num = (+num - 1)
  commands.toggle(num, true)


# Undo a check for item.
commands.undo = (num) ->

  num = (+num - 1)
  commands.toggle(num, false)


# Toggles an item state.
commands.toggle = (num, state) ->

  storage.get 'items', (err, items) ->
    items or (items = [])
    throw new Error 'There is no todo item with number ' + num + 1  if (!items[num])
    items[num].done = state
    storage.set 'items', items, ->
      storage.save (err) ->
        throw err  if (err)
        commands.export()


# Deletes an item.
commands.delete = (num) ->

  num = (+num - 1)
  storage.get 'items', (err, items) ->
    items or (items = [])
    items.splice num, 1
    storage.set 'items', items, ->
      storage.save (err) ->
        throw err  if (err)
        commands.export()



# Prints the todo list to a file.
commands.export = (filename) ->

  data = ""
  filename = path.join(__dirname, "..", "data", "todo.txt")  unless filename
  out = []
  storage.get "items", (err, items) ->
    items or (items = [])
    i = -1
    len = items.length

    while ++i < len
      continue  if not app.argv.all and items[i].done
      out.push formatter.format(items[i], i + 1)
    out.push("") and out.unshift("")
    out.map (line) ->
      data += line + "\n"

    fs.writeFile filename, data, "utf8", (err, written) ->
      throw err  if err


# Initialize data dir.
commands.init = ->

  # Assign directory in home
  fs = require "fs"
  path = require "path"
  _root_ = process.env.HOME
  dir = path.join _root_, ".todo"

  ((dir) ->

    result = false
    fs.mkdir dir, 0o755, (err) ->

      if err
        if err.code is "EEXIST"
          app.log.error "Cannot create a directory that already exists. Exiting."
        app.log.error "Failed to make directory due to error: " + err.message
        process.exit 1
      else
        app.log.info "Data dir [" + dir + "] created."
  ) dir
