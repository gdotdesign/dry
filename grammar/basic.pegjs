Literal
  = Boolean
  / Null
  / Unit
  / Number
  / Color
  / String
  / Element

//TODO Regexp

Null
  = "null" { new @Null }

Element
  = "%" zen:[a-zA-Z0-9\.\#&%~!-]+ attributes:ElementAttribute* _* text:Statement? { new @Element(zen.join(""),attributes, text) }
ElementAttribute
  = "[" key:[a-zA-Z-_]+ "=" value:[^\]]+ "]" { {key:key.join(""), value: value.join("")} }

String
  = SingleQuotedString / DoubleQuotedString
DoubleQuotedString
  = "'" value:([^\']*) "'" { value.join("") }
SingleQuotedString
  = '"' value:([^\"]*) '"' { value.join("") }

Boolean
  = value:("true" / "false") { value is 'true' }

Color
  = color:(HexColor/RgbColor/HslColor) { new @Color(color) }
HexColor
  = "#" value:(Hex6Digit / Hex3Digit) { "#"+value.join("") }
Hex3Digit
  = HexDigit HexDigit HexDigit
Hex6Digit
  = HexDigit HexDigit HexDigit HexDigit HexDigit HexDigit
HexDigit
  = [a-f0-9]i
RgbColor
  = "rgb" a:"a"? "(" _* red:Integer _* "," _* blue:Integer _* "," _* green:Integer _* alpha:("," _* alpha:Number _* { alpha } )? ")" {
    if a
      'rgba('+[red,green,blue,alpha].join(",")+')'
    else
      'rgb('+[red,green,blue].join(",")+')'
  }
HslColor
  = "hsl" a:"a"? "(" _* hue:Integer _* "," _* saturation:Number "%" _* "," _* lightness:Number "%" _* alpha:("," _* alpha:Number _* { alpha } )? ")" {
    if a
      "hsla(#{hue},#{saturation}%,#{lightness}%,#{alpha})"
    else
      "hsl(#{hue},#{saturation}%,#{lightness}%)"
  }

Unit
  = value:Number type:("px"/"em"/"deg"/"rad"/"s"/"ms") { new @Unit(value,type)}

Number
  = Float / Integer
Float
  = start:[0-9]+ "." end:[0-9]+ {parseFloat(start.join("")+"."+end.join("")) }
Integer
  = value:([0-9]+) { parseInt(value.join("")) }

Identifier
  = head:[a-z] tail:([a-zA-Z0-9]+) { head+tail.join("") }

ConstantIdentifier
  = head:[A-Z] tail:([a-zA-Z0-9]+) { head+tail.join("") }

EOF "New Line"
  = [\u000A\u000D\u2028\u2029]

_ "Whitespace"
  = [\u0009\u000B\u000C\u0020\u00A0\uFEFF\u1680\u180E\u2000-\u200A\u202F\u205F\u3000]+

__ = [^\u000A\u000D\u2028\u2029\u0009\u000B\u000C\u0020\u00A0\uFEFF\u1680\u180E\u2000-\u200A\u202F\u205F\u3000]