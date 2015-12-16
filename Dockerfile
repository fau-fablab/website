FROM	fedora:23
#FROM	ubuntu:14.04

# install requirements
# TODO requirements ausmisten
RUN	dnf -y install python3 python3-pip gcc gcc-c++ redhat-rpm-config python3-devel python3-setuptools \
	libjpeg-turbo zlib libtiff python3-freetype lcms2 libwebp tcl tk openjpeg2 \
	libtiff-devel libjpeg-turbo-devel libzip-devel freetype-devel lcms2-devel libwebp-devel tcl-devel tk-devel && \
	dnf clean all

#RUN	apt-get update && \
#	apt-get -y install python3 python3-pip gcc gcc-c++ python3-dev python3-setuptools postgresql-client-9.3 python-dev \
#	libtiff5-dev libjpeg8 zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk libpq-dev && \
#	apt-get clean

RUN	ln -s /usr/bin/python3 /usr/bin/python  # easiest way to run only python3 so we don't have to install package twice

ENV	PYTHONUNBUFFERED 1

WORKDIR	/srv/djangocms

ADD	./djangocms/requirements.txt /srv/djangocms/requirements.txt
RUN	pip3 install --upgrade -r /srv/djangocms/requirements.txt

ADD	./setup.sh /srv/setup.sh

CMD	NO_VENV=1 ../setup.sh post_setup && \
	./manage.py runserver 0.0.0.0:80 # TODO later we need gunnycorn or something like that
EXPOSE	80

# vim: ts=8 noet
