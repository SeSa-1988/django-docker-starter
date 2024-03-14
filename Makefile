.PHONY: shell
shell:
	docker compose exec web sh

.PHONY: start
start:
	docker compose up

.PHONY: restart
restart:
	docker compose down
	docker compose up

.PHONY: rebuild
rebuild:
	docker compose down
	docker compose build
	docker compose up --build