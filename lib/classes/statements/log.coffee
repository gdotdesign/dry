module.exports.Log = class Log extends Statement
  compile: ->
    args = if @exp instanceof List then @exp.compile() else ""
    "console.log #{args}"