signature TESTHARNESS =
sig
  val runtests : bool -> unit
  val runalltests : bool -> unit
  val runfiletests : bool -> unit
end
