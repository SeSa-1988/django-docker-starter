# Check if running inside Docker
ifneq ($(RUNNING_IN_DOCKER),true)
$(error This command should be run within a Docker container. Go to your project folder and use "make shell" to start the shell in the django container.)
endif

.PHONY: install
install:
	pip install -r requirements.txt
	python -m pip list

.PHONY: run-django
run-django:
	python manage.py runserver

.PHONY: migrate
migrate:
	python manage.py migrate

.PHONY: migrations
migrations:
	python manage.py makemigrations

.PHONY: superuser
superuser:
	python manage.py createsuperuser

.PHONY: update
update: install migrate ;

