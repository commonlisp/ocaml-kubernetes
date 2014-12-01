
type id = string
type metadata = (string, string) Hashtbl.t 

type port = { containerPort: int; hostPort: int }
type container = { name: string; image: string; ports: port list }

type manifest = { id: string; containers: container list }

type desiredState = { manifest: manifest }

type pod = { kind: string; id: string; desiredState: desiredState }

type resourceTy = 
    | Pod of pod
    | ReplicationController 
    | Service 

type resource = Resource of id * metadata * resourceTy

