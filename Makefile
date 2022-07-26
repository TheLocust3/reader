install:
	cd server && dune install
	cd ui && yarn install

build-backend:
	cd server && dune build

start-backend: build-backend
	cd server && dune exec reader
