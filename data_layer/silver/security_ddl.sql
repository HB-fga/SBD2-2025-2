CREATE SCHEMA IF NOT EXISTS silver;
DROP TABLE IF EXISTS silver.microsoft_security_incident;    
CREATE TABLE silver.microsoft_security_incident (
    id BIGINT PRIMARY KEY,
    org_id INT NOT NULL,
    incident_id INT NOT NULL,
    alert_id INT NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    detector_id INT NOT NULL,
    alert_title VARCHAR(500) NOT NULL,
    category VARCHAR(100) NOT NULL,
    mitre_techniques VARCHAR(200) NOT NULL,
    incident_grade INT NOT NULL,
    entity_type INT NOT NULL,
    evidence_role INT NOT NULL,
    device_id BIGINT,
    sha256 CHAR(64),
    ip_address INET,  
    url TEXT,
    account_sid VARCHAR(200), 
    account_upn VARCHAR(255),
    os_family VARCHAR(50) NOT NULL,
    os_version VARCHAR(50) NOT NULL,
    country_code CHAR(2) NOT NULL,
    state VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    last_verdict VARCHAR(50) NOT NULL
);
