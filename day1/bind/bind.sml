structure Bind : BIND = struct
  open Syntax
  open LabT

  exception Error of string

  structure Elem =
  struct
    type t = string
    fun eq (s1, s2) = s1 = s2
    val compare = String.compare
  end

  structure Context = DictFun(RedBlackDict(structure Key = Elem))
  structure Set = RedBlackSet(structure Elem = Elem)

  fun create_or_find ctx lab : Label.t = 
    case Context.find (!ctx) lab
      of SOME var => var
       | NONE => 
       let
         val var = Label.new lab
         val () = (ctx := Context.insert (!ctx) lab var)
        in
          var
       end

  fun bind_type labs tau =
    let
      fun bind_lab (lab, typ) = 
        (create_or_find labs lab, bind_type labs typ)
    in
    case tau of
        Tnat => Typ.Nat
      | Tarrow (tau1, tau2) => 
        Typ.Arrow (bind_type labs tau1, bind_type labs tau2)
      | Tprod tps => Typ.Prod (map bind_lab tps)
      | Tplus tps => Typ.Sum (map bind_lab tps)
    end

  fun bind_term ctx labels e =
      case e of
        Var name =>
        (case Context.find ctx name of
          NONE => raise Error ("Unbound variable \"" ^ name ^ "\".\n")
        | SOME var => Term.Var' var)
      | Z => Term.Z'
      | S e => Term.S' (bind_term ctx labels e)
      | Fn ((tau, name), e) =>
        let val var = Variable.new name in
          Term.Lam'
            ((var, bind_type labels tau),
             bind_term (Context.insert ctx name var) labels e)
        end
      | App (e1, e2) =>
        Term.Ap' (bind_term ctx labels e1, bind_term ctx labels e2)
      | Let _ => raise Error ("No such term \"let\" in this language.")
      | Pair entries => (
        let
          fun bind (lab, exp) : (Label.t * Term.t) = 
              (create_or_find labels lab, bind_term ctx labels exp)
         in
          Term.Pair' (map bind entries)
        end
      )
      | In (tau, lab, term) => (
        Term.Inj' (bind_type labels tau, 
                   create_or_find labels lab, 
                   bind_term ctx labels term)
      )
      | Case (term, cases)  => (
        let
          fun bind_case (lab : label, pat : pat, case_exp : exp) =
            case pat 
              of Pvar (var, _) => (
                let val var' = Variable.new var 
                    val ctx' = Context.insert ctx var var' in
                 ((create_or_find labels lab, var'), bind_term ctx' labels case_exp)
                end
               )
               | _ => raise Error "Product patterns are not supported"
         in
           Term.Case' (bind_term ctx labels term, map bind_case cases)
        end
      )
      | Iter (term, base, cur, acc, ind) => (
        Term.Iter' (
          bind_term ctx labels term,
          bind_term ctx labels base,
          let
            val cur' = Variable.new cur
            val acc' = Variable.new acc
            val ctx' = Context.insert (Context.insert ctx cur cur') acc acc'
          in
            if cur = acc 
            then raise Error "Repeated variable name in term Iter"
            else (cur', (acc', bind_term ctx' labels ind))
          end
        )
      )
      | Out (exp, lab) => (
        Term.Proj' (bind_term ctx labels exp, create_or_find labels lab)
      )

  val bind = bind_term Context.empty (ref Context.empty)
end
