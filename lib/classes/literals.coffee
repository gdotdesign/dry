module.exports.Null = class Null
  compile: -> "null"
  toString: -> "null"

module.exports.Literal = class Literal
  constructor: (@value) ->
  compile: ->
    return "this" if @value is "self"
    return @value if @value is 'true' or @value is 'false'
    return '"'+@value.replace(/"/g,'\\"')+'"' if typeof @value is 'string'
    @value

module.exports.Color = class Color extends Literal
  constructor: (@value) ->
  compile: -> "'#{@value}'"

module.exports.Json = class Json extends Literal
  constructor: (@exp) ->
  compile: -> "__json__(#{@exp.compile()})"

module.exports.Selector = class Selector extends Literal
  constructor: (@selector,@self)->
  compile: ->
    # TODO turn on helper
    if @self
      "__selector__('#{@selector}', this)"
    else
      "__selector__('#{@selector}')"

module.exports.Unit = class Unit extends Literal
  constructor: (@value,@type)->
  compile: ->
    return @value*16 if @type is 'em'
    return @value*1000 if @type is 's'
    @value

module.exports.Element = class Element extends Literal
  constructor: (@zen,attributes,@text) ->
    @attributes = {}
    @statements = []
    for item in attributes
      @attributes[item.key] = item.value
  compile: ->
    # TODO
    # turn on helper
    # move array compile to generics
    text = if @text then @text.compile() else '""'
    elements = []
    if @statements
      for s in @statements
        elements.push s.compile()
    '__element__("'+@zen+'", '+JSON.stringify(@attributes)+', '+text+', ['+elements.join(", ")+'])'

module.exports.Variable = class Variable extends Literal
  constructor: (@name,@self) ->
  compile: ->
    if @self then "@"+@name else @name