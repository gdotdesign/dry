# Module / Class System
**Example**:

    module Events
      class Emitter
        def addEventListener

    module Test2
      def test
        log self

    class Test
      mixin Events:Emitter
      mixin Test2

## Module
### Definition
Module names can have only AlphaNumeric characters and must start with an Uppercase character. ([A-Z][a-zA-Z0-9])

    module ModuleName

Modules can have the following sub statements:

* def - Method definitions
* get / set - Property definitions
* class - Class definition
* mixin - Mixin statement

## Mixin

Mixins copy all methods / properties from the target (prototype if it is a class)