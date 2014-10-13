open Core.Std
open Async.Std

type t =
  { status  : int
  ; headers : (string * string) list
  ; body    : string
  }

val of_cohttp
  :  resp:Cohttp_async.Response.t
  -> body:Cohttp_async.Body.t
  -> t Deferred.t

val to_string : t -> string
(** [to_string] is for cosmetic purposes only, not a valid HTTP response. *)
