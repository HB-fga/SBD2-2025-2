-- DDL da tabela de staging para carregar o CSV gold
-- Ajuste tipos se preferir (aqui usamos TEXT/varchar para máxima tolerância)

CREATE TABLE IF NOT EXISTS stg_security_incident (
    timestamp TEXT,
    orgid VARCHAR(255),
    detectorid VARCHAR(255),
    alerttitle TEXT,
    category VARCHAR(255),
    mitretechniques TEXT,
    incidentgrade VARCHAR(255),
    entitytype VARCHAR(255),
    evidencerole VARCHAR(255),
    osfamily VARCHAR(255),
    osversion VARCHAR(255),
    lastverdict VARCHAR(255),
    countrycode VARCHAR(10),
    state VARCHAR(255),
    city VARCHAR(255),
    raw_event_id VARCHAR(255) -- opcional, caso exista um id original
);

-- Recomendo criar um índice na coluna timestamp e orgid se for grande:
CREATE INDEX IF NOT EXISTS idx_stg_timestamp ON stg_security_incident (timestamp);
CREATE INDEX IF NOT EXISTS idx_stg_orgid ON stg_security_incident (orgid);

