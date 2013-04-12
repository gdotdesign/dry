module.exports.XHR = class XHR extends Method
  constructor: ->
    super
    if !!@method
      @method = switch @method
        when "!" then 'DELETE'
        when ">" then 'POST'
        when "=" then 'PUT'
    else
      @method = 'GET'
  compile: ->
    ret = "__request__ (#{@url.compile()}), '#{@method}'"
    ret += ",#{@data.compile()}" if !!@data
    ret += ", ->\n"+@compileBlock @ if @statements.length > 0
    ret