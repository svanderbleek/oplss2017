
structure Token =
   struct

      datatype token =
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
       | ITER
       | WITH

       | EVAL
       | LOAD
       | STEP
       | USE

   end
