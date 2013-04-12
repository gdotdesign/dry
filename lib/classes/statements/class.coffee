module.exports.Class = class Class extends Statement
  constructor: ->
    super
    @statements = []
  validateStatement: (s) ->
    return false unless s.type
    ['def','get','set','const','prop','constructor','mixin'].indexOf(s.type) isnt -1
  compile: ->
    exports.parent.Classes.push @lookupClassPath(@)
    if @extends
      code = "class #{@lookupClassPath(@)} extends #{@extends.name}\n"+@compileBlock @
    else
      code = "class #{@lookupClassPath(@)}\n"+@compileBlock @