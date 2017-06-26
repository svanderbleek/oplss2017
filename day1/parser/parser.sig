
signature PARSER =
   sig

      exception Error
      exception Unsupported of string

      val parseDirective : char Stream.stream -> Directive.directive
      val parse : char Stream.stream -> Syntax.exp
      val parseFile : string -> Syntax.exp

   end
