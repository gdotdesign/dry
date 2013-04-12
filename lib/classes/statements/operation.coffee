module.exports.Operation = class Operation extends Statement
  compile: ->
    switch @operator
      when "&="
        "Object.merge(#{@left.compile()},#{@right.compile()})"
      when "*~"
        @left.compile()+"?.classList?.toggle(#{@right.compile()})"
      when "*+"
        @left.compile()+"?.classList?.add(#{@right.compile()})"
      when "*-"
        @left.compile()+"?.classList?.remove(#{@right.compile()})"
      when "<<"
        @left.compile()+"?.appendChild("+@right.compile()+")"
      else
        @left.compile()+" #{@operator} "+@right.compile()