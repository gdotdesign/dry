module.exports.Super = class Super extends Statement
  compile: ->
    @throw() unless (@inDef() or @inType('constructor')) and @parent.inClass() and @parent.inExtends()
    "super"