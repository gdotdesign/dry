module.exports.If = class If extends Method
  compile: ->
    "if "+@exp.compile()+"\n"+@compileBlock @

module.exports.Try = class Try extends Method
  compile: ->
    "try\n"+@compileBlock @

module.exports.Catch = class Try extends Method
  compile: ->
    index = @parent.statements.indexOf(@)
    @throw() unless (prevStatement = @parent.statements[index-1])
    @throw() if ['try'].indexOf(prevStatement.type) is -1
    args = if @args instanceof List then @args.compile() else @args
    "catch #{args}\n"+@compileBlock @

module.exports.Else = class Else extends Method
  compile: ->
    index = @parent.statements.indexOf(@)
    @throw() unless (prevStatement = @parent.statements[index-1])
    @throw() if ['if','unless'].indexOf(prevStatement.type) is -1
    "else\n"+@compileBlock @

module.exports.Unless = class Unless extends Method
  compile: ->
    "unless "+@exp.compile()+"\n"+@compileBlock @