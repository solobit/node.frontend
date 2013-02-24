#!
# todo - Todos in the CLI like what.
#
# Veselin Todorov <hi@vesln.com>
# MIT License.
#

# Commands namespace.
commands = module.exports

# Node core modules
fs          = require "fs"
path        = require "path"

# App internal modules
app         = require "./app"             # The application.
storage     = require "./storage"         # Storage. Just an alias to application config.
formatter   = require "./formatter"       # Formatter.
logger      = require "./logger"          # System logger for events, errors and history

solobit     = require "./lib/resources/solobit"

# Constant variables (pseudo)
HOME_DIR    = process.env.HOME
DATA_DIR    = path.join HOME_DIR, ".todo"
DATA_FILE   = path.join DATA_DIR, 'db.json'

# Print alias
commands.print = logger.data

# Initialize data dir.
commands.init = ->

  # Create directory with correct permissions
  fs.exists DATA_DIR, (exists) ->

    if exists
      app.log.error "Data directory not created, already exists."

    else
      fs.mkdir DATA_DIR, 0o755, (err) ->
        app.log.error "Failed to initialize directory: " + err  if err
        app.log.info "Data directory [" + DATA_DIR + "] created."

    # Write database file if not already present
    fs.exists DATA_FILE, (exists) ->
      if exists
        app.log.error "Data file already exists...skipping"
      else
        fs.writeFile DATA_FILE, (err, written) ->
          throw err  if err
          app.log.info "Written db.json file in " + DATA_DIR

          # Initialize store with JSON data
          items = []
          storage.set 'items', items, ->
            storage.save (err) ->
              throw err  if err
              commands.export()


commands.todo = ->
  app.log.info "abc"


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

  # Get from data store, catch errors early
  storage.get 'items', (err, items) ->
    app.log.error  if err

    # Get data or create new array object
    items = [] if items?
    items.push({text: item, done: false})

    # Old + new additions saved in store
    storage.set "items", items, (err) ->
      storage.save (err) ->
        throw err  if err
        commands.export()


# Lists todo items.
commands.list = ->

  out = []
  storage.get('items', (err, items) ->

    console.log typeof items
    items = [] if items?
    len = items.length
    i = -1

    console.log items.length
    while i += len
      continue if not app.argv.all and items[i].done
      out.push formatter.format(items[i], i + 1)

    out.push('') and out.unshift('')

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
    items = []  if items?
    throw new Error 'There is no todo item with number ' + num + 1  if (!items[num])
    items[num].done = state
    storage.set 'items', items, ->
      storage.save (err) ->
        throw err  if err
        commands.export()


# Deletes an item.
commands.delete = (num) ->
  num = (+num - 1)
  storage.get 'items', (err, items) ->
    items or (items = [])
    items.splice num, 1
    storage.set 'items', items, ->
      storage.save (err) ->
        throw err  if err
        commands.export()



#
# Prints the todo/task list to a file
#
commands.export = (filename = DATA_FILE) ->
  console.log filename
  # Local members
  data = ""
  out = []

  # Retrieve all items from data store
  storage.get "items", (err, items) ->

    items or (items = []) # enforce new array if no items found
    len = items.length    # length of array, start at 0 .. ?
    i = -1                # set index

    # loop?
    while ++i < len

      # Proceed only with all current new items
      continue  if not app.argv.all and items[i].done

      # Populate array collection of items
      out.push(formatter.format(items[i], i + 1))

    # Add items to beginning of array
    out.push("") and out.unshift("")

    # Higher order function, method taking function as parameter
    out.map (line) -> data += line + "\n"

    #
    #
    #
    fs.writeFile filename, data, "utf8", (err, written) ->
      throw err  if err
      app.log.info "File export written."



