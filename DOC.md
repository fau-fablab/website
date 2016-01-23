Documentation
=============

0. Get the code
---------------

This repo is modular and uses submodules:

 - [fau-fablab/website-style](https://github.com/fau-fablab/website-style) (adapted bootstrap)

So **clone recursive** or run `git submodules init && git submodules update`

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

 - use **[./setup.sh](setup.sh)** to set up the homepage on your computer
 - it will do the required steps like docker, but without mess up your computer TM
 - every step / task is one argument / function and `all` will run the required steps in the right order
 - when running the script as root, the required system packages will be installed automatically (fedora (dnf) and ubuntu(/debian?) (apt) are supported)
 - when the environment variable `NO_VENV` is set (e.g. `export NO_VENV=1`) no virtual environment will be set (e.g. in docker `CMD` when running `post_setup`) up otherwise a venv will be created into `./venv`
   - enter this venv by `. ./venv/bin/activate`

 - to run the development server and for testing django site (outside of docker) run `./setup.sh post_setup`:
   - this will migrate the database (`manage.py migrate`, currently `sqlite3`) and compile the `scss` (sass)
   - TODO: set up development and production config in django config and switching via a env var)
   - inside the venv run `./djangocms/manage.py runserver` and go to [http://localhost:8000](http://localhost:8000)

2. Bootstrapping django-cms
---------------------------

 - Only for documentation: How to set up a new djangocms project
 - I ran the setup script until it crashed, entered the matrix - ehm venv and ran:

        pip3 install --upgrade -r docs/requirements.txt

 - then I ran `djangocms --config-file docs/djangocmsinstaller.conf -p djangocms fablab_website` and choosing the default values from [`./docs/djangocmsinstaller.conf`](./docs/djangocmsinstaller.conf)
 - one can now `rm -rf venv && ./setup.sh` to finish the provisioning or `./manage-docker.sh up`

3. Updating and upgrading
-------------------------

 - Old packages are reported by piprot after setting up via [`setup.py`](./setup.py):

		Django (1.8.7) is 38 days out of date. Latest is 1.9.1

   - some packages mustn't be updated, see below
   - also subscribe to django mailing list or RSS feed to get security announcements
 - For updating a package, edit [`requirements.txt`](./djangocms/requirements.txt)
   - update the specified number to the new version number
   - use the `==` operator, otherwise it can happen, that a new released version breaks the website and you can't understand, why (see https://github.com/divio/django-cms/issues/4843#issuecomment-164232239)
   - sometimes there is a comment like `# <1.9` if there is a module, which requires this module to be older than `1.9`
   - read their CHANGELOG before
 - after changing a version, test if everything is still ok:

```sh
deavtivate
./setup.sh
. venv/bin/activate
./djangocms/manage.py runserver
# test test
# commit
```
