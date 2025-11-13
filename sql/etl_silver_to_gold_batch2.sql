-- ETL batch by time_natural_key ranges
DO $$
DECLARE
  start_key BIGINT;
  max_key BIGINT;
  end_key BIGINT;
  batch_size BIGINT := 500000;
  inserted INT := 0;
BEGIN
  SELECT MIN(time_natural_key), MAX(time_natural_key) INTO start_key, max_key FROM d_time WHERE time_natural_key IS NOT NULL;
  IF start_key IS NULL THEN
    RAISE NOTICE 'No numeric natural keys present; nothing to do.';
    RETURN;
  END IF;

  WHILE start_key <= max_key LOOP
    end_key := start_key + batch_size - 1;

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
    FROM stg_security_incident s
    LEFT JOIN d_organization o ON o.organization_external_id = trim(s.orgid)::varchar
    LEFT JOIN d_detector d ON d.detector_external_id = trim(s.detectorid)::varchar
    LEFT JOIN d_alert a ON a.alert_title = LEFT(trim(s.alerttitle)::varchar,1000) AND a.category = LEFT(trim(s.category)::varchar,255)
    LEFT JOIN d_time dt ON dt.time_natural_key IS NOT NULL AND dt.time_natural_key = CASE WHEN trim(s.timestamp) ~ '^[0-9]+$' THEN trim(s.timestamp)::bigint ELSE NULL END
    LEFT JOIN d_time dt_ts ON dt_ts.event_timestamp IS NOT NULL AND dt_ts.event_timestamp = CASE WHEN trim(s.timestamp) ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}' THEN (regexp_replace(trim(s.timestamp), 'Z$', '', 'g'))::timestamp ELSE NULL END
    WHERE trim(s.timestamp) ~ '^[0-9]+$' AND (trim(s.timestamp)::bigint BETWEEN start_key AND end_key)
      AND trim(s.orgid) <> '';

    GET DIAGNOSTICS inserted = ROW_COUNT;
    RAISE NOTICE 'Inserted % rows for keys %..%', inserted, start_key, end_key;

    start_key := end_key + 1;
  END LOOP;
END$$;
