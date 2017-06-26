
structure Parser
   :> PARSER
   =
   struct

      exception Error
      exception Unsupported of string

      open Syntax

      type pos = int

      fun identity x = x
      fun lift x () = x

      fun null () = []
      fun single x = [x]
      fun double (x, y) = [x, y]
      val cons = op ::

      fun unsup msg = raise (Unsupported msg)

      structure Arg =
         struct

            type string = string
            type int = int

            type record = label * tp
            type recordlist = record list

            val record_only = identity
            val record_one = single
            val record_cons = cons

            type tp = tp

            val tp_id = identity
            val tp_nat = lift Tnat
            fun tp_unit _ = unsup "tunit"
            fun tp_void _ = unsup "void type"
            val tp_arrow = Tarrow
            fun tp_prod _ = unsup "product star syntax"
            val tp_plus = Tplus
            val tp_plus_emp = lift (Tplus [])
            val tp_record_emp = lift (Tprod [])
            val tp_record = Tprod
            fun tp_ident _ = unsup "ident type"
            fun tp_mu _ = unsup "mu type"
            fun tp_ref _ = unsup "ref type"

            type pred = unit

            fun pred_id _ = unsup "pred"
            fun pred_top _ = unsup "pred"
            fun pred_num _ = unsup "pred"
            fun pred_and _ = unsup "pred"
            fun pred_times _ = unsup "pred"
            fun pred_arrow _ = unsup "pred"
            fun pred_list _ = unsup "pred"

            type exp = exp

            val exp_id = identity
            val exp_ident = Var
            val exp_z = lift Z
            val exp_s = S
            fun exp_fn (v, t, e) = Fn ((t, v), e)
            fun exp_fix _ = unsup "fix"
            val exp_app = App
            val exp_let = Let
            fun exp_outl _ = unsup "outl"
            fun exp_outr _ = unsup "outr"
            fun exp_abort _ = unsup "abort"
            val exp_out = Out
            val exp_in = In
            val exp_case =  Case
            val exp_iter = Iter
            fun exp_ifz _ = unsup "ifz"

            fun exp_number _ = unsup "number exp"
            fun exp_unfold _ = unsup "unfold exp"
            fun exp_fn_inf _ = unsup "fn exp with inference"
            fun exp_fix_inf _ = unsup "fix exp"
            fun exp_fold _ = unsup "fold exp"

            type pairlist = (label * exp) list
            val pair_one = single
            fun  pair_cons (lab, term, rest) = (lab, term) :: rest

            val exp_unit = lift (Pair [])
            val exp_pair = Pair

            type edecls = (pat * exp) list

            val edecls_one = single
            val edecls_cons = cons

            type edecl = pat * exp

            val edecl_val = identity
            fun edecl_val_pred _ = unsup "predicate decl"

            type caserule = (label * pat * exp)
            type caserules = caserule list

            val case_only = identity
            val case_one = single
            val case_cons = cons

            type patlist = (label * pat) list
            type recordpat = (label * pat)

            val recordpat_only = identity
            val patlist_one = single
            val patlist_cons = cons

            type pat = pat

            val pat_id = identity
            val pat_ident = Pvar
            fun pat_ident_notp ident = Pvar (ident, Tvoid)
            val pat_wild = Pwild
            val pat_unit = lift (Ppair [])
            val pat_pair = Ppair
            val pat_alias = Palias
            
            type directive = Directive.directive

            fun directive_step0 () = Directive.Step NONE
            fun directive_step e = Directive.Step (SOME e)
            fun directive_eval0 () = Directive.Eval NONE
            fun directive_eval e = Directive.Eval (SOME e)
            val directive_load = Directive.Load
            val directive_use = Directive.Use


            datatype terminal = datatype Token.token

            fun error s =
               (case Stream.front s of
                   Stream.Nil =>
                      (
                      print "Syntax error at end of file.\n";
                      Error
                      )
                 | Stream.Cons ((_, pos), _) =>
                      (
                      print "Syntax error at ";
                      print (Int.toString pos);
                      print ".\n";
                      Error
                      ))
         end

      structure StreamWithPos =
         CoercedStreamable (structure Streamable = StreamStreamable
                            type 'a item = 'a * pos
                            fun coerce (x, _) = x)

      structure ParseMain =
         ParseMainFun
         (structure Streamable = StreamWithPos
          structure Arg = Arg)

      val lex = Lexer.lex

      fun parseDirective s =
         #1 (ParseMain.parse (Lexer.lex s))

      fun parse s =
         let
            val d = #1 (ParseMain.parse (Stream.eager (Stream.Cons ((Token.LOAD, 0), Lexer.lex s))))
         in
            (case d of
                Directive.Load e => e
              | _ => raise (Fail "impossible"))
         end

      fun parseFile fname =
         let
            val ins = TextIO.openIn fname
            val e = parse (Stream.fromTextInstream ins)
            val () = TextIO.closeIn ins
         in
            e
         end

   end
