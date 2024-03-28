# Python template for a SaaS Project.

The goal is to provide a comfortable starting point with step by step Instructions for SaaS projects with this tech stack: <br>
- Docker
- Django
- Postgresql (instead of sqlite)
- Adminer (optional gui to access the db)
- Tailwind (CSS Framework)
- HTMX (Interactive interfaces without JS)
- Ruff (Code Quality. Python linter and Formatter. Very fast.) https://pypi.org/project/ruff/
- MyPy (Code Quality. Static Type checker) https://mypy.readthedocs.io/en/stable/getting_started.html

**WARNING:** 
This is only a dev environment. A production ready version is going to follow.
Since i am still learning, there might be configuration errors. Use at your own risk.

## Getting Started

### Prerequisites

You need these on your host:
- Docker (Docker compose)
- Git

Also these packages. Preferably in a python virtual environment.
- Pre-Commit `pip install pre-commit` (To run ruff before every git commit) https://pre-commit.com
- Ruff `pip install ruff`
- MyPy (`pip install mypy`)

### Installing

#### 1. Basic Installation

1. Clone the repository: <br>
`git clone https://github.com/SeSa-1988/django-docker-starter.git`

2. Copy .env.example to .env and fill in the necessary environment variables:<br>
`cp .env.example .env`

3. Start the postgres and django container:<br> 
`docker compose build web db`<br>

4. Start the django project. <br>
`run web django-admin startproject project /usr/src/app` <br />
*(don't rename here)*

4. Optional: Rename the project folder
`mv project yourchosenname` <br />
*(This way in the settings etc. the project is named "project", while you can have a custom foldername)*

5. Attach to the web container (or use Visual Studio Code with the extension "Dev Containers" to open the container)
`make shell`

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

7. Optional: Make changes to /app/.editorconfig

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
5. Restart the containers (this time including the tailwind container)
`make restart`

6. Start a shell in the django container
`make shell`

7. Install Tailwind CSS dependencies, by running the following command in the django container: <br>
```python
python manage.py tailwind install
```

8. The Django Tailwind comes with a simple base.html template located at your_tailwind_app_name/templates/base.html. You can always extend or delete it if you already have a layout.

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

8. Add and configure Browser Reload it to INSTALLED_APPS in settings.py:

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
`make restart`

#### 3. Finalize the setup

1. Run the containers<br>
`make start`

2. Check the status of docker: <br>
`docker ps`

3. Initialize git and pre-commit
`git init` <br>
`pre-commit install` <br>

4. Make your initial commit
git commit -m "Initial commit"

6. Run shell in container <br>
`make shell`

7. Create your own superuser <br> (in web docker)
`maker superuser`

8.  Run migrations <br>
`make migrations`<br>
*Note: I am not sure if this is needed.*

9.   Start your project<br>
https://docs.djangoproject.com/en/5.0/intro/tutorial01/#creating-the-polls-app


## Installing new python packages

1. Add package to requirements.txt with the exact version

2. Run Shell in Django Container<br>
`make shell`

3. Install (and check if it worked) <br>
`make install`

(Alternatively use `pip install libraryname`, then get the version `libraryname --version` and add it to the requirements.txt)

## Making changes in the compose or dockerfile

1. Do your changes

2. Rebuild the image and restart<br>
`make rebuild`

## Todos:

- Including ruff, pytest and mypy into the container. Not sure about the pre commit.
- I am planning on improving security and performance
  - Running on non root user
  - Optimizing structure and order of the build process
- Production environment
- Deployment Server *(This templates runs the django server for dev purposes. It must not be used in production.)*

