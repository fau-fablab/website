FROM	fedora:23
#FROM	ubuntu:14.04

ENV	PYTHONUNBUFFERED 1
ENV	NO_VENV 1

# install requirements
RUN	dnf -y install python3 python3-pip which && dnf clean all
#RUN	apt-get -y install python3 python3-pip which && apt-get clean

RUN	ln -s /usr/bin/python3 /usr/bin/python

# add files and run the setup/provisioning script
ADD	./setup.sh /srv/setup.sh
# this is splitted for easier debugging
RUN	/srv/setup.sh install_system_requirements
ADD	./djangocms/requirements.txt /srv/djangocms/requirements.txt
RUN	/srv/setup.sh install_requirements

WORKDIR	/srv/djangocms

CMD	../setup.sh post_setup && \
	./manage.py runserver 0.0.0.0:80 # TODO later we need gunnycorn or something like that
EXPOSE	80

# vim: ts=8 noet
