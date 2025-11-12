# DLD — Data Dictionary (Camada Gold)

Arquivo: `data_layer/gold/security_incident_prediction_gold.csv`

Mapa de colunas (Gold) -> destino no star schema

- timestamp (string/ISO) -> d_time.timestamp (TIMESTAMP), e decomposição para d_time.date, year, month, day, hour, weekday
- orgid -> d_organization.organization_external_id (VARCHAR/INT dependendo), não nulo
- detectorid -> d_detector.detector_external_id (VARCHAR)
- alerttitle -> d_alert.alert_title (VARCHAR)
- category -> d_alert.category (VARCHAR)
- mitretechniques -> d_alert.mitre_techniques (TEXT)
- incidentgrade -> f_incident.incident_grade (VARCHAR)
- entitytype -> f_incident.entity_type (VARCHAR)
- evidencerole -> f_incident.evidence_role (VARCHAR)
- osfamily -> f_incident.os_family (VARCHAR)
- osversion -> f_incident.os_version (VARCHAR)
- lastverdict -> f_incident.last_verdict (VARCHAR)
- countrycode -> f_incident.country_code (CHAR(2))
- state -> f_incident.state (VARCHAR)
- city -> f_incident.city (VARCHAR)

Tipos e tamanhos recomendados:
- Chaves surrogate: BIGINT (serial/bigserial)
- `timestamp`: TIMESTAMP WITH TIME ZONE (ou TIMESTAMP)
- Strings curtas (identificadores, categorias): VARCHAR(100..255)
- `mitre_techniques`: TEXT (pode ser uma lista separada por `;`)

Regras de transformação e limpeza:
- Linhas sem `timestamp` ou `orgid` serão descartadas.
- Campos text serão `trim()` e com espaços normalizados.
- `countrycode` será convertido para uppercase e validado contra padrão ISO alpha-2.
- `osversion` truncado a 50 chars.

Exemplos de valores:
- timestamp: 2025-06-15T14:23:00Z
- orgid: 12345
- detectorid: detector-xyz
- alerttitle: Possible Ransomware Activity
- category: Malware
- mitretechniques: T1490;T1486
- incidentgrade: High
- countrycode: BR

Observação: para modelagem dimensional completa, poderia haver normalização adicional (ex: `d_location`), e manejo de técnicas MITRE em tabela separada — para esta entrega mantemos simplicidade e análise direta.
