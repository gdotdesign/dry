module.exports.SubStatementError = class SubStatementError extends StatementError
  toString: ->
    "Satement #{@exp} can't have sub statements!"