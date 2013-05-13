module.exports.Dispose = class Dispose extends Statement
  compile: ->
    base = @exp.compile()
    base+".parentNode.removeChild "+base

module.exports.Delete = class Delete extends Statement
  compile: ->
    "delete "+@exp.compile()