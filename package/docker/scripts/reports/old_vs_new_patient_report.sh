#!/bin/bash

request=$(</app/scripts/reports/request/pie_chart_request.json)
jq -c '.[]' /app/scripts/reports/request/old_vs_new_patient_input.json | while read i; do

  REPORT_NAME=$(echo $i | jq -r .name)
  FILE_NAME=$(echo $i | jq -r .sql)
  DB_REF_NAME=$(echo $i | jq -r .db_ref_name)
  METRICS=$(echo $i | jq -r .metrics)
  DIMENSION=$(echo $i | jq -r .dimension)
  DATABASE_ID=${!DB_REF_NAME}
  if [[ $DATABASE_ID == '' ]]
  then
    echo "Report:$REPORT_NAME cannot be generated as $DB_REF_NAME is not configured in metabase"
    continue
  fi
  echo "Generating $REPORT_NAME for database: $DB_REF_NAME"
  REPORT_SQL=$(</app/scripts/reports/sql/${FILE_NAME}.sql)

  report_request=$(jq  --arg METRICS "METRICS" --arg DIMENSION "DIMENSION" --arg REPORT_NAME "$REPORT_NAME" --argjson COLLECTION_ID $COLLECTION_ID --argjson DATABASE_ID $DATABASE_ID --arg REPORT_SQL "$REPORT_SQL" \
   '(.collection_id = $COLLECTION_ID | .dataset_query.database = $DATABASE_ID|.name=$REPORT_NAME |.dataset_query.native.query = $REPORT_SQL
   |.visualization_settings."graph.metrics"=$METRICS | .visualization_settings."graph.dimensions"=$DIMENSION)' <<< ${request})


  report_response=$(curl -s -w "%{http_code}" -X POST  \
   	-H "Content-type: application/json" \
 		-H "X-Metabase-Session: ${MB_TOKEN}" \
		 http://${MB_HOST}:${MB_PORT}/api/card/ \
 		-d "${report_request}")

	STATUS=${report_response: -3}

  if [ "$STATUS" == 200 ]
	then
    	echo "Created report for " ${REPORT_NAME}
	else
    	echo "Could not create report for " ${REPORT_NAME}
	fi
done