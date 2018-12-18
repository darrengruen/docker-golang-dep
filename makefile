# CircleCI Env vars
CIRCLE_PROJECT_REPONAME ?= app
CIRCLE_BRANCH           ?= "$(shell whoami)_unstable"

app        = $(shell basename "${PWD}" | sed 's|docker-||g')
branch     = $(shell git rev-parse --abbrev-ref HEAD 2> /dev/null || echo "unstable")
build_date := $(shell date -u +%FT%T.%S%Z)
commit     = $(shell git rev-parse --short HEAD 2> /dev/null || echo "unstable")
img        = ${ns}/${CIRCLE_PROJECT_REPONAME}:$(shell echo ${CIRCLE_BRANCH} | sed 's|\/|__|g')
ns         = gruen

build:
	docker build \
	  --build-arg BRANCH_NAME=${CIRCLE_BRANCH} \
	  --build-arg BUILD_DATE=${build_date} \
	  --build-arg COMMIT_SHA=${comimt} \
	  -t ${img} .
	
clean:
	docker rmi ${img}

lint:
	docker run -i --rm hadolint/hadolint:latest < Dockerfile
	
push:
	docker push ${img}

run:
	docker run -it --rm --entrypoint bash ${img}

test:
	docker run --rm \
		-v "${PWD}:/test" \
		-v /var/run/docker.sock:/var/run/docker.sock \
		--workdir /test \
		--name ${CIRCLE_PROJECT_REPONAME}_container_structure_test \
		gcr.io/gcp-runtimes/container-structure-test:latest \
			test \
			--image ${img} \
			--config /test/test.yaml

.phony: build clean lint push run test

ifndef VERBOSE
.SILENT:
endif
