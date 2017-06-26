
structure Directive =
   struct

      datatype directive =
         Step of Syntax.exp option
       | Eval of Syntax.exp option
       | Load of Syntax.exp
       | Use of string

   end
