OCAMLC = ocamlfind ocamlc
OBJECTS = kubernetes_types.mli kubernetes_types.cmi api.cmo

REQUIRES = netclient atdgen

.SUFFIXES: .cmo .cmi .cmx .ml .mli .atd

%.mli: %.atd
	atdgen $<
%.cmo %.cmx: %.ml
	$(OCAMLC) -package "$(REQUIRES)" -I . -c $<
%.cmi: %.mli
	$(OCAMLC) -package "$(REQUIRES)" -I . -c $<

all: $(OBJECTS)

clean:
	rm -f *.{cmi,cmo,cmx,cma,cmxa,a} kubernetes_types.{ml,mli}

