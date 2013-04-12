module.exports.Prop = class Prop extends Statement
  compile: ->
    @throw() unless @inClass()
    ret = "@prop '#{@base}'"
    ret += ", "+@value.compile() if !!@value
    ret