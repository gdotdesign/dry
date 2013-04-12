module.exports.Await = class Await extends Method
  constructor: ->
    super
    @statements = []
  translateAsync: (s) ->
    for st,i in s.statements
      if st.statements?
        firstSt = st
        break
    if firstSt
      firstSt.statements = firstSt.statements.concat s.statements.splice i+1
      @translateAsync(st)
    else
      s
  compile: ->
    @translateAsync @
    @compileBlock @, false