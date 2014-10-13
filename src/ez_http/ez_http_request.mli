type headers = (string * string) list

type t =
  { uri      : string
  ; method'  : [`GET | `PUT | `POST]
  ; headers  : headers
  ; body     : string
  }
