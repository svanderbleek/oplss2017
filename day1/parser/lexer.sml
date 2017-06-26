
structure Lexer
   :> LEXER 
   =
   struct

      open Token

      exception Error

      structure Table =
         HashTable (structure Key = StringHashable)
         
      val keywords : token Table.table = Table.table 20

      val () =
         List.app
         (fn (str, token) => Table.insert keywords str token)
         [
         ("abort", ABORT),
         ("bnd", BND),
         ("case", CASE),
         ("cmd", CMD),
         ("dcl", DCL),
         ("do", DO),
         ("end", END),
         ("else", ELSE),
         ("fix", FIX),
         ("fn", FN),
         ("fold", FOLD),
         ("if", IF),
         ("ifnil", IFNIL),
         ("ifz", IFZ),
         ("in", IN),
         ("inl", INL),
         ("inr", INR),
         ("is", IS),
         ("l", L),
         ("let", LET),
         ("list", LIST),
         ("match", MATCH),
         ("mu", MU),
         ("nat", NAT),
         ("num", NUM),
         ("proc", PROC),
         ("r", R),
         ("ref", REF),
         ("ret", RET),
         ("s", S),
         ("then", THEN),
         ("top", TOP),
         ("unfold", UNFOLD),
         ("unit", UNIT),
         ("val", VAL),
         ("void", VOID),
         ("while", WHILE),
         ("z", Z),
         ("eval", EVAL),
         ("load", LOAD),
         ("step", STEP),
         ("use", USE),
         ("iter", ITER),
         ("with", WITH)
         ]

      open Stream

      type pos = int

      type t = int -> (token * pos) front
      type u = int -> char stream * int
      type v = int -> char list -> char list * char stream * int
      type w = int -> char stream * int

      type self = { lexmain : char stream -> t,
                    lexcomment : char stream -> u,
                    lexstring : char stream -> v,
                    lexformat : char stream -> w }

      type info = { match : char list,
                    len : int, 
                    start : char stream, 
                    follow : char stream, 
                    self : self }

      fun action f ({ match, len, follow, self, ... }:info) pos =
         Cons (f (match, len, pos), lazy (fn () => #lexmain self follow (pos+len)))

      fun simple token ({ len, follow, self, ... }:info) pos =
         Cons ((token, pos), lazy (fn () => #lexmain self follow (pos+len)))

      fun stringchar ch ({ len, follow, self, ...}:info) pos acc =
         #lexstring self follow (pos+len) (ch :: acc)

      fun revappend l1 l2 =
         (case l1 of
             [] => l2
           | x :: rest =>
                revappend rest (x :: l2))

      structure Arg =
         struct
            type symbol = char
            val ord = Char.ord

            type t = t
            type u = u
            type v = v
            type w = w

            type self = self
            type info = info
  
            fun eof _ _ = Nil

            fun skip ({ len, follow, self, ... }:info) pos = #lexmain self follow (pos+len)
  
            val ident = 
               action
               (fn (chars, _, pos) => 
                      let
                         val str = implode chars
                      in
                         (case Table.find keywords str of
                             NONE =>
                                (IDENT str, pos)
                           | SOME token =>
                                (token, pos))
                      end)
  
            val number = 
               action 
               (fn (chars, _, pos) =>
                      ((case Int.fromString (implode chars) of
                           SOME n => 
                              (NUMBER n, pos)
                         | NONE =>
                              raise (Fail "invariant"))
                       handle Overflow => 
                                 (
                                 print "Illegal constant at ";
                                 print (Int.toString pos);
                                 print ".\n";
                                 raise Error
                                 )))

            val langle = simple LANGLE
            val rangle = simple RANGLE
            val lbrace = simple LBRACE
            val rbrace = simple RBRACE
            val lbracket = simple LBRACKET
            val rbracket = simple RBRACKET
            val lparen = simple LPAREN
            val rparen = simple RPAREN
            val ampersand = simple AMPERSAND
            val arrow = simple ARROW
            val assign = simple ASSIGN
            val at = simple AT
            val bar = simple BAR
            val colon = simple COLON
            val comma = simple COMMA
            val darrow = simple DARROW
            val dot = simple DOT
            val equal = simple EQUAL
            val larrow = simple LARROW
            val plus = simple PLUS
            val star = simple STAR
            val underscore = simple UNDERSCORE

            fun begin_comment ({ len, follow, self, ...}:info) pos =
               let
                  val (follow', pos') = 
                     #lexcomment self follow (pos+len)
               in
                  #lexmain self follow' pos'
               end

            fun error _ pos =
               (
               print "Lexical error at ";
               print (Int.toString pos);
               print ".\n";
               raise Error
               )

            fun comment_open ({ len, follow, self, ... }:info) pos =
                let
                   val (follow', pos') = #lexcomment self follow (pos+len)
                in
                   #lexcomment self follow' pos'
                end
  
            fun comment_close ({ len, follow, ...}:info) pos = 
                (follow, pos+len)
  
            fun comment_skip ({ len, follow, self, ... }:info) pos =
                #lexcomment self follow (pos+len)
  
            fun comment_error _ pos =
               (
               print "Unclosed comment at ";
               print (Int.toString pos);
               print ".\n";
               raise Error
               )

            fun string_end ({ len, follow, ... }:info) pos acc =
               (rev acc, follow, pos+len)

            fun string_stuff ({ match, len, follow, self, ... }:info) pos acc =
               #lexstring self follow (pos+len) (revappend match acc)

            val bs_a = stringchar #"\a"
            val bs_b = stringchar #"\b"
            val bs_t = stringchar #"\t"
            val bs_n = stringchar #"\n"
            val bs_v = stringchar #"\v"
            val bs_f = stringchar #"\f"
            val bs_r = stringchar #"\r"
            val bs_bs = stringchar #"\\"

            fun string_format ({ len, follow, self, ...}:info) pos acc =
               let
                  val (follow', pos') = #lexformat self follow (pos+len)
               in
                  #lexstring self follow' pos' acc
               end

            fun string_error _ pos _ =
               (
               print "Unclosed string at ";
               print (Int.toString pos);
               print ".\n";
               raise Error
               )

            fun format_end ({ len, follow, ...}:info) pos =
               (follow, pos+len)

            fun format_skip ({ len, follow, self, ...}:info) pos =
               #lexformat self follow (pos+len)

            fun format_error _ pos =
               (
               print "Illegal format character at ";
               print (Int.toString pos);
               print ".\n";
               raise Error
               )

         end

      structure LexMain =
         LexMainFun
         (structure Streamable = StreamStreamable
          structure Arg = Arg)

      fun lex s = lazy (fn () => LexMain.lexmain s 0)

   end
