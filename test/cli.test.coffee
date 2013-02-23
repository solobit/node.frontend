#!
# * todo - Todos in the CLI like what.
# *
# * Veselin Todorov <hi@vesln.com>
# * MIT License.
#

###
Test dependencies.
###
flatiron = require("flatiron")
path = require("path")

###
The tests object.

@type {Object}
###
cli = require("../lib/cli")

###
Support.
###
storage = require("../lib/storage")
commands = require("../lib/commands")
describe "cli", ->
  it "should expose flatiron app", ->
    cli.should.eql flatiron.app

  it "should register routes", ->
    cli.router.routes.version.on.should.eql commands.version
    cli.router.routes.ls.on.should.eql commands.list
    cli.router.routes.clear.on.should.eql commands.clear
    cli.router.routes.rm["([\\d]+)"].on.should.eql commands.destroy
    cli.router.routes.check["([\\d]+)"].on.should.eql commands.check
    cli.router.routes.undo["([\\d]+)"].on.should.eql commands.undo
    cli.router.routes["(.+)"].on.should.eql commands.add


