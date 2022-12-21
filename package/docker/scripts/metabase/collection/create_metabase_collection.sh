#!/bin/bash

echo "Adding Collection to Metabase"

collection_response=$(curl -s -w "%{http_code}" -X POST  \
       -H "Content-type:application/json" \
       -H "X-Metabase-Session:${MB_TOKEN}" \
       http://${MB_HOST}:${MB_PORT}/api/collection \
       -d '{
       "name": "Bahmni Analytics",
       "color": "#DDDDDD"
       }'
)
STATUS=${collection_response: -3}
if [ "$STATUS" == 200 ]
then
    COLLECTION_ID=$(jq -s -r '.[0].id' <<< ${collection_response})
    echo "Bahmni Collection added to Metabase with id:"${COLLECTION_ID}
else
    echo 'Could not create the Bahmni Collection in Metabase.' ${STATUS}
fi
