fs    = require 'fs'
path  = require 'path'
nconf = require 'nconf'

nconf.argv
  c:
    alias: 'cache'
    describe: 'Use cached require'
    default: true
  l:
    alias: 'log'
    describe: 'Verbose logging'

cache = nconf.get('cache')
global.verbose = nconf.get('log')

compile = (file)->
  if cache is 'false'
    for key, value of require.cache
      if !!key.match('dry') and !key.match('node_modules')
        delete require.cache[key]
  try
    {compileFile} = require '../lib/compiler'
    @response.set 'Content-Type', 'text/javascript'
    return compileFile file, path.resolve(__dirname, '../')
  catch e
    @response.set 'Content-Type', 'text/css'
    "window.onload = function(){document.body.textContent = '#{e.toString().replace(/\'/g,'"')}'}"

module.exports.app = require('zappajs').app ->
  @use @app.router
  @use 'static': process.cwd()
  @get "*.dry",     ->
    p = path.resolve process.cwd(), @params[0].substr(1)
    compile.call @, p
, disable_io: true
