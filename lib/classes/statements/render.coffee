module.exports.Render = class Render extends Statement
  compile: ->
    if @data
      "__render__('#{@name}', #{@data.compile()})"
    else
      "__render__('#{@name}')"