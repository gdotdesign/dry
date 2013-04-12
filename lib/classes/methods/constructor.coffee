module.exports.Constructor = class Constructor extends Method
  compile: ->
    @throw unless @inClass()
    args = if @args instanceof List then @args.compile() else ""
    "constructor: (#{args}) ->\n"+@compileBlock @