#!
# * todo - Todos in the CLI like what.
# *
# * Veselin Todorov <hi@vesln.com>
# * MIT License.
#

# Application.
app = module.exports = require("./app")

# Commands.
commands = require "./commands"

# Initialize storage
app.cmd /init/, commands.init

# Version.
app.cmd /version/, commands.version

# List todos.
app.cmd /ls/, commands.list

# Clear a todo item.
app.cmd /clear/, commands.clear

# Mark todo item as done.
app.cmd /check ([\d]+)/, commands.check

# Undo a todo item.
app.cmd /undo ([\d]+)/, commands.undo

# Destroy a todo item.
app.cmd /rm ([\d]+)/, commands.delete

# Export a todo list. Is this needed?
app.cmd /export (.+)/, commands.export

# Create a new todo item.
app.cmd /(.+)/, commands.add
