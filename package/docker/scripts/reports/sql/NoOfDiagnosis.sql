SELECT "visit_diagnoses"."coded_diagnosis" AS "coded_diagnosis", count(*) AS "count"
FROM "visit_diagnoses"
WHERE ("visit_diagnoses"."date_created" >= (CAST(date_trunc('week', ((now() + (INTERVAL '-1 week')) + (INTERVAL '1 day'))) AS timestamp) + (INTERVAL '-1 day'))
   AND "visit_diagnoses"."date_created" < (CAST(date_trunc('week', (now() + (INTERVAL '1 day'))) AS timestamp) + (INTERVAL '-1 day')))
GROUP BY "visit_diagnoses"."coded_diagnosis"
ORDER BY "visit_diagnoses"."coded_diagnosis"