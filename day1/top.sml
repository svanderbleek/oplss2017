structure TopLevelImpl = struct
  datatype cmd
    = Eval of LabT.Term.t option
    | Step of LabT.Term.t option
    | Load of LabT.Term.t

  datatype mem
    = None
    | Next of LabT.Term.t
    | Val of LabT.Term.t

  fun init () = None

  fun optmap f opt =
      case opt of
          NONE => NONE
        | SOME x => SOME (f x)

  fun bind d =
      case d of
          Directive.Step termopt =>
          Step (optmap Bind.bind termopt)
        | Directive.Eval termopt =>
          Eval (optmap Bind.bind termopt)
        | Directive.Load term =>
          Load (Bind.bind term)
        | Directive.Use file =>
          Load (Bind.bind (Parser.parseFile file))

  fun trim s =
      if String.size s < 79 then (s ^ "\n")
      else (String.substring (s, 0, 76) ^ "...\n")

  fun trimleft limit s =
      if String.size s < limit then s
      else ("..." ^ String.extract (s, String.size s - limit + 3,
                                    NONE))

  fun check e =
      TextIO.print
        (trim
           ("Statics: term has type "
            ^ LabT.Typ.toString
                (LabTChecker.checktype
                   LabTChecker.Context.empty
                   e)))

  fun eval e =
      let val v = LabTDynamics.eval e
      in (check v; Val v)
      end

  fun step e =
      case LabTDynamics.view (LabTDynamics.trystep e) of
          LabTDynamics.Step e' => (check e'; Next e')
        | LabTDynamics.Val => Val e
        | LabTDynamics.Err =>
          raise Fail "Dynamics erroneously returned Err.\n"

  fun runcmd cmd mem =
      case cmd of
          Eval NONE =>
          (case mem of
               Next e => eval e
             | _ => raise Fail "Nothing to eval!")
        | Eval (SOME e) => (check e; eval e)
        | Step NONE =>
          (case mem of
               Next e => step e
             | _ => raise Fail "Nothing to step!")
        | Step (SOME e) =>
          (check e; step e)
        | Load e => (check e; Next e)

  fun runtrans _ = raise Fail "Translation not supported"

  fun toString mem =
      case mem of
          None => ""
        | Next e => " |--> " ^ LabT.Term.toString e
        | Val e => " " ^ LabT.Term.toString e ^ " VAL"

  fun hdl exn =
      case exn of
          Parser.Error =>
          TextIO.print "Parse error\n"
        | Parser.Unsupported str =>
          TextIO.print ("Unsupported operation: " ^ str ^ "\n")
        | Bind.Error str =>
          TextIO.print str
        | LabTChecker.TypeError term_opt =>
          (case term_opt of
               NONE => TextIO.print "LabTChecker error\n"
             | SOME term =>
               TextIO.print
                 ("LabTChecker error in term: "
                  ^ LabT.Term.toString term
                  ^ "\n"))
        | LabTDynamics.Malformed =>
          TextIO.print "Malformed error in dynamics\n"
        | LabTDynamics.RuntimeError =>
          TextIO.print "Runtime error in dynamics\n"
        | Fail s =>
          TextIO.print ("Error: " ^ s ^ "\n")
        | _ =>
          TextIO.print
            ("Unexpected error: " ^
             exnName exn ^ " [" ^
             exnMessage exn ^ "]\n")
end

structure TopLevel = TopLevelFn (TopLevelImpl)
