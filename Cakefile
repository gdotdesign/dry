global.verbose = false

fs = require 'fs'
browserify = require('browserify')()

compile = (str)->
  classes = require('classes')
  classes.Modules = []
  classes.Classes = []
  root = @parser.parse str
  code = (s.compile() for s in root.statements.compact())
  code.join("\n")


classes = ['literals','lists','accessors','statement','method','statements/call','statements/class','statements/conditional','statements/dispose','statements/group','statements/include','statements/log','statements/module','statements/new','statements/operation','statements/prop','statements/render','statements/super','statements/template','methods/await','methods/constructor','methods/def','methods/event','methods/get-set','methods/if','methods/iteration','methods/timeout-interval','methods/xhr','errors/statement','errors/not-supported-statement','errors/sub-statement','tree']

browserify.transform require('coffeeify')
for cls in classes
  browserify.require __dirname+"/lib/classes/"+cls+".coffee", expose: './classes/'+cls
browserify.require __dirname+"/lib/classes.coffee", expose: 'classes'

parser = require(__dirname+'/lib/parser').parser.toSource()
code = ["""
Array.prototype.compact = function() {
  return this.filter(function(item) {
    return !!item;
  });
};

String.prototype.camelize = function() {
  return this.replace(/[- _](\w)/g, function(matches) {
    return matches[1].toUpperCase();
  });
};
"""
,"window.dry = { "]
code.push "compile: "+compile.toString()+","
code.push "parser: "+parser
code.push "}"

str = browserify.bundle {}, (error,cd)->
  code.push "\n;(function(){\n#{cd}\n; window.require = require})()"
  fs.writeFileSync 'website/js/dry.js', code.join("\n")
