init:
	packer init .
	cd repo/ && terraform init
	cd cluster/ && terraform init

repository:
	cd repo && terraform apply

image:
	./build_image.sh

build:
	cd cluster && terraform apply

teardown:
	cd cluster && terraform destroy
