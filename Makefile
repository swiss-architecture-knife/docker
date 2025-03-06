all:
	WITH_DOCKER_BUILD=1 WITH_DOCKER_PUSH=1 ./build.sh $(VERSION)

build-only:
	WITH_DOCKER_BUILD=1 ./build.sh $(VERSION)

prepare:
	./build.sh $(VERSION)
