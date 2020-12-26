
all:
	go build

run_test1:
	go build
	./mtp --cache-burst-override 116 ./www-src/index.html
	diff www/index.html ref

run_test2:
	go build
	./mtp --watch ./www-src/index.html
	diff www/index.html ref
