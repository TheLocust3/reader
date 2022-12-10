install:
	cd server && make install
	cd ui && make install

build:
	cd server && make build

clean:
	cd server && make clean

local-publish:
	make -f build/local/Makefile publish

local-deploy:
	make -f build/local/Makefile deploy

local-teardown:
	make -f build/local/Makefile teardown
