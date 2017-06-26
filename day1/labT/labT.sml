structure LabT :> LABT = struct
  structure TypOps = struct
    datatype typ
      = Typ'Nat
      | Typ'Arrow of typ * typ
      | Typ'Prod of (unit Abt.t * typ) list
      | Typ'Sum of (unit Abt.t * typ) list

    fun typ_bind x i typ =
      (case typ of
        Typ'Nat =>
        Typ'Nat
      | (Typ'Arrow (typ'1, typ'2)) =>
        (Typ'Arrow ((typ_bind x i typ'1), (typ_bind x i typ'2)))
      | (Typ'Prod list'5) =>
        (Typ'Prod (List.map (fn (label'3, typ'4) =>
          ((Abt.bind (fn _ =>
            (fn _ =>
              (fn t =>
                t
              )
            )
          ) x i label'3), (typ_bind x i typ'4))
        ) list'5))
      | (Typ'Sum list'8) =>
        (Typ'Sum (List.map (fn (label'6, typ'7) =>
          ((Abt.bind (fn _ =>
            (fn _ =>
              (fn t =>
                t
              )
            )
          ) x i label'6), (typ_bind x i typ'7))
        ) list'8))
      )

    fun typ_unbind x i typ =
      (case typ of
        Typ'Nat =>
        Typ'Nat
      | (Typ'Arrow (typ'1, typ'2)) =>
        (Typ'Arrow ((typ_unbind x i typ'1), (typ_unbind x i typ'2)))
      | (Typ'Prod list'5) =>
        (Typ'Prod (List.map (fn (label'3, typ'4) =>
          ((Abt.unbind (fn _ =>
            (fn _ =>
              (fn t =>
                t
              )
            )
          ) x i label'3), (typ_unbind x i typ'4))
        ) list'5))
      | (Typ'Sum list'8) =>
        (Typ'Sum (List.map (fn (label'6, typ'7) =>
          ((Abt.unbind (fn _ =>
            (fn _ =>
              (fn t =>
                t
              )
            )
          ) x i label'6), (typ_unbind x i typ'7))
        ) list'8))
      )

    fun typ_internal_aequiv (typ1, typ2) =
      (case (typ1, typ2) of
        (Typ'Nat, Typ'Nat) =>
        true
      | ((Typ'Arrow (typ'1, typ'3)), (Typ'Arrow (typ'2, typ'4))) =>
        ((typ_internal_aequiv (typ'1, typ'2)) andalso (typ_internal_aequiv (typ'3, typ'4)))
      | ((Typ'Prod list'5), (Typ'Prod list'6)) =>
        (ListPair.all (fn ((label'1, typ'3), (label'2, typ'4)) =>
          ((Abt.aequiv (fn _ =>
            true
          ) (label'1, label'2)) andalso (typ_internal_aequiv (typ'3, typ'4)))
        ) (list'5, list'6))
      | ((Typ'Sum list'5), (Typ'Sum list'6)) =>
        (ListPair.all (fn ((label'1, typ'3), (label'2, typ'4)) =>
          ((Abt.aequiv (fn _ =>
            true
          ) (label'1, label'2)) andalso (typ_internal_aequiv (typ'3, typ'4)))
        ) (list'5, list'6))
      | _ =>
        false
      )
  end

  datatype typ
    = Nat
    | Arrow of typ * typ
    | Prod of (Label.t * typ) list
    | Sum of (Label.t * typ) list

  fun typ_view_in vars typ =
    (case typ of
      Nat =>
      (TypOps.Typ'Nat, [])
    | (Arrow (typ'1, typ'2)) =>
      let
        val (t, vars') = let
          val (t0, vars'0) = (typ_view_in vars typ'1)
          val (t1, vars'1) = (typ_view_in vars typ'2)
        in
          ((t0, t1), (vars'0 @ vars'1))
        end
      in
        ((TypOps.Typ'Arrow t), vars')
      end
    | (Prod list'5) =>
      let
        val (t, vars') = let
          val (ts, vars') = (ListPair.unzip (List.map (fn (label'3, typ'4) =>
            let
              val (t0, vars'0) = ((List.foldl (fn (x, acc) =>
                (Abt.into (fn _ =>
                  (fn _ =>
                    (fn t =>
                      t
                    )
                  )
                ) (Abt.Binding (x, acc)))
              ) (Abt.into (fn _ =>
                (fn _ =>
                  (fn t =>
                    t
                  )
                )
              ) (Abt.Var label'3)) vars), [])
              val (t1, vars'1) = (typ_view_in vars typ'4)
            in
              ((t0, t1), (vars'0 @ vars'1))
            end
          ) list'5))
        in
          (ts, (List.concat vars'))
        end
      in
        ((TypOps.Typ'Prod t), vars')
      end
    | (Sum list'8) =>
      let
        val (t, vars') = let
          val (ts, vars') = (ListPair.unzip (List.map (fn (label'6, typ'7) =>
            let
              val (t0, vars'0) = ((List.foldl (fn (x, acc) =>
                (Abt.into (fn _ =>
                  (fn _ =>
                    (fn t =>
                      t
                    )
                  )
                ) (Abt.Binding (x, acc)))
              ) (Abt.into (fn _ =>
                (fn _ =>
                  (fn t =>
                    t
                  )
                )
              ) (Abt.Var label'6)) vars), [])
              val (t1, vars'1) = (typ_view_in vars typ'7)
            in
              ((t0, t1), (vars'0 @ vars'1))
            end
          ) list'8))
        in
          (ts, (List.concat vars'))
        end
      in
        ((TypOps.Typ'Sum t), vars')
      end
    )

  fun typ_view_out vars typ =
    (case typ of
      TypOps.Typ'Nat =>
      (Nat, [])
    | (TypOps.Typ'Arrow (typ'1, typ'2)) =>
      let
        val (t, vars') = let
          val (t0, vars'0) = (typ_view_out vars typ'1)
          val (t1, vars'1) = (typ_view_out vars typ'2)
        in
          ((t0, t1), (vars'0 @ vars'1))
        end
      in
        ((Arrow t), vars')
      end
    | (TypOps.Typ'Prod list'5) =>
      let
        val (t, vars') = let
          val (ts, vars') = (ListPair.unzip (List.map (fn (label'3, typ'4) =>
            let
              val (t0, vars'0) = let
                val (Abt.Var t) = (Abt.out (fn _ =>
                  (fn _ =>
                    (fn t =>
                      t
                    )
                  )
                ) (List.foldr (fn (x, acc) =>
                  let
                    val (Abt.Binding (_, acc')) = (Abt.out (fn _ =>
                      (fn _ =>
                        (fn t =>
                          t
                        )
                      )
                    ) (Abt.unbind (fn _ =>
                      (fn _ =>
                        (fn t =>
                          t
                        )
                      )
                    ) x ~1 acc))
                  in
                    acc'
                  end
                ) label'3 vars))
              in
                (t, [])
              end
              val (t1, vars'1) = (typ_view_out vars typ'4)
            in
              ((t0, t1), (vars'0 @ vars'1))
            end
          ) list'5))
        in
          (ts, (List.concat vars'))
        end
      in
        ((Prod t), vars')
      end
    | (TypOps.Typ'Sum list'8) =>
      let
        val (t, vars') = let
          val (ts, vars') = (ListPair.unzip (List.map (fn (label'6, typ'7) =>
            let
              val (t0, vars'0) = let
                val (Abt.Var t) = (Abt.out (fn _ =>
                  (fn _ =>
                    (fn t =>
                      t
                    )
                  )
                ) (List.foldr (fn (x, acc) =>
                  let
                    val (Abt.Binding (_, acc')) = (Abt.out (fn _ =>
                      (fn _ =>
                        (fn t =>
                          t
                        )
                      )
                    ) (Abt.unbind (fn _ =>
                      (fn _ =>
                        (fn t =>
                          t
                        )
                      )
                    ) x ~1 acc))
                  in
                    acc'
                  end
                ) label'6 vars))
              in
                (t, [])
              end
              val (t1, vars'1) = (typ_view_out vars typ'7)
            in
              ((t0, t1), (vars'0 @ vars'1))
            end
          ) list'8))
        in
          (ts, (List.concat vars'))
        end
      in
        ((Sum t), vars')
      end
    )

  structure Typ = struct
    datatype typ = datatype typ

    type t = typ
  end

  fun typ_aequiv (typ1, typ2) =
    (case (typ1, typ2) of
      (Nat, Nat) =>
      true
    | ((Arrow (typ'1, typ'3)), (Arrow (typ'2, typ'4))) =>
      ((typ_aequiv (typ'1, typ'2)) andalso (typ_aequiv (typ'3, typ'4)))
    | ((Prod list'5), (Prod list'6)) =>
      (ListPair.all (fn ((label'1, typ'3), (label'2, typ'4)) =>
        (Label.equal (label'1, label'2)) andalso (typ_aequiv (typ'3, typ'4)))
      ) (list'5, list'6)
    | ((Sum list'5), (Sum list'6)) =>
      (ListPair.all (fn ((label'1, typ'3), (label'2, typ'4)) =>
        (Label.equal (label'1, label'2)) andalso (typ_aequiv (typ'3, typ'4)))
      ) (list'5, list'6)
    | _ =>
      false
    )

  fun typ_toString typ =
    (case typ of
      Typ.Nat =>
      "Nat"
    | (Typ.Arrow (typ'1, typ'2)) =>
      ("(Arrow " ^ ("(" ^ (typ_toString typ'1) ^ ", " ^ (typ_toString typ'2) ^ ")") ^ ")")
    | (Typ.Prod list'5) =>
      ("(Prod " ^ ("[" ^ String.concatWith ", " (List.map (fn (label'3, typ'4) =>
        ("(" ^ (Label.toString label'3) ^ ", " ^ (typ_toString typ'4) ^ ")")
      ) list'5) ^ "]") ^ ")")
    | (Typ.Sum list'8) =>
      ("(Sum " ^ ("[" ^ String.concatWith ", " (List.map (fn (label'6, typ'7) =>
        ("(" ^ (Label.toString label'6) ^ ", " ^ (typ_toString typ'7) ^ ")")
      ) list'8) ^ "]") ^ ")")
    )

  structure Typ = struct
    open Typ
    val toString = typ_toString
    val internal_aequiv = TypOps.typ_internal_aequiv
    val aequiv = typ_aequiv
  end

  structure TermOps = struct
    datatype term_oper
      = Term'Z
      | Term'S of term
      | Term'Lam of (string * TypOps.typ) * term
      | Term'Ap of term * term
      | Term'Pair of (unit Abt.t * term) list
      | Term'Proj of term * unit Abt.t
      | Term'Inj of TypOps.typ * unit Abt.t * term
      | Term'Case of term * ((unit Abt.t * string) * term) list
      | Term'Iter of term * term * (string * (string * term))
    withtype term = term_oper Abt.t

    fun term_oper_bind x i term =
      (case term of
        Term'Z =>
        Term'Z
      | (Term'S term'1) =>
        (Term'S (Abt.bind term_oper_bind x i term'1))
      | (Term'Lam ((term'2, typ'3), term'4)) =>
        (Term'Lam ((term'2, (TypOps.typ_bind x i typ'3)), (Abt.bind term_oper_bind x i term'4)))
      | (Term'Ap (term'5, term'6)) =>
        (Term'Ap ((Abt.bind term_oper_bind x i term'5), (Abt.bind term_oper_bind x i term'6)))
      | (Term'Pair list'9) =>
        (Term'Pair (List.map (fn (label'7, term'8) =>
          ((Abt.bind (fn _ =>
            (fn _ =>
              (fn t =>
                t
              )
            )
          ) x i label'7), (Abt.bind term_oper_bind x i term'8))
        ) list'9))
      | (Term'Proj (term'10, label'11)) =>
        (Term'Proj ((Abt.bind term_oper_bind x i term'10), (Abt.bind (fn _ =>
          (fn _ =>
            (fn t =>
              t
            )
          )
        ) x i label'11)))
      | (Term'Inj (typ'12, label'13, term'14)) =>
        (Term'Inj ((TypOps.typ_bind x i typ'12), (Abt.bind (fn _ =>
          (fn _ =>
            (fn t =>
              t
            )
          )
        ) x i label'13), (Abt.bind term_oper_bind x i term'14)))
      | (Term'Case (term'15, list'19)) =>
        (Term'Case ((Abt.bind term_oper_bind x i term'15), (List.map (fn ((label'16, term'17), term'18) =>
          (((Abt.bind (fn _ =>
            (fn _ =>
              (fn t =>
                t
              )
            )
          ) x i label'16), term'17), (Abt.bind term_oper_bind x i term'18))
        ) list'19)))
      | (Term'Iter (term'20, term'21, (term'22, (term'23, term'24)))) =>
        (Term'Iter ((Abt.bind term_oper_bind x i term'20), (Abt.bind term_oper_bind x i term'21), (term'22, (term'23, (Abt.bind term_oper_bind x i term'24)))))
      )

    fun term_oper_unbind x i term =
      (case term of
        Term'Z =>
        Term'Z
      | (Term'S term'1) =>
        (Term'S (Abt.unbind term_oper_unbind x i term'1))
      | (Term'Lam ((term'2, typ'3), term'4)) =>
        (Term'Lam ((term'2, (TypOps.typ_unbind x i typ'3)), (Abt.unbind term_oper_unbind x i term'4)))
      | (Term'Ap (term'5, term'6)) =>
        (Term'Ap ((Abt.unbind term_oper_unbind x i term'5), (Abt.unbind term_oper_unbind x i term'6)))
      | (Term'Pair list'9) =>
        (Term'Pair (List.map (fn (label'7, term'8) =>
          ((Abt.unbind (fn _ =>
            (fn _ =>
              (fn t =>
                t
              )
            )
          ) x i label'7), (Abt.unbind term_oper_unbind x i term'8))
        ) list'9))
      | (Term'Proj (term'10, label'11)) =>
        (Term'Proj ((Abt.unbind term_oper_unbind x i term'10), (Abt.unbind (fn _ =>
          (fn _ =>
            (fn t =>
              t
            )
          )
        ) x i label'11)))
      | (Term'Inj (typ'12, label'13, term'14)) =>
        (Term'Inj ((TypOps.typ_unbind x i typ'12), (Abt.unbind (fn _ =>
          (fn _ =>
            (fn t =>
              t
            )
          )
        ) x i label'13), (Abt.unbind term_oper_unbind x i term'14)))
      | (Term'Case (term'15, list'19)) =>
        (Term'Case ((Abt.unbind term_oper_unbind x i term'15), (List.map (fn ((label'16, term'17), term'18) =>
          (((Abt.unbind (fn _ =>
            (fn _ =>
              (fn t =>
                t
              )
            )
          ) x i label'16), term'17), (Abt.unbind term_oper_unbind x i term'18))
        ) list'19)))
      | (Term'Iter (term'20, term'21, (term'22, (term'23, term'24)))) =>
        (Term'Iter ((Abt.unbind term_oper_unbind x i term'20), (Abt.unbind term_oper_unbind x i term'21), (term'22, (term'23, (Abt.unbind term_oper_unbind x i term'24)))))
      )

    fun term_oper_aequiv (term1, term2) =
      (case (term1, term2) of
        (Term'Z, Term'Z) =>
        true
      | ((Term'S term'1), (Term'S term'2)) =>
        ((Abt.aequiv term_oper_aequiv) (term'1, term'2))
      | ((Term'Lam ((_, typ'1), term'3)), (Term'Lam ((_, typ'2), term'4))) =>
        ((true andalso (Typ.internal_aequiv (typ'1, typ'2))) andalso ((Abt.aequiv term_oper_aequiv) (term'3, term'4)))
      | ((Term'Ap (term'1, term'3)), (Term'Ap (term'2, term'4))) =>
        (((Abt.aequiv term_oper_aequiv) (term'1, term'2)) andalso ((Abt.aequiv term_oper_aequiv) (term'3, term'4)))
      | ((Term'Pair list'5), (Term'Pair list'6)) =>
        (ListPair.all (fn ((label'1, term'3), (label'2, term'4)) =>
          ((Abt.aequiv (fn _ =>
            true
          ) (label'1, label'2)) andalso ((Abt.aequiv term_oper_aequiv) (term'3, term'4)))
        ) (list'5, list'6))
      | ((Term'Proj (term'1, label'3)), (Term'Proj (term'2, label'4))) =>
        (((Abt.aequiv term_oper_aequiv) (term'1, term'2)) andalso (Abt.aequiv (fn _ =>
          true
        ) (label'3, label'4)))
      | ((Term'Inj (typ'1, label'3, term'5)), (Term'Inj (typ'2, label'4, term'6))) =>
        ((Typ.internal_aequiv (typ'1, typ'2)) andalso (Abt.aequiv (fn _ =>
          true
        ) (label'3, label'4)) andalso ((Abt.aequiv term_oper_aequiv) (term'5, term'6)))
      | ((Term'Case (term'1, list'7)), (Term'Case (term'2, list'8))) =>
        (((Abt.aequiv term_oper_aequiv) (term'1, term'2)) andalso (ListPair.all (fn (((label'3, _), term'5), ((label'4, _), term'6)) =>
          (((Abt.aequiv (fn _ =>
            true
          ) (label'3, label'4)) andalso true) andalso ((Abt.aequiv term_oper_aequiv) (term'5, term'6)))
        ) (list'7, list'8)))
      | ((Term'Iter (term'1, term'3, (_, (_, term'5)))), (Term'Iter (term'2, term'4, (_, (_, term'6))))) =>
        (((Abt.aequiv term_oper_aequiv) (term'1, term'2)) andalso ((Abt.aequiv term_oper_aequiv) (term'3, term'4)) andalso (true andalso (true andalso ((Abt.aequiv term_oper_aequiv) (term'5, term'6)))))
      | _ =>
        false
      )
  end

  structure Term = struct
    type termVar = Temp.t
    type term = TermOps.term
    type t = term

    structure Var = Temp

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

    fun view_in vars term =
      (case term of
        (Var x) =>
        (Abt.Var x)
      | Z =>
        (Abt.Oper TermOps.Term'Z)
      | (S term'1) =>
        (Abt.Oper (TermOps.Term'S ((fn (x, _) =>
          x
        ) ((List.foldl (fn (x, acc) =>
          (Abt.into TermOps.term_oper_bind (Abt.Binding (x, acc)))
        ) term'1 vars), []))))
      | (Lam ((term'2, typ'3), term'4)) =>
        (Abt.Oper (TermOps.Term'Lam ((fn (x, _) =>
          x
        ) let
          val (t, vars') = let
            val (t0, vars'0) = let
              val var = term'2
            in
              ((Temp.toUserString var), [var])
            end
            val (t1, vars'1) = (typ_view_in vars typ'3)
          in
            ((t0, t1), (vars'0 @ vars'1))
          end
          val vars = (vars' @ vars)
          val (t', vars') = ((List.foldl (fn (x, acc) =>
            (Abt.into TermOps.term_oper_bind (Abt.Binding (x, acc)))
          ) term'4 vars), [])
        in
          ((t, t'), vars')
        end)))
      | (Ap (term'5, term'6)) =>
        (Abt.Oper (TermOps.Term'Ap ((fn (x, _) =>
          x
        ) let
          val (t0, vars'0) = ((List.foldl (fn (x, acc) =>
            (Abt.into TermOps.term_oper_bind (Abt.Binding (x, acc)))
          ) term'5 vars), [])
          val (t1, vars'1) = ((List.foldl (fn (x, acc) =>
            (Abt.into TermOps.term_oper_bind (Abt.Binding (x, acc)))
          ) term'6 vars), [])
        in
          ((t0, t1), (vars'0 @ vars'1))
        end)))
      | (Pair list'9) =>
        (Abt.Oper (TermOps.Term'Pair ((fn (x, _) =>
          x
        ) let
          val (ts, vars') = (ListPair.unzip (List.map (fn (label'7, term'8) =>
            let
              val (t0, vars'0) = ((List.foldl (fn (x, acc) =>
                (Abt.into (fn _ =>
                  (fn _ =>
                    (fn t =>
                      t
                    )
                  )
                ) (Abt.Binding (x, acc)))
              ) (Abt.into (fn _ =>
                (fn _ =>
                  (fn t =>
                    t
                  )
                )
              ) (Abt.Var label'7)) vars), [])
              val (t1, vars'1) = ((List.foldl (fn (x, acc) =>
                (Abt.into TermOps.term_oper_bind (Abt.Binding (x, acc)))
              ) term'8 vars), [])
            in
              ((t0, t1), (vars'0 @ vars'1))
            end
          ) list'9))
        in
          (ts, (List.concat vars'))
        end)))
      | (Proj (term'10, label'11)) =>
        (Abt.Oper (TermOps.Term'Proj ((fn (x, _) =>
          x
        ) let
          val (t0, vars'0) = ((List.foldl (fn (x, acc) =>
            (Abt.into TermOps.term_oper_bind (Abt.Binding (x, acc)))
          ) term'10 vars), [])
          val (t1, vars'1) = ((List.foldl (fn (x, acc) =>
            (Abt.into (fn _ =>
              (fn _ =>
                (fn t =>
                  t
                )
              )
            ) (Abt.Binding (x, acc)))
          ) (Abt.into (fn _ =>
            (fn _ =>
              (fn t =>
                t
              )
            )
          ) (Abt.Var label'11)) vars), [])
        in
          ((t0, t1), (vars'0 @ vars'1))
        end)))
      | (Inj (typ'12, label'13, term'14)) =>
        (Abt.Oper (TermOps.Term'Inj ((fn (x, _) =>
          x
        ) let
          val (t0, vars'0) = (typ_view_in vars typ'12)
          val (t1, vars'1) = ((List.foldl (fn (x, acc) =>
            (Abt.into (fn _ =>
              (fn _ =>
                (fn t =>
                  t
                )
              )
            ) (Abt.Binding (x, acc)))
          ) (Abt.into (fn _ =>
            (fn _ =>
              (fn t =>
                t
              )
            )
          ) (Abt.Var label'13)) vars), [])
          val (t2, vars'2) = ((List.foldl (fn (x, acc) =>
            (Abt.into TermOps.term_oper_bind (Abt.Binding (x, acc)))
          ) term'14 vars), [])
        in
          ((t0, t1, t2), (vars'0 @ vars'1 @ vars'2))
        end)))
      | (Case (term'15, list'19)) =>
        (Abt.Oper (TermOps.Term'Case ((fn (x, _) =>
          x
        ) let
          val (t0, vars'0) = ((List.foldl (fn (x, acc) =>
            (Abt.into TermOps.term_oper_bind (Abt.Binding (x, acc)))
          ) term'15 vars), [])
          val (t1, vars'1) = let
            val (ts, vars') = (ListPair.unzip (List.map (fn ((label'16, term'17), term'18) =>
              let
                val (t, vars') = let
                  val (t0, vars'0) = ((List.foldl (fn (x, acc) =>
                    (Abt.into (fn _ =>
                      (fn _ =>
                        (fn t =>
                          t
                        )
                      )
                    ) (Abt.Binding (x, acc)))
                  ) (Abt.into (fn _ =>
                    (fn _ =>
                      (fn t =>
                        t
                      )
                    )
                  ) (Abt.Var label'16)) vars), [])
                  val (t1, vars'1) = let
                    val var = term'17
                  in
                    ((Temp.toUserString var), [var])
                  end
                in
                  ((t0, t1), (vars'0 @ vars'1))
                end
                val vars = (vars' @ vars)
                val (t', vars') = ((List.foldl (fn (x, acc) =>
                  (Abt.into TermOps.term_oper_bind (Abt.Binding (x, acc)))
                ) term'18 vars), [])
              in
                ((t, t'), vars')
              end
            ) list'19))
          in
            (ts, (List.concat vars'))
          end
        in
          ((t0, t1), (vars'0 @ vars'1))
        end)))
      | (Iter (term'20, term'21, (term'22, (term'23, term'24)))) =>
        (Abt.Oper (TermOps.Term'Iter ((fn (x, _) =>
          x
        ) let
          val (t0, vars'0) = ((List.foldl (fn (x, acc) =>
            (Abt.into TermOps.term_oper_bind (Abt.Binding (x, acc)))
          ) term'20 vars), [])
          val (t1, vars'1) = ((List.foldl (fn (x, acc) =>
            (Abt.into TermOps.term_oper_bind (Abt.Binding (x, acc)))
          ) term'21 vars), [])
          val (t2, vars'2) = let
            val (t, vars') = let
              val var = term'22
            in
              ((Temp.toUserString var), [var])
            end
            val vars = (vars' @ vars)
            val (t', vars') = let
              val (t, vars') = let
                val var = term'23
              in
                ((Temp.toUserString var), [var])
              end
              val vars = (vars' @ vars)
              val (t', vars') = ((List.foldl (fn (x, acc) =>
                (Abt.into TermOps.term_oper_bind (Abt.Binding (x, acc)))
              ) term'24 vars), [])
            in
              ((t, t'), vars')
            end
          in
            ((t, t'), vars')
          end
        in
          ((t0, t1, t2), (vars'0 @ vars'1 @ vars'2))
        end)))
      )

    fun oper_view_out vars term =
      (case term of
        TermOps.Term'Z =>
        Z
      | (TermOps.Term'S term'1) =>
        (S ((fn (x, _) =>
          x
        ) ((List.foldr (fn (x, acc) =>
          let
            val (Abt.Binding (_, acc')) = (Abt.out TermOps.term_oper_unbind (Abt.unbind TermOps.term_oper_unbind x ~1 acc))
          in
            acc'
          end
        ) term'1 vars), [])))
      | (TermOps.Term'Lam ((term'2, typ'3), term'4)) =>
        (Lam ((fn (x, _) =>
          x
        ) let
          val (t, vars') = let
            val (t0, vars'0) = let
              val x = (Temp.new term'2)
            in
              (x, [x])
            end
            val (t1, vars'1) = (typ_view_out vars typ'3)
          in
            ((t0, t1), (vars'0 @ vars'1))
          end
          val vars = (vars' @ vars)
          val (t', vars') = ((List.foldr (fn (x, acc) =>
            let
              val (Abt.Binding (_, acc')) = (Abt.out TermOps.term_oper_unbind (Abt.unbind TermOps.term_oper_unbind x ~1 acc))
            in
              acc'
            end
          ) term'4 vars), [])
        in
          ((t, t'), vars')
        end))
      | (TermOps.Term'Ap (term'5, term'6)) =>
        (Ap ((fn (x, _) =>
          x
        ) let
          val (t0, vars'0) = ((List.foldr (fn (x, acc) =>
            let
              val (Abt.Binding (_, acc')) = (Abt.out TermOps.term_oper_unbind (Abt.unbind TermOps.term_oper_unbind x ~1 acc))
            in
              acc'
            end
          ) term'5 vars), [])
          val (t1, vars'1) = ((List.foldr (fn (x, acc) =>
            let
              val (Abt.Binding (_, acc')) = (Abt.out TermOps.term_oper_unbind (Abt.unbind TermOps.term_oper_unbind x ~1 acc))
            in
              acc'
            end
          ) term'6 vars), [])
        in
          ((t0, t1), (vars'0 @ vars'1))
        end))
      | (TermOps.Term'Pair list'9) =>
        (Pair ((fn (x, _) =>
          x
        ) let
          val (ts, vars') = (ListPair.unzip (List.map (fn (label'7, term'8) =>
            let
              val (t0, vars'0) = let
                val (Abt.Var t) = (Abt.out (fn _ =>
                  (fn _ =>
                    (fn t =>
                      t
                    )
                  )
                ) (List.foldr (fn (x, acc) =>
                  let
                    val (Abt.Binding (_, acc')) = (Abt.out (fn _ =>
                      (fn _ =>
                        (fn t =>
                          t
                        )
                      )
                    ) (Abt.unbind (fn _ =>
                      (fn _ =>
                        (fn t =>
                          t
                        )
                      )
                    ) x ~1 acc))
                  in
                    acc'
                  end
                ) label'7 vars))
              in
                (t, [])
              end
              val (t1, vars'1) = ((List.foldr (fn (x, acc) =>
                let
                  val (Abt.Binding (_, acc')) = (Abt.out TermOps.term_oper_unbind (Abt.unbind TermOps.term_oper_unbind x ~1 acc))
                in
                  acc'
                end
              ) term'8 vars), [])
            in
              ((t0, t1), (vars'0 @ vars'1))
            end
          ) list'9))
        in
          (ts, (List.concat vars'))
        end))
      | (TermOps.Term'Proj (term'10, label'11)) =>
        (Proj ((fn (x, _) =>
          x
        ) let
          val (t0, vars'0) = ((List.foldr (fn (x, acc) =>
            let
              val (Abt.Binding (_, acc')) = (Abt.out TermOps.term_oper_unbind (Abt.unbind TermOps.term_oper_unbind x ~1 acc))
            in
              acc'
            end
          ) term'10 vars), [])
          val (t1, vars'1) = let
            val (Abt.Var t) = (Abt.out (fn _ =>
              (fn _ =>
                (fn t =>
                  t
                )
              )
            ) (List.foldr (fn (x, acc) =>
              let
                val (Abt.Binding (_, acc')) = (Abt.out (fn _ =>
                  (fn _ =>
                    (fn t =>
                      t
                    )
                  )
                ) (Abt.unbind (fn _ =>
                  (fn _ =>
                    (fn t =>
                      t
                    )
                  )
                ) x ~1 acc))
              in
                acc'
              end
            ) label'11 vars))
          in
            (t, [])
          end
        in
          ((t0, t1), (vars'0 @ vars'1))
        end))
      | (TermOps.Term'Inj (typ'12, label'13, term'14)) =>
        (Inj ((fn (x, _) =>
          x
        ) let
          val (t0, vars'0) = (typ_view_out vars typ'12)
          val (t1, vars'1) = let
            val (Abt.Var t) = (Abt.out (fn _ =>
              (fn _ =>
                (fn t =>
                  t
                )
              )
            ) (List.foldr (fn (x, acc) =>
              let
                val (Abt.Binding (_, acc')) = (Abt.out (fn _ =>
                  (fn _ =>
                    (fn t =>
                      t
                    )
                  )
                ) (Abt.unbind (fn _ =>
                  (fn _ =>
                    (fn t =>
                      t
                    )
                  )
                ) x ~1 acc))
              in
                acc'
              end
            ) label'13 vars))
          in
            (t, [])
          end
          val (t2, vars'2) = ((List.foldr (fn (x, acc) =>
            let
              val (Abt.Binding (_, acc')) = (Abt.out TermOps.term_oper_unbind (Abt.unbind TermOps.term_oper_unbind x ~1 acc))
            in
              acc'
            end
          ) term'14 vars), [])
        in
          ((t0, t1, t2), (vars'0 @ vars'1 @ vars'2))
        end))
      | (TermOps.Term'Case (term'15, list'19)) =>
        (Case ((fn (x, _) =>
          x
        ) let
          val (t0, vars'0) = ((List.foldr (fn (x, acc) =>
            let
              val (Abt.Binding (_, acc')) = (Abt.out TermOps.term_oper_unbind (Abt.unbind TermOps.term_oper_unbind x ~1 acc))
            in
              acc'
            end
          ) term'15 vars), [])
          val (t1, vars'1) = let
            val (ts, vars') = (ListPair.unzip (List.map (fn ((label'16, term'17), term'18) =>
              let
                val (t, vars') = let
                  val (t0, vars'0) = let
                    val (Abt.Var t) = (Abt.out (fn _ =>
                      (fn _ =>
                        (fn t =>
                          t
                        )
                      )
                    ) (List.foldr (fn (x, acc) =>
                      let
                        val (Abt.Binding (_, acc')) = (Abt.out (fn _ =>
                          (fn _ =>
                            (fn t =>
                              t
                            )
                          )
                        ) (Abt.unbind (fn _ =>
                          (fn _ =>
                            (fn t =>
                              t
                            )
                          )
                        ) x ~1 acc))
                      in
                        acc'
                      end
                    ) label'16 vars))
                  in
                    (t, [])
                  end
                  val (t1, vars'1) = let
                    val x = (Temp.new term'17)
                  in
                    (x, [x])
                  end
                in
                  ((t0, t1), (vars'0 @ vars'1))
                end
                val vars = (vars' @ vars)
                val (t', vars') = ((List.foldr (fn (x, acc) =>
                  let
                    val (Abt.Binding (_, acc')) = (Abt.out TermOps.term_oper_unbind (Abt.unbind TermOps.term_oper_unbind x ~1 acc))
                  in
                    acc'
                  end
                ) term'18 vars), [])
              in
                ((t, t'), vars')
              end
            ) list'19))
          in
            (ts, (List.concat vars'))
          end
        in
          ((t0, t1), (vars'0 @ vars'1))
        end))
      | (TermOps.Term'Iter (term'20, term'21, (term'22, (term'23, term'24)))) =>
        (Iter ((fn (x, _) =>
          x
        ) let
          val (t0, vars'0) = ((List.foldr (fn (x, acc) =>
            let
              val (Abt.Binding (_, acc')) = (Abt.out TermOps.term_oper_unbind (Abt.unbind TermOps.term_oper_unbind x ~1 acc))
            in
              acc'
            end
          ) term'20 vars), [])
          val (t1, vars'1) = ((List.foldr (fn (x, acc) =>
            let
              val (Abt.Binding (_, acc')) = (Abt.out TermOps.term_oper_unbind (Abt.unbind TermOps.term_oper_unbind x ~1 acc))
            in
              acc'
            end
          ) term'21 vars), [])
          val (t2, vars'2) = let
            val (t, vars') = let
              val x = (Temp.new term'22)
            in
              (x, [x])
            end
            val vars = (vars' @ vars)
            val (t', vars') = let
              val (t, vars') = let
                val x = (Temp.new term'23)
              in
                (x, [x])
              end
              val vars = (vars' @ vars)
              val (t', vars') = ((List.foldr (fn (x, acc) =>
                let
                  val (Abt.Binding (_, acc')) = (Abt.out TermOps.term_oper_unbind (Abt.unbind TermOps.term_oper_unbind x ~1 acc))
                in
                  acc'
                end
              ) term'24 vars), [])
            in
              ((t, t'), vars')
            end
          in
            ((t, t'), vars')
          end
        in
          ((t0, t1, t2), (vars'0 @ vars'1 @ vars'2))
        end))
      )

    fun view_out t =
      (case t of
        (Abt.Var x) =>
        (Var x)
      | (Abt.Oper oper) =>
        (oper_view_out [] oper)
      | _ =>
        (raise Fail "Internal Abbot Error")
      )

    fun into v =
      (Abt.into TermOps.term_oper_bind (view_in [] v))
    fun out term =
      (view_out (Abt.out TermOps.term_oper_unbind term))

    val Var' = (into o Var)
    val Z' = (into Z)
    val S' = (into o S)
    val Lam' = (into o Lam)
    val Ap' = (into o Ap)
    val Pair' = (into o Pair)
    val Proj' = (into o Proj)
    val Inj' = (into o Inj)
    val Case' = (into o Case)
    val Iter' = (into o Iter)
  end

  fun term_toString term =
    (case (Term.out term) of
      (Term.Var x) =>
      (Variable.toString x)
    | Term.Z =>
      "Z"
    | (Term.S term'1) =>
      ("(S " ^ (term_toString term'1) ^ ")")
    | (Term.Lam ((term'2, typ'3), term'4)) =>
      ("(Lam " ^ ("(" ^ ("(" ^ (Variable.toString term'2) ^ ", " ^ (Typ.toString typ'3) ^ ")") ^ " . " ^ (term_toString term'4) ^ ")") ^ ")")
    | (Term.Ap (term'5, term'6)) =>
      ("(Ap " ^ ("(" ^ (term_toString term'5) ^ ", " ^ (term_toString term'6) ^ ")") ^ ")")
    | (Term.Pair list'9) =>
      ("(Pair " ^ ("[" ^ String.concatWith ", " (List.map (fn (label'7, term'8) =>
        ("(" ^ (Label.toString label'7) ^ ", " ^ (term_toString term'8) ^ ")")
      ) list'9) ^ "]") ^ ")")
    | (Term.Proj (term'10, label'11)) =>
      ("(Proj " ^ ("(" ^ (term_toString term'10) ^ ", " ^ (Label.toString label'11) ^ ")") ^ ")")
    | (Term.Inj (typ'12, label'13, term'14)) =>
      ("(Inj " ^ ("(" ^ (Typ.toString typ'12) ^ ", " ^ (Label.toString label'13) ^ ", " ^ (term_toString term'14) ^ ")") ^ ")")
    | (Term.Case (term'15, list'19)) =>
      ("(Case " ^ ("(" ^ (term_toString term'15) ^ ", " ^ ("[" ^ String.concatWith ", " (List.map (fn ((label'16, term'17), term'18) =>
        ("(" ^ ("(" ^ (Label.toString label'16) ^ ", " ^ (Variable.toString term'17) ^ ")") ^ " . " ^ (term_toString term'18) ^ ")")
      ) list'19) ^ "]") ^ ")") ^ ")")
    | (Term.Iter (term'20, term'21, (term'22, (term'23, term'24)))) =>
      ("(Iter " ^ ("(" ^ (term_toString term'20) ^ ", " ^ (term_toString term'21) ^ ", " ^ ("(" ^ (Variable.toString term'22) ^ " . " ^ ("(" ^ (Variable.toString term'23) ^ " . " ^ (term_toString term'24) ^ ")") ^ ")") ^ ")") ^ ")")
    )

  fun term_subst t x term =
    (case (Term.out term) of
      (Term.Var y) =>
      (if (Variable.equal (x, y))
      then t
      else (Term.Var' y))
    | Term.Z =>
      Term.Z'
    | (Term.S term'1) =>
      (Term.S' (term_subst t x term'1))
    | (Term.Lam ((term'2, typ'3), term'4)) =>
      (Term.Lam' ((term'2, ((fn _ =>
        (fn _ =>
          (fn t =>
            t
          )
        )
      ) t x typ'3)), (term_subst t x term'4)))
    | (Term.Ap (term'5, term'6)) =>
      (Term.Ap' ((term_subst t x term'5), (term_subst t x term'6)))
    | (Term.Pair list'9) =>
      (Term.Pair' (List.map (fn (label'7, term'8) =>
        (label'7, (term_subst t x term'8))
      ) list'9))
    | (Term.Proj (term'10, label'11)) =>
      (Term.Proj' ((term_subst t x term'10), label'11))
    | (Term.Inj (typ'12, label'13, term'14)) =>
      (Term.Inj' (((fn _ =>
        (fn _ =>
          (fn t =>
            t
          )
        )
      ) t x typ'12), label'13, (term_subst t x term'14)))
    | (Term.Case (term'15, list'19)) =>
      (Term.Case' ((term_subst t x term'15), (List.map (fn ((label'16, term'17), term'18) =>
        ((label'16, term'17), (term_subst t x term'18))
      ) list'19)))
    | (Term.Iter (term'20, term'21, (term'22, (term'23, term'24)))) =>
      (Term.Iter' ((term_subst t x term'20), (term_subst t x term'21), (term'22, (term'23, (term_subst t x term'24)))))
    )

  structure Term = struct
    open Term
    val toString = term_toString
    val aequiv = (Abt.aequiv TermOps.term_oper_aequiv)
    val subst = term_subst
  end
end
