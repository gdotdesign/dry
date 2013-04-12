module.exports.New = class New extends Statement
  compile: ->
    args = if @args instanceof List then @args.compile() else ""
    "new #{@name.name}(#{args})"
