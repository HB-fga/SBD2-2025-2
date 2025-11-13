-- ETL: Silver -> Gold (PostgreSQL)
-- Versão limpa e robusta: trata timestamp numérico como chave natural e aceita ISO quando presente

-- 1) Popula dimensão d_time
BEGIN;

INSERT INTO d_time (time_natural_key, event_timestamp, event_date, year, month, day, hour, weekday)
SELECT DISTINCT
    CASE WHEN trim(s.timestamp) ~ '^[0-9]+$' THEN trim(s.timestamp)::bigint ELSE NULL END AS time_natural_key,
    CASE WHEN trim(s.timestamp) ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}' THEN (regexp_replace(trim(s.timestamp), 'Z$', '', 'g'))::timestamp ELSE NULL END AS event_timestamp,
    CASE WHEN trim(s.timestamp) ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}' THEN ((regexp_replace(trim(s.timestamp), 'Z$', '', 'g'))::timestamp)::date ELSE NULL END AS event_date,
    CASE WHEN trim(s.timestamp) ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}' THEN EXTRACT(YEAR FROM (regexp_replace(trim(s.timestamp), 'Z$', '', 'g'))::timestamp)::int ELSE NULL END AS year,
    CASE WHEN trim(s.timestamp) ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}' THEN EXTRACT(MONTH FROM (regexp_replace(trim(s.timestamp), 'Z$', '', 'g'))::timestamp)::int ELSE NULL END AS month,
    CASE WHEN trim(s.timestamp) ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}' THEN EXTRACT(DAY FROM (regexp_replace(trim(s.timestamp), 'Z$', '', 'g'))::timestamp)::int ELSE NULL END AS day,
    CASE WHEN trim(s.timestamp) ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}' THEN EXTRACT(HOUR FROM (regexp_replace(trim(s.timestamp), 'Z$', '', 'g'))::timestamp)::int ELSE NULL END AS hour,
    CASE WHEN trim(s.timestamp) ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}' THEN EXTRACT(DOW FROM (regexp_replace(trim(s.timestamp), 'Z$', '', 'g'))::timestamp)::int ELSE NULL END AS weekday
FROM stg_security_incident s
WHERE s.timestamp IS NOT NULL AND trim(s.timestamp) <> ''
ON CONFLICT (time_natural_key) DO NOTHING;

COMMIT;

-- 2) Popula dimensões de referência
BEGIN;

INSERT INTO d_organization (organization_external_id, organization_name)
SELECT DISTINCT trim(orgid)::varchar AS organization_external_id, NULL::varchar
FROM stg_security_incident
WHERE orgid IS NOT NULL AND trim(orgid) <> ''
ON CONFLICT (organization_external_id) DO NOTHING;

INSERT INTO d_detector (detector_external_id, detector_name)
SELECT DISTINCT trim(detectorid)::varchar AS detector_external_id, NULL::varchar
FROM stg_security_incident
WHERE detectorid IS NOT NULL AND trim(detectorid) <> ''
ON CONFLICT (detector_external_id) DO NOTHING;

INSERT INTO d_alert (alert_title, category, mitre_techniques)
SELECT DISTINCT LEFT(trim(alerttitle)::varchar,1000), LEFT(trim(category)::varchar,255), trim(mitretechniques)::text
FROM stg_security_incident
WHERE alerttitle IS NOT NULL AND trim(alerttitle) <> ''
ON CONFLICT (alert_title, category) DO NOTHING;

COMMIT;

-- 3) Popula fato f_incident
BEGIN;

WITH staging AS (
  SELECT *,
    CASE WHEN trim(timestamp) ~ '^[0-9]+$' THEN trim(timestamp)::bigint ELSE NULL END AS _time_natural_key,
    CASE WHEN trim(timestamp) ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}' THEN (regexp_replace(trim(timestamp), 'Z$', '', 'g'))::timestamp ELSE NULL END AS _event_timestamp
  FROM stg_security_incident
  WHERE timestamp IS NOT NULL AND trim(timestamp) <> ''
)
INSERT INTO f_incident (
    time_key, org_key, det_key, alert_key,
    incident_title, incident_grade, entity_type, evidence_role,
    os_family, os_version, last_verdict, country_code, state, city, raw_event_id
)
SELECT
    COALESCE(dt.time_key, dt_ts.time_key) AS time_key,
    o.org_key,
    d.det_key,
    a.alert_key,
    LEFT(trim(s.alerttitle)::varchar,1000) AS incident_title,
    LEFT(trim(s.incidentgrade)::varchar,50) AS incident_grade,
    LEFT(trim(s.entitytype)::varchar,255) AS entity_type,
    LEFT(trim(s.evidencerole)::varchar,255) AS evidence_role,
    LEFT(trim(s.osfamily)::varchar,255) AS os_family,
    LEFT(trim(s.osversion)::varchar,50) AS os_version,
    LEFT(trim(s.lastverdict)::varchar,255) AS last_verdict,
    CASE WHEN trim(s.countrycode) = '' THEN NULL ELSE UPPER(LEFT(trim(s.countrycode),2)) END AS country_code,
    NULLIF(trim(s.state),'') AS state,
    NULLIF(trim(s.city),'') AS city,
    NULL::varchar AS raw_event_id
FROM staging s
LEFT JOIN d_organization o ON o.organization_external_id = trim(s.orgid)::varchar
LEFT JOIN d_detector d ON d.detector_external_id = trim(s.detectorid)::varchar
LEFT JOIN d_alert a ON a.alert_title = LEFT(trim(s.alerttitle)::varchar,1000) AND a.category = LEFT(trim(s.category)::varchar,255)
LEFT JOIN d_time dt ON dt.time_natural_key IS NOT NULL AND dt.time_natural_key = s._time_natural_key
LEFT JOIN d_time dt_ts ON dt_ts.event_timestamp IS NOT NULL AND dt_ts.event_timestamp = s._event_timestamp
WHERE s.orgid IS NOT NULL AND trim(s.orgid) <> ''
;

COMMIT;

-- Fim do ETL
