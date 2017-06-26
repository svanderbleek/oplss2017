structure LabTChecker : TYPECHECKER =
struct
  open LabT 

  type typ = Typ.t
  type term = Term.t

  exception TypeError of Term.t option
  exception Malformed

  structure Context =
  DictFun
    (RedBlackDict
       (structure Key = struct
        type t = Variable.t
        val eq = Variable.equal
        val compare = Variable.compare
        end))

  structure Set = RedBlackSet
  (structure Elem =
    struct
      type t = Label.t
      val eq = Label.equal
      val compare = Label.compare
    end)

  type context = Typ.t Context.dict

  (* checks if t1 = t2, and raises TypeError (SOME e) if not *)
  fun equiv (e : Term.t) (t1 : Typ.t) (t2 : Typ.t) : unit = 
    if Typ.aequiv (t1, t2) then () else raise TypeError (SOME e)

  fun first f (a, b) = (f a , b)
  fun fst (a, b) = a

  (* Remove this when you are done. *)
  exception Unimplemented

  fun checktype ctx e = raise Unimplemented

end
