all: build rm run

build:
	docker build -t ryangraham/errbit .

rm:
	docker stop errbit && docker rm errbit

run:
	docker run --name errbit -p 80:80 -d ryangraham/errbit

seed:
	docker run --name errbit --net=host -it ryangraham/errbit seed

attach:
	docker exec -it errbit bash
