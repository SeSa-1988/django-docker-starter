# Template and Step-by-Step Instructions for new Docker + Django + Postgres + Tailwind Projects

Basis template and instructions to create a dockerized development (and later deployment envirnment) with:
Docker, Django, Postgresql, Tailwind, Adminer, HTMX

The goal is to provide a comfortable starting point for new projects with this tech stack. 

**WARNING:** 
This is only a dev environment. A production ready version is going to follow.
Since i am still learning, there might be configuration errors. Use at your own risk.

## Getting Started

### Prerequisites

- Docker
- Docker Compose
- Git

### Installing

#### 1. Basic Installation

1. Clone the repository: <br>
`git clone https://github.com/SeSa-1988/django-docker-starter.git`

2. Copy .env.example to .env and fill in the necessary environment variables:<br>
`cp .env.example .env`

3. Start the services using Docker Compose:<br> 
`docker compose build`<br>
**Note: Tailwind throws an error, until you have finished the steps in the django tailwind installation section.*

4. Start the django project. replace webapp with your chosen name
docker-compose <br>
`run web django-admin startproject webapp /usr/src/app`

5. Attach to the web container (or use Visual Studio Code with the extension "Dev Containers" to open the container)
`docker compose exec web sh`

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

#### 2. Django Tailwind

*This repo uses this django-tailwind package: https://django-tailwind.readthedocs.io/* - I copied the steps 2-12 in here, so you dont have to switch documents.

Note: If you dont want to use Tailwind, remove the "tailwind" section in compose.yaml and skip this step.

1. Add Tailwind app to settings.py<br>

```python
#settings.py

INSTALLED_APPS = [
  # other Django apps
  'tailwind',
]
```

2. Create a Tailwind CSS compatible Django app and name it "theme" <br>
`python manage.py tailwind init`<br>
*(You can use another name. Just adapt the following steps accordingly)*

3. Add your newly created 'theme' app to INSTALLED_APPS in settings.py:

```python
# settings.py

INSTALLED_APPS = [
  # other Django apps
  'tailwind',
  'theme'
]
```

4. Make sure that the INTERNAL_IPS list is present in the settings.py file and contains the 127.0.0.1 ip address:
```python
INTERNAL_IPS = [
    "127.0.0.1",
]
```

5. Install Tailwind CSS dependencies, by running the following command:
```python
python manage.py tailwind install
```

6. The Django Tailwind comes with a simple base.html template located at your_tailwind_app_name/templates/base.html. You can always extend or delete it if you already have a layout.

If you are not using the base.html template that comes with Django Tailwind, add `{% tailwind_css %}` to the base.html template:

```python
{% load static tailwind_tags %}
...
<head>
   ...
   {% tailwind_css %}
   ...
</head>
```

The `{% tailwind_css %}` tag includes Tailwind's stylesheet.

7. Add and configure Browser Reload it to INSTALLED_APPS in settings.py:

```python
INSTALLED_APPS = [
  # other Django apps
  'tailwind',
  'theme',
  'django_browser_reload'
]
```

8. Staying in settings.py, add the middleware:

```python
MIDDLEWARE = [
  # ...
  'django_browser_reload.middleware.BrowserReloadMiddleware',
  # ...
]
```

The middleware should be listed after any that encode the response, such as Django’s GZipMiddleware. The middleware automatically inserts the required script tag on HTML responses before `</body>` when DEBUG is True.

9. Include django_browser_reload URL in your root url.py:

```python
from django.urls import include, path
urlpatterns = [
    ...,
    path("__reload__/", include("django_browser_reload.urls")),
]
````

10. Restart docker
`docker compose down`
`docker compose up`

#### 3. Start with your proejct

1. Run the containers<br>
`docker compose up`

2. Open a new terminal (on host)

3. Check the status of docker: <br>
`docker ps`

4. Start the shell in the web container:
`docker compose exec web sh`

5. Create your own superuser <br> (in web docker)
`python manage.py createsuperuser`

6.  Run migrations <br>
`python manage.py migrate`<br>
*Note: I am not sure if this is needed.*

7.   Start your project<br>
https://docs.djangoproject.com/en/5.0/intro/tutorial01/#creating-the-polls-app

## Installing new python packages

1. Add package to requirements.txt

2. Run Shell<br>
`docker compose exec web sh`

3. Install <br>
`pip install --no-cache-dir -r requirements.txt`

4. Check if it worked <br>
`python -m pip list` <br>

## Making changes in the compose or dockerfile

1. Rebuild the image<br>
`docker compose build`

2. Restart the containers<br> 
`docker compose up -d`

## Whats missing

- I am planning on improving security and performance
  - Running on non root user
  - Optimizing structure and order of the build process
- Production environment
- Deployment Server *(This templates runs the django server for dev purposes. It must not be used in production.)*

