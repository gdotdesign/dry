module.exports.Module = class Module extends Statement
  constructor: ->
    super
    @statements = []
  validateStatement: (s) ->
    return false unless s.type
    ['def','mixin','class'].indexOf(s.type) isnt -1
  compile: ->
    exports.parent.Modules.push @lookupClassPath(@)
    @compileBlock @, false

module.exports.Mixin = class Module extends Statement
  compile: ->
    if @parent.type is 'module'
      path = @lookupClassPath(@parent)
      "#{path}.mixin #{@name.compile()}"
    else
      "@mixin #{@name.compile()}"
