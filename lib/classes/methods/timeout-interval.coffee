module.exports.After = class After extends Method
  compile: ->
    "setTimeout ( => \n"+@compileBlock(@)+"\n), "+@exp.compile()

module.exports.Every = class Every extends Method
  compile: ->
    "setInterval ( => \n"+@compileBlock(@)+"\n), "+@exp.compile()