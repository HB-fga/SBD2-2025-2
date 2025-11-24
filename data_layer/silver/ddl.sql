CREATE SCHEMA IF NOT EXISTS silver;

DROP TABLE IF EXISTS silver.microsoft_security_incident;

CREATE TABLE silver.microsoft_security_incident (

    id BIGINT,
    org_id BIGINT,
    incident_id BIGINT,
    alert_id BIGINT,
    timestamp TIMESTAMP,
    detector_id BIGINT,
    alert_title TEXT,
    category TEXT,
    mitre_techniques TEXT,
    incident_grade TEXT,
    entity_type TEXT,
    evidence_role TEXT,
    device_id BIGINT,
    sha256 TEXT,
    url TEXT,
    account_sid TEXT,
    account_upn TEXT,
    os_family TEXT,
    os_version TEXT,
    country_code TEXT,
    state TEXT,
    city TEXT,
    last_verdict TEXT
);

-- incide
CREATE INDEX IF NOT EXISTS idx_silver_timestamp ON silver.microsoft_security_incident(timestamp);