signature BIND = sig
  exception Error of string

  val bind : Syntax.exp -> LabT.Term.t
end
