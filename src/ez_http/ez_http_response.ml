open Core.Std
open Async.Std

type t =
  { status  : int
  ; headers : (string * string) list
  ; body    : string
  }

let of_cohttp ~resp ~body =
  let
    { Cohttp_async.Response
    . encoding = _
    ; version  = _
    ; flush    = _
    ; status
    ; headers
    } = resp
  in
  Cohttp_async.Body.to_string body
  >>| fun body ->
  { status  = status  |> Cohttp.Code.code_of_status
  ; headers = headers |> Cohttp.Header.to_list
  ; body
  }

let to_string {status; headers; body} =
  let status  = Int.to_string status in
  let headers = List.map headers ~f:(fun (k, v) -> sprintf "%s: %s" k v) in
  String.concat ~sep:"\n" (status :: headers @ [" "; body])
