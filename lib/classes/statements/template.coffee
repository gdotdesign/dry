module.exports.Template = class Template extends Statement
  constructor: ->
    super
    @statements = []
  validateStatement: (s) -> s instanceof Element
  compile: ->
    elements = []
    for st in @statements
      elements.push st.compile()
    "__template__('#{@exp}',[#{elements.join(', ')}])"