open Core.Std
open Async.Std

val exec : Ez_http_request.t -> Ez_http_response.t Deferred.t
