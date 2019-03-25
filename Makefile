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
	./mvnw clean package
release:
	echo "release to production"
dcclean:
	docker rm $$(docker ps -aq)
diclean:
	docker rmi
jenkins:
	docker-compose up -d jenkins
envup:
	docker-compose up
envdown:
	docker-compose down	
