(* api.ml -- Kubernetes interface for OCaml *)
open Http_client.Convenience

module Api = functor(Param : sig val server_url : string end) ->
struct 
  let defaultLen = 1024
  let defaultPos = 0

  module MkResource = 
     functor (X: sig 
		   type t
		   val resource_base : string
		   val string_of_resource : t -> string
		   val resource_of_string : string -> t
		 end) ->
     struct
       let resource = X.resource_base ^ "/"
       let nextId = let x = ref 0 in fun () -> (x := !x + 1; (string_of_int !x))
       let pod_url = Param.server_url ^ resource

       let get_all () = 
           http_get (Param.server_url ^ X.resource_base)
 
       let get id = 
           let url = pod_url ^ id
           in Kubernetes_types.pod_of_string (http_get url)
 
       let make pod =
           let url = pod_url ^ nextId()
           in http_put url (Kubernetes_types.string_of_pod pod)

       let delete id = 
           http_delete (pod_url ^ id)
     end

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

  module Service = 
    MkResource(struct
	         type t = Kubernetes_types.service
		 let resource_base = "services/"
		 let string_of_resource = Kubernetes_types.string_of_service ~len:defaultLen
		 let resource_of_string = Kubernetes_types.service_of_string ~pos:defaultPos
	       end)
end

