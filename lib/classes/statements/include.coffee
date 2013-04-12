module.exports.Include = class Include extends Statement
  compile: ->
    @throw() unless @inRoot()
    exports.parent.compileFile @exp, @root.path, false, false

module.exports.Require = class Require extends Statement
  compile: ->
    @throw() unless @inRoot()
    [lib,version] = @exp.split('@')
    version ?= '*'
    resolvePackage lib, version

resolvePackage = (name, version) ->
  if version isnt "*"
    if (v = module.exports.parent.Requires[name])
      if v isnt version
        throw "CONFLICT: #{name}@#{v} is already loaded when trying to load #{name}@#{version}"
      else
        return ""
  fs = require('fs')
  cache = process.cwd()+"/.dry-cache"
  libDir = cache+"/#{name}/"
  if version is "*"
    if fs.existsSync(libDir+"version")
      version = fs.readFileSync(libDir+"version",'utf-8')
    else
      throw "Package '#{name}' not found. Please run dry --install."
  if fs.existsSync(libDir+"#{version}/dry.json")
    config = JSON.parse(fs.readFileSync(libDir+"#{version}/dry.json",'utf-8'))
    module.exports.parent.Requires[name] = version
    exports.parent.compileFile config.main, libDir+"#{version}", false, false
  else
    throw "Package '#{name}' not found. Please run dry --install."