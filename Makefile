.DEFAULT_GOAL := help
.PHONY: help setup deploy info destroy

compose_v2_not_supported = $(shell command docker compose 2> /dev/null)
ifeq (,$(compose_v2_not_supported))
  DOCKER_COMPOSE_COMMAND = docker-compose
else
  DOCKER_COMPOSE_COMMAND = docker compose
endif

help:
	@echo "Usage: make [TARGET]"
	@echo "Targets:"
	@echo "setup           Generate onion address"
	@echo "deploy          Deploy reverse proxy"
	@echo "info            Show onion address"
	@echo "destroy         Clean up"

setup:
		@docker run -it --rm -v ./web:/web ghcr.io/sudo88com/tor-reverse:latest generate tor

deploy:
		@$(DOCKER_COMPOSE_COMMAND) -f docker-compose.yml up -d

info:
		@cat web/hostname

destroy:
		@$(DOCKER_COMPOSE_COMMAND) down && rm -rf web
