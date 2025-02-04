PROJECT_PATH := srcs

all: build up ps

build:
	mkdir /home/eaubry/data
	mkdir /home/eaubry/data/mariadb
	mkdir /home/eaubry/data/wordpress
	cd $(PROJECT_PATH) && docker compose build

up:
	cd $(PROJECT_PATH) && docker compose up -d

ps:
	cd $(PROJECT_PATH) && docker compose ps

logs:
	cd $(PROJECT_PATH) && docker compose logs nginx && docker compose logs wordpress && docker compose logs mariadb

down:
	cd $(PROJECT_PATH) && docker compose down

clean:
	@sudo chmod -R 777 /home/eaubry/data
	@rm -rf /home/eaubry/data
	cd $(PROJECT_PATH) && docker compose down -v

prune:
	docker system prune -f

.PHONY: all build up ps logs down clean prune