install:
	export SQLITE3_OCAML_BREWCHECK=1
	export C_INCLUDE_PATH=`ocamlc -where`:$C_INCLUDE_PATH
	cd server && dune install
	cd ui && yarn install

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
