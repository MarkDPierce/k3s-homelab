# Check if 'profile' is present in the command line arguments
ifdef profile
COMPOSE_CMD := docker-compose -f docker-compose.yaml --profile $(profile) up -d --remove-orphans
DOWN_CMD := docker-compose -f docker-compose.yaml --profile $(profile) down
else
COMPOSE_CMD := docker-compose -f docker-compose.yaml up -d --remove-orphans
DOWN_CMD := docker-compose -f docker-compose.yaml down
endif


# Used for game server deployment
.PHONY: buildheim
buildheim: env:=buildheim
buildheim: compose_env

.PHONY: homeheim
homeheim: env:=homeheim
homeheim: compose_env

.PHONY: hardheim
hardheim: env:=hardheim
hardheim: compose_env

.PHONY: down_homeheim
down_homeheim: env:=homeheim
down_homeheim: down_env

.PHONY: down_buildheim
down_buildheim: env:=buildheim
down_buildheim: down_env

.PHONY: down_hardheim
down_hardheim: env:=hardheim
down_hardheim: down_env


# Define the compose command
compose:
	$(COMPOSE_CMD)

compose_env:
	docker-compose --env-file ./$(env).env -f docker-compose.yaml up --detach --remove-orphans $(env)

down_env:
	docker-compose --env-file ./$(env).env -f docker-compose.yaml down --remove-orphans $(env)

down:
	$(DOWN_CMD)