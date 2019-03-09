#project variables
PROJECT_NAME ?= petclinic
REPO_NAME ?= petclinic

#fileNames
#to declare key := value
#to reference $(var_name)

#docker compose project names
REL_NAME := $(PROJECT_NAME)$(BUILD_ID)

#usage: docker-compose -p $(REL_NAME) -f $(COMPOSE_FILE) up <stage>
.PHONY: test build release

test:
	echo "test"
build:
	echo "build"
	./mvnw package
release:
	echo "release"

