#!/bin/bash

FUNCTIONS=("up" "run" "run-shell" "start" "stop" "restart" "build" "clean" "shell" "port" "logs")

if [ "$(basename ${0})" == "$(basename ${BASH_SOURCE})" ] ; then
	if [ -z $1 ] || [[ ! "${FUNCTIONS[@]}" =~ "$1" ]]; then
		echo "Usage: manage.sh [COMMAND]"
		echo ""
		echo "Commands:"
		echo "	up		build and run"
		echo "	run		run an already built container"
		echo "	run-shell	run a shell in an already built container (overwrites CMD)"
		echo "	start		start an already created container"
		echo "	stop		stop a running container"
		echo "	restart		stop + start"
		echo "	build		build a new container"
		echo "	clean		remove all persistent data"
		echo "	shell		attach to running container and run a shell"
		echo "	port		query the port where the appserver is bound to"
		echo "	logs		tail the logs of dropwizard"
		echo "ProTip: source this file for tab completion"
	else

		set -e  # exit on error

		cd "$(dirname ${0})"  # allow calling this script from outside the scriptdir

		IMAGE="fablab_djangocms:3.2.0"
		CONTAINER="fablab_website"
		VOL_LOC="${PWD}/djangocms/"
		VOL_DOC="/srv/djangocms/"
		SHELL="bash"
		PORT="80:80"
		if [ $(whoami) == "root" ]; then
		    DOCKERCMD="docker"
		else
		    DOCKERCMD="sudo docker"
		fi

		function port() {
			${DOCKERCMD} port "${CONTAINER}"
		}
		function build() {
			${DOCKERCMD} build -t "${IMAGE}" .
		}
		function run() {
			${DOCKERCMD} run -d -p "${PORT}" --volume="${VOL_LOC}/:${VOL_DOC}/:rw,Z" \
				--name="${CONTAINER}" "${IMAGE}"
		}
		function run-shell() {
			${DOCKERCMD} run --rm -it -p "${PORT}" --volume="${VOL_LOC}/:${VOL_DOC}/rw,:Z" \
				--name="${CONTAINER}-interactive" "${IMAGE}" "${SHELL}"
		}
		function up() {
			build
			run
		}
		function start() {
			${DOCKERCMD} start "${CONTAINER}"
		}
		function stop() {
			${DOCKERCMD} stop "${CONTAINER}"
		}
		function restart() {
			${DOCKERCMD} restart "${CONTAINER}"
		}
		function clean() {
			read -p "Do you really want to delete the container including ALL data? [y/N] "
			if [ "$REPLY" == "y" ]; then
				${DOCKERCMD} rm -v "${CONTAINER}"
			fi
		}
		function shell() {
			${DOCKERCMD} exec -it "${CONTAINER}" "${SHELL}"
		}
		function logs() {
			${DOCKERCMD} logs -f "${CONTAINER}"
		}

		$1  # run the command

	fi

else
	# someone is sourcing this file -> tab completion
	if $(complete -p "$(basename ${BASH_SOURCE})" 2>/dev/null) ; then complete -r "$(basename ${BASH_SOURCE})"; fi
	complete -W "$(echo ${FUNCTIONS[@]})" "$(basename ${BASH_SOURCE})"
	unset FUNCTIONS
	echo "[i] successfully added tab completion for $(basename ${BASH_SOURCE}) - happy tabbing"
fi

# vim: st=8 ts=8 noet
