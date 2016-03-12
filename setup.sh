#!/bin/bash

FUNCTIONS=("activate_venv" "install_system_requirements" "check_system_requirements" "create_venv" "install_requirements" "run_checks" "post_setup" "all")

if [ "$(basename ${0})" == "$(basename ${BASH_SOURCE})" ] ; then
	if [ ! -z $1 ] && [[ ! "${FUNCTIONS[@]}" =~ "$1" ]]; then
		echo "Usage: $0"
		echo ""
		echo "available tasks are:"
		echo "	check_system_requirements	checks if all system requirements are installed"
		echo "	install_system_requirements	installs system requirements using you deistributions package manager"
		echo "	create_venv			create a virtual environment"
		echo "	install_requirements		install all python requirements with pip"
		echo "	run_checks			run installation checks"
		echo "	post_setup			run post setup tasks"
		echo "	all				run all tasks (default)"
		echo ""
		echo "All commands are run in the virtual environment if the environment variable NO_VENV is unset"
		echo "ProTip: source this file for tab completion"
		exit 0
	else

		set -e  # exit on error

		cd "$(dirname ${0})"

		VENV_DIR="./.venv/"
		SITE="./djangocms/"
		DOCKERFILE="./Dockerfile"

		function activate_venv() {
		# checks if you are in the virtual environment and enters it if not

			if [ -z $VIRTUAL_ENV ] && [ -z $NO_VENV ] ; then
				echo "[i] Entering virtual env"
				. "${VENV_DIR}/bin/activate"
			fi
		}

		function get_system_requirements() {
		# extracts the system packages from the Dockerfile
			if [ "${1}"=="fedora" ]; then
				sed ':a;$!{N;ba};s/\\\n//g;s/#//g' "${DOCKERFILE}" | grep "^RUN\sdnf -y install " | sed 's/^RUN\sdnf -y install\s//;s/\sdnf clean all$//;s/&//g'
			elif [ "${1}"=="ubuntu" ]; then
				sed ':a;$!{N;ba};s/\\\n//g;s/#//g' "${DOCKERFILE}" | grep "^RUN\sapt-get update &&\sapt-get -y install " | sed 's/^RUN\sapt-get update &&\sapt-get -y install //;s/\sapt-get clean$//;s/&//g'
			fi
		}

		function install_system_requirements() {
		# installs all system requirements

			if [ $(which dnf) ] ; then

				echo "[i]   I think this is fedora"

				REQ=$(get_system_requirements "fedora")

				dnf -y install $REQ

			elif [ $(which apt-get) ] ; then

				echo "[i]   I think this is ubuntu"

				REQ=$(get_system_requirements "ubuntu")

				apt-get update -qq
				apt-get -y install $REQ

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

				REQ=($(get_system_requirements "fedora"))

				for pkg in ${REQ[@]}; do
					if ! $(rpm -q "${pkg}" >/dev/null) ; then
						echo "[!]   '${pkg}' is not installed" >&2
						exit 1
					fi
				done

			elif [ $(which apt-get) ] ; then

				echo "[i]   I think this is ubuntu"

				REQ=($(get_system_requirements "ubuntu"))

				for pkg in ${REQ[@]}; do
					if ! $(dpkg -q "${pkg}" >/dev/null) ; then
						echo "[!]   '${pkg}' is not installed" >&2
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

			if [ ! -z $VIRTUAL_ENV ]; then
				echo "[!] Won't create a new virtualenv in \"${VENV_DIR}\" as we are in the virtualenv \"$VIRTUAL_ENV\""
				echo "[!]   Run 'deactivate' to leave the current virtualenv"
			elif [ -z $NO_VENV ]; then
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

		function run_checks() {
			activate_venv
			echo "[i] Running checks"
			echo "[i]   Checking django installation..."
			python3 "./${SITE}/manage.py" "check"
			echo "[i]   Checking django cms installation..."
			python3 "./${SITE}/manage.py" "cms" "check"
			echo "[i]   Checking for pip updates..."
			[ `piprot -o "${SITE}/requirements.txt" >&2` ] || true
		}

		function post_setup() {
		# tasks to do after setup

			activate_venv
			echo "[i] Running post setup tasks"
			echo "[i]   Compiling scss..."
			python3 "./${SITE}/manage.py" "compilescss"
			echo "[i]   Migrating database..."
			python3 "./${SITE}/manage.py" "migrate"  # First migrate packaged migrations
			python3 "./${SITE}/manage.py" "makemigrations"  # If there are still new migrations, make and apply them
			python3 "./${SITE}/manage.py" "migrate"
			run_checks
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
