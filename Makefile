all: build rm run

build:
	docker build -t ryangraham/errbit .

rm:
	docker stop errbit && docker rm errbit

run:
	docker run --name errbit -e "ERRBIT_HOST=errbit.myexample.com" -e 'MONGO_URL=mongodb://localhost/errbit_dev' -p 80:80 -d ryangraham/errbit

seed:
	docker run --name errbit -e "ERRBIT_HOST=errbit.myexample.com" -e 'MONGO_URL=mongodb://localhost/errbit_dev' --net=host -it ryangraham/errbit seed

attach:
	docker exec -it errbit bash
