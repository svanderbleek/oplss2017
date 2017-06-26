structure LabTDynamics : DYNAMICS =
struct
  type term = LabT.Term.t

  open LabT

  exception RuntimeError
  exception Malformed
  exception Abort

  datatype d = STEP of Term.t | VAL
  datatype D = Step of Term.t | Val | Err

  fun <$>(f, a) =
    case a
      of VAL => VAL
       | STEP a' => STEP (f a')
  infix <$>

  fun view d1 =
    case d1 of
      STEP t1 => Step t1
    | VAL => Val

  fun snd (a, b) = b
  fun fst (a, b) = a

  (* Remove this when you are done. *)
  exception Unimplemented

  fun trystep e = raise Unimplemented
  
  fun eval e =
    case trystep e of
      STEP e' => eval e'
    | VAL => e
end
