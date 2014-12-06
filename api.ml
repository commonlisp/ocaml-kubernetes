(* api.ml -- Kubernetes interface for OCaml *)
open Http_client.Convenience

module Api = functor(Param : sig val server_url : string end) ->
struct 
  module Pod = struct
     let resource_base = "/pods"
     let resource = resource_base ^ "/"
     let nextId = let x = ref 0 in fun () -> x := !x + 1; (string_of_int !x);;
     let pod_url = Param.server_url ^ resource

     let get_all () = 
        http_get (Param.server_url ^ resource_base)
 
     let get id = 
        Kubernetes_types.pod_of_string (http_get (pod_url ^ id))
 
     let make pod =
        http_put (pod_url ^ nextId()) (Kubernetes_types.string_of_pod pod)

     let delete id = 
        http_delete (pod_url ^ id)
  end

  module ReplicationController = struct 
  end
end

