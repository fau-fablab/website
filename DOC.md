Documentation
=============

1. Scripts and Testing
----------------------

 - source [`tabcompletion.sh`](./tabcompletion.sh) to get tab completion: `. ./tabcompletion.sh`

### Docker

 - use the **[./manage-docker.sh](./manage-docker.sh)** to quickly run the website inside a docker container
   - run `./manage-docker.sh up` to build and start the container
   - run `./manage-docker.sh port` to get the port the container is listening on
   - go to [http://localhost:$PORT](http://localhost:80) to see the page
 - TODO: add docker-compose script or [kastenwesen](https://github.com/faufablab/kastenwesen) config

### Setup / Provisioning (with and without docker)

 - docker will use **[./setup.sh](setup.sh)** to set up the container
 - but you can do this on your computer, too
 - every step / task is one function / argument and `all` will run the required steps in the right order
 - when running the script as root (e.g. in docker), the required system packages will be installed (fedora (dnf) and ubuntu(/debian?) (apt) are supported)
 - when the environment variable `NO_VENV` is set (e.g. `export NO_VENV=1`) no virtual environment will be set (e.g. in docker) up otherwise a venv will be created into `./venv`
   - enter this venv by `. ./venv/bin/activate`

 - to run the developement server and for testing django site (outside of docker) run `./setup.sh post_setup`:
   - this will migrate the database (`manage.py migrate`, currently `sqlite3`)
   - TODO: set up development and production config in django config and switching via a env var)
   - inside the venv run `./djangocms/manage.py runserver` and go to [http://localhost:8000](http://localhost:8000)

2. Bootstrapping django-cms
---------------------------

 - Only for documentation: How to set up a new djangocms project
 - I ran the setup script until it crashed, entered the matrix - ehm venv and ran:

        pip3 install --upgrade -r docs/requirements.txt

 - then I ran `djangocms --config-file docs/djangocmsinstaller.conf -p djangocms fablab_website` and chooosing the default values from [`./docs/djangocmsinstaller.conf`](./docs/djangocmsinstaller.conf)
 - one can now `rm venv && ./setup.sh` to finnish the provisioning or `./manage-docker.sh up`
