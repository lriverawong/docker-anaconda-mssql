# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help up down up-db exec-anaconda

help: ## make help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

up: ## Start the containers
	docker-compose up --build -d

down: ## Stop the containers
	docker-compose down

up-db: ## Start
	docker-compose up --build -d sql-server

exec-anaconda: ## Enter anaconda container - bash
	docker exec -ti anaconda bash