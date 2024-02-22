.PHONY: build homeheim buildheim fooheim

build:
	docker build -t necess:latest --platform linux/amd64 .

compose:
	docker-compose up --detach --build --force-recreate $(env) 

homeheim: env:=homeheim
homeheim: compose

buildheim: env:=buildheim
buildheim: compose

fooheim: env:=fooheim
fooheim: compose