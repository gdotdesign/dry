module.exports.Event = class Event extends Method
  compile: ->
    operator = if @bound then "=" else "-"
    c = [@base.compile()+".addEventListener '#{@name}', (e)#{operator}>"]
    c.push "event = e".replace(/^/gm, '  ')
    for st in @statements
      c.push st.compile().replace(/^/gm, '  ')
    c.push ', true'
    c.join("\n")