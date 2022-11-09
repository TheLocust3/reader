install:
	export C_INCLUDE_PATH=`ocamlc -where`:$C_INCLUDE_PATH
	export PKG_CONFIG_PATH=/usr/local/opt/zlib/lib/pkgconfig:/usr/local/opt/openssl/lib/pkgconfig:/usr/local/opt/sqlite3/lib/pkgconfig
	export SQLITE3_OCAML_BREWCHECK=1 && opam install server/ --verbose

build:
	dune build

puller: build
	dune exec job puller

start: build
	dune exec reader

rollback: build
	dune exec database rollback

migrate: build
	dune exec database migrate

clean:
	rm -rf _build
