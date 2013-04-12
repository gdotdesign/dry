module.exports.Statement = class Statement
  constructor: (props) ->
    for key,value of props
      @[key] = value
  toString: ->
    "<"+@__proto__.constructor.name+" #{@type} ##{@line}:#{@column}>"
  compileBlock: (s, indent = true)->
    c = []
    if s.statements
      for st in s.statements
        c.push st.compile()
    if indent
      for line,i in c
        c[i] = line.replace(/^/gm, '  ')
    c.join("\n")
  lookupClassPath: (s) ->
    c = []
    parent = s.parent
    while parent.type is 'module'
      c.push parent.name
      parent = parent.parent
    c.reverse()
    c.push s.name
    c.join(".")
  inType: (type) ->
    return @parent.type is type
  inExtends: ->
    return false unless @inClass()
    !!@parent.extends
  inRoot: ->
    @parent.type is 'root'
  inModule: ->
    @inType 'module'
  inClass: ->
    @inType 'class'
  inDef: ->
    @inType 'def'
  throw: ->
    throw new NotSupportedStatementError( @parent, @, true )