module.exports.Def = class Def extends Method
  compile: ->
    if @parent.type is 'module'
      @base = @lookupClassPath(@parent)+"."+@base
    operator = if @parent.type is 'class' then ":" else "="
    args = if @args instanceof List then @args.compile() else ""
    @base + " #{operator} (#{args})->\n"+@compileBlock @