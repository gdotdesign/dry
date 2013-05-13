fs    = require 'fs'
path  = require 'path'
nconf = require 'nconf'
coffee = require 'coffee-script'
autoprefixer = require('autoprefixer')
jade = require('jade')

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
  @all "*", ->
    p = path.resolve process.cwd(), @params[0].substr(1)
    return @next() unless fs.existsSync(p)
    if fs.statSync(p).isDirectory()
      if fs.existsSync(p+"/index.jade")
        fn = jade.compile(fs.readFileSync(p+"/index.jade",'utf-8'),{filename: p+"/index.jade"})
        fn()
      else
        return @next()
    else
      return @next()

  @get "*.coffee", ->
    p = path.resolve process.cwd(), @params[0].substr(1)
    @response.set 'Content-Type', 'text/javascript'
    coffee.compile fs.readFileSync(p+".coffee",'utf-8'), {bare: true}
  @get "*.css",     ->
    p = path.resolve process.cwd(), @params[0].substr(1)+".css"
    @response.set 'Content-Type', 'text/css'
    autoprefixer.compile fs.readFileSync(p,'utf-8')
  @get "*.dry",     ->
    p = path.resolve process.cwd(), @params[0].substr(1)
    compile.call @, p
, disable_io: true
