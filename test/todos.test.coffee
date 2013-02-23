Todos = require("../lib/todos")
Storage = require("./support/fake_storage")
describe "todos", ->
  fake = undefined
  todos = undefined
  items = undefined
  beforeEach ->
    fake = new Storage()
    todos = new Todos(fake)
    items = (method) ->
      returned = undefined
      todos[method] (items) ->
        returned = items

      returned

  describe "all", ->
    it "runs a callback with all items", ->
      fake.items = [1, 2, 3, 4, 5]
      items("all").should.eql [1, 2, 3, 4, 5]

    it "runs a callback with empty array if no items are preset", ->
      fake.items = null
      items("all").should.eql []


  describe "add", ->
    it "adds a todo items", ->
      todos.add "Text"
      todo = items("all")[0]
      todo.text.should.eql "Text"
      todo.done.should.not.be.ok

    # reserved words supported for now: check, rm, undo
    it "adds todo items that begin with a reserved word", ->
      todos.add "check the thermometer"
      todos.add "rm the test file"
      todos.add "undo injustices in the world"
      checkTodo = items("all")[0]
      checkTodo.text.should.eql "check the thermometer"
      checkTodo.done.should.not.be.ok

      rmTodo = items("all")[1]
      rmTodo.text.should.eql "rm the test file"

      rmTodo.done.should.not.be.ok
      undoTodo = items("all")[2]
      undoTodo.text.should.eql "undo injustices in the world"
      undoTodo.done.should.not.be.ok

  describe "destroy", ->
    it "removes an item with given index", ->
      fake.items = [1, 2, 3, 4, 5]
      todos.destroy 1
      items("all").should.eql [1, 3, 4, 5]


  describe "check", ->
    it "can mark todo as done", ->
      fake.items = [done: false]
      todos.check 0, true
      items('all')[0].done.should.be.ok

    it "can mark todo as no done", ->
      fake.items = [done: true]
      todos.check 0, false
      items('all')[0].done.should.not.be.ok

    it "throws an error if todo doesn't not exits", ->
      (-> todos.check(0, false)).should.throw(/There is no todo item with number/)

  describe "clear", ->
    it "removes all items", ->
      fake.items = [1, 2, 3]
      todos.clear()
      items("all").should.eql []


  describe "undone", ->
    it "runs a callback with all undone items", ->
      done = done: true
      undone = done: false
      fake.items = [done, undone, done, undone]
      items("undone").should.eql [undone, undone]



