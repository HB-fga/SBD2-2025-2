-- ETL: Silver -> Gold (PostgreSQL style)
-- Assunções:
-- 1) Já existe uma tabela staging `stg_security_incident` com colunas que correspondem ao CSV gold.
-- 2) O CSV pode ser carregado usando \copy no psql ou outro mecanismo (ver exemplo mais abaixo).

-- Exemplo de carregamento local via psql cliente (executar no terminal):
-- \copy stg_security_incident FROM 'data_layer/gold/security_incident_prediction_gold.csv' CSV HEADER;

-- 1) Popula dimensão d_time (UPSERT não necessário se sempre geramos novos registros para cada timestamp)
BEGIN;

n-- Insere timestamps únicos em d_time
INSERT INTO d_time (event_timestamp, event_date, year, month, day, hour, weekday)
SELECT DISTINCT
    (regexp_replace(trim(timestamp), 'Z$', '', 'g'))::timestamp AS event_timestamp,
    ((regexp_replace(trim(timestamp), 'Z$', '', 'g'))::timestamp)::date AS event_date,
    EXTRACT(YEAR FROM (regexp_replace(trim(timestamp), 'Z$', '', 'g'))::timestamp)::int AS year,
    EXTRACT(MONTH FROM (regexp_replace(trim(timestamp), 'Z$', '', 'g'))::timestamp)::int AS month,
    EXTRACT(DAY FROM (regexp_replace(trim(timestamp), 'Z$', '', 'g'))::timestamp)::int AS day,
    EXTRACT(HOUR FROM (regexp_replace(trim(timestamp), 'Z$', '', 'g'))::timestamp)::int AS hour,
    EXTRACT(DOW FROM (regexp_replace(trim(timestamp), 'Z$', '', 'g'))::timestamp)::int AS weekday
FROM stg_security_incident s
WHERE s.timestamp IS NOT NULL
ON CONFLICT DO NOTHING;

-- 2) Popula dimensão d_organization (upsert)
INSERT INTO d_organization (organization_external_id, organization_name)
SELECT DISTINCT trim(orgid)::varchar AS organization_external_id, NULL::varchar
FROM stg_security_incident
WHERE orgid IS NOT NULL
ON CONFLICT (organization_external_id) DO NOTHING;

-- 3) Popula dimensão d_detector
INSERT INTO d_detector (detector_external_id, detector_name)
SELECT DISTINCT trim(detectorid)::varchar AS detector_external_id, NULL::varchar
FROM stg_security_incident
WHERE detectorid IS NOT NULL
ON CONFLICT (detector_external_id) DO NOTHING;

-- 4) Popula dimensão d_alert
INSERT INTO d_alert (alert_title, category, mitre_techniques)
SELECT DISTINCT trim(alerttitle)::varchar, trim(category)::varchar, trim(mitretechniques)::text
FROM stg_security_incident
WHERE alerttitle IS NOT NULL
ON CONFLICT (alert_title, category) DO NOTHING;

COMMIT;

-- 5) Popula fato f_incident a partir da staging juntando chaves das dimensões
BEGIN;

INSERT INTO f_incident (
    time_key, org_key, det_key, alert_key,
    incident_title, incident_grade, entity_type, evidence_role,
    os_family, os_version, last_verdict, country_code, state, city, raw_event_id
)
SELECT
    t.time_key,
    o.org_key,
    d.det_key,
    a.alert_key,
    s.alerttitle,
    s.incidentgrade,
    s.entitytype,
    s.evidencerole,
    s.osfamily,
    s.osversion,
    s.lastverdict,
    UPPER(s.countrycode),
    s.state,
    s.city,
    s.raw_event_id
FROM stg_security_incident s
LEFT JOIN d_time t ON t.event_timestamp = (regexp_replace(trim(s.timestamp), 'Z$', '', 'g'))::timestamp
LEFT JOIN d_organization o ON o.organization_external_id = trim(s.orgid)::varchar
LEFT JOIN d_detector d ON d.detector_external_id = trim(s.detectorid)::varchar
LEFT JOIN d_alert a ON a.alert_title = trim(s.alerttitle) AND a.category = trim(s.category)
-- Filtrar eventos inválidos (sem timestamp ou orgid)
WHERE s.timestamp IS NOT NULL
  AND s.orgid IS NOT NULL
  -- Opcional: evitar duplicação já registrada (se houver raw_event_id)
  AND NOT EXISTS (
      SELECT 1 FROM f_incident f WHERE f.raw_event_id IS NOT NULL AND f.raw_event_id = s.raw_event_id
  );

COMMIT;

-- Observações / verificações de integridade
-- 1) Contagens: comparar COUNT(*) entre staging (filtrado) e f_incident
-- 2) Checar NULLs inesperados nas FK: SELECT * FROM f_incident WHERE time_key IS NULL OR org_key IS NULL;

-- Exemplo de validação rápida:
-- SELECT COUNT(*) AS staging_total FROM stg_security_incident WHERE timestamp IS NOT NULL AND orgid IS NOT NULL;
-- SELECT COUNT(*) AS fact_total FROM f_incident;

-- Se desejar, implementar deduplicação mais avançada (hash do evento, raw_event_id, etc.).
