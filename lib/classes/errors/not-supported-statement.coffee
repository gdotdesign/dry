module.exports.NotSupportedStatementError = class NotSupportedStatementError extends StatementError
  constructor: (@exp,@s, @context = false)->
  toString: ->
    message = "Statement #{@exp} not supports statement #{@s}"
    message += " in this context" if @context
    message