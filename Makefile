SERVICE_NAME=web
DEFAULT_FILE=main.py

.PHONY: shell start down restart rebuild run pytest pytestcov tests install-deps

shell:
	docker compose exec app sh

start:
	docker compose up

down:
	docker compose down

restart:
	docker compose down
	docker compose up

rebuild:
	docker compose down
	docker compose build
	docker compose up --build

run:
	$(eval FILE ?= $(DEFAULT_FILE))
	docker compose exec $(SERVICE_NAME) python /usr/src/app/$(FILE)

pytest:
	docker compose exec $(SERVICE_NAME) pytest /usr/src/app/tests

pytestcov:
	docker compose exec $(SERVICE_NAME) pytest /usr/src/app/tests --cov
	# docker compose exec $(SERVICE_NAME) coverage html

tests:
	docker compose exec $(SERVICE_NAME) ruff check /usr/src/app/
	docker compose exec $(SERVICE_NAME) mypy /usr/src/app/
	docker compose exec $(SERVICE_NAME) pytest /usr/src/app/tests
	docker compose exec $(SERVICE_NAME) pytest /usr/src/app/tests --cov

install-deps:
	docker compose exec -T $(SERVICE_NAME) pip install -r /usr/src/app/requirements.txt