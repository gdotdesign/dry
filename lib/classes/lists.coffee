module.exports.List = class List
  constructor: (@base)->
  compile: ->
    data = for item in @base.compact(true)
      item.compile()
    data.join(", ")

module.exports.ArrayLiteral = class ArrayLiteral
  constructor: (@base)->
  compile: ->
    "["+@base.compile()+"]"

module.exports.Obj = class Obj
  compile: ->
    data = for own key, value of @ 
      "#{key}: " + (value.compile())
    "{" + data.join(", ")+"}"