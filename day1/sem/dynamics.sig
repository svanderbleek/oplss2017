signature DYNAMICS =
sig
  type term
  type d

  datatype D = Step of term | Val | Err
  val view : d -> D

  exception Malformed
  exception Abort

  val trystep : term -> d

  exception RuntimeError

  val eval : term -> term
end
