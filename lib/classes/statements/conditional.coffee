module.exports.Conditional = class Conditional extends Statement
  compile: ->
    "if "+@base.compile()+" then "+@ts.compile()+" else "+@fs.compile()