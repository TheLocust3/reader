install:
	export C_INCLUDE_PATH=`ocamlc -where`:$C_INCLUDE_PATH
	export PKG_CONFIG_PATH=/usr/local/opt/zlib/lib/pkgconfig:/usr/local/opt/openssl/lib/pkgconfig:/usr/local/opt/sqlite3/lib/pkgconfig
	export SQLITE3_OCAML_BREWCHECK=1 && opam install server/ --verbose

build-backend:
	cd server && dune build

start-puller: build-backend
	cd server && dune exec job puller

start-backend: build-backend
	cd server && dune exec reader

start:
	make start-backend

rollback: build-backend
	cd server && dune exec database rollback

migrate: build-backend
	cd server && dune exec database migrate

clean:
	rm -rf server/_build
