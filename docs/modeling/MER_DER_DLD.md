# Modelagem — MER / DER / DLD (Camada Gold)

Este documento descreve a modelagem em estrela (star schema) para a camada Gold, baseada no dataset disponível em `data_layer/gold/security_incident_prediction_gold.csv`.

Resumo das colunas originais (Gold):
- timestamp
- orgid
- detectorid
- alerttitle
- category
- mitretechniques
- incidentgrade
- entitytype
- evidencerole
- osfamily
- osversion
- lastverdict
- countrycode
- state
- city

Decisões de modelagem (assunções):
- Banco alvo: PostgreSQL (sintaxe usada nos scripts DDL/ETL). Se necessário, adaptação para outro SGBD é trivial.
- Usamos surrogate keys (bigserial) nas dimensões para garantir performance e evitar dependência direta de ids externos.
- Star schema com 1 fato de incidente (`f_incident`) e 4 dimensões: organização, detector, tempo e alerta (alert/attack).

Mnemônicos principais (ver `docs/mnemonicos.md` para detalhes):
- Fato: F_INCIDENT (tabela: f_incident)
- Dimensões: D_ORGANIZATION (d_organization), D_DETECTOR (d_detector), D_TIME (d_time), D_ALERT (d_alert)

DER / Star Schema (texto / ASCII art):

                 d_organization           d_detector
                +------------+          +------------+
                | org_key PK |<-------->| det_key PK |
                | org_id     |          | detectorid |
                | name       |          | name       |
                +------------+          +------------+
                       ^                      ^
                       |                      |
                       +--------+  +----------+
                                |  |
                              +--------------------------+
                              |       f_incident         |
                              | +----------------------+ |
                              | |incident_key PK       | |
                              | |time_key FK           | |
                              | |org_key FK            | |
                              | |det_key FK            | |
                              | |alert_key FK          | |
                              | |alerttitle            | |
                              | |category              | |
                              | |mitretechniques       | |
                              | |incidentgrade         | |
                              | |entitytype            | |
                              | |evidencerole          | |
                              | |osfamily              | |
                              | |osversion             | |
                              | |lastverdict           | |
                              | |countrycode/state/city| |
                              | +----------------------+ |
                              +--------------------------+
                                       ^
                                       |
                                  d_time (d_time)
                                  d_alert (d_alert)

Observações sobre colunas e design:
- `timestamp` será decomposto em `d_time` (date, year, month, day, hour, weekday) para permitir agregações temporais eficientes.
- Informações de alerta (alerttitle, category, mitretechniques) irão para `d_alert`. Algumas colunas (mitretechniques) podem ser multivalor — serão mantidas em forma de string normalizada para esta entrega; para produção considerar tabela many-to-many `alert_mitre`.
- Localização (countrycode/state/city) mantida no fato por simplicidade, mas poderia virar `d_location` se necessário para normalização.

DLD (Data Level Design) resumo — transformações principais:
- timestamp -> d_time: extração de componentes e truncamento para data/hora.
- orgid -> d_organization.org_external_id (mapeamento direto)
- detectorid -> d_detector.detector_external_id
- alerttitle, category, mitretechniques -> d_alert (agregação por título+categoria)
- incidentgrade, entitytype, evidencerole, osfamily, osversion, lastverdict, countrycode, state, city -> campos no fato (f_incident) para análises imediatas.

Regras de qualidade / integridade:
- Eliminar linhas sem `timestamp` ou `orgid` (dados essenciais para análise).
- Normalizar `countrycode` (usar ISO ALPHA-2 quando possível).
- Trim e lower para chaves textuais ao popular dimensões para reduzir duplicidades.
- Tratar `mitretechniques` como string única (até 1024 chars) para esta entrega.

Próximo: ver scripts DDL para criar as tabelas e script ETL para popular as dimensões e fato.
