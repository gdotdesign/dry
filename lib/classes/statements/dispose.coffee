module.exports.Dispose = class Dispose extends Statement
  compile: ->
    base = @exp.compile()
    base+".parentNode.removeChild "+base