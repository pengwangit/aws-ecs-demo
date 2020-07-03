#!/bin/sh

set -e

# AWS ENV do not have double quotes, add double quotes here
update_conf_file () {
	sed -i 's/^"DbUser".*/"DbUser" = '\"${DB_USER}\"'/' ./conf.toml
	sed -i 's/^"DbPassword".*/"DbPassword" = '\"${DB_PASSWORD}\"'/' ./conf.toml
	sed -i 's/^"DbName".*/"DbName" = '\"${DB_NAME}\"'/' ./conf.toml
	sed -i 's/^"DbHost".*/"DbHost" = '\"${DB_HOST}\"'/' ./conf.toml
}

update_conf_file

is_db_initialized () {

	export PGPASSWORD=${DB_PASSWORD}

	EXIST=$(psql -w -d ${DB_NAME} -h ${DB_HOST} -U ${DB_USER} -c "
						SELECT EXISTS ( SELECT FROM information_schema.tables 
						WHERE table_catalog = '${DB_NAME}' 
						AND table_name = 'tasks');" || echo "error"
	)
	echo $EXIST | cut -d ' ' -f3
}

DB_STATUS="$(is_db_initialized)"

if [ "$DB_STATUS" = "f" ]; then
    echo "Table does not exist, initializing the table ......"
    ./TechTestApp updatedb -s
elif [ "$DB_STATUS" = "error" ]; then
	# to avoid re-creating tables while errors occur during database check
	echo "Error on checking database tables"
	exit 2
else
	echo "Table exists, do not recreate"
fi

./TechTestApp serve