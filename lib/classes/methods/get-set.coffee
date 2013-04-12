module.exports.Set = class Set extends Method
  compile: ->
    @throw() unless @inClass()
    "@set '#{@base}': (#{@name})->\n"+@compileBlock @

module.exports.Get = class Get extends Method
  compile: ->
    @throw() unless @inClass()
    if @name
      "@get '#{@base}': (#{@name})->\n"+@compileBlock @
    else
      "@get '#{@base}': ->\n"+@compileBlock @