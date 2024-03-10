destroy:
	@echo "$(RED_COLOR)==> Destroying all containers...$(NO_COLOR)"
	@docker rm -f `docker ps -aq`

db-up:
	@echo "$(CYAN_COLOR)==> Starting database server...$(NO_COLOR)"
	docker-compose run --service-ports db

