
structure Syntax =
   struct

      type variable = string
      type label = string

      datatype tp =
         Tnat
       | Tarrow of tp * tp
       | Tprod of (label * tp) list
       | Tplus of (label * tp) list
       | Tvoid

      datatype pat =
         Pwild of tp
       | Pvar of (variable * tp)
       | Ppair of (label * pat) list
       | Palias of (pat * variable)

      datatype exp =
         Var of variable
       | Z
       | S of exp
       | Fn of (tp * variable) * exp
       | App of exp * exp
       | Let of (pat * exp) list * exp
       | Pair of (label * exp) list
       | In of tp * label * exp
       | Case of exp * (label * pat * exp) list
       | Iter of exp * exp * variable * variable * exp
       | Out of exp * label

   end
