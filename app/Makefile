# Check if running inside Docker
ifneq ($(RUNNING_IN_DOCKER),true)
$(error This command should be run within a Docker container. Go to your project folder and use "make shell" to start the shell in the django container.)
endif

install:
	pip install -r requirements.txt
	python -m pip list

run-django:
	python manage.py runserver

migrate:
	python manage.py migrate

migrations:
	python manage.py makemigrations

superuser:
	python manage.py createsuperuser

update: 
	install migrate ;

pytest:
	pytest /usr/src/app/tests

pytestcov:
	pytest /usr/src/app/tests --cov
	# coverage html

tests:
	ruff check /usr/src/app/
	mypy /usr/src/app/
	pytest /usr/src/app/tests
	pytest /usr/src/app/tests --cov

install-deps:
	pip install -r /usr/src/app/requirements.txt

.PHONY: install run-django migrate migrations superuser update pytest pytestcov tests install-deps

