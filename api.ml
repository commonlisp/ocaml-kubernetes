(* api.ml -- Kubernetes interface for OCaml *)
open Http_client.Convenience

module Api(param : sig val server_url : string end) = 
struct 
  module Pod = struct
     let resource_base "/pods"
     let resource = resource_base ^ "/"
     let nextId = let x = ref 0 in fun () -> x := !x + 1; (string_of_int x);;

     let get_all () = 
        http_get (server_url ^ resource_base)
 
     let get id = 
        http_get (server_url ^ resource ^ id)
 
     let make url pod =
        http_put (server_url ^ resource ^ nextId()) (Kubernetes_types_j.string_of_pod pod)
  end
end



