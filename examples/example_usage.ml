open Core.Std
open Async.Std

module Server = struct
  module Server = Cohttp_async.Server

  type status =
    Started

  let resp_body = "foo"

  let start ~port ~status_channel =
    Server.create
      ~on_handler_error:`Raise
      (Tcp.on_port port)
      (fun ~body:_ _sock _req -> Server.respond_with_string resp_body)
    >>= fun _ ->
    Pipe.write status_channel Started >>= fun () ->
    Deferred.never ()
end

let main port =
  let r, w = Pipe.create () in
  don't_wait_for (Server.start ~port ~status_channel:w);
  Pipe.read r >>= function
  | `Eof -> assert false
  | `Ok Server.Started ->
      Pipe.close w;
      let req =
        { Ez_http_request
        . uri     = sprintf "http://localhost:%d/" port
        ; method' = `GET
        ; headers = []
        ; body    = ""
        }
      in
      Ez_http_client.exec req >>= fun resp ->
      let
        { Ez_http_response
        . status
        ; headers = _
        ; body
        } = resp
      in
      assert (status = 200);
      assert (body = Server.resp_body);
      eprintf "Everything is awesome!\n%!";
      return ()

let () =
  Command.async_basic
    ~summary:""
    Command.Spec.(empty
      +> flag "-p" (optional_with_default 8080 int) ~doc:"port HTTP server port."
    )
    (fun port () -> main port)
  |> Command.run
