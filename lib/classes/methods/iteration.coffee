module.exports.Iteration = class Iteration extends Method
  compile: ->
    # TODO helper
    base = @base.compile()
    c = []
    if @callbackArgs
      cbargs = "(#{@callbackArgs.compile()})"
    else
      cbargs = ""
    c.push "__for__ #{base}, #{cbargs}->"
    if @statement
      c.push @statement.compile().replace(/^/gm, '  ')
    if @statements
      for st in @statements
        c.push st.compile().replace(/^/gm, '  ')
    c.join("\n")