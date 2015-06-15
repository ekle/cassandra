IMG=cassandra

start: build run
	echo starting

build:
	docker build -t=$(IMG) . 

run:
	docker run --rm --name cassandra_main -i -p 9042:9042 -t $(IMG) 

cqlsh:
cql:
	docker run -it --rm --link cassandra_main:cass cassandra cqlsh cass

stop:
	docker kill cassandra_main
