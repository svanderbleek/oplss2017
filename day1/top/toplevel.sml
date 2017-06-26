functor TopLevelFn (Impl : TOPLEVEL_IMPL) : TOPLEVEL =
struct

exception TopLevelFnInternalError
structure Impl = Impl

fun empty () = Stream.eager Stream.Nil
fun cons (x, s) = Stream.eager (Stream.Cons (x, s))

fun toCharStreams s =
    case Stream.front s of
        Stream.Nil => Stream.Nil
      | Stream.Cons ((c, _), s') =>
        (case c of
             #";" =>
             Stream.Cons (empty (), Stream.lazy (fn () => toCharStreams s'))
           | _ =>
             (case toCharStreams s' of
                  Stream.Nil => raise Fail "Found EOF before semicolon."
                | Stream.Cons (cs, ss) =>
                  Stream.Cons (cons (c, cs), ss)))

fun processDef s mem =
    Impl.runcmd (Impl.bind (Parser.parseDirective s)) mem

fun handler f s mem =
    (f s mem) handle exn => (Impl.hdl exn; mem)

fun processDefRepl s mem =
    let
      val mem' = processDef s mem
    in
      TextIO.print (Impl.toString mem' ^ "\n");
      mem'
    end

fun fold f e s =
    case Stream.front s of
        Stream.Nil => e
      | Stream.Cons (x, s') =>
        fold f (f x e) s'

fun repl () =
  (fold
     (handler processDefRepl)
     (Impl.init ())
     (Input.promptKeybd "->" "=>"
        (fn s => Stream.lazy (fn () => toCharStreams s)));
   ())

fun evalFile file = 
  Impl.runcmd (Impl.bind (Directive.Eval (SOME (Parser.parseFile file)))) 
              (Impl.init ())

fun runTransFile file = 
  Impl.runtrans (Impl.bind (Directive.Eval (SOME (Parser.parseFile file))))  

fun eval s =
  fold processDef
    (Impl.init ())
    (Stream.lazy
       (fn () =>
          toCharStreams
            (foldr cons (empty ())
               (map (fn c => (c, [])) (String.explode s)))))
end
