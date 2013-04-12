fs                = require 'fs'
PEG               = require 'pegjs'
PEGjsCoffeePlugin = require 'pegjs-coffee-plugin'
PEGjsCoffeePlugin.addTo PEG

grammar = ''
for file in ['index','expression','basic']
  grammar += fs.readFileSync(__dirname+'/../grammar/'+file+'.pegjs','utf-8')+"\n"

start = Date.now()
exports.parser = PEG.buildParser grammar, trackLineAndColumn: true, cache: true
console.log "Parser took #{Date.now()-start}ms" if verbose
