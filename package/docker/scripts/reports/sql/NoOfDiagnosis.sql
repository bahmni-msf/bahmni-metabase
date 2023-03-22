SELECT vd.coded_diagnosis AS "coded_diagnosis", count(*) AS "count"
FROM visit_diagnoses vd
WHERE (vd.date_created >= (CAST(date_trunc('week', ((now() + (INTERVAL '-1 week')) + (INTERVAL '1 day'))) AS timestamp) + (INTERVAL '-1 day'))
    AND vd.date_created < (CAST(date_trunc('week', (now() + (INTERVAL '1 day'))) AS timestamp) + (INTERVAL '-1 day')))
GROUP BY vd.coded_diagnosis
ORDER BY vd.coded_diagnosis