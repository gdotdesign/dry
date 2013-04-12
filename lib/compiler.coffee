Array::compact = -> @filter((item) -> !!item)
String::camelize = -> @replace /[- _](\w)/g, (matches) -> matches[1].toUpperCase()

coffee   = require 'coffee-script'
fs       = require 'fs'
path     = require 'path'

Classes  = require __dirname+'/classes'
{parser} = require __dirname+'/parser'

helpers =
  extra: true
  for: true
  'class': true
  'element': true
  'selector': true
  'json': true
  'request': true
  'template': true
  'attribute': true
  'css': true

Modules = Classes.Modules = []
Classes.Requires = {}
Classes.Classes = []

SelectorProperties = {}
Classes.AddSelectorProperty = (name) ->
  unless SelectorProperties[name]
    SelectorProperties[name] = "Selector.warp('#{name}')"

JS =
  stringify: (obj) ->
    "{"+(for key,value of obj then '"'+key+'"'+": "+value).join(", ")+"}"

BuildHelpers = ->
  helperCode = ''
  for key, value of helpers
    if value
      console.log "Adding helper: #{key}" if verbose
      helperCode += fs.readFileSync(__dirname+'/../helpers/'+key)+"\n"
  helperCode

helperCode = coffee.compile BuildHelpers(), bare: true

exports.geatherFile = geatherFile = (filePath, root = __dirname, requires = []) ->
  filepath = path.resolve(root, filePath)
  filepath = path.resolve(root, filePath+".dry") unless fs.existsSync(filepath)
  geather fs.readFileSync(filepath,'utf-8'), path.resolve(filepath, '..'), requires
  requires

geather = (str, path = __dirname, requires) ->
  root = parser.parse str
  root.path = path
  for s in root.statements.compact()
    if s.type is 'require'
      requires.push(s.exp)
    if s.type is 'include'
      geatherFile s.exp, path, requires

Classes.compileFile = compileFile = (filePath, root = __dirname, helpers = true, cp = true) ->
  filepath = path.resolve(root, filePath)
  filepath = path.resolve(root, filePath+".dry") unless fs.existsSync(filepath)
  compile fs.readFileSync(filepath,'utf-8'), path.resolve(filepath, '..'), helpers, cp

Classes.compile = compile = (str, path = __dirname, helpers = true, compile = true)->
  sStart = Date.now()
  code = []
  try
    start = Date.now()
    root = parser.parse str
    root.path = path
    console.log "Parsing took #{Date.now()-start}ms" if verbose
    start = Date.now()
    for s in root.statements.compact()
      code.push s.compile()
    console.log "Eval took #{Date.now()-start}ms" if verbose
    co = code.join("\n")
    if compile
      start = Date.now()
      code = coffee.compile co, bare: true
      console.log "CS compile took #{Date.now()-start}ms"  if verbose
    else
      code = co
    if helpers
      console.log "Full compile took: "+(Date.now()-sStart)+"ms" if verbose
      hp = helperCode
      hp += "Selector.accessor("+JS.stringify(SelectorProperties)+")\n"
      for key in Modules
        hp += key+" = {}\n"
      hp+"\n"+code
    else
      code
  catch e
    console.log e
    throw e if e.exp
    throw "<Syntax error: unexpected '#{e.found}' ##{e.line}:#{e.column}>" if e.line
    throw e

exports.compileFile = compileFile