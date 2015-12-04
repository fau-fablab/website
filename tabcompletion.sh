#################
# For manage.py #
#################

FUNCTIONS=("changepassword" "createsuperuser" "cms" "check" "compilemessages" "createcachetable" "dbshell" "diffsettings" "dumpdata" "flush" "inspectdb" "loaddata" "makemessages" "makemigrations" "migrate" "runfcgi" "shell" "showmigrations" "sql" "sqlall" "sqlclear" "sqlcustom" "sqldropindexes" "sqlflush" "sqlindexes" "sqlmigrate" "sqlsequencereset" "squashmigrations" "startapp" "startproject" "syncdb" "test" "testserver" "validate" "createinitialrevisions" "deleterevisions" "clearsessions" "ping_google" "collectstatic" "findstatic" "runserver")

# tab completion for manage.py
if $(complete -p "manage.py" 2>/dev/null) ; then complete -r "manage.py"; fi
complete -W "$(echo ${FUNCTIONS[@]})" "manage.py"
unset FUNCTIONS
echo "[i] successfully added tab completion for manage.py - happy tabbing"

########################
# For manage-docker.sh #
########################

. ./manage-docker.sh

################
# For setup.sh #
################

. ./setup.sh
