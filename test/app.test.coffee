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
Dependencies.
###
flatiron = require("flatiron")

###
The tests object.

@type {Object}
###
app = require("./lib/app")
describe "app", ->
  it "is flatiron app", ->
    app.should.eql flatiron.app


