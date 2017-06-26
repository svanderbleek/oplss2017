
functor ParseMainFun
   (structure Streamable : STREAMABLE
    structure Arg :
       sig
          type string
          type int
          type record
          type recordlist
          type tp
          type pred
          type pairlist
          type exp
          type edecls
          type edecl
          type caserule
          type caserules
          type pat
          type recordpat
          type patlist
          type directive

          val directive_use : string -> directive
          val directive_load : exp -> directive
          val directive_eval : exp -> directive
          val directive_eval0 : unit -> directive
          val directive_step : exp -> directive
          val directive_step0 : unit -> directive
          val patlist_cons : recordpat * patlist -> patlist
          val patlist_one : recordpat -> patlist
          val recordpat_only : string * pat -> recordpat
          val pat_pair : patlist -> pat
          val pat_unit : unit -> pat
          val pat_alias : pat * string -> pat
          val pat_ident_notp : string -> pat
          val pat_ident : string * tp -> pat
          val pat_wild : tp -> pat
          val pat_id : pat -> pat
          val case_cons : caserule * caserules -> caserules
          val case_one : caserule -> caserules
          val case_only : string * pat * exp -> caserule
          val edecl_val_pred : string * pred * exp -> edecl
          val edecl_val : pat * exp -> edecl
          val edecls_cons : edecl * edecls -> edecls
          val edecls_one : edecl -> edecls
          val exp_fold : string * tp * exp -> exp
          val exp_fix_inf : string * exp -> exp
          val exp_fix : string * tp * exp -> exp
          val exp_fn_inf : string * exp -> exp
          val exp_fn : string * tp * exp -> exp
          val exp_out : exp * string -> exp
          val exp_unfold : exp -> exp
          val exp_in : tp * string * exp -> exp
          val exp_abort : tp * exp -> exp
          val exp_s : exp -> exp
          val exp_app : exp * exp -> exp
          val exp_ifz : exp * exp * string * exp -> exp
          val exp_case : exp * caserules -> exp
          val exp_iter : exp * exp * string * string * exp -> exp
          val exp_let : edecls * exp -> exp
          val exp_pair : pairlist -> exp
          val exp_unit : unit -> exp
          val exp_z : unit -> exp
          val exp_number : int -> exp
          val exp_ident : string -> exp
          val exp_id : exp -> exp
          val pair_cons : string * exp * pairlist -> pairlist
          val pair_one : string * exp -> pairlist
          val pred_list : pred -> pred
          val pred_arrow : pred * pred -> pred
          val pred_times : pred * pred -> pred
          val pred_and : pred * pred -> pred
          val pred_num : unit -> pred
          val pred_top : unit -> pred
          val pred_id : pred -> pred
          val tp_ref : tp -> tp
          val tp_mu : string * tp -> tp
          val tp_arrow : tp * tp -> tp
          val tp_plus : recordlist -> tp
          val tp_plus_emp : unit -> tp
          val tp_record : recordlist -> tp
          val tp_record_emp : unit -> tp
          val tp_void : unit -> tp
          val tp_unit : unit -> tp
          val tp_nat : unit -> tp
          val tp_ident : unit -> tp
          val tp_id : tp -> tp
          val record_cons : record * recordlist -> recordlist
          val record_one : record -> recordlist
          val record_only : string * tp -> record

          datatype terminal =
             IDENT of string
           | NUMBER of int
           | STRING of string
           | LANGLE
           | RANGLE
           | LBRACE
           | RBRACE
           | LBRACKET
           | RBRACKET
           | LPAREN
           | RPAREN
           | AMPERSAND
           | ARROW
           | ASSIGN
           | AT
           | BAR
           | COLON
           | COMMA
           | DARROW
           | DOT
           | EQUAL
           | LARROW
           | PLUS
           | STAR
           | UNDERSCORE
           | ABORT
           | BND
           | CASE
           | CMD
           | DCL
           | DO
           | ELSE
           | END
           | FIX
           | FN
           | FOLD
           | IF
           | IFNIL
           | IFZ
           | IN
           | INL
           | INR
           | IS
           | L
           | LET
           | LIST
           | MATCH
           | MU
           | NAT
           | NUM
           | PROC
           | R
           | REF
           | RET
           | S
           | THEN
           | TOP
           | UNFOLD
           | UNIT
           | VAL
           | VOID
           | WHILE
           | Z
           | EVAL
           | LOAD
           | STEP
           | USE
           | ITER
           | WITH

          val error : terminal Streamable.t -> exn
       end)
   :>
   sig
      val parse : Arg.terminal Streamable.t -> Arg.directive * Arg.terminal Streamable.t
   end
=

(*

AUTOMATON LISTING
=================

State 0:

start -> . Directive  / 0
68 : Directive -> . STEP  / 0
69 : Directive -> . STEP Exp  / 0
70 : Directive -> . EVAL  / 0
71 : Directive -> . EVAL Exp  / 0
72 : Directive -> . LOAD Exp  / 0
73 : Directive -> . USE STRING  / 0

EVAL => shift 4
LOAD => shift 3
STEP => shift 2
USE => shift 1
Directive => goto 5

-----

State 1:

73 : Directive -> USE . STRING  / 0

STRING => shift 6

-----

State 2:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 1
25 : ExpAtom -> . IDENT  / 1
26 : ExpAtom -> . NUMBER  / 1
27 : ExpAtom -> . Z  / 1
28 : ExpAtom -> . LANGLE RANGLE  / 1
29 : ExpAtom -> . LANGLE PairList RANGLE  / 1
30 : ExpAtom -> . LET Edecls IN Exp END  / 1
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 1
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 1
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 1
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 1
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 1
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 1
37 : ExpApp -> . ExpAtom  / 1
38 : ExpApp -> . ExpApp ExpAtom  / 1
39 : ExpApp -> . S ExpAtom  / 1
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 1
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 1
42 : ExpApp -> . UNFOLD ExpAtom  / 1
43 : ExpPost -> . ExpApp  / 2
44 : ExpPost -> . ExpPost DOT IDENT  / 2
45 : Exp -> . ExpPost  / 0
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 0
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 0
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 0
49 : Exp -> . FIX IDENT IS Exp  / 0
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 0
68 : Directive -> STEP .  / 0
69 : Directive -> STEP . Exp  / 0

$ => reduce 68
IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 7
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 3:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 1
25 : ExpAtom -> . IDENT  / 1
26 : ExpAtom -> . NUMBER  / 1
27 : ExpAtom -> . Z  / 1
28 : ExpAtom -> . LANGLE RANGLE  / 1
29 : ExpAtom -> . LANGLE PairList RANGLE  / 1
30 : ExpAtom -> . LET Edecls IN Exp END  / 1
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 1
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 1
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 1
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 1
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 1
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 1
37 : ExpApp -> . ExpAtom  / 1
38 : ExpApp -> . ExpApp ExpAtom  / 1
39 : ExpApp -> . S ExpAtom  / 1
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 1
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 1
42 : ExpApp -> . UNFOLD ExpAtom  / 1
43 : ExpPost -> . ExpApp  / 2
44 : ExpPost -> . ExpPost DOT IDENT  / 2
45 : Exp -> . ExpPost  / 0
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 0
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 0
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 0
49 : Exp -> . FIX IDENT IS Exp  / 0
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 0
72 : Directive -> LOAD . Exp  / 0

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 27
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 4:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 1
25 : ExpAtom -> . IDENT  / 1
26 : ExpAtom -> . NUMBER  / 1
27 : ExpAtom -> . Z  / 1
28 : ExpAtom -> . LANGLE RANGLE  / 1
29 : ExpAtom -> . LANGLE PairList RANGLE  / 1
30 : ExpAtom -> . LET Edecls IN Exp END  / 1
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 1
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 1
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 1
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 1
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 1
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 1
37 : ExpApp -> . ExpAtom  / 1
38 : ExpApp -> . ExpApp ExpAtom  / 1
39 : ExpApp -> . S ExpAtom  / 1
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 1
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 1
42 : ExpApp -> . UNFOLD ExpAtom  / 1
43 : ExpPost -> . ExpApp  / 2
44 : ExpPost -> . ExpPost DOT IDENT  / 2
45 : Exp -> . ExpPost  / 0
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 0
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 0
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 0
49 : Exp -> . FIX IDENT IS Exp  / 0
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 0
70 : Directive -> EVAL .  / 0
71 : Directive -> EVAL . Exp  / 0

$ => reduce 70
IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 28
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 5:

start -> Directive .  / 0

$ => accept

-----

State 6:

73 : Directive -> USE STRING .  / 0

$ => reduce 73

-----

State 7:

69 : Directive -> STEP Exp .  / 0

$ => reduce 69

-----

State 8:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 3
25 : ExpAtom -> . IDENT  / 3
26 : ExpAtom -> . NUMBER  / 3
27 : ExpAtom -> . Z  / 3
28 : ExpAtom -> . LANGLE RANGLE  / 3
29 : ExpAtom -> . LANGLE PairList RANGLE  / 3
30 : ExpAtom -> . LET Edecls IN Exp END  / 3
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 3
31 : ExpAtom -> ITER . Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 4
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 3
32 : ExpAtom -> ITER . Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 4
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 3
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 3
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 3
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 3
37 : ExpApp -> . ExpAtom  / 3
38 : ExpApp -> . ExpApp ExpAtom  / 3
39 : ExpApp -> . S ExpAtom  / 3
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 3
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 3
42 : ExpApp -> . UNFOLD ExpAtom  / 3
43 : ExpPost -> . ExpApp  / 5
44 : ExpPost -> . ExpPost DOT IDENT  / 5
45 : Exp -> . ExpPost  / 6
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 6
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 6
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 6
49 : Exp -> . FIX IDENT IS Exp  / 6
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 6

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 29
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 9:

50 : Exp -> FOLD . LBRACKET IDENT DOT Tp RBRACKET Exp  / 7

LBRACKET => shift 30

-----

State 10:

46 : Exp -> FN . LPAREN IDENT COLON Tp RPAREN Exp  / 7
47 : Exp -> FN . LPAREN IDENT RPAREN Exp  / 7

LPAREN => shift 31

-----

State 11:

48 : Exp -> FIX . IDENT COLON Tp IS Exp  / 7
49 : Exp -> FIX . IDENT IS Exp  / 7

IDENT => shift 32

-----

State 12:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 3
25 : ExpAtom -> . IDENT  / 3
26 : ExpAtom -> . NUMBER  / 3
27 : ExpAtom -> . Z  / 3
28 : ExpAtom -> . LANGLE RANGLE  / 3
29 : ExpAtom -> . LANGLE PairList RANGLE  / 3
30 : ExpAtom -> . LET Edecls IN Exp END  / 3
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 3
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 3
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 3
33 : ExpAtom -> CASE . Exp LBRACE CaseRules RBRACE  / 4
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 3
34 : ExpAtom -> CASE . Exp LBRACE BAR CaseRules RBRACE  / 4
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 3
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 3
37 : ExpApp -> . ExpAtom  / 3
38 : ExpApp -> . ExpApp ExpAtom  / 3
39 : ExpApp -> . S ExpAtom  / 3
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 3
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 3
42 : ExpApp -> . UNFOLD ExpAtom  / 3
43 : ExpPost -> . ExpApp  / 5
44 : ExpPost -> . ExpPost DOT IDENT  / 5
45 : Exp -> . ExpPost  / 6
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 6
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 6
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 6
49 : Exp -> . FIX IDENT IS Exp  / 6
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 6

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 33
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 13:

40 : ExpApp -> ABORT . LBRACKET Tp RBRACKET ExpAtom  / 4

LBRACKET => shift 34

-----

State 14:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 8
24 : ExpAtom -> LPAREN . Exp RPAREN  / 4
25 : ExpAtom -> . IDENT  / 8
26 : ExpAtom -> . NUMBER  / 8
27 : ExpAtom -> . Z  / 8
28 : ExpAtom -> . LANGLE RANGLE  / 8
29 : ExpAtom -> . LANGLE PairList RANGLE  / 8
30 : ExpAtom -> . LET Edecls IN Exp END  / 8
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 8
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 8
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 8
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 8
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 8
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 8
37 : ExpApp -> . ExpAtom  / 8
38 : ExpApp -> . ExpApp ExpAtom  / 8
39 : ExpApp -> . S ExpAtom  / 8
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 8
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 8
42 : ExpApp -> . UNFOLD ExpAtom  / 8
43 : ExpPost -> . ExpApp  / 9
44 : ExpPost -> . ExpPost DOT IDENT  / 9
45 : Exp -> . ExpPost  / 10
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 10
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 10
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 10
49 : Exp -> . FIX IDENT IS Exp  / 10
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 10

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 35
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 15:

22 : PairList -> . IDENT EQUAL Exp  / 11
23 : PairList -> . IDENT EQUAL Exp COMMA PairList  / 11
28 : ExpAtom -> LANGLE . RANGLE  / 4
29 : ExpAtom -> LANGLE . PairList RANGLE  / 4

IDENT => shift 38
RANGLE => shift 37
PairList => goto 36

-----

State 16:

26 : ExpAtom -> NUMBER .  / 4

$ => reduce 26
IDENT => reduce 26
NUMBER => reduce 26
LANGLE => reduce 26
RANGLE => reduce 26
LBRACE => reduce 26
RBRACE => reduce 26
LPAREN => reduce 26
RPAREN => reduce 26
BAR => reduce 26
COMMA => reduce 26
DOT => reduce 26
CASE => reduce 26
END => reduce 26
IFZ => reduce 26
IN => reduce 26
LET => reduce 26
VAL => reduce 26
Z => reduce 26
ITER => reduce 26

-----

State 17:

25 : ExpAtom -> IDENT .  / 4

$ => reduce 25
IDENT => reduce 25
NUMBER => reduce 25
LANGLE => reduce 25
RANGLE => reduce 25
LBRACE => reduce 25
RBRACE => reduce 25
LPAREN => reduce 25
RPAREN => reduce 25
BAR => reduce 25
COMMA => reduce 25
DOT => reduce 25
CASE => reduce 25
END => reduce 25
IFZ => reduce 25
IN => reduce 25
LET => reduce 25
VAL => reduce 25
Z => reduce 25
ITER => reduce 25

-----

State 18:

3 : Tp -> . LPAREN Tp RPAREN  / 12
4 : Tp -> . IDENT  / 12
5 : Tp -> . NAT  / 12
6 : Tp -> . UNIT  / 12
7 : Tp -> . VOID  / 12
8 : Tp -> . LANGLE RANGLE  / 12
9 : Tp -> . LANGLE RecordList RANGLE  / 12
10 : Tp -> . LBRACKET RBRACKET  / 12
11 : Tp -> . LBRACKET RecordList RBRACKET  / 12
12 : Tp -> . Tp ARROW Tp  / 12
13 : Tp -> . MU IDENT DOT Tp  / 12
14 : Tp -> . REF Tp  / 12
41 : ExpApp -> IN . Tp LBRACE IDENT RBRACE ExpAtom  / 4

IDENT => shift 45
LANGLE => shift 44
LBRACKET => shift 43
LPAREN => shift 46
MU => shift 42
NAT => shift 41
REF => shift 40
UNIT => shift 48
VOID => shift 47
Tp => goto 39

-----

State 19:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 3
25 : ExpAtom -> . IDENT  / 3
26 : ExpAtom -> . NUMBER  / 3
27 : ExpAtom -> . Z  / 3
28 : ExpAtom -> . LANGLE RANGLE  / 3
29 : ExpAtom -> . LANGLE PairList RANGLE  / 3
30 : ExpAtom -> . LET Edecls IN Exp END  / 3
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 3
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 3
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 3
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 3
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 3
35 : ExpAtom -> IFZ . Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 3
36 : ExpAtom -> IFZ . Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
37 : ExpApp -> . ExpAtom  / 3
38 : ExpApp -> . ExpApp ExpAtom  / 3
39 : ExpApp -> . S ExpAtom  / 3
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 3
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 3
42 : ExpApp -> . UNFOLD ExpAtom  / 3
43 : ExpPost -> . ExpApp  / 5
44 : ExpPost -> . ExpPost DOT IDENT  / 5
45 : Exp -> . ExpPost  / 6
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 6
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 6
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 6
49 : Exp -> . FIX IDENT IS Exp  / 6
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 6

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 49
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 20:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 4
25 : ExpAtom -> . IDENT  / 4
26 : ExpAtom -> . NUMBER  / 4
27 : ExpAtom -> . Z  / 4
28 : ExpAtom -> . LANGLE RANGLE  / 4
29 : ExpAtom -> . LANGLE PairList RANGLE  / 4
30 : ExpAtom -> . LET Edecls IN Exp END  / 4
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 4
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 4
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 4
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 4
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
42 : ExpApp -> UNFOLD . ExpAtom  / 4

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
CASE => shift 12
IFZ => shift 19
LET => shift 22
Z => shift 23
ITER => shift 8
ExpAtom => goto 50

-----

State 21:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 4
25 : ExpAtom -> . IDENT  / 4
26 : ExpAtom -> . NUMBER  / 4
27 : ExpAtom -> . Z  / 4
28 : ExpAtom -> . LANGLE RANGLE  / 4
29 : ExpAtom -> . LANGLE PairList RANGLE  / 4
30 : ExpAtom -> . LET Edecls IN Exp END  / 4
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 4
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 4
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 4
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 4
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
39 : ExpApp -> S . ExpAtom  / 4

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
CASE => shift 12
IFZ => shift 19
LET => shift 22
Z => shift 23
ITER => shift 8
ExpAtom => goto 51

-----

State 22:

30 : ExpAtom -> LET . Edecls IN Exp END  / 4
51 : Edecls -> . Edecl  / 13
52 : Edecls -> . Edecl Edecls  / 13
53 : Edecl -> . VAL Pat EQUAL Exp  / 14
54 : Edecl -> . VAL IDENT COLON Pred EQUAL Exp  / 14

VAL => shift 52
Edecls => goto 53
Edecl => goto 54

-----

State 23:

27 : ExpAtom -> Z .  / 4

$ => reduce 27
IDENT => reduce 27
NUMBER => reduce 27
LANGLE => reduce 27
RANGLE => reduce 27
LBRACE => reduce 27
RBRACE => reduce 27
LPAREN => reduce 27
RPAREN => reduce 27
BAR => reduce 27
COMMA => reduce 27
DOT => reduce 27
CASE => reduce 27
END => reduce 27
IFZ => reduce 27
IN => reduce 27
LET => reduce 27
VAL => reduce 27
Z => reduce 27
ITER => reduce 27

-----

State 24:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 4
25 : ExpAtom -> . IDENT  / 4
26 : ExpAtom -> . NUMBER  / 4
27 : ExpAtom -> . Z  / 4
28 : ExpAtom -> . LANGLE RANGLE  / 4
29 : ExpAtom -> . LANGLE PairList RANGLE  / 4
30 : ExpAtom -> . LET Edecls IN Exp END  / 4
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 4
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 4
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 4
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 4
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
38 : ExpApp -> ExpApp . ExpAtom  / 4
43 : ExpPost -> ExpApp .  / 15

$ => reduce 43
IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
RANGLE => reduce 43
LBRACE => reduce 43
RBRACE => reduce 43
LPAREN => shift 14
RPAREN => reduce 43
BAR => reduce 43
COMMA => reduce 43
DOT => reduce 43
CASE => shift 12
END => reduce 43
IFZ => shift 19
IN => reduce 43
LET => shift 22
VAL => reduce 43
Z => shift 23
ITER => shift 8
ExpAtom => goto 55

-----

State 25:

37 : ExpApp -> ExpAtom .  / 4

$ => reduce 37
IDENT => reduce 37
NUMBER => reduce 37
LANGLE => reduce 37
RANGLE => reduce 37
LBRACE => reduce 37
RBRACE => reduce 37
LPAREN => reduce 37
RPAREN => reduce 37
BAR => reduce 37
COMMA => reduce 37
DOT => reduce 37
CASE => reduce 37
END => reduce 37
IFZ => reduce 37
IN => reduce 37
LET => reduce 37
VAL => reduce 37
Z => reduce 37
ITER => reduce 37

-----

State 26:

44 : ExpPost -> ExpPost . DOT IDENT  / 15
45 : Exp -> ExpPost .  / 7

$ => reduce 45
RANGLE => reduce 45
LBRACE => reduce 45
RBRACE => reduce 45
RPAREN => reduce 45
BAR => reduce 45
COMMA => reduce 45
DOT => shift 56
END => reduce 45
IN => reduce 45
VAL => reduce 45

-----

State 27:

72 : Directive -> LOAD Exp .  / 0

$ => reduce 72

-----

State 28:

71 : Directive -> EVAL Exp .  / 0

$ => reduce 71

-----

State 29:

31 : ExpAtom -> ITER Exp . LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 4
32 : ExpAtom -> ITER Exp . LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 4

LBRACE => shift 57

-----

State 30:

50 : Exp -> FOLD LBRACKET . IDENT DOT Tp RBRACKET Exp  / 7

IDENT => shift 58

-----

State 31:

46 : Exp -> FN LPAREN . IDENT COLON Tp RPAREN Exp  / 7
47 : Exp -> FN LPAREN . IDENT RPAREN Exp  / 7

IDENT => shift 59

-----

State 32:

48 : Exp -> FIX IDENT . COLON Tp IS Exp  / 7
49 : Exp -> FIX IDENT . IS Exp  / 7

COLON => shift 61
IS => shift 60

-----

State 33:

33 : ExpAtom -> CASE Exp . LBRACE CaseRules RBRACE  / 4
34 : ExpAtom -> CASE Exp . LBRACE BAR CaseRules RBRACE  / 4

LBRACE => shift 62

-----

State 34:

3 : Tp -> . LPAREN Tp RPAREN  / 16
4 : Tp -> . IDENT  / 16
5 : Tp -> . NAT  / 16
6 : Tp -> . UNIT  / 16
7 : Tp -> . VOID  / 16
8 : Tp -> . LANGLE RANGLE  / 16
9 : Tp -> . LANGLE RecordList RANGLE  / 16
10 : Tp -> . LBRACKET RBRACKET  / 16
11 : Tp -> . LBRACKET RecordList RBRACKET  / 16
12 : Tp -> . Tp ARROW Tp  / 16
13 : Tp -> . MU IDENT DOT Tp  / 16
14 : Tp -> . REF Tp  / 16
40 : ExpApp -> ABORT LBRACKET . Tp RBRACKET ExpAtom  / 4

IDENT => shift 45
LANGLE => shift 44
LBRACKET => shift 43
LPAREN => shift 46
MU => shift 42
NAT => shift 41
REF => shift 40
UNIT => shift 48
VOID => shift 47
Tp => goto 63

-----

State 35:

24 : ExpAtom -> LPAREN Exp . RPAREN  / 4

RPAREN => shift 64

-----

State 36:

29 : ExpAtom -> LANGLE PairList . RANGLE  / 4

RANGLE => shift 65

-----

State 37:

28 : ExpAtom -> LANGLE RANGLE .  / 4

$ => reduce 28
IDENT => reduce 28
NUMBER => reduce 28
LANGLE => reduce 28
RANGLE => reduce 28
LBRACE => reduce 28
RBRACE => reduce 28
LPAREN => reduce 28
RPAREN => reduce 28
BAR => reduce 28
COMMA => reduce 28
DOT => reduce 28
CASE => reduce 28
END => reduce 28
IFZ => reduce 28
IN => reduce 28
LET => reduce 28
VAL => reduce 28
Z => reduce 28
ITER => reduce 28

-----

State 38:

22 : PairList -> IDENT . EQUAL Exp  / 11
23 : PairList -> IDENT . EQUAL Exp COMMA PairList  / 11

EQUAL => shift 66

-----

State 39:

12 : Tp -> Tp . ARROW Tp  / 12
41 : ExpApp -> IN Tp . LBRACE IDENT RBRACE ExpAtom  / 4

LBRACE => shift 67
ARROW => shift 68

-----

State 40:

3 : Tp -> . LPAREN Tp RPAREN  / 17
4 : Tp -> . IDENT  / 17
5 : Tp -> . NAT  / 17
6 : Tp -> . UNIT  / 17
7 : Tp -> . VOID  / 17
8 : Tp -> . LANGLE RANGLE  / 17
9 : Tp -> . LANGLE RecordList RANGLE  / 17
10 : Tp -> . LBRACKET RBRACKET  / 17
11 : Tp -> . LBRACKET RecordList RBRACKET  / 17
12 : Tp -> . Tp ARROW Tp  / 17
13 : Tp -> . MU IDENT DOT Tp  / 17
14 : Tp -> . REF Tp  / 17
14 : Tp -> REF . Tp  / 17

IDENT => shift 45
LANGLE => shift 44
LBRACKET => shift 43
LPAREN => shift 46
MU => shift 42
NAT => shift 41
REF => shift 40
UNIT => shift 48
VOID => shift 47
Tp => goto 69

-----

State 41:

5 : Tp -> NAT .  / 17

RANGLE => reduce 5
LBRACE => reduce 5
RBRACKET => reduce 5
RPAREN => reduce 5
ARROW => reduce 5
AT => reduce 5
COMMA => reduce 5
DARROW => reduce 5
EQUAL => reduce 5
IS => reduce 5

-----

State 42:

13 : Tp -> MU . IDENT DOT Tp  / 17

IDENT => shift 70

-----

State 43:

0 : Record -> . IDENT COLON COLON Tp  / 18
1 : RecordList -> . Record  / 19
2 : RecordList -> . Record COMMA RecordList  / 19
10 : Tp -> LBRACKET . RBRACKET  / 17
11 : Tp -> LBRACKET . RecordList RBRACKET  / 17

IDENT => shift 74
RBRACKET => shift 73
Record => goto 72
RecordList => goto 71

-----

State 44:

0 : Record -> . IDENT COLON COLON Tp  / 20
1 : RecordList -> . Record  / 11
2 : RecordList -> . Record COMMA RecordList  / 11
8 : Tp -> LANGLE . RANGLE  / 17
9 : Tp -> LANGLE . RecordList RANGLE  / 17

IDENT => shift 74
RANGLE => shift 76
Record => goto 72
RecordList => goto 75

-----

State 45:

4 : Tp -> IDENT .  / 17

RANGLE => reduce 4
LBRACE => reduce 4
RBRACKET => reduce 4
RPAREN => reduce 4
ARROW => reduce 4
AT => reduce 4
COMMA => reduce 4
DARROW => reduce 4
EQUAL => reduce 4
IS => reduce 4

-----

State 46:

3 : Tp -> . LPAREN Tp RPAREN  / 21
3 : Tp -> LPAREN . Tp RPAREN  / 17
4 : Tp -> . IDENT  / 21
5 : Tp -> . NAT  / 21
6 : Tp -> . UNIT  / 21
7 : Tp -> . VOID  / 21
8 : Tp -> . LANGLE RANGLE  / 21
9 : Tp -> . LANGLE RecordList RANGLE  / 21
10 : Tp -> . LBRACKET RBRACKET  / 21
11 : Tp -> . LBRACKET RecordList RBRACKET  / 21
12 : Tp -> . Tp ARROW Tp  / 21
13 : Tp -> . MU IDENT DOT Tp  / 21
14 : Tp -> . REF Tp  / 21

IDENT => shift 45
LANGLE => shift 44
LBRACKET => shift 43
LPAREN => shift 46
MU => shift 42
NAT => shift 41
REF => shift 40
UNIT => shift 48
VOID => shift 47
Tp => goto 77

-----

State 47:

7 : Tp -> VOID .  / 17

RANGLE => reduce 7
LBRACE => reduce 7
RBRACKET => reduce 7
RPAREN => reduce 7
ARROW => reduce 7
AT => reduce 7
COMMA => reduce 7
DARROW => reduce 7
EQUAL => reduce 7
IS => reduce 7

-----

State 48:

6 : Tp -> UNIT .  / 17

RANGLE => reduce 6
LBRACE => reduce 6
RBRACKET => reduce 6
RPAREN => reduce 6
ARROW => reduce 6
AT => reduce 6
COMMA => reduce 6
DARROW => reduce 6
EQUAL => reduce 6
IS => reduce 6

-----

State 49:

35 : ExpAtom -> IFZ Exp . LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
36 : ExpAtom -> IFZ Exp . LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4

LBRACE => shift 78

-----

State 50:

42 : ExpApp -> UNFOLD ExpAtom .  / 4

$ => reduce 42
IDENT => reduce 42
NUMBER => reduce 42
LANGLE => reduce 42
RANGLE => reduce 42
LBRACE => reduce 42
RBRACE => reduce 42
LPAREN => reduce 42
RPAREN => reduce 42
BAR => reduce 42
COMMA => reduce 42
DOT => reduce 42
CASE => reduce 42
END => reduce 42
IFZ => reduce 42
IN => reduce 42
LET => reduce 42
VAL => reduce 42
Z => reduce 42
ITER => reduce 42

-----

State 51:

39 : ExpApp -> S ExpAtom .  / 4

$ => reduce 39
IDENT => reduce 39
NUMBER => reduce 39
LANGLE => reduce 39
RANGLE => reduce 39
LBRACE => reduce 39
RBRACE => reduce 39
LPAREN => reduce 39
RPAREN => reduce 39
BAR => reduce 39
COMMA => reduce 39
DOT => reduce 39
CASE => reduce 39
END => reduce 39
IFZ => reduce 39
IN => reduce 39
LET => reduce 39
VAL => reduce 39
Z => reduce 39
ITER => reduce 39

-----

State 52:

53 : Edecl -> VAL . Pat EQUAL Exp  / 14
54 : Edecl -> VAL . IDENT COLON Pred EQUAL Exp  / 14
58 : Pat -> . LPAREN Pat RPAREN  / 22
59 : Pat -> . UNDERSCORE COLON Tp  / 22
60 : Pat -> . IDENT COLON Tp  / 22
61 : Pat -> . IDENT  / 22
62 : Pat -> . Pat AT IDENT  / 22
63 : Pat -> . LANGLE RANGLE  / 22
64 : Pat -> . LANGLE PatList RANGLE  / 22

IDENT => shift 80
LANGLE => shift 79
LPAREN => shift 81
UNDERSCORE => shift 83
Pat => goto 82

-----

State 53:

30 : ExpAtom -> LET Edecls . IN Exp END  / 4

IN => shift 84

-----

State 54:

51 : Edecls -> . Edecl  / 13
51 : Edecls -> Edecl .  / 13
52 : Edecls -> . Edecl Edecls  / 13
52 : Edecls -> Edecl . Edecls  / 13
53 : Edecl -> . VAL Pat EQUAL Exp  / 14
54 : Edecl -> . VAL IDENT COLON Pred EQUAL Exp  / 14

IN => reduce 51
VAL => shift 52
Edecls => goto 85
Edecl => goto 54

-----

State 55:

38 : ExpApp -> ExpApp ExpAtom .  / 4

$ => reduce 38
IDENT => reduce 38
NUMBER => reduce 38
LANGLE => reduce 38
RANGLE => reduce 38
LBRACE => reduce 38
RBRACE => reduce 38
LPAREN => reduce 38
RPAREN => reduce 38
BAR => reduce 38
COMMA => reduce 38
DOT => reduce 38
CASE => reduce 38
END => reduce 38
IFZ => reduce 38
IN => reduce 38
LET => reduce 38
VAL => reduce 38
Z => reduce 38
ITER => reduce 38

-----

State 56:

44 : ExpPost -> ExpPost DOT . IDENT  / 15

IDENT => shift 86

-----

State 57:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 23
25 : ExpAtom -> . IDENT  / 23
26 : ExpAtom -> . NUMBER  / 23
27 : ExpAtom -> . Z  / 23
28 : ExpAtom -> . LANGLE RANGLE  / 23
29 : ExpAtom -> . LANGLE PairList RANGLE  / 23
30 : ExpAtom -> . LET Edecls IN Exp END  / 23
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 23
31 : ExpAtom -> ITER Exp LBRACE . Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 4
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 23
32 : ExpAtom -> ITER Exp LBRACE . Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 4
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 23
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 23
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 23
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 23
37 : ExpApp -> . ExpAtom  / 23
38 : ExpApp -> . ExpApp ExpAtom  / 23
39 : ExpApp -> . S ExpAtom  / 23
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 23
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 23
42 : ExpApp -> . UNFOLD ExpAtom  / 23
43 : ExpPost -> . ExpApp  / 24
44 : ExpPost -> . ExpPost DOT IDENT  / 24
45 : Exp -> . ExpPost  / 25
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 25
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 25
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 25
49 : Exp -> . FIX IDENT IS Exp  / 25
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 25

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 87
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 58:

50 : Exp -> FOLD LBRACKET IDENT . DOT Tp RBRACKET Exp  / 7

DOT => shift 88

-----

State 59:

46 : Exp -> FN LPAREN IDENT . COLON Tp RPAREN Exp  / 7
47 : Exp -> FN LPAREN IDENT . RPAREN Exp  / 7

RPAREN => shift 89
COLON => shift 90

-----

State 60:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 4
25 : ExpAtom -> . IDENT  / 4
26 : ExpAtom -> . NUMBER  / 4
27 : ExpAtom -> . Z  / 4
28 : ExpAtom -> . LANGLE RANGLE  / 4
29 : ExpAtom -> . LANGLE PairList RANGLE  / 4
30 : ExpAtom -> . LET Edecls IN Exp END  / 4
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 4
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 4
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 4
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 4
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
37 : ExpApp -> . ExpAtom  / 4
38 : ExpApp -> . ExpApp ExpAtom  / 4
39 : ExpApp -> . S ExpAtom  / 4
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 4
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 4
42 : ExpApp -> . UNFOLD ExpAtom  / 4
43 : ExpPost -> . ExpApp  / 15
44 : ExpPost -> . ExpPost DOT IDENT  / 15
45 : Exp -> . ExpPost  / 7
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 7
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 7
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 7
49 : Exp -> . FIX IDENT IS Exp  / 7
49 : Exp -> FIX IDENT IS . Exp  / 7
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 7

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 91
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 61:

3 : Tp -> . LPAREN Tp RPAREN  / 26
4 : Tp -> . IDENT  / 26
5 : Tp -> . NAT  / 26
6 : Tp -> . UNIT  / 26
7 : Tp -> . VOID  / 26
8 : Tp -> . LANGLE RANGLE  / 26
9 : Tp -> . LANGLE RecordList RANGLE  / 26
10 : Tp -> . LBRACKET RBRACKET  / 26
11 : Tp -> . LBRACKET RecordList RBRACKET  / 26
12 : Tp -> . Tp ARROW Tp  / 26
13 : Tp -> . MU IDENT DOT Tp  / 26
14 : Tp -> . REF Tp  / 26
48 : Exp -> FIX IDENT COLON . Tp IS Exp  / 7

IDENT => shift 45
LANGLE => shift 44
LBRACKET => shift 43
LPAREN => shift 46
MU => shift 42
NAT => shift 41
REF => shift 40
UNIT => shift 48
VOID => shift 47
Tp => goto 92

-----

State 62:

33 : ExpAtom -> CASE Exp LBRACE . CaseRules RBRACE  / 4
34 : ExpAtom -> CASE Exp LBRACE . BAR CaseRules RBRACE  / 4
55 : CaseRule -> . IDENT Pat DARROW Exp  / 27
56 : CaseRules -> . CaseRule  / 28
57 : CaseRules -> . CaseRule BAR CaseRules  / 28

IDENT => shift 96
BAR => shift 95
CaseRules => goto 94
CaseRule => goto 93

-----

State 63:

12 : Tp -> Tp . ARROW Tp  / 16
40 : ExpApp -> ABORT LBRACKET Tp . RBRACKET ExpAtom  / 4

RBRACKET => shift 97
ARROW => shift 68

-----

State 64:

24 : ExpAtom -> LPAREN Exp RPAREN .  / 4

$ => reduce 24
IDENT => reduce 24
NUMBER => reduce 24
LANGLE => reduce 24
RANGLE => reduce 24
LBRACE => reduce 24
RBRACE => reduce 24
LPAREN => reduce 24
RPAREN => reduce 24
BAR => reduce 24
COMMA => reduce 24
DOT => reduce 24
CASE => reduce 24
END => reduce 24
IFZ => reduce 24
IN => reduce 24
LET => reduce 24
VAL => reduce 24
Z => reduce 24
ITER => reduce 24

-----

State 65:

29 : ExpAtom -> LANGLE PairList RANGLE .  / 4

$ => reduce 29
IDENT => reduce 29
NUMBER => reduce 29
LANGLE => reduce 29
RANGLE => reduce 29
LBRACE => reduce 29
RBRACE => reduce 29
LPAREN => reduce 29
RPAREN => reduce 29
BAR => reduce 29
COMMA => reduce 29
DOT => reduce 29
CASE => reduce 29
END => reduce 29
IFZ => reduce 29
IN => reduce 29
LET => reduce 29
VAL => reduce 29
Z => reduce 29
ITER => reduce 29

-----

State 66:

22 : PairList -> IDENT EQUAL . Exp  / 11
23 : PairList -> IDENT EQUAL . Exp COMMA PairList  / 11
24 : ExpAtom -> . LPAREN Exp RPAREN  / 29
25 : ExpAtom -> . IDENT  / 29
26 : ExpAtom -> . NUMBER  / 29
27 : ExpAtom -> . Z  / 29
28 : ExpAtom -> . LANGLE RANGLE  / 29
29 : ExpAtom -> . LANGLE PairList RANGLE  / 29
30 : ExpAtom -> . LET Edecls IN Exp END  / 29
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 29
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 29
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 29
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 29
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 29
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 29
37 : ExpApp -> . ExpAtom  / 29
38 : ExpApp -> . ExpApp ExpAtom  / 29
39 : ExpApp -> . S ExpAtom  / 29
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 29
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 29
42 : ExpApp -> . UNFOLD ExpAtom  / 29
43 : ExpPost -> . ExpApp  / 30
44 : ExpPost -> . ExpPost DOT IDENT  / 30
45 : Exp -> . ExpPost  / 20
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 20
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 20
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 20
49 : Exp -> . FIX IDENT IS Exp  / 20
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 20

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 98
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 67:

41 : ExpApp -> IN Tp LBRACE . IDENT RBRACE ExpAtom  / 4

IDENT => shift 99

-----

State 68:

3 : Tp -> . LPAREN Tp RPAREN  / 17
4 : Tp -> . IDENT  / 17
5 : Tp -> . NAT  / 17
6 : Tp -> . UNIT  / 17
7 : Tp -> . VOID  / 17
8 : Tp -> . LANGLE RANGLE  / 17
9 : Tp -> . LANGLE RecordList RANGLE  / 17
10 : Tp -> . LBRACKET RBRACKET  / 17
11 : Tp -> . LBRACKET RecordList RBRACKET  / 17
12 : Tp -> . Tp ARROW Tp  / 17
12 : Tp -> Tp ARROW . Tp  / 17
13 : Tp -> . MU IDENT DOT Tp  / 17
14 : Tp -> . REF Tp  / 17

IDENT => shift 45
LANGLE => shift 44
LBRACKET => shift 43
LPAREN => shift 46
MU => shift 42
NAT => shift 41
REF => shift 40
UNIT => shift 48
VOID => shift 47
Tp => goto 100

-----

State 69:

12 : Tp -> Tp . ARROW Tp  / 17
14 : Tp -> REF Tp .  / 17

RANGLE => reduce 14
LBRACE => reduce 14
RBRACKET => reduce 14
RPAREN => reduce 14
ARROW => reduce 14, shift 68  PRECEDENCE
AT => reduce 14
COMMA => reduce 14
DARROW => reduce 14
EQUAL => reduce 14
IS => reduce 14

-----

State 70:

13 : Tp -> MU IDENT . DOT Tp  / 17

DOT => shift 101

-----

State 71:

11 : Tp -> LBRACKET RecordList . RBRACKET  / 17

RBRACKET => shift 102

-----

State 72:

1 : RecordList -> Record .  / 31
2 : RecordList -> Record . COMMA RecordList  / 31

RANGLE => reduce 1
RBRACKET => reduce 1
COMMA => shift 103

-----

State 73:

10 : Tp -> LBRACKET RBRACKET .  / 17

RANGLE => reduce 10
LBRACE => reduce 10
RBRACKET => reduce 10
RPAREN => reduce 10
ARROW => reduce 10
AT => reduce 10
COMMA => reduce 10
DARROW => reduce 10
EQUAL => reduce 10
IS => reduce 10

-----

State 74:

0 : Record -> IDENT . COLON COLON Tp  / 32

COLON => shift 104

-----

State 75:

9 : Tp -> LANGLE RecordList . RANGLE  / 17

RANGLE => shift 105

-----

State 76:

8 : Tp -> LANGLE RANGLE .  / 17

RANGLE => reduce 8
LBRACE => reduce 8
RBRACKET => reduce 8
RPAREN => reduce 8
ARROW => reduce 8
AT => reduce 8
COMMA => reduce 8
DARROW => reduce 8
EQUAL => reduce 8
IS => reduce 8

-----

State 77:

3 : Tp -> LPAREN Tp . RPAREN  / 17
12 : Tp -> Tp . ARROW Tp  / 21

RPAREN => shift 106
ARROW => shift 68

-----

State 78:

35 : ExpAtom -> IFZ Exp LBRACE . Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
36 : ExpAtom -> IFZ Exp LBRACE . BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4

BAR => shift 107
Z => shift 108

-----

State 79:

63 : Pat -> LANGLE . RANGLE  / 33
64 : Pat -> LANGLE . PatList RANGLE  / 33
65 : RecordPat -> . IDENT EQUAL Pat  / 20
66 : PatList -> . RecordPat  / 11
67 : PatList -> . RecordPat COMMA PatList  / 11

IDENT => shift 112
RANGLE => shift 111
PatList => goto 110
RecordPat => goto 109

-----

State 80:

54 : Edecl -> VAL IDENT . COLON Pred EQUAL Exp  / 14
60 : Pat -> IDENT . COLON Tp  / 22
61 : Pat -> IDENT .  / 22

AT => reduce 61
COLON => shift 113
EQUAL => reduce 61

-----

State 81:

58 : Pat -> . LPAREN Pat RPAREN  / 34
58 : Pat -> LPAREN . Pat RPAREN  / 33
59 : Pat -> . UNDERSCORE COLON Tp  / 34
60 : Pat -> . IDENT COLON Tp  / 34
61 : Pat -> . IDENT  / 34
62 : Pat -> . Pat AT IDENT  / 34
63 : Pat -> . LANGLE RANGLE  / 34
64 : Pat -> . LANGLE PatList RANGLE  / 34

IDENT => shift 114
LANGLE => shift 79
LPAREN => shift 81
UNDERSCORE => shift 83
Pat => goto 115

-----

State 82:

53 : Edecl -> VAL Pat . EQUAL Exp  / 14
62 : Pat -> Pat . AT IDENT  / 22

AT => shift 116
EQUAL => shift 117

-----

State 83:

59 : Pat -> UNDERSCORE . COLON Tp  / 33

COLON => shift 118

-----

State 84:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 35
25 : ExpAtom -> . IDENT  / 35
26 : ExpAtom -> . NUMBER  / 35
27 : ExpAtom -> . Z  / 35
28 : ExpAtom -> . LANGLE RANGLE  / 35
29 : ExpAtom -> . LANGLE PairList RANGLE  / 35
30 : ExpAtom -> . LET Edecls IN Exp END  / 35
30 : ExpAtom -> LET Edecls IN . Exp END  / 4
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 35
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 35
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 35
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 35
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 35
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 35
37 : ExpApp -> . ExpAtom  / 35
38 : ExpApp -> . ExpApp ExpAtom  / 35
39 : ExpApp -> . S ExpAtom  / 35
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 35
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 35
42 : ExpApp -> . UNFOLD ExpAtom  / 35
43 : ExpPost -> . ExpApp  / 36
44 : ExpPost -> . ExpPost DOT IDENT  / 36
45 : Exp -> . ExpPost  / 37
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 37
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 37
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 37
49 : Exp -> . FIX IDENT IS Exp  / 37
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 37

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 119
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 85:

52 : Edecls -> Edecl Edecls .  / 13

IN => reduce 52

-----

State 86:

44 : ExpPost -> ExpPost DOT IDENT .  / 15

$ => reduce 44
RANGLE => reduce 44
LBRACE => reduce 44
RBRACE => reduce 44
RPAREN => reduce 44
BAR => reduce 44
COMMA => reduce 44
DOT => reduce 44
END => reduce 44
IN => reduce 44
VAL => reduce 44

-----

State 87:

31 : ExpAtom -> ITER Exp LBRACE Exp . BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 4
32 : ExpAtom -> ITER Exp LBRACE Exp . BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 4

BAR => shift 120

-----

State 88:

3 : Tp -> . LPAREN Tp RPAREN  / 16
4 : Tp -> . IDENT  / 16
5 : Tp -> . NAT  / 16
6 : Tp -> . UNIT  / 16
7 : Tp -> . VOID  / 16
8 : Tp -> . LANGLE RANGLE  / 16
9 : Tp -> . LANGLE RecordList RANGLE  / 16
10 : Tp -> . LBRACKET RBRACKET  / 16
11 : Tp -> . LBRACKET RecordList RBRACKET  / 16
12 : Tp -> . Tp ARROW Tp  / 16
13 : Tp -> . MU IDENT DOT Tp  / 16
14 : Tp -> . REF Tp  / 16
50 : Exp -> FOLD LBRACKET IDENT DOT . Tp RBRACKET Exp  / 7

IDENT => shift 45
LANGLE => shift 44
LBRACKET => shift 43
LPAREN => shift 46
MU => shift 42
NAT => shift 41
REF => shift 40
UNIT => shift 48
VOID => shift 47
Tp => goto 121

-----

State 89:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 4
25 : ExpAtom -> . IDENT  / 4
26 : ExpAtom -> . NUMBER  / 4
27 : ExpAtom -> . Z  / 4
28 : ExpAtom -> . LANGLE RANGLE  / 4
29 : ExpAtom -> . LANGLE PairList RANGLE  / 4
30 : ExpAtom -> . LET Edecls IN Exp END  / 4
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 4
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 4
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 4
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 4
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
37 : ExpApp -> . ExpAtom  / 4
38 : ExpApp -> . ExpApp ExpAtom  / 4
39 : ExpApp -> . S ExpAtom  / 4
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 4
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 4
42 : ExpApp -> . UNFOLD ExpAtom  / 4
43 : ExpPost -> . ExpApp  / 15
44 : ExpPost -> . ExpPost DOT IDENT  / 15
45 : Exp -> . ExpPost  / 7
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 7
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 7
47 : Exp -> FN LPAREN IDENT RPAREN . Exp  / 7
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 7
49 : Exp -> . FIX IDENT IS Exp  / 7
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 7

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 122
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 90:

3 : Tp -> . LPAREN Tp RPAREN  / 21
4 : Tp -> . IDENT  / 21
5 : Tp -> . NAT  / 21
6 : Tp -> . UNIT  / 21
7 : Tp -> . VOID  / 21
8 : Tp -> . LANGLE RANGLE  / 21
9 : Tp -> . LANGLE RecordList RANGLE  / 21
10 : Tp -> . LBRACKET RBRACKET  / 21
11 : Tp -> . LBRACKET RecordList RBRACKET  / 21
12 : Tp -> . Tp ARROW Tp  / 21
13 : Tp -> . MU IDENT DOT Tp  / 21
14 : Tp -> . REF Tp  / 21
46 : Exp -> FN LPAREN IDENT COLON . Tp RPAREN Exp  / 7

IDENT => shift 45
LANGLE => shift 44
LBRACKET => shift 43
LPAREN => shift 46
MU => shift 42
NAT => shift 41
REF => shift 40
UNIT => shift 48
VOID => shift 47
Tp => goto 123

-----

State 91:

49 : Exp -> FIX IDENT IS Exp .  / 7

$ => reduce 49
RANGLE => reduce 49
LBRACE => reduce 49
RBRACE => reduce 49
RPAREN => reduce 49
BAR => reduce 49
COMMA => reduce 49
END => reduce 49
IN => reduce 49
VAL => reduce 49

-----

State 92:

12 : Tp -> Tp . ARROW Tp  / 26
48 : Exp -> FIX IDENT COLON Tp . IS Exp  / 7

ARROW => shift 68
IS => shift 124

-----

State 93:

56 : CaseRules -> CaseRule .  / 28
57 : CaseRules -> CaseRule . BAR CaseRules  / 28

RBRACE => reduce 56
BAR => shift 125

-----

State 94:

33 : ExpAtom -> CASE Exp LBRACE CaseRules . RBRACE  / 4

RBRACE => shift 126

-----

State 95:

34 : ExpAtom -> CASE Exp LBRACE BAR . CaseRules RBRACE  / 4
55 : CaseRule -> . IDENT Pat DARROW Exp  / 27
56 : CaseRules -> . CaseRule  / 28
57 : CaseRules -> . CaseRule BAR CaseRules  / 28

IDENT => shift 96
CaseRules => goto 127
CaseRule => goto 93

-----

State 96:

55 : CaseRule -> IDENT . Pat DARROW Exp  / 27
58 : Pat -> . LPAREN Pat RPAREN  / 38
59 : Pat -> . UNDERSCORE COLON Tp  / 38
60 : Pat -> . IDENT COLON Tp  / 38
61 : Pat -> . IDENT  / 38
62 : Pat -> . Pat AT IDENT  / 38
63 : Pat -> . LANGLE RANGLE  / 38
64 : Pat -> . LANGLE PatList RANGLE  / 38

IDENT => shift 114
LANGLE => shift 79
LPAREN => shift 81
UNDERSCORE => shift 83
Pat => goto 128

-----

State 97:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 4
25 : ExpAtom -> . IDENT  / 4
26 : ExpAtom -> . NUMBER  / 4
27 : ExpAtom -> . Z  / 4
28 : ExpAtom -> . LANGLE RANGLE  / 4
29 : ExpAtom -> . LANGLE PairList RANGLE  / 4
30 : ExpAtom -> . LET Edecls IN Exp END  / 4
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 4
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 4
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 4
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 4
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
40 : ExpApp -> ABORT LBRACKET Tp RBRACKET . ExpAtom  / 4

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
CASE => shift 12
IFZ => shift 19
LET => shift 22
Z => shift 23
ITER => shift 8
ExpAtom => goto 129

-----

State 98:

22 : PairList -> IDENT EQUAL Exp .  / 11
23 : PairList -> IDENT EQUAL Exp . COMMA PairList  / 11

RANGLE => reduce 22
COMMA => shift 130

-----

State 99:

41 : ExpApp -> IN Tp LBRACE IDENT . RBRACE ExpAtom  / 4

RBRACE => shift 131

-----

State 100:

12 : Tp -> Tp . ARROW Tp  / 17
12 : Tp -> Tp ARROW Tp .  / 17

RANGLE => reduce 12
LBRACE => reduce 12
RBRACKET => reduce 12
RPAREN => reduce 12
ARROW => shift 68, reduce 12  PRECEDENCE
AT => reduce 12
COMMA => reduce 12
DARROW => reduce 12
EQUAL => reduce 12
IS => reduce 12

-----

State 101:

3 : Tp -> . LPAREN Tp RPAREN  / 17
4 : Tp -> . IDENT  / 17
5 : Tp -> . NAT  / 17
6 : Tp -> . UNIT  / 17
7 : Tp -> . VOID  / 17
8 : Tp -> . LANGLE RANGLE  / 17
9 : Tp -> . LANGLE RecordList RANGLE  / 17
10 : Tp -> . LBRACKET RBRACKET  / 17
11 : Tp -> . LBRACKET RecordList RBRACKET  / 17
12 : Tp -> . Tp ARROW Tp  / 17
13 : Tp -> . MU IDENT DOT Tp  / 17
13 : Tp -> MU IDENT DOT . Tp  / 17
14 : Tp -> . REF Tp  / 17

IDENT => shift 45
LANGLE => shift 44
LBRACKET => shift 43
LPAREN => shift 46
MU => shift 42
NAT => shift 41
REF => shift 40
UNIT => shift 48
VOID => shift 47
Tp => goto 132

-----

State 102:

11 : Tp -> LBRACKET RecordList RBRACKET .  / 17

RANGLE => reduce 11
LBRACE => reduce 11
RBRACKET => reduce 11
RPAREN => reduce 11
ARROW => reduce 11
AT => reduce 11
COMMA => reduce 11
DARROW => reduce 11
EQUAL => reduce 11
IS => reduce 11

-----

State 103:

0 : Record -> . IDENT COLON COLON Tp  / 32
1 : RecordList -> . Record  / 31
2 : RecordList -> . Record COMMA RecordList  / 31
2 : RecordList -> Record COMMA . RecordList  / 31

IDENT => shift 74
Record => goto 72
RecordList => goto 133

-----

State 104:

0 : Record -> IDENT COLON . COLON Tp  / 32

COLON => shift 134

-----

State 105:

9 : Tp -> LANGLE RecordList RANGLE .  / 17

RANGLE => reduce 9
LBRACE => reduce 9
RBRACKET => reduce 9
RPAREN => reduce 9
ARROW => reduce 9
AT => reduce 9
COMMA => reduce 9
DARROW => reduce 9
EQUAL => reduce 9
IS => reduce 9

-----

State 106:

3 : Tp -> LPAREN Tp RPAREN .  / 17

RANGLE => reduce 3
LBRACE => reduce 3
RBRACKET => reduce 3
RPAREN => reduce 3
ARROW => reduce 3
AT => reduce 3
COMMA => reduce 3
DARROW => reduce 3
EQUAL => reduce 3
IS => reduce 3

-----

State 107:

36 : ExpAtom -> IFZ Exp LBRACE BAR . Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4

Z => shift 135

-----

State 108:

35 : ExpAtom -> IFZ Exp LBRACE Z . DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4

DARROW => shift 136

-----

State 109:

66 : PatList -> RecordPat .  / 11
67 : PatList -> RecordPat . COMMA PatList  / 11

RANGLE => reduce 66
COMMA => shift 137

-----

State 110:

64 : Pat -> LANGLE PatList . RANGLE  / 33

RANGLE => shift 138

-----

State 111:

63 : Pat -> LANGLE RANGLE .  / 33

RANGLE => reduce 63
RPAREN => reduce 63
AT => reduce 63
COMMA => reduce 63
DARROW => reduce 63
EQUAL => reduce 63

-----

State 112:

65 : RecordPat -> IDENT . EQUAL Pat  / 20

EQUAL => shift 139

-----

State 113:

3 : Tp -> . LPAREN Tp RPAREN  / 39
4 : Tp -> . IDENT  / 39
5 : Tp -> . NAT  / 39
6 : Tp -> . UNIT  / 39
7 : Tp -> . VOID  / 39
8 : Tp -> . LANGLE RANGLE  / 39
9 : Tp -> . LANGLE RecordList RANGLE  / 39
10 : Tp -> . LBRACKET RBRACKET  / 39
11 : Tp -> . LBRACKET RecordList RBRACKET  / 39
12 : Tp -> . Tp ARROW Tp  / 39
13 : Tp -> . MU IDENT DOT Tp  / 39
14 : Tp -> . REF Tp  / 39
15 : Pred -> . LPAREN Pred RPAREN  / 40
16 : Pred -> . TOP  / 40
17 : Pred -> . NUM  / 40
18 : Pred -> . Pred AMPERSAND Pred  / 40
19 : Pred -> . Pred STAR Pred  / 40
20 : Pred -> . Pred ARROW Pred  / 40
21 : Pred -> . LIST Pred  / 40
54 : Edecl -> VAL IDENT COLON . Pred EQUAL Exp  / 14
60 : Pat -> IDENT COLON . Tp  / 22

IDENT => shift 45
LANGLE => shift 44
LBRACKET => shift 43
LPAREN => shift 142
LIST => shift 141
MU => shift 42
NAT => shift 41
NUM => shift 143
REF => shift 40
TOP => shift 144
UNIT => shift 48
VOID => shift 47
Tp => goto 140
Pred => goto 145

-----

State 114:

60 : Pat -> IDENT . COLON Tp  / 41
61 : Pat -> IDENT .  / 41

RANGLE => reduce 61
RPAREN => reduce 61
AT => reduce 61
COLON => shift 146
COMMA => reduce 61
DARROW => reduce 61

-----

State 115:

58 : Pat -> LPAREN Pat . RPAREN  / 33
62 : Pat -> Pat . AT IDENT  / 34

RPAREN => shift 147
AT => shift 116

-----

State 116:

62 : Pat -> Pat AT . IDENT  / 33

IDENT => shift 148

-----

State 117:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 42
25 : ExpAtom -> . IDENT  / 42
26 : ExpAtom -> . NUMBER  / 42
27 : ExpAtom -> . Z  / 42
28 : ExpAtom -> . LANGLE RANGLE  / 42
29 : ExpAtom -> . LANGLE PairList RANGLE  / 42
30 : ExpAtom -> . LET Edecls IN Exp END  / 42
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 42
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 42
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 42
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 42
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 42
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 42
37 : ExpApp -> . ExpAtom  / 42
38 : ExpApp -> . ExpApp ExpAtom  / 42
39 : ExpApp -> . S ExpAtom  / 42
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 42
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 42
42 : ExpApp -> . UNFOLD ExpAtom  / 42
43 : ExpPost -> . ExpApp  / 43
44 : ExpPost -> . ExpPost DOT IDENT  / 43
45 : Exp -> . ExpPost  / 14
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 14
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 14
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 14
49 : Exp -> . FIX IDENT IS Exp  / 14
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 14
53 : Edecl -> VAL Pat EQUAL . Exp  / 14

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 149
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 118:

3 : Tp -> . LPAREN Tp RPAREN  / 44
4 : Tp -> . IDENT  / 44
5 : Tp -> . NAT  / 44
6 : Tp -> . UNIT  / 44
7 : Tp -> . VOID  / 44
8 : Tp -> . LANGLE RANGLE  / 44
9 : Tp -> . LANGLE RecordList RANGLE  / 44
10 : Tp -> . LBRACKET RBRACKET  / 44
11 : Tp -> . LBRACKET RecordList RBRACKET  / 44
12 : Tp -> . Tp ARROW Tp  / 44
13 : Tp -> . MU IDENT DOT Tp  / 44
14 : Tp -> . REF Tp  / 44
59 : Pat -> UNDERSCORE COLON . Tp  / 33

IDENT => shift 45
LANGLE => shift 44
LBRACKET => shift 43
LPAREN => shift 46
MU => shift 42
NAT => shift 41
REF => shift 40
UNIT => shift 48
VOID => shift 47
Tp => goto 150

-----

State 119:

30 : ExpAtom -> LET Edecls IN Exp . END  / 4

END => shift 151

-----

State 120:

31 : ExpAtom -> ITER Exp LBRACE Exp BAR . S IDENT WITH IDENT DARROW Exp RBRACE  / 4
32 : ExpAtom -> ITER Exp LBRACE Exp BAR . S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 4

S => shift 152

-----

State 121:

12 : Tp -> Tp . ARROW Tp  / 16
50 : Exp -> FOLD LBRACKET IDENT DOT Tp . RBRACKET Exp  / 7

RBRACKET => shift 153
ARROW => shift 68

-----

State 122:

47 : Exp -> FN LPAREN IDENT RPAREN Exp .  / 7

$ => reduce 47
RANGLE => reduce 47
LBRACE => reduce 47
RBRACE => reduce 47
RPAREN => reduce 47
BAR => reduce 47
COMMA => reduce 47
END => reduce 47
IN => reduce 47
VAL => reduce 47

-----

State 123:

12 : Tp -> Tp . ARROW Tp  / 21
46 : Exp -> FN LPAREN IDENT COLON Tp . RPAREN Exp  / 7

RPAREN => shift 154
ARROW => shift 68

-----

State 124:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 4
25 : ExpAtom -> . IDENT  / 4
26 : ExpAtom -> . NUMBER  / 4
27 : ExpAtom -> . Z  / 4
28 : ExpAtom -> . LANGLE RANGLE  / 4
29 : ExpAtom -> . LANGLE PairList RANGLE  / 4
30 : ExpAtom -> . LET Edecls IN Exp END  / 4
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 4
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 4
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 4
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 4
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
37 : ExpApp -> . ExpAtom  / 4
38 : ExpApp -> . ExpApp ExpAtom  / 4
39 : ExpApp -> . S ExpAtom  / 4
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 4
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 4
42 : ExpApp -> . UNFOLD ExpAtom  / 4
43 : ExpPost -> . ExpApp  / 15
44 : ExpPost -> . ExpPost DOT IDENT  / 15
45 : Exp -> . ExpPost  / 7
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 7
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 7
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 7
48 : Exp -> FIX IDENT COLON Tp IS . Exp  / 7
49 : Exp -> . FIX IDENT IS Exp  / 7
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 7

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 155
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 125:

55 : CaseRule -> . IDENT Pat DARROW Exp  / 27
56 : CaseRules -> . CaseRule  / 28
57 : CaseRules -> . CaseRule BAR CaseRules  / 28
57 : CaseRules -> CaseRule BAR . CaseRules  / 28

IDENT => shift 96
CaseRules => goto 156
CaseRule => goto 93

-----

State 126:

33 : ExpAtom -> CASE Exp LBRACE CaseRules RBRACE .  / 4

$ => reduce 33
IDENT => reduce 33
NUMBER => reduce 33
LANGLE => reduce 33
RANGLE => reduce 33
LBRACE => reduce 33
RBRACE => reduce 33
LPAREN => reduce 33
RPAREN => reduce 33
BAR => reduce 33
COMMA => reduce 33
DOT => reduce 33
CASE => reduce 33
END => reduce 33
IFZ => reduce 33
IN => reduce 33
LET => reduce 33
VAL => reduce 33
Z => reduce 33
ITER => reduce 33

-----

State 127:

34 : ExpAtom -> CASE Exp LBRACE BAR CaseRules . RBRACE  / 4

RBRACE => shift 157

-----

State 128:

55 : CaseRule -> IDENT Pat . DARROW Exp  / 27
62 : Pat -> Pat . AT IDENT  / 38

AT => shift 116
DARROW => shift 158

-----

State 129:

40 : ExpApp -> ABORT LBRACKET Tp RBRACKET ExpAtom .  / 4

$ => reduce 40
IDENT => reduce 40
NUMBER => reduce 40
LANGLE => reduce 40
RANGLE => reduce 40
LBRACE => reduce 40
RBRACE => reduce 40
LPAREN => reduce 40
RPAREN => reduce 40
BAR => reduce 40
COMMA => reduce 40
DOT => reduce 40
CASE => reduce 40
END => reduce 40
IFZ => reduce 40
IN => reduce 40
LET => reduce 40
VAL => reduce 40
Z => reduce 40
ITER => reduce 40

-----

State 130:

22 : PairList -> . IDENT EQUAL Exp  / 11
23 : PairList -> . IDENT EQUAL Exp COMMA PairList  / 11
23 : PairList -> IDENT EQUAL Exp COMMA . PairList  / 11

IDENT => shift 38
PairList => goto 159

-----

State 131:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 4
25 : ExpAtom -> . IDENT  / 4
26 : ExpAtom -> . NUMBER  / 4
27 : ExpAtom -> . Z  / 4
28 : ExpAtom -> . LANGLE RANGLE  / 4
29 : ExpAtom -> . LANGLE PairList RANGLE  / 4
30 : ExpAtom -> . LET Edecls IN Exp END  / 4
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 4
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 4
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 4
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 4
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
41 : ExpApp -> IN Tp LBRACE IDENT RBRACE . ExpAtom  / 4

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
CASE => shift 12
IFZ => shift 19
LET => shift 22
Z => shift 23
ITER => shift 8
ExpAtom => goto 160

-----

State 132:

12 : Tp -> Tp . ARROW Tp  / 17
13 : Tp -> MU IDENT DOT Tp .  / 17

RANGLE => reduce 13
LBRACE => reduce 13
RBRACKET => reduce 13
RPAREN => reduce 13
ARROW => shift 68, reduce 13  PRECEDENCE
AT => reduce 13
COMMA => reduce 13
DARROW => reduce 13
EQUAL => reduce 13
IS => reduce 13

-----

State 133:

2 : RecordList -> Record COMMA RecordList .  / 31

RANGLE => reduce 2
RBRACKET => reduce 2

-----

State 134:

0 : Record -> IDENT COLON COLON . Tp  / 32
3 : Tp -> . LPAREN Tp RPAREN  / 45
4 : Tp -> . IDENT  / 45
5 : Tp -> . NAT  / 45
6 : Tp -> . UNIT  / 45
7 : Tp -> . VOID  / 45
8 : Tp -> . LANGLE RANGLE  / 45
9 : Tp -> . LANGLE RecordList RANGLE  / 45
10 : Tp -> . LBRACKET RBRACKET  / 45
11 : Tp -> . LBRACKET RecordList RBRACKET  / 45
12 : Tp -> . Tp ARROW Tp  / 45
13 : Tp -> . MU IDENT DOT Tp  / 45
14 : Tp -> . REF Tp  / 45

IDENT => shift 45
LANGLE => shift 44
LBRACKET => shift 43
LPAREN => shift 46
MU => shift 42
NAT => shift 41
REF => shift 40
UNIT => shift 48
VOID => shift 47
Tp => goto 161

-----

State 135:

36 : ExpAtom -> IFZ Exp LBRACE BAR Z . DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4

DARROW => shift 162

-----

State 136:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 23
25 : ExpAtom -> . IDENT  / 23
26 : ExpAtom -> . NUMBER  / 23
27 : ExpAtom -> . Z  / 23
28 : ExpAtom -> . LANGLE RANGLE  / 23
29 : ExpAtom -> . LANGLE PairList RANGLE  / 23
30 : ExpAtom -> . LET Edecls IN Exp END  / 23
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 23
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 23
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 23
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 23
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 23
35 : ExpAtom -> IFZ Exp LBRACE Z DARROW . Exp BAR S IDENT DARROW Exp RBRACE  / 4
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 23
37 : ExpApp -> . ExpAtom  / 23
38 : ExpApp -> . ExpApp ExpAtom  / 23
39 : ExpApp -> . S ExpAtom  / 23
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 23
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 23
42 : ExpApp -> . UNFOLD ExpAtom  / 23
43 : ExpPost -> . ExpApp  / 24
44 : ExpPost -> . ExpPost DOT IDENT  / 24
45 : Exp -> . ExpPost  / 25
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 25
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 25
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 25
49 : Exp -> . FIX IDENT IS Exp  / 25
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 25

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 163
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 137:

65 : RecordPat -> . IDENT EQUAL Pat  / 20
66 : PatList -> . RecordPat  / 11
67 : PatList -> . RecordPat COMMA PatList  / 11
67 : PatList -> RecordPat COMMA . PatList  / 11

IDENT => shift 112
PatList => goto 164
RecordPat => goto 109

-----

State 138:

64 : Pat -> LANGLE PatList RANGLE .  / 33

RANGLE => reduce 64
RPAREN => reduce 64
AT => reduce 64
COMMA => reduce 64
DARROW => reduce 64
EQUAL => reduce 64

-----

State 139:

58 : Pat -> . LPAREN Pat RPAREN  / 46
59 : Pat -> . UNDERSCORE COLON Tp  / 46
60 : Pat -> . IDENT COLON Tp  / 46
61 : Pat -> . IDENT  / 46
62 : Pat -> . Pat AT IDENT  / 46
63 : Pat -> . LANGLE RANGLE  / 46
64 : Pat -> . LANGLE PatList RANGLE  / 46
65 : RecordPat -> IDENT EQUAL . Pat  / 20

IDENT => shift 114
LANGLE => shift 79
LPAREN => shift 81
UNDERSCORE => shift 83
Pat => goto 165

-----

State 140:

12 : Tp -> Tp . ARROW Tp  / 44
60 : Pat -> IDENT COLON Tp .  / 33

RANGLE => reduce 60
RPAREN => reduce 60
ARROW => shift 68
AT => reduce 60
COMMA => reduce 60
DARROW => reduce 60
EQUAL => reduce 60

-----

State 141:

15 : Pred -> . LPAREN Pred RPAREN  / 47
16 : Pred -> . TOP  / 47
17 : Pred -> . NUM  / 47
18 : Pred -> . Pred AMPERSAND Pred  / 47
19 : Pred -> . Pred STAR Pred  / 47
20 : Pred -> . Pred ARROW Pred  / 47
21 : Pred -> . LIST Pred  / 47
21 : Pred -> LIST . Pred  / 47

LPAREN => shift 167
LIST => shift 141
NUM => shift 143
TOP => shift 144
Pred => goto 166

-----

State 142:

3 : Tp -> . LPAREN Tp RPAREN  / 21
3 : Tp -> LPAREN . Tp RPAREN  / 48
4 : Tp -> . IDENT  / 21
5 : Tp -> . NAT  / 21
6 : Tp -> . UNIT  / 21
7 : Tp -> . VOID  / 21
8 : Tp -> . LANGLE RANGLE  / 21
9 : Tp -> . LANGLE RecordList RANGLE  / 21
10 : Tp -> . LBRACKET RBRACKET  / 21
11 : Tp -> . LBRACKET RecordList RBRACKET  / 21
12 : Tp -> . Tp ARROW Tp  / 21
13 : Tp -> . MU IDENT DOT Tp  / 21
14 : Tp -> . REF Tp  / 21
15 : Pred -> . LPAREN Pred RPAREN  / 49
15 : Pred -> LPAREN . Pred RPAREN  / 47
16 : Pred -> . TOP  / 49
17 : Pred -> . NUM  / 49
18 : Pred -> . Pred AMPERSAND Pred  / 49
19 : Pred -> . Pred STAR Pred  / 49
20 : Pred -> . Pred ARROW Pred  / 49
21 : Pred -> . LIST Pred  / 49

IDENT => shift 45
LANGLE => shift 44
LBRACKET => shift 43
LPAREN => shift 142
LIST => shift 141
MU => shift 42
NAT => shift 41
NUM => shift 143
REF => shift 40
TOP => shift 144
UNIT => shift 48
VOID => shift 47
Tp => goto 77
Pred => goto 168

-----

State 143:

17 : Pred -> NUM .  / 47

RPAREN => reduce 17
AMPERSAND => reduce 17
ARROW => reduce 17
EQUAL => reduce 17
STAR => reduce 17

-----

State 144:

16 : Pred -> TOP .  / 47

RPAREN => reduce 16
AMPERSAND => reduce 16
ARROW => reduce 16
EQUAL => reduce 16
STAR => reduce 16

-----

State 145:

18 : Pred -> Pred . AMPERSAND Pred  / 40
19 : Pred -> Pred . STAR Pred  / 40
20 : Pred -> Pred . ARROW Pred  / 40
54 : Edecl -> VAL IDENT COLON Pred . EQUAL Exp  / 14

AMPERSAND => shift 171
ARROW => shift 170
EQUAL => shift 169
STAR => shift 172

-----

State 146:

3 : Tp -> . LPAREN Tp RPAREN  / 50
4 : Tp -> . IDENT  / 50
5 : Tp -> . NAT  / 50
6 : Tp -> . UNIT  / 50
7 : Tp -> . VOID  / 50
8 : Tp -> . LANGLE RANGLE  / 50
9 : Tp -> . LANGLE RecordList RANGLE  / 50
10 : Tp -> . LBRACKET RBRACKET  / 50
11 : Tp -> . LBRACKET RecordList RBRACKET  / 50
12 : Tp -> . Tp ARROW Tp  / 50
13 : Tp -> . MU IDENT DOT Tp  / 50
14 : Tp -> . REF Tp  / 50
60 : Pat -> IDENT COLON . Tp  / 41

IDENT => shift 45
LANGLE => shift 44
LBRACKET => shift 43
LPAREN => shift 46
MU => shift 42
NAT => shift 41
REF => shift 40
UNIT => shift 48
VOID => shift 47
Tp => goto 140

-----

State 147:

58 : Pat -> LPAREN Pat RPAREN .  / 33

RANGLE => reduce 58
RPAREN => reduce 58
AT => reduce 58
COMMA => reduce 58
DARROW => reduce 58
EQUAL => reduce 58

-----

State 148:

62 : Pat -> Pat AT IDENT .  / 33

RANGLE => reduce 62
RPAREN => reduce 62
AT => reduce 62
COMMA => reduce 62
DARROW => reduce 62
EQUAL => reduce 62

-----

State 149:

53 : Edecl -> VAL Pat EQUAL Exp .  / 14

IN => reduce 53
VAL => reduce 53

-----

State 150:

12 : Tp -> Tp . ARROW Tp  / 44
59 : Pat -> UNDERSCORE COLON Tp .  / 33

RANGLE => reduce 59
RPAREN => reduce 59
ARROW => shift 68
AT => reduce 59
COMMA => reduce 59
DARROW => reduce 59
EQUAL => reduce 59

-----

State 151:

30 : ExpAtom -> LET Edecls IN Exp END .  / 4

$ => reduce 30
IDENT => reduce 30
NUMBER => reduce 30
LANGLE => reduce 30
RANGLE => reduce 30
LBRACE => reduce 30
RBRACE => reduce 30
LPAREN => reduce 30
RPAREN => reduce 30
BAR => reduce 30
COMMA => reduce 30
DOT => reduce 30
CASE => reduce 30
END => reduce 30
IFZ => reduce 30
IN => reduce 30
LET => reduce 30
VAL => reduce 30
Z => reduce 30
ITER => reduce 30

-----

State 152:

31 : ExpAtom -> ITER Exp LBRACE Exp BAR S . IDENT WITH IDENT DARROW Exp RBRACE  / 4
32 : ExpAtom -> ITER Exp LBRACE Exp BAR S . LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 4

IDENT => shift 174
LPAREN => shift 173

-----

State 153:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 4
25 : ExpAtom -> . IDENT  / 4
26 : ExpAtom -> . NUMBER  / 4
27 : ExpAtom -> . Z  / 4
28 : ExpAtom -> . LANGLE RANGLE  / 4
29 : ExpAtom -> . LANGLE PairList RANGLE  / 4
30 : ExpAtom -> . LET Edecls IN Exp END  / 4
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 4
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 4
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 4
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 4
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
37 : ExpApp -> . ExpAtom  / 4
38 : ExpApp -> . ExpApp ExpAtom  / 4
39 : ExpApp -> . S ExpAtom  / 4
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 4
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 4
42 : ExpApp -> . UNFOLD ExpAtom  / 4
43 : ExpPost -> . ExpApp  / 15
44 : ExpPost -> . ExpPost DOT IDENT  / 15
45 : Exp -> . ExpPost  / 7
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 7
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 7
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 7
49 : Exp -> . FIX IDENT IS Exp  / 7
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 7
50 : Exp -> FOLD LBRACKET IDENT DOT Tp RBRACKET . Exp  / 7

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 175
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 154:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 4
25 : ExpAtom -> . IDENT  / 4
26 : ExpAtom -> . NUMBER  / 4
27 : ExpAtom -> . Z  / 4
28 : ExpAtom -> . LANGLE RANGLE  / 4
29 : ExpAtom -> . LANGLE PairList RANGLE  / 4
30 : ExpAtom -> . LET Edecls IN Exp END  / 4
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 4
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 4
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 4
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 4
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 4
37 : ExpApp -> . ExpAtom  / 4
38 : ExpApp -> . ExpApp ExpAtom  / 4
39 : ExpApp -> . S ExpAtom  / 4
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 4
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 4
42 : ExpApp -> . UNFOLD ExpAtom  / 4
43 : ExpPost -> . ExpApp  / 15
44 : ExpPost -> . ExpPost DOT IDENT  / 15
45 : Exp -> . ExpPost  / 7
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 7
46 : Exp -> FN LPAREN IDENT COLON Tp RPAREN . Exp  / 7
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 7
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 7
49 : Exp -> . FIX IDENT IS Exp  / 7
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 7

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 176
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 155:

48 : Exp -> FIX IDENT COLON Tp IS Exp .  / 7

$ => reduce 48
RANGLE => reduce 48
LBRACE => reduce 48
RBRACE => reduce 48
RPAREN => reduce 48
BAR => reduce 48
COMMA => reduce 48
END => reduce 48
IN => reduce 48
VAL => reduce 48

-----

State 156:

57 : CaseRules -> CaseRule BAR CaseRules .  / 28

RBRACE => reduce 57

-----

State 157:

34 : ExpAtom -> CASE Exp LBRACE BAR CaseRules RBRACE .  / 4

$ => reduce 34
IDENT => reduce 34
NUMBER => reduce 34
LANGLE => reduce 34
RANGLE => reduce 34
LBRACE => reduce 34
RBRACE => reduce 34
LPAREN => reduce 34
RPAREN => reduce 34
BAR => reduce 34
COMMA => reduce 34
DOT => reduce 34
CASE => reduce 34
END => reduce 34
IFZ => reduce 34
IN => reduce 34
LET => reduce 34
VAL => reduce 34
Z => reduce 34
ITER => reduce 34

-----

State 158:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 51
25 : ExpAtom -> . IDENT  / 51
26 : ExpAtom -> . NUMBER  / 51
27 : ExpAtom -> . Z  / 51
28 : ExpAtom -> . LANGLE RANGLE  / 51
29 : ExpAtom -> . LANGLE PairList RANGLE  / 51
30 : ExpAtom -> . LET Edecls IN Exp END  / 51
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 51
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 51
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 51
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 51
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 51
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 51
37 : ExpApp -> . ExpAtom  / 51
38 : ExpApp -> . ExpApp ExpAtom  / 51
39 : ExpApp -> . S ExpAtom  / 51
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 51
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 51
42 : ExpApp -> . UNFOLD ExpAtom  / 51
43 : ExpPost -> . ExpApp  / 52
44 : ExpPost -> . ExpPost DOT IDENT  / 52
45 : Exp -> . ExpPost  / 27
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 27
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 27
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 27
49 : Exp -> . FIX IDENT IS Exp  / 27
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 27
55 : CaseRule -> IDENT Pat DARROW . Exp  / 27

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 177
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 159:

23 : PairList -> IDENT EQUAL Exp COMMA PairList .  / 11

RANGLE => reduce 23

-----

State 160:

41 : ExpApp -> IN Tp LBRACE IDENT RBRACE ExpAtom .  / 4

$ => reduce 41
IDENT => reduce 41
NUMBER => reduce 41
LANGLE => reduce 41
RANGLE => reduce 41
LBRACE => reduce 41
RBRACE => reduce 41
LPAREN => reduce 41
RPAREN => reduce 41
BAR => reduce 41
COMMA => reduce 41
DOT => reduce 41
CASE => reduce 41
END => reduce 41
IFZ => reduce 41
IN => reduce 41
LET => reduce 41
VAL => reduce 41
Z => reduce 41
ITER => reduce 41

-----

State 161:

0 : Record -> IDENT COLON COLON Tp .  / 32
12 : Tp -> Tp . ARROW Tp  / 45

RANGLE => reduce 0
RBRACKET => reduce 0
ARROW => shift 68
COMMA => reduce 0

-----

State 162:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 23
25 : ExpAtom -> . IDENT  / 23
26 : ExpAtom -> . NUMBER  / 23
27 : ExpAtom -> . Z  / 23
28 : ExpAtom -> . LANGLE RANGLE  / 23
29 : ExpAtom -> . LANGLE PairList RANGLE  / 23
30 : ExpAtom -> . LET Edecls IN Exp END  / 23
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 23
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 23
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 23
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 23
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 23
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 23
36 : ExpAtom -> IFZ Exp LBRACE BAR Z DARROW . Exp BAR S IDENT DARROW Exp RBRACE  / 4
37 : ExpApp -> . ExpAtom  / 23
38 : ExpApp -> . ExpApp ExpAtom  / 23
39 : ExpApp -> . S ExpAtom  / 23
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 23
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 23
42 : ExpApp -> . UNFOLD ExpAtom  / 23
43 : ExpPost -> . ExpApp  / 24
44 : ExpPost -> . ExpPost DOT IDENT  / 24
45 : Exp -> . ExpPost  / 25
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 25
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 25
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 25
49 : Exp -> . FIX IDENT IS Exp  / 25
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 25

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 178
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 163:

35 : ExpAtom -> IFZ Exp LBRACE Z DARROW Exp . BAR S IDENT DARROW Exp RBRACE  / 4

BAR => shift 179

-----

State 164:

67 : PatList -> RecordPat COMMA PatList .  / 11

RANGLE => reduce 67

-----

State 165:

62 : Pat -> Pat . AT IDENT  / 46
65 : RecordPat -> IDENT EQUAL Pat .  / 20

RANGLE => reduce 65
AT => shift 116
COMMA => reduce 65

-----

State 166:

18 : Pred -> Pred . AMPERSAND Pred  / 47
19 : Pred -> Pred . STAR Pred  / 47
20 : Pred -> Pred . ARROW Pred  / 47
21 : Pred -> LIST Pred .  / 47

RPAREN => reduce 21
AMPERSAND => reduce 21, shift 171  PRECEDENCE
ARROW => reduce 21, shift 170  PRECEDENCE
EQUAL => reduce 21
STAR => reduce 21, shift 172  PRECEDENCE

-----

State 167:

15 : Pred -> . LPAREN Pred RPAREN  / 49
15 : Pred -> LPAREN . Pred RPAREN  / 47
16 : Pred -> . TOP  / 49
17 : Pred -> . NUM  / 49
18 : Pred -> . Pred AMPERSAND Pred  / 49
19 : Pred -> . Pred STAR Pred  / 49
20 : Pred -> . Pred ARROW Pred  / 49
21 : Pred -> . LIST Pred  / 49

LPAREN => shift 167
LIST => shift 141
NUM => shift 143
TOP => shift 144
Pred => goto 168

-----

State 168:

15 : Pred -> LPAREN Pred . RPAREN  / 47
18 : Pred -> Pred . AMPERSAND Pred  / 49
19 : Pred -> Pred . STAR Pred  / 49
20 : Pred -> Pred . ARROW Pred  / 49

RPAREN => shift 180
AMPERSAND => shift 171
ARROW => shift 170
STAR => shift 172

-----

State 169:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 42
25 : ExpAtom -> . IDENT  / 42
26 : ExpAtom -> . NUMBER  / 42
27 : ExpAtom -> . Z  / 42
28 : ExpAtom -> . LANGLE RANGLE  / 42
29 : ExpAtom -> . LANGLE PairList RANGLE  / 42
30 : ExpAtom -> . LET Edecls IN Exp END  / 42
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 42
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 42
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 42
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 42
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 42
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 42
37 : ExpApp -> . ExpAtom  / 42
38 : ExpApp -> . ExpApp ExpAtom  / 42
39 : ExpApp -> . S ExpAtom  / 42
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 42
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 42
42 : ExpApp -> . UNFOLD ExpAtom  / 42
43 : ExpPost -> . ExpApp  / 43
44 : ExpPost -> . ExpPost DOT IDENT  / 43
45 : Exp -> . ExpPost  / 14
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 14
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 14
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 14
49 : Exp -> . FIX IDENT IS Exp  / 14
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 14
54 : Edecl -> VAL IDENT COLON Pred EQUAL . Exp  / 14

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 181
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 170:

15 : Pred -> . LPAREN Pred RPAREN  / 47
16 : Pred -> . TOP  / 47
17 : Pred -> . NUM  / 47
18 : Pred -> . Pred AMPERSAND Pred  / 47
19 : Pred -> . Pred STAR Pred  / 47
20 : Pred -> . Pred ARROW Pred  / 47
20 : Pred -> Pred ARROW . Pred  / 47
21 : Pred -> . LIST Pred  / 47

LPAREN => shift 167
LIST => shift 141
NUM => shift 143
TOP => shift 144
Pred => goto 182

-----

State 171:

15 : Pred -> . LPAREN Pred RPAREN  / 47
16 : Pred -> . TOP  / 47
17 : Pred -> . NUM  / 47
18 : Pred -> . Pred AMPERSAND Pred  / 47
18 : Pred -> Pred AMPERSAND . Pred  / 47
19 : Pred -> . Pred STAR Pred  / 47
20 : Pred -> . Pred ARROW Pred  / 47
21 : Pred -> . LIST Pred  / 47

LPAREN => shift 167
LIST => shift 141
NUM => shift 143
TOP => shift 144
Pred => goto 183

-----

State 172:

15 : Pred -> . LPAREN Pred RPAREN  / 47
16 : Pred -> . TOP  / 47
17 : Pred -> . NUM  / 47
18 : Pred -> . Pred AMPERSAND Pred  / 47
19 : Pred -> . Pred STAR Pred  / 47
19 : Pred -> Pred STAR . Pred  / 47
20 : Pred -> . Pred ARROW Pred  / 47
21 : Pred -> . LIST Pred  / 47

LPAREN => shift 167
LIST => shift 141
NUM => shift 143
TOP => shift 144
Pred => goto 184

-----

State 173:

32 : ExpAtom -> ITER Exp LBRACE Exp BAR S LPAREN . IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 4

IDENT => shift 185

-----

State 174:

31 : ExpAtom -> ITER Exp LBRACE Exp BAR S IDENT . WITH IDENT DARROW Exp RBRACE  / 4

WITH => shift 186

-----

State 175:

50 : Exp -> FOLD LBRACKET IDENT DOT Tp RBRACKET Exp .  / 7

$ => reduce 50
RANGLE => reduce 50
LBRACE => reduce 50
RBRACE => reduce 50
RPAREN => reduce 50
BAR => reduce 50
COMMA => reduce 50
END => reduce 50
IN => reduce 50
VAL => reduce 50

-----

State 176:

46 : Exp -> FN LPAREN IDENT COLON Tp RPAREN Exp .  / 7

$ => reduce 46
RANGLE => reduce 46
LBRACE => reduce 46
RBRACE => reduce 46
RPAREN => reduce 46
BAR => reduce 46
COMMA => reduce 46
END => reduce 46
IN => reduce 46
VAL => reduce 46

-----

State 177:

55 : CaseRule -> IDENT Pat DARROW Exp .  / 27

RBRACE => reduce 55
BAR => reduce 55

-----

State 178:

36 : ExpAtom -> IFZ Exp LBRACE BAR Z DARROW Exp . BAR S IDENT DARROW Exp RBRACE  / 4

BAR => shift 187

-----

State 179:

35 : ExpAtom -> IFZ Exp LBRACE Z DARROW Exp BAR . S IDENT DARROW Exp RBRACE  / 4

S => shift 188

-----

State 180:

15 : Pred -> LPAREN Pred RPAREN .  / 47

RPAREN => reduce 15
AMPERSAND => reduce 15
ARROW => reduce 15
EQUAL => reduce 15
STAR => reduce 15

-----

State 181:

54 : Edecl -> VAL IDENT COLON Pred EQUAL Exp .  / 14

IN => reduce 54
VAL => reduce 54

-----

State 182:

18 : Pred -> Pred . AMPERSAND Pred  / 47
19 : Pred -> Pred . STAR Pred  / 47
20 : Pred -> Pred . ARROW Pred  / 47
20 : Pred -> Pred ARROW Pred .  / 47

RPAREN => reduce 20
AMPERSAND => shift 171, reduce 20  PRECEDENCE
ARROW => shift 170, reduce 20  PRECEDENCE
EQUAL => reduce 20
STAR => shift 172, reduce 20  PRECEDENCE

-----

State 183:

18 : Pred -> Pred . AMPERSAND Pred  / 47
18 : Pred -> Pred AMPERSAND Pred .  / 47
19 : Pred -> Pred . STAR Pred  / 47
20 : Pred -> Pred . ARROW Pred  / 47

RPAREN => reduce 18
AMPERSAND => shift 171, reduce 18  PRECEDENCE
ARROW => reduce 18, shift 170  PRECEDENCE
EQUAL => reduce 18
STAR => reduce 18, shift 172  PRECEDENCE

-----

State 184:

18 : Pred -> Pred . AMPERSAND Pred  / 47
19 : Pred -> Pred . STAR Pred  / 47
19 : Pred -> Pred STAR Pred .  / 47
20 : Pred -> Pred . ARROW Pred  / 47

RPAREN => reduce 19
AMPERSAND => shift 171, reduce 19  PRECEDENCE
ARROW => reduce 19, shift 170  PRECEDENCE
EQUAL => reduce 19
STAR => shift 172, reduce 19  PRECEDENCE

-----

State 185:

32 : ExpAtom -> ITER Exp LBRACE Exp BAR S LPAREN IDENT . RPAREN WITH IDENT DARROW Exp RBRACE  / 4

RPAREN => shift 189

-----

State 186:

31 : ExpAtom -> ITER Exp LBRACE Exp BAR S IDENT WITH . IDENT DARROW Exp RBRACE  / 4

IDENT => shift 190

-----

State 187:

36 : ExpAtom -> IFZ Exp LBRACE BAR Z DARROW Exp BAR . S IDENT DARROW Exp RBRACE  / 4

S => shift 191

-----

State 188:

35 : ExpAtom -> IFZ Exp LBRACE Z DARROW Exp BAR S . IDENT DARROW Exp RBRACE  / 4

IDENT => shift 192

-----

State 189:

32 : ExpAtom -> ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN . WITH IDENT DARROW Exp RBRACE  / 4

WITH => shift 193

-----

State 190:

31 : ExpAtom -> ITER Exp LBRACE Exp BAR S IDENT WITH IDENT . DARROW Exp RBRACE  / 4

DARROW => shift 194

-----

State 191:

36 : ExpAtom -> IFZ Exp LBRACE BAR Z DARROW Exp BAR S . IDENT DARROW Exp RBRACE  / 4

IDENT => shift 195

-----

State 192:

35 : ExpAtom -> IFZ Exp LBRACE Z DARROW Exp BAR S IDENT . DARROW Exp RBRACE  / 4

DARROW => shift 196

-----

State 193:

32 : ExpAtom -> ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH . IDENT DARROW Exp RBRACE  / 4

IDENT => shift 197

-----

State 194:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 53
25 : ExpAtom -> . IDENT  / 53
26 : ExpAtom -> . NUMBER  / 53
27 : ExpAtom -> . Z  / 53
28 : ExpAtom -> . LANGLE RANGLE  / 53
29 : ExpAtom -> . LANGLE PairList RANGLE  / 53
30 : ExpAtom -> . LET Edecls IN Exp END  / 53
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 53
31 : ExpAtom -> ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW . Exp RBRACE  / 4
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 53
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 53
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 53
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 53
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 53
37 : ExpApp -> . ExpAtom  / 53
38 : ExpApp -> . ExpApp ExpAtom  / 53
39 : ExpApp -> . S ExpAtom  / 53
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 53
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 53
42 : ExpApp -> . UNFOLD ExpAtom  / 53
43 : ExpPost -> . ExpApp  / 54
44 : ExpPost -> . ExpPost DOT IDENT  / 54
45 : Exp -> . ExpPost  / 28
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 28
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 28
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 28
49 : Exp -> . FIX IDENT IS Exp  / 28
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 28

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 198
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 195:

36 : ExpAtom -> IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT . DARROW Exp RBRACE  / 4

DARROW => shift 199

-----

State 196:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 53
25 : ExpAtom -> . IDENT  / 53
26 : ExpAtom -> . NUMBER  / 53
27 : ExpAtom -> . Z  / 53
28 : ExpAtom -> . LANGLE RANGLE  / 53
29 : ExpAtom -> . LANGLE PairList RANGLE  / 53
30 : ExpAtom -> . LET Edecls IN Exp END  / 53
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 53
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 53
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 53
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 53
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 53
35 : ExpAtom -> IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW . Exp RBRACE  / 4
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 53
37 : ExpApp -> . ExpAtom  / 53
38 : ExpApp -> . ExpApp ExpAtom  / 53
39 : ExpApp -> . S ExpAtom  / 53
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 53
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 53
42 : ExpApp -> . UNFOLD ExpAtom  / 53
43 : ExpPost -> . ExpApp  / 54
44 : ExpPost -> . ExpPost DOT IDENT  / 54
45 : Exp -> . ExpPost  / 28
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 28
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 28
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 28
49 : Exp -> . FIX IDENT IS Exp  / 28
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 28

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 200
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 197:

32 : ExpAtom -> ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT . DARROW Exp RBRACE  / 4

DARROW => shift 201

-----

State 198:

31 : ExpAtom -> ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp . RBRACE  / 4

RBRACE => shift 202

-----

State 199:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 53
25 : ExpAtom -> . IDENT  / 53
26 : ExpAtom -> . NUMBER  / 53
27 : ExpAtom -> . Z  / 53
28 : ExpAtom -> . LANGLE RANGLE  / 53
29 : ExpAtom -> . LANGLE PairList RANGLE  / 53
30 : ExpAtom -> . LET Edecls IN Exp END  / 53
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 53
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 53
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 53
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 53
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 53
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 53
36 : ExpAtom -> IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW . Exp RBRACE  / 4
37 : ExpApp -> . ExpAtom  / 53
38 : ExpApp -> . ExpApp ExpAtom  / 53
39 : ExpApp -> . S ExpAtom  / 53
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 53
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 53
42 : ExpApp -> . UNFOLD ExpAtom  / 53
43 : ExpPost -> . ExpApp  / 54
44 : ExpPost -> . ExpPost DOT IDENT  / 54
45 : Exp -> . ExpPost  / 28
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 28
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 28
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 28
49 : Exp -> . FIX IDENT IS Exp  / 28
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 28

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 203
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 200:

35 : ExpAtom -> IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp . RBRACE  / 4

RBRACE => shift 204

-----

State 201:

24 : ExpAtom -> . LPAREN Exp RPAREN  / 53
25 : ExpAtom -> . IDENT  / 53
26 : ExpAtom -> . NUMBER  / 53
27 : ExpAtom -> . Z  / 53
28 : ExpAtom -> . LANGLE RANGLE  / 53
29 : ExpAtom -> . LANGLE PairList RANGLE  / 53
30 : ExpAtom -> . LET Edecls IN Exp END  / 53
31 : ExpAtom -> . ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE  / 53
32 : ExpAtom -> . ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE  / 53
32 : ExpAtom -> ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW . Exp RBRACE  / 4
33 : ExpAtom -> . CASE Exp LBRACE CaseRules RBRACE  / 53
34 : ExpAtom -> . CASE Exp LBRACE BAR CaseRules RBRACE  / 53
35 : ExpAtom -> . IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 53
36 : ExpAtom -> . IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE  / 53
37 : ExpApp -> . ExpAtom  / 53
38 : ExpApp -> . ExpApp ExpAtom  / 53
39 : ExpApp -> . S ExpAtom  / 53
40 : ExpApp -> . ABORT LBRACKET Tp RBRACKET ExpAtom  / 53
41 : ExpApp -> . IN Tp LBRACE IDENT RBRACE ExpAtom  / 53
42 : ExpApp -> . UNFOLD ExpAtom  / 53
43 : ExpPost -> . ExpApp  / 54
44 : ExpPost -> . ExpPost DOT IDENT  / 54
45 : Exp -> . ExpPost  / 28
46 : Exp -> . FN LPAREN IDENT COLON Tp RPAREN Exp  / 28
47 : Exp -> . FN LPAREN IDENT RPAREN Exp  / 28
48 : Exp -> . FIX IDENT COLON Tp IS Exp  / 28
49 : Exp -> . FIX IDENT IS Exp  / 28
50 : Exp -> . FOLD LBRACKET IDENT DOT Tp RBRACKET Exp  / 28

IDENT => shift 17
NUMBER => shift 16
LANGLE => shift 15
LPAREN => shift 14
ABORT => shift 13
CASE => shift 12
FIX => shift 11
FN => shift 10
FOLD => shift 9
IFZ => shift 19
IN => shift 18
LET => shift 22
S => shift 21
UNFOLD => shift 20
Z => shift 23
ITER => shift 8
Exp => goto 205
ExpAtom => goto 25
ExpApp => goto 24
ExpPost => goto 26

-----

State 202:

31 : ExpAtom -> ITER Exp LBRACE Exp BAR S IDENT WITH IDENT DARROW Exp RBRACE .  / 4

$ => reduce 31
IDENT => reduce 31
NUMBER => reduce 31
LANGLE => reduce 31
RANGLE => reduce 31
LBRACE => reduce 31
RBRACE => reduce 31
LPAREN => reduce 31
RPAREN => reduce 31
BAR => reduce 31
COMMA => reduce 31
DOT => reduce 31
CASE => reduce 31
END => reduce 31
IFZ => reduce 31
IN => reduce 31
LET => reduce 31
VAL => reduce 31
Z => reduce 31
ITER => reduce 31

-----

State 203:

36 : ExpAtom -> IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp . RBRACE  / 4

RBRACE => shift 206

-----

State 204:

35 : ExpAtom -> IFZ Exp LBRACE Z DARROW Exp BAR S IDENT DARROW Exp RBRACE .  / 4

$ => reduce 35
IDENT => reduce 35
NUMBER => reduce 35
LANGLE => reduce 35
RANGLE => reduce 35
LBRACE => reduce 35
RBRACE => reduce 35
LPAREN => reduce 35
RPAREN => reduce 35
BAR => reduce 35
COMMA => reduce 35
DOT => reduce 35
CASE => reduce 35
END => reduce 35
IFZ => reduce 35
IN => reduce 35
LET => reduce 35
VAL => reduce 35
Z => reduce 35
ITER => reduce 35

-----

State 205:

32 : ExpAtom -> ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp . RBRACE  / 4

RBRACE => shift 207

-----

State 206:

36 : ExpAtom -> IFZ Exp LBRACE BAR Z DARROW Exp BAR S IDENT DARROW Exp RBRACE .  / 4

$ => reduce 36
IDENT => reduce 36
NUMBER => reduce 36
LANGLE => reduce 36
RANGLE => reduce 36
LBRACE => reduce 36
RBRACE => reduce 36
LPAREN => reduce 36
RPAREN => reduce 36
BAR => reduce 36
COMMA => reduce 36
DOT => reduce 36
CASE => reduce 36
END => reduce 36
IFZ => reduce 36
IN => reduce 36
LET => reduce 36
VAL => reduce 36
Z => reduce 36
ITER => reduce 36

-----

State 207:

32 : ExpAtom -> ITER Exp LBRACE Exp BAR S LPAREN IDENT RPAREN WITH IDENT DARROW Exp RBRACE .  / 4

$ => reduce 32
IDENT => reduce 32
NUMBER => reduce 32
LANGLE => reduce 32
RANGLE => reduce 32
LBRACE => reduce 32
RBRACE => reduce 32
LPAREN => reduce 32
RPAREN => reduce 32
BAR => reduce 32
COMMA => reduce 32
DOT => reduce 32
CASE => reduce 32
END => reduce 32
IFZ => reduce 32
IN => reduce 32
LET => reduce 32
VAL => reduce 32
Z => reduce 32
ITER => reduce 32

-----

lookahead 0 = $ 
lookahead 1 = $ IDENT NUMBER LANGLE LPAREN DOT CASE IFZ LET Z ITER 
lookahead 2 = $ DOT 
lookahead 3 = IDENT NUMBER LANGLE LBRACE LPAREN DOT CASE IFZ LET Z ITER 
lookahead 4 = $ IDENT NUMBER LANGLE RANGLE LBRACE RBRACE LPAREN RPAREN BAR COMMA DOT CASE END IFZ IN LET VAL Z ITER 
lookahead 5 = LBRACE DOT 
lookahead 6 = LBRACE 
lookahead 7 = $ RANGLE LBRACE RBRACE RPAREN BAR COMMA END IN VAL 
lookahead 8 = IDENT NUMBER LANGLE LPAREN RPAREN DOT CASE IFZ LET Z ITER 
lookahead 9 = RPAREN DOT 
lookahead 10 = RPAREN 
lookahead 11 = RANGLE 
lookahead 12 = LBRACE ARROW 
lookahead 13 = IN 
lookahead 14 = IN VAL 
lookahead 15 = $ RANGLE LBRACE RBRACE RPAREN BAR COMMA DOT END IN VAL 
lookahead 16 = RBRACKET ARROW 
lookahead 17 = RANGLE LBRACE RBRACKET RPAREN ARROW AT COMMA DARROW EQUAL IS 
lookahead 18 = RBRACKET COMMA 
lookahead 19 = RBRACKET 
lookahead 20 = RANGLE COMMA 
lookahead 21 = RPAREN ARROW 
lookahead 22 = AT EQUAL 
lookahead 23 = IDENT NUMBER LANGLE LPAREN BAR DOT CASE IFZ LET Z ITER 
lookahead 24 = BAR DOT 
lookahead 25 = BAR 
lookahead 26 = ARROW IS 
lookahead 27 = RBRACE BAR 
lookahead 28 = RBRACE 
lookahead 29 = IDENT NUMBER LANGLE RANGLE LPAREN COMMA DOT CASE IFZ LET Z ITER 
lookahead 30 = RANGLE COMMA DOT 
lookahead 31 = RANGLE RBRACKET 
lookahead 32 = RANGLE RBRACKET COMMA 
lookahead 33 = RANGLE RPAREN AT COMMA DARROW EQUAL 
lookahead 34 = RPAREN AT 
lookahead 35 = IDENT NUMBER LANGLE LPAREN DOT CASE END IFZ LET Z ITER 
lookahead 36 = DOT END 
lookahead 37 = END 
lookahead 38 = AT DARROW 
lookahead 39 = ARROW AT EQUAL 
lookahead 40 = AMPERSAND ARROW EQUAL STAR 
lookahead 41 = RANGLE RPAREN AT COMMA DARROW 
lookahead 42 = IDENT NUMBER LANGLE LPAREN DOT CASE IFZ IN LET VAL Z ITER 
lookahead 43 = DOT IN VAL 
lookahead 44 = RANGLE RPAREN ARROW AT COMMA DARROW EQUAL 
lookahead 45 = RANGLE RBRACKET ARROW COMMA 
lookahead 46 = RANGLE AT COMMA 
lookahead 47 = RPAREN AMPERSAND ARROW EQUAL STAR 
lookahead 48 = RPAREN ARROW AT EQUAL 
lookahead 49 = RPAREN AMPERSAND ARROW STAR 
lookahead 50 = RANGLE RPAREN ARROW AT COMMA DARROW 
lookahead 51 = IDENT NUMBER LANGLE RBRACE LPAREN BAR DOT CASE IFZ LET Z ITER 
lookahead 52 = RBRACE BAR DOT 
lookahead 53 = IDENT NUMBER LANGLE RBRACE LPAREN DOT CASE IFZ LET Z ITER 
lookahead 54 = RBRACE DOT 

*)

struct
local
structure Value = struct
datatype nonterminal =
nonterminal
| string of Arg.string
| int of Arg.int
| record of Arg.record
| recordlist of Arg.recordlist
| tp of Arg.tp
| pred of Arg.pred
| pairlist of Arg.pairlist
| exp of Arg.exp
| edecls of Arg.edecls
| edecl of Arg.edecl
| caserule of Arg.caserule
| caserules of Arg.caserules
| pat of Arg.pat
| recordpat of Arg.recordpat
| patlist of Arg.patlist
| directive of Arg.directive
end
structure ParseEngine = ParseEngineFun (structure Streamable = Streamable
type terminal = Arg.terminal
type value = Value.nonterminal
val dummy = Value.nonterminal
fun read terminal =
(case terminal of
Arg.IDENT x => (1, Value.string x)
| Arg.NUMBER x => (2, Value.int x)
| Arg.STRING x => (3, Value.string x)
| Arg.LANGLE => (4, Value.nonterminal)
| Arg.RANGLE => (5, Value.nonterminal)
| Arg.LBRACE => (6, Value.nonterminal)
| Arg.RBRACE => (7, Value.nonterminal)
| Arg.LBRACKET => (8, Value.nonterminal)
| Arg.RBRACKET => (9, Value.nonterminal)
| Arg.LPAREN => (10, Value.nonterminal)
| Arg.RPAREN => (11, Value.nonterminal)
| Arg.AMPERSAND => (12, Value.nonterminal)
| Arg.ARROW => (13, Value.nonterminal)
| Arg.ASSIGN => (14, Value.nonterminal)
| Arg.AT => (15, Value.nonterminal)
| Arg.BAR => (16, Value.nonterminal)
| Arg.COLON => (17, Value.nonterminal)
| Arg.COMMA => (18, Value.nonterminal)
| Arg.DARROW => (19, Value.nonterminal)
| Arg.DOT => (20, Value.nonterminal)
| Arg.EQUAL => (21, Value.nonterminal)
| Arg.LARROW => (22, Value.nonterminal)
| Arg.PLUS => (23, Value.nonterminal)
| Arg.STAR => (24, Value.nonterminal)
| Arg.UNDERSCORE => (25, Value.nonterminal)
| Arg.ABORT => (26, Value.nonterminal)
| Arg.BND => (27, Value.nonterminal)
| Arg.CASE => (28, Value.nonterminal)
| Arg.CMD => (29, Value.nonterminal)
| Arg.DCL => (30, Value.nonterminal)
| Arg.DO => (31, Value.nonterminal)
| Arg.ELSE => (32, Value.nonterminal)
| Arg.END => (33, Value.nonterminal)
| Arg.FIX => (34, Value.nonterminal)
| Arg.FN => (35, Value.nonterminal)
| Arg.FOLD => (36, Value.nonterminal)
| Arg.IF => (37, Value.nonterminal)
| Arg.IFNIL => (38, Value.nonterminal)
| Arg.IFZ => (39, Value.nonterminal)
| Arg.IN => (40, Value.nonterminal)
| Arg.INL => (41, Value.nonterminal)
| Arg.INR => (42, Value.nonterminal)
| Arg.IS => (43, Value.nonterminal)
| Arg.L => (44, Value.nonterminal)
| Arg.LET => (45, Value.nonterminal)
| Arg.LIST => (46, Value.nonterminal)
| Arg.MATCH => (47, Value.nonterminal)
| Arg.MU => (48, Value.nonterminal)
| Arg.NAT => (49, Value.nonterminal)
| Arg.NUM => (50, Value.nonterminal)
| Arg.PROC => (51, Value.nonterminal)
| Arg.R => (52, Value.nonterminal)
| Arg.REF => (53, Value.nonterminal)
| Arg.RET => (54, Value.nonterminal)
| Arg.S => (55, Value.nonterminal)
| Arg.THEN => (56, Value.nonterminal)
| Arg.TOP => (57, Value.nonterminal)
| Arg.UNFOLD => (58, Value.nonterminal)
| Arg.UNIT => (59, Value.nonterminal)
| Arg.VAL => (60, Value.nonterminal)
| Arg.VOID => (61, Value.nonterminal)
| Arg.WHILE => (62, Value.nonterminal)
| Arg.Z => (63, Value.nonterminal)
| Arg.EVAL => (64, Value.nonterminal)
| Arg.LOAD => (65, Value.nonterminal)
| Arg.STEP => (66, Value.nonterminal)
| Arg.USE => (67, Value.nonterminal)
| Arg.ITER => (68, Value.nonterminal)
| Arg.WITH => (69, Value.nonterminal)
)
)
in
val parse = ParseEngine.parse (
ParseEngine.next7x2 "\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^E\128\^D\128\^C\128\^B\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\a\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\186\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\184\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\255\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\181\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\185\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^_\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128 \128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128!\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128#\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128'\128\^@\128\^@\128\^@\128&\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\228\127\228\127\228\128\^@\127\228\127\228\127\228\127\228\128\^@\128\^@\127\228\127\228\128\^@\128\^@\128\^@\128\^@\127\228\128\^@\127\228\128\^@\127\228\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\228\128\^@\128\^@\128\^@\128\^@\127\228\128\^@\128\^@\128\^@\128\^@\128\^@\127\228\127\228\128\^@\128\^@\128\^@\128\^@\127\228\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\228\128\^@\128\^@\127\228\128\^@\128\^@\128\^@\128\^@\127\228\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\229\127\229\127\229\128\^@\127\229\127\229\127\229\127\229\128\^@\128\^@\127\229\127\229\128\^@\128\^@\128\^@\128\^@\127\229\128\^@\127\229\128\^@\127\229\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\229\128\^@\128\^@\128\^@\128\^@\127\229\128\^@\128\^@\128\^@\128\^@\128\^@\127\229\127\229\128\^@\128\^@\128\^@\128\^@\127\229\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\229\128\^@\128\^@\127\229\128\^@\128\^@\128\^@\128\^@\127\229\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128.\128\^@\128\^@\128-\128\^@\128\^@\128\^@\128,\128\^@\128/\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128+\128*\128\^@\128\^@\128\^@\128)\128\^@\128\^@\128\^@\128\^@\128\^@\1281\128\^@\1280\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^T\128\^@\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^T\128\^@\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\1285\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\227\127\227\127\227\128\^@\127\227\127\227\127\227\127\227\128\^@\128\^@\127\227\127\227\128\^@\128\^@\128\^@\128\^@\127\227\128\^@\127\227\128\^@\127\227\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\227\128\^@\128\^@\128\^@\128\^@\127\227\128\^@\128\^@\128\^@\128\^@\128\^@\127\227\127\227\128\^@\128\^@\128\^@\128\^@\127\227\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\227\128\^@\128\^@\127\227\128\^@\128\^@\128\^@\128\^@\127\227\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\211\128\^R\128\^Q\128\^@\128\^P\127\211\127\211\127\211\128\^@\128\^@\128\^O\127\211\128\^@\128\^@\128\^@\128\^@\127\211\128\^@\127\211\128\^@\127\211\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\127\211\128\^@\128\^@\128\^@\128\^@\128\^@\128\^T\127\211\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\211\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\217\127\217\127\217\128\^@\127\217\127\217\127\217\127\217\128\^@\128\^@\127\217\127\217\128\^@\128\^@\128\^@\128\^@\127\217\128\^@\127\217\128\^@\127\217\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\217\128\^@\128\^@\128\^@\128\^@\127\217\128\^@\128\^@\128\^@\128\^@\128\^@\127\217\127\217\128\^@\128\^@\128\^@\128\^@\127\217\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\217\128\^@\128\^@\127\217\128\^@\128\^@\128\^@\128\^@\127\217\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\209\128\^@\128\^@\128\^@\128\^@\127\209\127\209\127\209\128\^@\128\^@\128\^@\127\209\128\^@\128\^@\128\^@\128\^@\127\209\128\^@\127\209\128\^@\1289\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\209\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\209\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\209\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\182\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\183\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128:\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128;\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128<\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128>\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128=\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128?\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128.\128\^@\128\^@\128-\128\^@\128\^@\128\^@\128,\128\^@\128/\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128+\128*\128\^@\128\^@\128\^@\128)\128\^@\128\^@\128\^@\128\^@\128\^@\1281\128\^@\1280\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128A\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128B\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\226\127\226\127\226\128\^@\127\226\127\226\127\226\127\226\128\^@\128\^@\127\226\127\226\128\^@\128\^@\128\^@\128\^@\127\226\128\^@\127\226\128\^@\127\226\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\226\128\^@\128\^@\128\^@\128\^@\127\226\128\^@\128\^@\128\^@\128\^@\128\^@\127\226\127\226\128\^@\128\^@\128\^@\128\^@\127\226\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\226\128\^@\128\^@\127\226\128\^@\128\^@\128\^@\128\^@\127\226\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128C\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128D\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128E\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128.\128\^@\128\^@\128-\128\^@\128\^@\128\^@\128,\128\^@\128/\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128+\128*\128\^@\128\^@\128\^@\128)\128\^@\128\^@\128\^@\128\^@\128\^@\1281\128\^@\1280\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\249\127\249\128\^@\128\^@\127\249\128\^@\127\249\128\^@\127\249\128\^@\127\249\128\^@\128\^@\127\249\127\249\128\^@\127\249\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\249\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128G\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128K\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128J\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128K\128\^@\128\^@\128\^@\128M\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\250\127\250\128\^@\128\^@\127\250\128\^@\127\250\128\^@\127\250\128\^@\127\250\128\^@\128\^@\127\250\127\250\128\^@\127\250\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\250\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128.\128\^@\128\^@\128-\128\^@\128\^@\128\^@\128,\128\^@\128/\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128+\128*\128\^@\128\^@\128\^@\128)\128\^@\128\^@\128\^@\128\^@\128\^@\1281\128\^@\1280\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\247\127\247\128\^@\128\^@\127\247\128\^@\127\247\128\^@\127\247\128\^@\127\247\128\^@\128\^@\127\247\127\247\128\^@\127\247\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\247\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\248\127\248\128\^@\128\^@\127\248\128\^@\127\248\128\^@\127\248\128\^@\127\248\128\^@\128\^@\127\248\127\248\128\^@\127\248\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\248\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\212\127\212\127\212\128\^@\127\212\127\212\127\212\127\212\128\^@\128\^@\127\212\127\212\128\^@\128\^@\128\^@\128\^@\127\212\128\^@\127\212\128\^@\127\212\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\212\128\^@\128\^@\128\^@\128\^@\127\212\128\^@\128\^@\128\^@\128\^@\128\^@\127\212\127\212\128\^@\128\^@\128\^@\128\^@\127\212\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\212\128\^@\128\^@\127\212\128\^@\128\^@\128\^@\128\^@\127\212\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\215\127\215\127\215\128\^@\127\215\127\215\127\215\127\215\128\^@\128\^@\127\215\127\215\128\^@\128\^@\128\^@\128\^@\127\215\128\^@\127\215\128\^@\127\215\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\215\128\^@\128\^@\128\^@\128\^@\127\215\128\^@\128\^@\128\^@\128\^@\128\^@\127\215\127\215\128\^@\128\^@\128\^@\128\^@\127\215\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\215\128\^@\128\^@\127\215\128\^@\128\^@\128\^@\128\^@\127\215\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128Q\128\^@\128\^@\128P\128\^@\128\^@\128\^@\128\^@\128\^@\128R\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128T\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128U\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\203\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\1285\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\216\127\216\127\216\128\^@\127\216\127\216\127\216\127\216\128\^@\128\^@\127\216\127\216\128\^@\128\^@\128\^@\128\^@\127\216\128\^@\127\216\128\^@\127\216\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\216\128\^@\128\^@\128\^@\128\^@\127\216\128\^@\128\^@\128\^@\128\^@\128\^@\127\216\127\216\128\^@\128\^@\128\^@\128\^@\127\216\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\216\128\^@\128\^@\127\216\128\^@\128\^@\128\^@\128\^@\127\216\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128Y\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128Z\128\^@\128\^@\128\^@\128\^@\128\^@\128[\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128.\128\^@\128\^@\128-\128\^@\128\^@\128\^@\128,\128\^@\128/\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128+\128*\128\^@\128\^@\128\^@\128)\128\^@\128\^@\128\^@\128\^@\128\^@\1281\128\^@\1280\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128a\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128`\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128b\128\^@\128\^@\128\^@\128E\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\230\127\230\127\230\128\^@\127\230\127\230\127\230\127\230\128\^@\128\^@\127\230\127\230\128\^@\128\^@\128\^@\128\^@\127\230\128\^@\127\230\128\^@\127\230\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\230\128\^@\128\^@\128\^@\128\^@\127\230\128\^@\128\^@\128\^@\128\^@\128\^@\127\230\127\230\128\^@\128\^@\128\^@\128\^@\127\230\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\230\128\^@\128\^@\127\230\128\^@\128\^@\128\^@\128\^@\127\230\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\225\127\225\127\225\128\^@\127\225\127\225\127\225\127\225\128\^@\128\^@\127\225\127\225\128\^@\128\^@\128\^@\128\^@\127\225\128\^@\127\225\128\^@\127\225\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\225\128\^@\128\^@\128\^@\128\^@\127\225\128\^@\128\^@\128\^@\128\^@\128\^@\127\225\127\225\128\^@\128\^@\128\^@\128\^@\127\225\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\225\128\^@\128\^@\127\225\128\^@\128\^@\128\^@\128\^@\127\225\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128d\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128.\128\^@\128\^@\128-\128\^@\128\^@\128\^@\128,\128\^@\128/\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128+\128*\128\^@\128\^@\128\^@\128)\128\^@\128\^@\128\^@\128\^@\128\^@\1281\128\^@\1280\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\240\127\240\128\^@\128\^@\127\240\128\^@\127\240\128\^@\127\240\128\^@\127\240\128\^@\128\^@\127\240\127\240\128\^@\127\240\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\240\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128f\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128g\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\253\128\^@\128\^@\128\^@\127\253\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128h\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\244\127\244\128\^@\128\^@\127\244\128\^@\127\244\128\^@\127\244\128\^@\127\244\128\^@\128\^@\127\244\127\244\128\^@\127\244\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\244\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128i\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128j\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\246\127\246\128\^@\128\^@\127\246\128\^@\127\246\128\^@\127\246\128\^@\127\246\128\^@\128\^@\127\246\127\246\128\^@\127\246\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\246\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128k\128\^@\128E\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128l\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128m\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128q\128\^@\128\^@\128\^@\128p\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\193\128\^@\128r\128\^@\128\^@\128\^@\127\193\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128s\128\^@\128\^@\128P\128\^@\128\^@\128\^@\128\^@\128\^@\128R\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128T\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128u\128\^@\128\^@\128\^@\128\^@\128\^@\128v\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128w\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\202\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\210\128\^@\128\^@\128\^@\128\^@\127\210\127\210\127\210\128\^@\128\^@\128\^@\127\210\128\^@\128\^@\128\^@\128\^@\127\210\128\^@\127\210\128\^@\127\210\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\210\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\210\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\210\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128y\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128.\128\^@\128\^@\128-\128\^@\128\^@\128\^@\128,\128\^@\128/\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128+\128*\128\^@\128\^@\128\^@\128)\128\^@\128\^@\128\^@\128\^@\128\^@\1281\128\^@\1280\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128.\128\^@\128\^@\128-\128\^@\128\^@\128\^@\128,\128\^@\128/\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128+\128*\128\^@\128\^@\128\^@\128)\128\^@\128\^@\128\^@\128\^@\128\^@\1281\128\^@\1280\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\205\128\^@\128\^@\128\^@\128\^@\127\205\127\205\127\205\128\^@\128\^@\128\^@\127\205\128\^@\128\^@\128\^@\128\^@\127\205\128\^@\127\205\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\205\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\205\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\205\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128E\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128}\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\198\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128~\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\127\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128a\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128s\128\^@\128\^@\128P\128\^@\128\^@\128\^@\128\^@\128\^@\128R\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128T\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^T\128\^@\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\232\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\131\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\132\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\242\127\242\128\^@\128\^@\127\242\128\^@\127\242\128\^@\128E\128\^@\127\242\128\^@\128\^@\127\242\127\242\128\^@\127\242\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\242\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128.\128\^@\128\^@\128-\128\^@\128\^@\128\^@\128,\128\^@\128/\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128+\128*\128\^@\128\^@\128\^@\128)\128\^@\128\^@\128\^@\128\^@\128\^@\1281\128\^@\1280\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\243\127\243\128\^@\128\^@\127\243\128\^@\127\243\128\^@\127\243\128\^@\127\243\128\^@\128\^@\127\243\127\243\128\^@\127\243\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\243\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128K\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\135\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\245\127\245\128\^@\128\^@\127\245\128\^@\127\245\128\^@\127\245\128\^@\127\245\128\^@\128\^@\127\245\127\245\128\^@\127\245\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\245\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\251\127\251\128\^@\128\^@\127\251\128\^@\127\251\128\^@\127\251\128\^@\127\251\128\^@\128\^@\127\251\127\251\128\^@\127\251\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\251\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\136\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\137\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\188\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\138\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\139\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\191\128\^@\128\^@\128\^@\128\^@\128\^@\127\191\128\^@\128\^@\128\^@\127\191\128\^@\128\^@\127\191\127\191\128\^@\127\191\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\140\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128.\128\^@\128\^@\128-\128\^@\128\^@\128\^@\128,\128\^@\128\143\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\142\128\^@\128+\128*\128\144\128\^@\128\^@\128)\128\^@\128\^@\128\^@\128\145\128\^@\1281\128\^@\1280\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\193\128\^@\128\^@\128\^@\128\^@\128\^@\127\193\128\^@\128\^@\128\^@\127\193\128\^@\128\147\127\193\127\193\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\148\128\^@\128\^@\128\^@\128u\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\149\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128.\128\^@\128\^@\128-\128\^@\128\^@\128\^@\128,\128\^@\128/\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128+\128*\128\^@\128\^@\128\^@\128)\128\^@\128\^@\128\^@\128\^@\128\^@\1281\128\^@\1280\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\152\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\153\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\154\128\^@\128\^@\128\^@\128E\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\207\128\^@\128\^@\128\^@\128\^@\127\207\127\207\127\207\128\^@\128\^@\128\^@\127\207\128\^@\128\^@\128\^@\128\^@\127\207\128\^@\127\207\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\207\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\207\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\207\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\155\128\^@\128E\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128a\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\221\127\221\127\221\128\^@\127\221\127\221\127\221\127\221\128\^@\128\^@\127\221\127\221\128\^@\128\^@\128\^@\128\^@\127\221\128\^@\127\221\128\^@\127\221\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\221\128\^@\128\^@\128\^@\128\^@\127\221\128\^@\128\^@\128\^@\128\^@\128\^@\127\221\127\221\128\^@\128\^@\128\^@\128\^@\127\221\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\221\128\^@\128\^@\127\221\128\^@\128\^@\128\^@\128\^@\127\221\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\158\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128u\128\^@\128\^@\128\^@\128\159\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\214\127\214\127\214\128\^@\127\214\127\214\127\214\127\214\128\^@\128\^@\127\214\127\214\128\^@\128\^@\128\^@\128\^@\127\214\128\^@\127\214\128\^@\127\214\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\214\128\^@\128\^@\128\^@\128\^@\127\214\128\^@\128\^@\128\^@\128\^@\128\^@\127\214\127\214\128\^@\128\^@\128\^@\128\^@\127\214\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\214\128\^@\128\^@\127\214\128\^@\128\^@\128\^@\128\^@\127\214\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128'\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^T\128\^@\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\241\127\241\128\^@\128\^@\127\241\128\^@\127\241\128\^@\128E\128\^@\127\241\128\^@\128\^@\127\241\127\241\128\^@\127\241\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\241\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\252\128\^@\128\^@\128\^@\127\252\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128.\128\^@\128\^@\128-\128\^@\128\^@\128\^@\128,\128\^@\128/\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128+\128*\128\^@\128\^@\128\^@\128)\128\^@\128\^@\128\^@\128\^@\128\^@\1281\128\^@\1280\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\163\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128q\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\190\128\^@\128\^@\128\^@\128\^@\128\^@\127\190\128\^@\128\^@\128\^@\127\190\128\^@\128\^@\127\190\127\190\128\^@\127\190\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128s\128\^@\128\^@\128P\128\^@\128\^@\128\^@\128\^@\128\^@\128R\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128T\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\194\128\^@\128\^@\128\^@\128\^@\128\^@\127\194\128\^@\128E\128\^@\127\194\128\^@\128\^@\127\194\127\194\128\^@\127\194\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\168\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\142\128\^@\128\^@\128\^@\128\144\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\145\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128.\128\^@\128\^@\128-\128\^@\128\^@\128\^@\128,\128\^@\128\143\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\142\128\^@\128+\128*\128\144\128\^@\128\^@\128)\128\^@\128\^@\128\^@\128\145\128\^@\1281\128\^@\1280\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\237\127\237\127\237\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\237\128\^@\128\^@\127\237\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\238\127\238\127\238\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\238\128\^@\128\^@\127\238\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\172\128\171\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\170\128\^@\128\^@\128\173\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128.\128\^@\128\^@\128-\128\^@\128\^@\128\^@\128,\128\^@\128/\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128+\128*\128\^@\128\^@\128\^@\128)\128\^@\128\^@\128\^@\128\^@\128\^@\1281\128\^@\1280\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\196\128\^@\128\^@\128\^@\128\^@\128\^@\127\196\128\^@\128\^@\128\^@\127\196\128\^@\128\^@\127\196\127\196\128\^@\127\196\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\192\128\^@\128\^@\128\^@\128\^@\128\^@\127\192\128\^@\128\^@\128\^@\127\192\128\^@\128\^@\127\192\127\192\128\^@\127\192\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\201\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\201\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\195\128\^@\128\^@\128\^@\128\^@\128\^@\127\195\128\^@\128E\128\^@\127\195\128\^@\128\^@\127\195\127\195\128\^@\127\195\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\224\127\224\127\224\128\^@\127\224\127\224\127\224\127\224\128\^@\128\^@\127\224\127\224\128\^@\128\^@\128\^@\128\^@\127\224\128\^@\127\224\128\^@\127\224\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\224\128\^@\128\^@\128\^@\128\^@\127\224\128\^@\128\^@\128\^@\128\^@\128\^@\127\224\127\224\128\^@\128\^@\128\^@\128\^@\127\224\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\224\128\^@\128\^@\127\224\128\^@\128\^@\128\^@\128\^@\127\224\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\175\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\174\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\206\128\^@\128\^@\128\^@\128\^@\127\206\127\206\127\206\128\^@\128\^@\128\^@\127\206\128\^@\128\^@\128\^@\128\^@\127\206\128\^@\127\206\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\206\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\206\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\206\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\197\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\220\127\220\127\220\128\^@\127\220\127\220\127\220\127\220\128\^@\128\^@\127\220\127\220\128\^@\128\^@\128\^@\128\^@\127\220\128\^@\127\220\128\^@\127\220\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\220\128\^@\128\^@\128\^@\128\^@\127\220\128\^@\128\^@\128\^@\128\^@\128\^@\127\220\127\220\128\^@\128\^@\128\^@\128\^@\127\220\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\220\128\^@\128\^@\127\220\128\^@\128\^@\128\^@\128\^@\127\220\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\231\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\213\127\213\127\213\128\^@\127\213\127\213\127\213\127\213\128\^@\128\^@\127\213\127\213\128\^@\128\^@\128\^@\128\^@\127\213\128\^@\127\213\128\^@\127\213\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\213\128\^@\128\^@\128\^@\128\^@\127\213\128\^@\128\^@\128\^@\128\^@\128\^@\127\213\127\213\128\^@\128\^@\128\^@\128\^@\127\213\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\213\128\^@\128\^@\127\213\128\^@\128\^@\128\^@\128\^@\127\213\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\254\128\^@\128\^@\128\^@\127\254\128\^@\128\^@\128\^@\128E\128\^@\128\^@\128\^@\128\^@\127\254\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\180\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\187\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\189\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128u\128\^@\128\^@\127\189\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\233\127\233\127\233\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\233\128\^@\128\^@\127\233\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\168\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\142\128\^@\128\^@\128\^@\128\144\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\145\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\181\128\172\128\171\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\173\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\168\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\142\128\^@\128\^@\128\^@\128\144\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\145\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\168\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\142\128\^@\128\^@\128\^@\128\144\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\145\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\168\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\142\128\^@\128\^@\128\^@\128\144\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\145\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\186\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\187\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\204\128\^@\128\^@\128\^@\128\^@\127\204\127\204\127\204\128\^@\128\^@\128\^@\127\204\128\^@\128\^@\128\^@\128\^@\127\204\128\^@\127\204\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\204\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\204\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\204\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\208\128\^@\128\^@\128\^@\128\^@\127\208\127\208\127\208\128\^@\128\^@\128\^@\127\208\128\^@\128\^@\128\^@\128\^@\127\208\128\^@\127\208\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\208\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\208\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\208\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\199\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\199\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\188\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\189\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\239\127\239\127\239\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\239\128\^@\128\^@\127\239\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\200\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\200\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\234\128\172\128\171\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\234\128\^@\128\^@\128\173\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\236\128\172\127\236\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\236\128\^@\128\^@\127\236\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\235\128\172\127\235\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\235\128\^@\128\^@\128\173\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\190\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\191\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\192\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\193\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\194\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\195\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\196\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\197\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\198\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\200\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\202\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\203\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\205\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^R\128\^Q\128\^@\128\^P\128\^@\128\^@\128\^@\128\^@\128\^@\128\^O\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^N\128\^@\128\r\128\^@\128\^@\128\^@\128\^@\128\^@\128\f\128\v\128\n\128\^@\128\^@\128\^T\128\^S\128\^@\128\^@\128\^@\128\^@\128\^W\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^V\128\^@\128\^@\128\^U\128\^@\128\^@\128\^@\128\^@\128\^X\128\^@\128\^@\128\^@\128\^@\128\t\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\223\127\223\127\223\128\^@\127\223\127\223\127\223\127\223\128\^@\128\^@\127\223\127\223\128\^@\128\^@\128\^@\128\^@\127\223\128\^@\127\223\128\^@\127\223\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\223\128\^@\128\^@\128\^@\128\^@\127\223\128\^@\128\^@\128\^@\128\^@\128\^@\127\223\127\223\128\^@\128\^@\128\^@\128\^@\127\223\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\223\128\^@\128\^@\127\223\128\^@\128\^@\128\^@\128\^@\127\223\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\207\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\219\127\219\127\219\128\^@\127\219\127\219\127\219\127\219\128\^@\128\^@\127\219\127\219\128\^@\128\^@\128\^@\128\^@\127\219\128\^@\127\219\128\^@\127\219\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\219\128\^@\128\^@\128\^@\128\^@\127\219\128\^@\128\^@\128\^@\128\^@\128\^@\127\219\127\219\128\^@\128\^@\128\^@\128\^@\127\219\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\219\128\^@\128\^@\127\219\128\^@\128\^@\128\^@\128\^@\127\219\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\208\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\218\127\218\127\218\128\^@\127\218\127\218\127\218\127\218\128\^@\128\^@\127\218\127\218\128\^@\128\^@\128\^@\128\^@\127\218\128\^@\127\218\128\^@\127\218\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\218\128\^@\128\^@\128\^@\128\^@\127\218\128\^@\128\^@\128\^@\128\^@\128\^@\127\218\127\218\128\^@\128\^@\128\^@\128\^@\127\218\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\218\128\^@\128\^@\127\218\128\^@\128\^@\128\^@\128\^@\127\218\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\222\127\222\127\222\128\^@\127\222\127\222\127\222\127\222\128\^@\128\^@\127\222\127\222\128\^@\128\^@\128\^@\128\^@\127\222\128\^@\127\222\128\^@\127\222\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\222\128\^@\128\^@\128\^@\128\^@\127\222\128\^@\128\^@\128\^@\128\^@\128\^@\127\222\127\222\128\^@\128\^@\128\^@\128\^@\127\222\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\127\222\128\^@\128\^@\127\222\128\^@\128\^@\128\^@\128\^@\127\222\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@",
ParseEngine.next7x2 "\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^E\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\a\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^[\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^\\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^]\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128!\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128#\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128$\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128'\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\1281\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\1282\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\1283\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\1285\128\^@\128\^@\128\^@\1286\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\1287\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128?\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128E\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128H\128\^@\128G\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128H\128\^@\128K\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128M\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128R\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128U\128\^@\128\^@\128\^@\1286\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128W\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128[\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\\\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128^\128\^@\128\^@\128\^@\128\^@\128]\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128b\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128d\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128n\128m\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128s\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128w\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128y\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128z\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128{\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\127\128\^@\128\^@\128\^@\128\^@\128]\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\128\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\129\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\132\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128H\128\^@\128\133\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\140\128\^@\128\145\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\149\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\150\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\155\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\156\128\^@\128\^@\128\^@\128\^@\128]\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\159\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\160\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\161\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\163\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\164\128m\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\165\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\166\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128M\128\^@\128\168\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\140\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\175\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\176\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\177\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\178\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\168\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\181\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\182\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\183\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\184\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\198\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\200\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\203\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\205\128\^Y\128\^@\128\^@\128\^X\128\^Z\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@\128\^@",
Vector.fromList [(0,4,(fn Value.tp(arg0)::_::_::Value.string(arg1)::rest => Value.record(Arg.record_only {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(2,1,(fn Value.record(arg0)::rest => Value.recordlist(Arg.record_one arg0)::rest|_=>raise (Fail "bad parser"))),
(2,3,(fn Value.recordlist(arg0)::_::Value.record(arg1)::rest => Value.recordlist(Arg.record_cons {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,3,(fn _::Value.tp(arg0)::_::rest => Value.tp(Arg.tp_id arg0)::rest|_=>raise (Fail "bad parser"))),
(1,1,(fn _::rest => Value.tp(Arg.tp_ident {})::rest|_=>raise (Fail "bad parser"))),
(1,1,(fn _::rest => Value.tp(Arg.tp_nat {})::rest|_=>raise (Fail "bad parser"))),
(1,1,(fn _::rest => Value.tp(Arg.tp_unit {})::rest|_=>raise (Fail "bad parser"))),
(1,1,(fn _::rest => Value.tp(Arg.tp_void {})::rest|_=>raise (Fail "bad parser"))),
(1,2,(fn _::_::rest => Value.tp(Arg.tp_record_emp {})::rest|_=>raise (Fail "bad parser"))),
(1,3,(fn _::Value.recordlist(arg0)::_::rest => Value.tp(Arg.tp_record arg0)::rest|_=>raise (Fail "bad parser"))),
(1,2,(fn _::_::rest => Value.tp(Arg.tp_plus_emp {})::rest|_=>raise (Fail "bad parser"))),
(1,3,(fn _::Value.recordlist(arg0)::_::rest => Value.tp(Arg.tp_plus arg0)::rest|_=>raise (Fail "bad parser"))),
(1,3,(fn Value.tp(arg0)::_::Value.tp(arg1)::rest => Value.tp(Arg.tp_arrow {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,4,(fn Value.tp(arg0)::_::Value.string(arg1)::_::rest => Value.tp(Arg.tp_mu {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,2,(fn Value.tp(arg0)::_::rest => Value.tp(Arg.tp_ref arg0)::rest|_=>raise (Fail "bad parser"))),
(3,3,(fn _::Value.pred(arg0)::_::rest => Value.pred(Arg.pred_id arg0)::rest|_=>raise (Fail "bad parser"))),
(3,1,(fn _::rest => Value.pred(Arg.pred_top {})::rest|_=>raise (Fail "bad parser"))),
(3,1,(fn _::rest => Value.pred(Arg.pred_num {})::rest|_=>raise (Fail "bad parser"))),
(3,3,(fn Value.pred(arg0)::_::Value.pred(arg1)::rest => Value.pred(Arg.pred_and {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(3,3,(fn Value.pred(arg0)::_::Value.pred(arg1)::rest => Value.pred(Arg.pred_times {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(3,3,(fn Value.pred(arg0)::_::Value.pred(arg1)::rest => Value.pred(Arg.pred_arrow {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(3,2,(fn Value.pred(arg0)::_::rest => Value.pred(Arg.pred_list arg0)::rest|_=>raise (Fail "bad parser"))),
(4,3,(fn Value.exp(arg0)::_::Value.string(arg1)::rest => Value.pairlist(Arg.pair_one {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(4,5,(fn Value.pairlist(arg0)::_::Value.exp(arg1)::_::Value.string(arg2)::rest => Value.pairlist(Arg.pair_cons {3=arg0,2=arg1,1=arg2})::rest|_=>raise (Fail "bad parser"))),
(6,3,(fn _::Value.exp(arg0)::_::rest => Value.exp(Arg.exp_id arg0)::rest|_=>raise (Fail "bad parser"))),
(6,1,(fn Value.string(arg0)::rest => Value.exp(Arg.exp_ident arg0)::rest|_=>raise (Fail "bad parser"))),
(6,1,(fn Value.int(arg0)::rest => Value.exp(Arg.exp_number arg0)::rest|_=>raise (Fail "bad parser"))),
(6,1,(fn _::rest => Value.exp(Arg.exp_z {})::rest|_=>raise (Fail "bad parser"))),
(6,2,(fn _::_::rest => Value.exp(Arg.exp_unit {})::rest|_=>raise (Fail "bad parser"))),
(6,3,(fn _::Value.pairlist(arg0)::_::rest => Value.exp(Arg.exp_pair arg0)::rest|_=>raise (Fail "bad parser"))),
(6,5,(fn _::Value.exp(arg0)::_::Value.edecls(arg1)::_::rest => Value.exp(Arg.exp_let {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(6,12,(fn _::Value.exp(arg0)::_::Value.string(arg1)::_::Value.string(arg2)::_::_::Value.exp(arg3)::_::Value.exp(arg4)::_::rest => Value.exp(Arg.exp_iter {5=arg0,4=arg1,3=arg2,2=arg3,1=arg4})::rest|_=>raise (Fail "bad parser"))),
(6,14,(fn _::Value.exp(arg0)::_::Value.string(arg1)::_::_::Value.string(arg2)::_::_::_::Value.exp(arg3)::_::Value.exp(arg4)::_::rest => Value.exp(Arg.exp_iter {5=arg0,4=arg1,3=arg2,2=arg3,1=arg4})::rest|_=>raise (Fail "bad parser"))),
(6,5,(fn _::Value.caserules(arg0)::_::Value.exp(arg1)::_::rest => Value.exp(Arg.exp_case {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(6,6,(fn _::Value.caserules(arg0)::_::_::Value.exp(arg1)::_::rest => Value.exp(Arg.exp_case {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(6,12,(fn _::Value.exp(arg0)::_::Value.string(arg1)::_::_::Value.exp(arg2)::_::_::_::Value.exp(arg3)::_::rest => Value.exp(Arg.exp_ifz {4=arg0,3=arg1,2=arg2,1=arg3})::rest|_=>raise (Fail "bad parser"))),
(6,13,(fn _::Value.exp(arg0)::_::Value.string(arg1)::_::_::Value.exp(arg2)::_::_::_::_::Value.exp(arg3)::_::rest => Value.exp(Arg.exp_ifz {4=arg0,3=arg1,2=arg2,1=arg3})::rest|_=>raise (Fail "bad parser"))),
(9,1,(fn Value.exp(arg0)::rest => Value.exp(Arg.exp_id arg0)::rest|_=>raise (Fail "bad parser"))),
(9,2,(fn Value.exp(arg0)::Value.exp(arg1)::rest => Value.exp(Arg.exp_app {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(9,2,(fn Value.exp(arg0)::_::rest => Value.exp(Arg.exp_s arg0)::rest|_=>raise (Fail "bad parser"))),
(9,5,(fn Value.exp(arg0)::_::Value.tp(arg1)::_::_::rest => Value.exp(Arg.exp_abort {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(9,6,(fn Value.exp(arg0)::_::Value.string(arg1)::_::Value.tp(arg2)::_::rest => Value.exp(Arg.exp_in {3=arg0,2=arg1,1=arg2})::rest|_=>raise (Fail "bad parser"))),
(9,2,(fn Value.exp(arg0)::_::rest => Value.exp(Arg.exp_unfold arg0)::rest|_=>raise (Fail "bad parser"))),
(10,1,(fn Value.exp(arg0)::rest => Value.exp(Arg.exp_id arg0)::rest|_=>raise (Fail "bad parser"))),
(10,3,(fn Value.string(arg0)::_::Value.exp(arg1)::rest => Value.exp(Arg.exp_out {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(5,1,(fn Value.exp(arg0)::rest => Value.exp(Arg.exp_id arg0)::rest|_=>raise (Fail "bad parser"))),
(5,7,(fn Value.exp(arg0)::_::Value.tp(arg1)::_::Value.string(arg2)::_::_::rest => Value.exp(Arg.exp_fn {3=arg0,2=arg1,1=arg2})::rest|_=>raise (Fail "bad parser"))),
(5,5,(fn Value.exp(arg0)::_::Value.string(arg1)::_::_::rest => Value.exp(Arg.exp_fn_inf {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(5,6,(fn Value.exp(arg0)::_::Value.tp(arg1)::_::Value.string(arg2)::_::rest => Value.exp(Arg.exp_fix {3=arg0,2=arg1,1=arg2})::rest|_=>raise (Fail "bad parser"))),
(5,4,(fn Value.exp(arg0)::_::Value.string(arg1)::_::rest => Value.exp(Arg.exp_fix_inf {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(5,7,(fn Value.exp(arg0)::_::Value.tp(arg1)::_::Value.string(arg2)::_::_::rest => Value.exp(Arg.exp_fold {3=arg0,2=arg1,1=arg2})::rest|_=>raise (Fail "bad parser"))),
(7,1,(fn Value.edecl(arg0)::rest => Value.edecls(Arg.edecls_one arg0)::rest|_=>raise (Fail "bad parser"))),
(7,2,(fn Value.edecls(arg0)::Value.edecl(arg1)::rest => Value.edecls(Arg.edecls_cons {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(11,4,(fn Value.exp(arg0)::_::Value.pat(arg1)::_::rest => Value.edecl(Arg.edecl_val {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(11,6,(fn Value.exp(arg0)::_::Value.pred(arg1)::_::Value.string(arg2)::_::rest => Value.edecl(Arg.edecl_val_pred {3=arg0,2=arg1,1=arg2})::rest|_=>raise (Fail "bad parser"))),
(13,4,(fn Value.exp(arg0)::_::Value.pat(arg1)::Value.string(arg2)::rest => Value.caserule(Arg.case_only {3=arg0,2=arg1,1=arg2})::rest|_=>raise (Fail "bad parser"))),
(8,1,(fn Value.caserule(arg0)::rest => Value.caserules(Arg.case_one arg0)::rest|_=>raise (Fail "bad parser"))),
(8,3,(fn Value.caserules(arg0)::_::Value.caserule(arg1)::rest => Value.caserules(Arg.case_cons {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(12,3,(fn _::Value.pat(arg0)::_::rest => Value.pat(Arg.pat_id arg0)::rest|_=>raise (Fail "bad parser"))),
(12,3,(fn Value.tp(arg0)::_::_::rest => Value.pat(Arg.pat_wild arg0)::rest|_=>raise (Fail "bad parser"))),
(12,3,(fn Value.tp(arg0)::_::Value.string(arg1)::rest => Value.pat(Arg.pat_ident {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(12,1,(fn Value.string(arg0)::rest => Value.pat(Arg.pat_ident_notp arg0)::rest|_=>raise (Fail "bad parser"))),
(12,3,(fn Value.string(arg0)::_::Value.pat(arg1)::rest => Value.pat(Arg.pat_alias {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(12,2,(fn _::_::rest => Value.pat(Arg.pat_unit {})::rest|_=>raise (Fail "bad parser"))),
(12,3,(fn _::Value.patlist(arg0)::_::rest => Value.pat(Arg.pat_pair arg0)::rest|_=>raise (Fail "bad parser"))),
(15,3,(fn Value.pat(arg0)::_::Value.string(arg1)::rest => Value.recordpat(Arg.recordpat_only {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(14,1,(fn Value.recordpat(arg0)::rest => Value.patlist(Arg.patlist_one arg0)::rest|_=>raise (Fail "bad parser"))),
(14,3,(fn Value.patlist(arg0)::_::Value.recordpat(arg1)::rest => Value.patlist(Arg.patlist_cons {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(16,1,(fn _::rest => Value.directive(Arg.directive_step0 {})::rest|_=>raise (Fail "bad parser"))),
(16,2,(fn Value.exp(arg0)::_::rest => Value.directive(Arg.directive_step arg0)::rest|_=>raise (Fail "bad parser"))),
(16,1,(fn _::rest => Value.directive(Arg.directive_eval0 {})::rest|_=>raise (Fail "bad parser"))),
(16,2,(fn Value.exp(arg0)::_::rest => Value.directive(Arg.directive_eval arg0)::rest|_=>raise (Fail "bad parser"))),
(16,2,(fn Value.exp(arg0)::_::rest => Value.directive(Arg.directive_load arg0)::rest|_=>raise (Fail "bad parser"))),
(16,2,(fn Value.string(arg0)::_::rest => Value.directive(Arg.directive_use arg0)::rest|_=>raise (Fail "bad parser")))],
(fn Value.directive x => x | _ => raise (Fail "bad parser")), Arg.error)
end
end
