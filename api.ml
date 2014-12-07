(* api.ml -- Kubernetes interface for OCaml *)
open Http_client.Convenience

module Api = functor(Param : sig val server_url : string end) ->
struct 
  module MkResource = 
     functor (X: sig 
		   type t
		   val resource_base : string
		   val string_of_resource : t -> string
		   val resource_of_string : string -> t
		 end) ->
     struct
       let resource = X.resource_base ^ "/"
       let nextId = let x = ref 0 in fun () -> x := !x + 1; (string_of_int !x);;
       let pod_url = Param.server_url ^ resource

       let get_all () = 
          http_get (Param.server_url ^ X.resource_base)
 
       let get id = 
          Kubernetes_types.pod_of_string (http_get (pod_url ^ id))
 
       let make pod =
          http_put (pod_url ^ nextId()) (Kubernetes_types.string_of_pod pod)

       let delete id = 
          http_delete (pod_url ^ id)
     end

  let defaultLen = 1024
  let defaultPos = 0

  module Pod = MkResource(struct 
                 type t = Kubernetes_types.pod 
		 let resource_base = "pods/" 
		 let string_of_resource = Kubernetes_types.string_of_pod ~len:defaultLen
		 let resource_of_string = Kubernetes_types.pod_of_string ~pos:defaultPos
	       end)

  module ReplicationController = 
    MkResource(struct
	         type t = Kubernetes_types.replicationController
		 let resource_base = "replicationControllers/"
		 let string_of_resource = Kubernetes_types.string_of_replicationController ~len:defaultLen
		 let resource_of_string = Kubernetes_types.replicationController_of_string ~pos:defaultPos
		end)
end

