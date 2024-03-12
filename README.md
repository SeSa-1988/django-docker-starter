# Template for new Docker + Django + Postgres + Tailwind Projects

Basic structure of a new docker + django + postgresql + tailwind project.
The goal is to provide a comfortable starting point for new projects with this tech stack.

Its based on this: https://github.com/docker/awesome-compose/tree/master/official-documentation-samples/django/
*(It didnt work for me)*

**WARNING:** 
This is only a dev environment. A production ready version is going to follow.
Since i am still learning, there might be configuration errors. Use at your own risk.

## Getting Started

### Prerequisites

- Docker
- Docker Compose
- Git

### Installing

1. Clone the repository: <br>
`git clone https://github.com/SeSa-1988/django-docker-starter.git`

2. Copy .env.example to .env and fill in the necessary environment variables:<br>
`cp .env.example .env`

3. Start the services using Docker Compose:<br> 
`docker compose build`

4. Start the django project. replace webapp with your chosen name
docker-compose <br>
`run web django-admin startproject webapp /usr/src/app`

5. Attach to the web container (or use Visual Studio Code with the extension "Dev Containers" to open the container)

6. Configure DB by editing your settings.py file

```python
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
```

7. Run <br>
`docker compose up`

8. Create your own superuser <br>
`python manage.py createsuperuser`

9. Run migrations <br>
`python manage.py migrate`<br>
*Note: I am not sure if this is needed.*

1.  Start your project<br>
https://docs.djangoproject.com/en/5.0/intro/tutorial01/#creating-the-polls-app

## Installing new python packages

1. Add package 
to requirements.txt

2. Rebuild the image<br>
`docker compose build`

3. Restart the containers
`docker compose up -d`

4. Check if it worked <br>
`docker compose exec web sh` <br>
`python -m pip list` <br>

## Whats missing

- Tailwind
- I am planning on improving the security and performance
- Production environment
- Deployment Server (Currently it only includes the Django Server for devs. It shouldnt be used for production.)

