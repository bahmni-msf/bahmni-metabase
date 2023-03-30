SELECT count(*) as "count" , "old" as "type"
FROM visit
WHERE (visit.date_started >= date(now(6))
  AND visit.date_started < date(date_add(now(6), INTERVAL 1 day)) AND visit.patient_id in (SELECT visit.patient_id AS patient_id
    FROM visit
    WHERE visit.date_started < convert_tz('2023-03-02 00:00:00.000', 'GMT', @@session.time_zone)))
UNION ALL
SELECT count(*)  as "count", "new" as "type"
FROM visit
WHERE (visit.date_started >= date(now(6))
  AND visit.date_started < date(date_add(now(6), INTERVAL 1 day)) AND visit.patient_id not in (SELECT visit.patient_id AS patient_id
    FROM visit
    WHERE visit.date_started < convert_tz('2023-03-02 00:00:00.000', 'GMT', @@session.time_zone)))