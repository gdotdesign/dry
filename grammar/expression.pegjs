Statement
  = ObjectLiteral
  / Comment
  / Iteration
  / ArrayLiteral
  / Log
  / After
  / Every
  / Await
  / XHR
  / Else
  / If
  / Unless
  / Try
  / Catch
  / Super
  / Module
  / New
  / Get
  / Set
  / Class
  / Mixin
  / Prop
  / Template
  / Render
  / Conditional
  / Contsructor
  / Def
  / Dispose
  / Delete
  / Event
  / Operation
  / Call
  / MemberAccess
  / Group
  / Primary

After
  = "after" _+ base:Statement { new @After type: 'after', exp: base }
Every
  = "every" _+ base:Statement { new @Every type: 'every', exp: base }

Include
  = "include" _* s:String { new @Include type: 'include', exp: s }
Require
  = "require" _* s:String { new @Require type: 'require', exp: s }
Comment
  = "#" _ [^\n\r]* {""}

Json
  = "<" statement:Statement ">" { new @Json statement }

Primary
  = "self"             { new @Literal("self") }
  / Json
  / Selector
  / lit:Literal        { if lit instanceof @Literal then lit else new @Literal(lit)  }
  / Variable
  / ConstLookup

Variable
  = self:"@"? name:Identifier { v = new @Variable(name); v.self = !!self; v }

Accessor
  = StyleAccessor
  / AttributeAccessor
  / PropertyAccessor
  / AltPropertyAccessor

AttributeAccessor
  = "@" head:[a-z] tail:[a-z0-9-]i+ { new @Accessor 'attribute', head+tail.join("") }
StyleAccessor
  = "#" head:[a-z] tail:[a-z0-9-]i+ { new @Accessor 'style', head+tail.join("") }
PropertyAccessor
  = "." name:Identifier { new @Accessor 'property', name }
AltPropertyAccessor
  = "[" s:Statement "]" { new @Accessor 'alt-property', s}

ConstLookup
  = left:ConstantIdentifier right:(":" name:ConstantIdentifier {name} )* { new @Variable [left].concat(right).join(".") }

MemberAccess
  = base:(Group/Primary) data:Accessor { new @MemberAccessor base, data }

Group
  = "(" _* s:Statement _* ")" { new @Group type: 'group', exp: s }
Operation
  = left:(Call/LEFT) _ operator:Operator _ right:Statement { new @Operation type: 'operation', left: left, right:right, operator: operator}


Await
  = "await" { new @Await type: 'await' }

XHR
  = "~" type:(">"/"="/"!")? _+ url:Statement data:(_+ "with" _+ s:Statement {s})? { new @XHR type: 'xhr', method: type, url:url, data:data}

Call
  = base:LEFT args:(ArgumentList / ("!"/"?")) callbackArgs:(_ a:ArgumentList {a})? callback:( _* "&" _* s:Statement? {s or true})? { new @Call type: 'call', exp: base, args:args, callback: callback, callbackArgs: callbackArgs}



If
  = "if" _+ base:Statement { new @If type: 'if', exp: base }
Else
  = "else" { new @Else type: 'else' }
Try
  = "try" { new @Try type: 'try'}
Catch
  = "catch" args:ArgumentList? { new @Catch type: 'catch', args: args}
Unless
  = "unless" _+ base:Statement { new @Unless type: 'unless', exp: base }


ArgumentList
  = "("_* args:List _* ")" { args }

Template
  = "template" _* base:Identifier { new @Template type: 'template', exp: base}

Render
  = "render" _+ name:Identifier data:(_+ "with" _+ st:Statement {st})? { new @Render type: 'render', name: name, data:data}





Module
  = "module" _+ name:ConstantIdentifier {new @Module type: 'module', name: name}

Mixin
  = "mixin" _+ name:ConstLookup {new @Mixin type: 'mixin', name: name}

Class
  = "class" _+ name:ConstantIdentifier ext:(_+ "extends" _+ ext:ConstLookup {ext} )? {new @Class type: 'class', name: name, extends: ext}

New
  = "new" _+ name:ConstLookup args:ArgumentList? {new @New type: 'new', name: name, args:args }

Super
  = "super" list:(_+ list:List {list})? {new @Super type: 'super', args:list}

Get
  = "get" _+ base:Identifier name:("(" _* name:Identifier _* ")" {name})? {new @Get type: 'get', base:base, name: name}

Prop
  = "prop" _+ base:Identifier value:(_+ value:(Primary/ArrayLiteral/ObjectLiteral) {value})? {new @Prop type: 'prop', base:base, value: value }

Set
  = "set" _+ base:Identifier "(" _* name:Identifier _* ")" {new @Set type: 'set', base:base, name: name}

Def
  = "def" _+ base:Identifier args:ArgumentList? ("!"/"?")? { new @Def type: 'def', base:base, args:args }

Contsructor
  = "def constructor" args:ArgumentList? ("!"/"?")? { new @Constructor type: 'constructor', args:args }



Log
  = "log" _+ base:List { new @Log type: 'log', exp: base }

Dispose
  = "dispose" _+ base:LEFT { new @Dispose type: 'dispose', exp: base }

Delete
  = "delete" _+ base:LEFT { new @Delete type: 'dispose', exp: base }

Event
  = base:LEFT "::" name:Identifier bound:"!"? { new @Event type: 'event', base:base, name: name, bound: bound }

Conditional
  = base:LEFT _* "?"  _* ts:Statement _* ":"  _* fs:Statement { new @Conditional type: 'conditional', base:base, ts: ts, fs: fs }

ArrayLiteral
  = "[" list:List "]" { new @ArrayLiteral list }

List
  = head:Statement? _* tail:("," _* tail:Statement _* {tail} )* { new @List [head].concat(tail) }

LEFT
  = MemberAccess / Primary / Selector

Selector = GlobalSelector / SelfSelector

GlobalSelector
  = "|" selector:[^|]+ "|" { new @Selector selector.join("") }
SelfSelector
  = "\\" selector:[^\\]+ "\\" { new @Selector selector.join(""), true }

ObjectLiteral
  = "{" (_/"\n")* obj:(key:(String/Identifier) _* ":" _* value:Statement (_/"\n")* ","? (_/"\n")* {[key,value]} )* "}" {
    ret = new @Obj
    for item in obj
      ret[item[0]] = item[1]
    ret
  }

Iteration
  = obj:(ArrayLiteral/ObjectLiteral/MemberAccess/Primary) _* callbackArgs:ArgumentList? _* "&&" _* statement:Statement? { new @Iteration type:'iteration', base:obj, statement: statement, callbackArgs: callbackArgs}

Operator
  = "=="
  / "*~"
  / "*+"
  / "*-"
  / "+="
  / "-="
  / "isnt"
  / "is"
  / "="
  / "<<"
  / "+"
  / "-"
  / "*="
  / "*"
  / "and"
  / ">"
  / "<"
  / "%"
  / "/"
  / "|"
  / "or"
  / "&="
