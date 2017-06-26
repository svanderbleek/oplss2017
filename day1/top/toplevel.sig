signature TOPLEVEL_IMPL =
sig
   type cmd
   type mem

   val init : unit -> mem
   val bind : Directive.directive -> cmd
   val runcmd : cmd -> mem -> mem
   val runtrans : cmd -> mem
   val toString : mem -> string
   val hdl : exn -> unit
end

signature TOPLEVEL =
sig

structure Impl : TOPLEVEL_IMPL

val evalFile : string -> Impl.mem
val runTransFile : string -> Impl.mem
val eval : string -> Impl.mem
val repl : unit -> unit

end
