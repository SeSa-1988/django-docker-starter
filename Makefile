shell:
	docker compose exec web sh

start:
	docker compose up

restart:
	docker compose down
	docker compose up

rebuild:
	docker compose down
	docker compose build
	docker compose up --build