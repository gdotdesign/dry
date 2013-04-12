module.exports.Call = class Call extends Statement
  constructor: ->
    super
    @statements = []
  compile: ->
    args = if @args instanceof List then @args.compile() else @args
    if !!@callback or @statements.length > 0
      block = @compileBlock @
      if @callback?.compile
        block = (@callback.compile()).replace(/^/gm, '  ')+"\n"+block
      if @callbackArgs
        cbargs = "(#{@callbackArgs.compile()})"
      else
        cbargs = ""
      if args is ""
        args += "#{cbargs}->"
      else
        args += ", #{cbargs}->"
    if args is "!" or args is "?" or args is ""
      return @exp.compile()+"()"
    c = "("+@exp.compile()+" "+args
    if @callback or @statements.length > 0
      c +="\n"+block
    c += ")"