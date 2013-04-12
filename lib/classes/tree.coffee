module.exports.Root = class Root extends Statement
  constructor: ->
    super
    @statements = []
    @line = 0
    @column = 0
  compile: ->
    @compileBlock @

module.exports.Tree = class Tree
  constructor: ->
    @root = new Root type: 'root'
    @ancestors = []
  addNode: (indent, exp, line, column) ->
    return unless exp
    exp.line = line
    exp.column = column
    @ancestors.splice indent
    @current = @root
    @ancestors.forEach ((e) ->
      @current = e
    ), this
    throw new SubStatementError(@current) unless @current.statements
    if @current.validateStatement
      if @current.validateStatement(exp)
        @current.statements.push exp
        exp.parent = @current
      else
        throw new NotSupportedStatementError(@current,exp)
    else
      @current.statements.push exp
      exp.root = @root
      exp.parent = @current
    @ancestors.push exp