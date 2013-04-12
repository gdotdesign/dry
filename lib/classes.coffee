requireMerge = (path) ->
  obj = require path
  for key, value of obj
    obj.parent = module.exports
    module.exports[key] = value
    @[key] = value

requireMerge './classes/literals'
requireMerge './classes/lists'
requireMerge './classes/accessors'
requireMerge './classes/statement'
requireMerge './classes/method'

requireMerge './classes/statements/call'
requireMerge './classes/statements/class'
requireMerge './classes/statements/conditional'
requireMerge './classes/statements/dispose'
requireMerge './classes/statements/group'
requireMerge './classes/statements/include'
requireMerge './classes/statements/log'
requireMerge './classes/statements/module'
requireMerge './classes/statements/new'
requireMerge './classes/statements/operation'
requireMerge './classes/statements/prop'
requireMerge './classes/statements/render'
requireMerge './classes/statements/super'
requireMerge './classes/statements/template'

requireMerge './classes/methods/await'
requireMerge './classes/methods/constructor'
requireMerge './classes/methods/def'
requireMerge './classes/methods/event'
requireMerge './classes/methods/get-set'
requireMerge './classes/methods/if'
requireMerge './classes/methods/iteration'
requireMerge './classes/methods/timeout-interval'
requireMerge './classes/methods/xhr'

requireMerge './classes/errors/statement'
requireMerge './classes/errors/not-supported-statement'
requireMerge './classes/errors/sub-statement'

requireMerge './classes/tree'