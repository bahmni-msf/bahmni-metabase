#!/bin/bash

echo "Adding Databases to Metabase"

get_db_data()
{
    cat <<EOF
    [
        {
            "DB_HOST": "${MART_DB_HOST}",
            "DB_NAME": "${MART_DB_NAME}",
            "DB_USERNAME": "${MART_DB_USERNAME}",
            "DB_PASSWORD": "${MART_DB_PASSWORD}",
            "DB_TYPE": "postgres",
            "DB_REF_NAME": "mart"
        }
    ]
EOF
}

DB_CONNECTIONS="$(get_db_data)"

if !(jq -e . >/dev/null 2>&1 <<< $DB_CONNECTIONS); then
    echo "Database connections cannot be provided for invalid json value."
    exit 1
fi

DATABASE_CREATED=false

add_DB_to_metabase(){
    database_response=$(curl -s -w "%{http_code}" -X POST \
    -H "Content-type: application/json" \
    -H "X-Metabase-Session: ${MB_TOKEN}" \
    http://${MB_HOST}:${MB_PORT}/api/database \
    -d '{
        "engine": "'$1'",
        "name": "'$2'",
        "details": {
            "host": "'$3'",
            "db": "'$4'",
            "user": "'$5'",
            "password": "'$6'"
        }
    }')
    STATUS=${database_response: -3}
    if [ $STATUS == 200 ]
    then
        id=$(jq -s -r '.[0].id' <<< ${database_response})
        eval "${DB_REF_NAME}=$id"
        echo "$2 Database added to Metabase"
        DATABASE_CREATED=true
    else
        echo "error occured while connecting DB : $2"
    fi
}

echo "connecting Databases..."

length=$(jq '. | length' <<< ${DB_CONNECTIONS} )

for ((i=0; i < $length; i++))
do
    DB_DATA=$(jq ".[$i]" <<< ${DB_CONNECTIONS})

    DB_HOST_NAME=$(echo "${DB_DATA}" | jq '.DB_HOST' | tr -d '"')
    DB_NAME=$(echo "${DB_DATA}" | jq '.DB_NAME' | tr -d '"')
    DB_USERNAME=$(echo "${DB_DATA}" | jq '.DB_USERNAME' | tr -d '"')
    DB_PASSWORD=$(echo "${DB_DATA}" | jq '.DB_PASSWORD' | tr -d '"')
    DB_TYPE=$(echo "${DB_DATA}" | jq '.DB_TYPE' | tr -d '"')
    DB_REF_NAME=$(echo "${DB_DATA}" | jq '.DB_REF_NAME' | tr -d '"')

    echo "connecting DB : $DB_REF_NAME"

    add_DB_to_metabase  $DB_TYPE $DB_REF_NAME $DB_HOST_NAME $DB_NAME $DB_USERNAME $DB_PASSWORD
done

if [ $DATABASE_CREATED == true ]
then
    source /app/scripts/metabase/collection/create_metabase_collection.sh
    source /app/scripts/reports/add_reports.sh
    source /app/scripts/reports/old_vs_new_patient_report.sh
fi
