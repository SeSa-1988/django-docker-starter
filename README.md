# Project Title

Basic structure of a new docker + django + postgresql + tailwind project
Its based on this: https://github.com/docker/awesome-compose/tree/master/official-documentation-samples/django/

## Getting Started

### Prerequisites

- Docker
- Docker Compose
- Git

### Installing

1. Clone the repository:
git clone https://github.com/yourusername/yourproject.git

2. Copy `.env.example` to `.env` and fill in the necessary environment variables:
cp .env.example .env

3. Start the services using Docker Compose:
docker compose build

4. Start the django project. replace webapp with your chosen name
docker-compose run web django-admin startproject webapp /usr/src/app

5. Configure DB

# settings.py

import os

[...]

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('POSTGRES_NAME'),
        'USER': os.environ.get('POSTGRES_USER'),
        'PASSWORD': os.environ.get('POSTGRES_PASSWORD'),
        'HOST': 'db',
        'PORT': 5432,
    }
}


6. Run 
docker compose up

7. Create your own superuser
$ python manage.py createsuperuser

8. Run migrations (necessar?)
python manage.py migrate


# Installing new packages

1. add package 
to requirements.txt

2. rebuild the image
docker-compose build

3. restart the containers
docker-compose up -d

4. check if it worked
docker-compose exec web sh
python -m pip list

## Running the tests

pass

## Deployment

pass

