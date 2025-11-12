CREATE SCHEMA IF NOT EXISTS silver;
DROP TABLE IF EXISTS silver.microsoft_security_incident;    
CREATE TABLE silver.microsoft_security_incident (
    -- Identificadores
    id BIGINT PRIMARY KEY,
    org_id INT NOT NULL,
    incident_id INT NOT NULL,
    alert_id INT NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    detector_id INT NOT NULL,
    alert_title INT NOT NULL,
    category INT NOT NULL,
    mitre_techniques INT NOT NULL,
    incident_grade INT NOT NULL,
    entity_type INT NOT NULL,
    evidence_role INT NOT NULL,
    device_id BIGINT,
    sha256 BIGINT,
    ip_address BIGINT,
    url BIGINT,
    account_sid BIGINT,
    account_upn BIGINT,
    os_family INT NOT NULL,
    os_version INT NOT NULL,
    country_code INT NOT NULL,
    state INT NOT NULL,
    city INT NOT NULL,
    last_verdict INT NOT NULL
);
