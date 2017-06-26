signature LABT = sig
  structure Typ : sig
    datatype typ
      = Nat
      | Arrow of typ * typ
      | Prod of (Label.t * typ) list
      | Sum of (Label.t * typ) list

    type t = typ

    val aequiv : t * t -> bool

    val toString : t -> string
  end

  structure Term : sig
    type termVar = Variable.t
    type term
    type t = term

    datatype view
      = Var of termVar
      | Z
      | S of term
      | Lam of (termVar * Typ.t) * term
      | Ap of term * term
      | Pair of (Label.t * term) list
      | Proj of term * Label.t
      | Inj of Typ.t * Label.t * term
      | Case of term * ((Label.t * termVar) * term) list
      | Iter of term * term * (termVar * (termVar * term))

    val Var' : termVar -> term
    val Z' : term
    val S' : term -> term
    val Lam' : (termVar * Typ.t) * term -> term
    val Ap' : term * term -> term
    val Pair' : (Label.t * term) list -> term
    val Proj' : term * Label.t -> term
    val Inj' : Typ.t * Label.t * term -> term
    val Case' : term * ((Label.t * termVar) * term) list -> term
    val Iter' : term * term * (termVar * (termVar * term)) -> term

    val into : view -> term
    val out : term -> view
    val aequiv : term * term -> bool
    val toString : term -> string

    val subst : term -> termVar -> term -> term
  end
end
