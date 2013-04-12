{
  if typeof exports is 'undefined'
    p = 'classes'
  else
    path = require 'path'
    p = path.resolve __dirname,"../../../lib/classes.coffee"
  for key,value of require p
    @[key] = value
  @tree = new @Tree
}


start
  = (line/" "*"\n")* { @tree.root }

line
  = indent:"  "*
    name: statement
    ws: _*
    ( EOF / !. )
    {
      @tree.addNode indent.length, name, line, column
    }

statement
  = Include
  / Require
  / Statement