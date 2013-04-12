module.exports.Accessor = class Acessor
  constructor: (@type, @name) ->

module.exports.MemberAccessor = class MemberAccessor
  constructor: (@base,@data) ->
  compile: ->
    base = @base.compile()
    s = switch @data.type
      when "style"
        if @base instanceof Selector
          base+".style('"+@data.name.camelize(false)+"').value"
        else
          "__css__(#{base}, '#{@data.name.camelize(false)}').value"
      when "attribute"
        # TODO turn on helper
        "__attribute__(#{base}, '#{@data.name}').value"
      when "property"
        # TODO
        if @base instanceof Selector
          exports.parent.AddSelectorProperty @data.name
        base+"?."+@data.name
      when "alt-property"
        base+"["+@data.name.compile()+"]"
    s = "@"+s if @self
    s