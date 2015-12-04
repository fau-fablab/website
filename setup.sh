#!/bin/bash

FUNCTIONS=("activate_venv" "install_system_requirements" "check_system_requirements" "create_venv" "install_requirements" "post_setup" "all")

if [ "$(basename ${0})" == "$(basename ${BASH_SOURCE})" ] ; then
	if [ ! -z $1 ] && [[ ! "${FUNCTIONS[@]}" =~ "$1" ]]; then
		echo "Usage: $0"
		echo ""
		echo "available tasks are:"
		echo "	check_system_requirements	checks if all system requirements are installed"
		echo "	install_system_requirements	installs system requirements using you deistributions package manager"
		echo "	create_venv			create a virtual environment"
		echo "	install_requirements		install all python requirements with pip"
		echo "	post_setup			run post setup tasks"
		echo "	all				run all tasks (default)"
		echo ""
		echo "All commands are run in the virtual environment if the environment variable NO_VENV is unset"
		echo "ProTip: source this file for tab completion"
		exit 0
	else

		set -e # exit on error

		cd "$(dirname ${0})"

		VENV_DIR="./venv/"
		SITE="./djangocms/"
		# TODO: requirements ausmisten
		REQUIREMENTS_FEDORA=("wget" "gcc" "redhat-rpm-config" "python3-devel" "python3-setuptools" "libjpeg-turbo" "zlib" "libtiff" "python3-freetype" "lcms2" "libwebp" "tcl" "tk" "openjpeg2" \
					"libtiff-devel" "libjpeg-turbo-devel" "libzip-devel" "freetype-devel" "lcms2-devel" "libwebp-devel" "tcl-devel" "tk-devel")
		REQUIREMENTS_UBUNTU=("wget" "gcc" "python3-dev" "python3-setuptools" "libtiff5-dev" "libjpeg8" "zlib1g-dev" "libfreetype6-dev" "liblcms2-dev" "libwebp-dev" "tcl8.6-dev" "tk8.6-dev" "python-tk" "libpq-dev" "postgresql-client-9.3" "python-dev")

		function activate_venv() {
		# checks if you are in the virtual environment and enters it if not

			if [ -z $VIRTUAL_ENV ] && [ -z $NO_VENV ] ; then
				echo "[i] Entering virtual env"
				. "${VENV_DIR}/bin/activate"
			fi
		}

		function install_system_requirements() {
		# installs all system requirements

			if [ $(which dnf) ] ; then

				echo "[i]   I think this is fedora"

				dnf -y install ${REQUIREMENTS_FEDORA[@]} && dnf clean all

			elif [ $(which apt-get) ] ; then

				echo "[i]   I think this is ubuntu"

				apt-get update -qq
				apt-get -y install ${REQUIREMENTS_UBUNTU[@]} && apt-get clean

			else
				echo "[!]   your distro is not supported!" >&2
				exit 2
			fi

		}

		function check_system_requirements() {
		# checks if all external requirements are installed and installs them via the distros package manager if the script is run by root

			echo "[i] Checking system requirements - run task 'all' as root or run task 'install_system_requirements' to install them"

			if [ $(which dnf) ] ; then

				echo "[i]   I think this is fedora"

				for pkg in ${REQUIREMENTS_FEDORA[@]}; do
					if ! $(rpm -q "${pkg}" >/dev/null) ; then
						echo "[!]   $(rpm -q ${pkg})" >&2
						exit 1
					fi
				done

			elif [ $(which apt-get) ] ; then

				echo "[i]   I think this is ubuntu"

				for pkg in ${REQUIREMENTS_UBUNTU[@]}; do
					if ! $(dpkg -q "${pkg}" >/dev/null) ; then
						echo "[!]   $(dpkg -q ${pkg})" >&2	  # TODO test this
						exit 1
					fi
				done

			else
				echo "[!]   your distro is not supported!" >&2
				exit 2
			fi

			echo "[i]   OK. All required packages are installed"

		}

		function create_venv() {
		# creates a virtual env and sources it

			if [ -z $NO_VENV ]; then
				echo "[i] Creating a virtual env in \"${VENV_DIR}\" ..."
				python3 -m "virtualenv" -p python3.4 "${VENV_DIR}"

				activate_venv
			fi

		}

		function install_requirements() {
		# installs all requirements

			activate_venv
			echo "[i] Installing requirements from ${SITE}/requirements.txt"
			pip3 install --upgrade -r "${SITE}/requirements.txt"

		}

		function post_setup() {
		# tasks to do after setup

			activate_venv
			echo "[i] Migrating Database"
			cd "${SITE}"
			python3 "./manage.py" "makemigrations"
			python3 "./manage.py" "migrate"
			cd - >/dev/null

		}


		function all() {

			if [ ${UID} -eq 0 ] ; then
				echo "[i] I'll install all dependencies - abort now if you don't want to do this!"
				install_system_requirements
			else
				check_system_requirements
			fi

			create_venv

			install_requirements

			post_setup

		}

		${1:-all} # execute function
	fi
else
	# someone is sourcing this file -> tab completion
	if $(complete -p "$(basename ${BASH_SOURCE})" 2>/dev/null) ; then complete -r "$(basename ${BASH_SOURCE})"; fi
	complete -W "$(echo ${FUNCTIONS[@]})" "$(basename ${BASH_SOURCE})"
	unset FUNCTIONS
	echo "[i] successfully added tab completion for $(basename ${BASH_SOURCE}) - happy tabbing"
fi

# vim: ts=8 noet
