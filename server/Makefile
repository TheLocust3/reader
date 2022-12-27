install:
	export C_INCLUDE_PATH=`ocamlc -where`:$C_INCLUDE_PATH
	export PKG_CONFIG_PATH=/usr/local/opt/zlib/lib/pkgconfig:/usr/local/opt/openssl/lib/pkgconfig
	export LDFLAGS="-L/usr/local/opt/libpq/lib"
	export CPPFLAGS="-I/usr/local/opt/libpq/include"
	opam pin add -yn reader .
	opam install --deps-only reader

build:
	dune build

puller: build
	export `cat ../database.env` && dune exec job puller

feed-pruner: build
	export `cat ../database.env` && dune exec job feed-pruner

item-pruner: build
	export `cat ../database.env` && dune exec job item-pruner

start: build
	export `cat ../database.env` && dune exec reader

rollback: build
	export `cat ../database.env` && dune exec database rollback

migrate: build
	export `cat ../database.env` && dune exec database migrate

clean:
	rm -rf _build
