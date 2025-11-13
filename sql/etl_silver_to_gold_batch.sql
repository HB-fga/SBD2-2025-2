-- ETL batch insert para f_incident (processa em lotes)
DO $$
DECLARE
  batch_size INT := 500000;
  rows_inserted INT := 1;
  offset INT := 0;
BEGIN
  WHILE rows_inserted > 0 LOOP
    WITH staging AS (
      SELECT *,
        CASE WHEN trim(timestamp) ~ '^[0-9]+$' THEN trim(timestamp)::bigint ELSE NULL END AS _time_natural_key,
        CASE WHEN trim(timestamp) ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}' THEN (regexp_replace(trim(timestamp), 'Z$', '', 'g'))::timestamp ELSE NULL END AS _event_timestamp
      FROM stg_security_incident
      WHERE timestamp IS NOT NULL AND trim(timestamp) <> '' AND trim(orgid) <> ''
      LIMIT batch_size OFFSET offset
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
    LEFT JOIN d_time dt_ts ON dt_ts.event_timestamp IS NOT NULL AND dt_ts.event_timestamp = s._event_timestamp;

    GET DIAGNOSTICS rows_inserted = ROW_COUNT;
    offset := offset + rows_inserted;
    RAISE NOTICE 'Batch inserted % rows (offset now %)', rows_inserted, offset;
  END LOOP;
END$$;
