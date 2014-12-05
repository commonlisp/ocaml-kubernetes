OCAMLC = ocamlfind ocamlc
OBJECTS = kubernetes_types.mli kubernetes_types.cmi api.cmo

REQUIRES = netclient atdgen

.SUFFIXES: .cmo .cmi .cmx .ml .mli .atd

.atd.mli: 
	atdgen $<
.ml.cmo:
	$(OCAMLC) -package "$(REQUIRES)" -I . -c $<
.mli.cmi:
	$(OCAMLC) -package "$(REQUIRES)" -I . -c $<
.ml.cmx:
	$(OCAMLC) -package "$(REQUIRES)" -I . -c $<

all: $(OBJECTS)

.PHONY: clean
	rm -f *.{cmi,cmo,cmx,cma,cmxa,a}

