#!
# * todo - Todos in the CLI like what.
# *
# * Veselin Todorov <hi@vesln.com>
# * MIT License.
#

# Todos constructor.
Todos = (storage) ->
  @storage = storage

# Fetch all items.
Todos::all = (cb) ->
  @storage.get "items", (err, items) ->
    cb items or []


Todos::add = (text) ->
  @all (items) ->
    items.push
      text: text
      done: false

    @_update items
  .bind(this)

Todos::destroy = (num) ->
  @all (items) ->
    items.splice num, 1
    @_update items
  .bind(this)

Todos::check = (num, checked) ->
  @all (items) ->
    throw new Error("There is no todo item with number " + num + 1)  unless items[num]
    items[num].done = checked
    @_update items
  .bind(this)

Todos::undone = (callback) ->
  @all (items) ->
    items = items.filter((item) ->
      not item.done
    )
    callback items


Todos::clear = ->
  @_update []

Todos::_update = (items) ->
  @storage.set "items", items, ->
    @storage.save (err) ->
      throw err  if err

  .bind(this)

module.exports = Todos
