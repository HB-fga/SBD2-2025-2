-- DDL para Star Schema (PostgreSQL)
-- Cria 1 tabela fato e 4 dimensões

BEGIN;

-- Dimensão Tempo
CREATE TABLE IF NOT EXISTS d_time (
    time_key BIGSERIAL PRIMARY KEY,
    event_timestamp TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    event_date DATE NOT NULL,
    year integer,
    month integer,
    day integer,
    hour integer,
    weekday integer,
    created_at TIMESTAMP DEFAULT now()
);

-- Dimensão Organização
CREATE TABLE IF NOT EXISTS d_organization (
    org_key BIGSERIAL PRIMARY KEY,
    organization_external_id VARCHAR(255),
    organization_name VARCHAR(255),
    created_at TIMESTAMP DEFAULT now(),
    UNIQUE (organization_external_id)
);

-- Dimensão Detector
CREATE TABLE IF NOT EXISTS d_detector (
    det_key BIGSERIAL PRIMARY KEY,
    detector_external_id VARCHAR(255),
    detector_name VARCHAR(255),
    created_at TIMESTAMP DEFAULT now(),
    UNIQUE (detector_external_id)
);

-- Dimensão Alerta / Categoria
CREATE TABLE IF NOT EXISTS d_alert (
    alert_key BIGSERIAL PRIMARY KEY,
    alert_title VARCHAR(1000),
    category VARCHAR(255),
    mitre_techniques TEXT,
    created_at TIMESTAMP DEFAULT now(),
    UNIQUE (alert_title, category)
);

-- Tabela Fato: Incidentes
CREATE TABLE IF NOT EXISTS f_incident (
    incident_key BIGSERIAL PRIMARY KEY,
    time_key BIGINT NOT NULL REFERENCES d_time(time_key),
    org_key BIGINT REFERENCES d_organization(org_key),
    det_key BIGINT REFERENCES d_detector(det_key),
    alert_key BIGINT REFERENCES d_alert(alert_key),
    incident_title VARCHAR(1000),
    incident_grade VARCHAR(50),
    entity_type VARCHAR(255),
    evidence_role VARCHAR(255),
    os_family VARCHAR(255),
    os_version VARCHAR(255),
    last_verdict VARCHAR(255),
    country_code CHAR(2),
    state VARCHAR(255),
    city VARCHAR(255),
    raw_event_id VARCHAR(255), -- opcional: id original da linha
    created_at TIMESTAMP DEFAULT now()
);

-- Índices para consultas analíticas
CREATE INDEX IF NOT EXISTS idx_f_incident_time_key ON f_incident(time_key);
CREATE INDEX IF NOT EXISTS idx_f_incident_org_key ON f_incident(org_key);
CREATE INDEX IF NOT EXISTS idx_f_incident_alert_key ON f_incident(alert_key);
CREATE INDEX IF NOT EXISTS idx_d_time_event_date ON d_time(event_date);

COMMIT;

-- Nota: adaptar tipos e constraints conforme SGBD de destino. Este script assume PostgreSQL.
