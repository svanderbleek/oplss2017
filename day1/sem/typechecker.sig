signature TYPECHECKER =
sig
  type typ
  type term

  (* The optional Term.t argument to TypeError. can be omitted, but it
   * will be reported by the toplevel repl when provided, which can be
   * useful for locating the source of type errors. *)
  exception TypeError of term option

  structure Context : DICT

  type context = typ Context.dict

  val checktype : context -> term -> typ
end
