install:
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
