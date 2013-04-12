module.exports.Group = class Group extends Statement
  compile: ->
    "("+@exp.compile()+")"