# Python template for a SaaS Project.

This is my step by step process for new SaaS projects.

You have no idea, what you are doing, but you want to do it right. At least that has been my goal. So i decided to go with Docker, Code Quality checks, Django and Tailwind + HTMX. This is the tech stack:<br>

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

### Installing

#### 1. Basic Installation

1. Clone the repository: <br>
`git clone https://github.com/SeSa-1988/django-docker-starter.git .`
*(If you encounter an issue since your folder is not empty. Repeat the command without "." at the end, to create a subfolder. You can move the content to your main folder after that.)*

2. Copy .env.example to .env and fill in the necessary environment variables:<br>
`cp .env.example .env`

1. Optional: In the compose.yaml rename the images:<br>
`image: django-server:latest` <br>
`image: tailwind-server:latest` <br >
Example <br>
*image: myproject-django-server: latest*

1. Start the postgres and django container:<br> 
`make rebuild`<br>

1. Start the django project. <br>
`make shell`<br>
`django-admin startproject project /usr/src/app` <br />
*(don't rename here)*

1. Optional: Rename the project folder
`mv project yourchosenname` <br />
*(This way in the settings etc. the project is named "project", while you can have a custom foldername)*

1. Configure DB by editing your settings.py file (in the project folder). Add the import and replace the content of 'default'

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

7. In your compose.yaml (project folder) uncomment this line under web:<br>
`command: python manage.py runserver 0.0.0.0:8000`

8. Exit the shell `exit` and restart the docker container with `make restart`

9. Run shell inside the docker an Run migrations (in web docker)<br>
`make shell`<br>
`make migrations`<br>

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

4. Register the generated 'theme' app by adding the following line to settings.py file:
`TAILWIND_APP_NAME = 'theme'`

5. Make sure that the INTERNAL_IPS list is present in the settings.py file and contains the 127.0.0.1 ip address:
```python
INTERNAL_IPS = [
    "127.0.0.1",
]
```
6. Restart the containers
`make restart`

7. Start a shell in the django container
`make shell`

8. Install Tailwind CSS dependencies, by running the following command in the django container: <br>
```python
python manage.py tailwind install
```

9. The Django Tailwind comes with a simple base.html template located at your_tailwind_app_name/templates/base.html. You can always extend or delete it if you already have a layout.

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

10. Add and configure Browser Reload it to INSTALLED_APPS in settings.py:

```python
INSTALLED_APPS = [
  # other Django apps
  'tailwind',
  'theme',
  'django_browser_reload' #dev only
]
```

11. Staying in settings.py, add the middleware:

```python
MIDDLEWARE = [
  # ...
  'django_browser_reload.middleware.BrowserReloadMiddleware', #dev only
  # ...
]
```

The middleware should be listed after any that encode the response, such as Django’s GZipMiddleware. The middleware automatically inserts the required script tag on HTML responses before `</body>` when DEBUG is True.

12. Include django_browser_reload URL in your root url.py:

```python
from django.urls import include, path
urlpatterns = [
    ...,
    path("__reload__/", include("django_browser_reload.urls")),
]
````

13. Restart docker
`make restart`


#### 3. Optional: First Steps

Important:

(on host) means these commands should be run in your project folder on your local machine

(in web docker) means that commands should be run in your web docker container in the /app/ folder. 

#### Howto run commands in the container?

Option 1: Use VS Code Dev Containers extension 
https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers
(folder `src/usr/app/`)

Option 2: Attach your shell to the container with `make shell` and use `exit` to get out

#### First Steps

1. Check the status of docker: (on host) <br>
`docker ps`

1. Attach to the server in VSCode
(folder `src/usr/app/`)

1. Initialize git (on host)
`git init` <br>

1. Make your initial commit (on host)
`git add .`
`git commit -m "Initial commit"`


1. Create your own superuser (in web docker)<br>
`maker superuser`

1.   Read more on how to start with django<br>
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

- I am planning on improving security and performance
  - Running on non root user
  - Optimizing structure and order of the build process
- Production environment
- Deployment Server *(This templates runs the django server for dev purposes. It must not be used in production.)*
- Psycopg3 instead of 2

