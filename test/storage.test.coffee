#!
# * todo - Todos in the CLI like what.
# *
# * Veselin Todorov <hi@vesln.com>
# * MIT License.
#

###
Support.
###
should = require("chai").should()

###
Test dependencies.
###
Storr = require("storr")

###
The tests object.

@type {Object}
###
storage = require("../lib/storage")
describe "storage", ->
  it "is Storr object", ->
    storage.constructor.should.eql Storr


