open Core.Std
open Async.Std

let exec {Ez_http_request.uri; method'; headers; body} =
  let uri     = Uri.of_string uri in
  let headers = Cohttp.Header.of_list headers in
  let body    = Cohttp_async.Body.of_pipe (Pipe.of_list [body]) in
  let exec () =
    match method' with
    | `GET  -> Cohttp_async.Client.get  uri ~headers
    | `PUT  -> Cohttp_async.Client.put  uri ~headers ~body
    | `POST -> Cohttp_async.Client.post uri ~headers ~body
  in
  exec () >>= fun (resp, body) ->
  Ez_http_response.of_cohttp ~resp ~body
