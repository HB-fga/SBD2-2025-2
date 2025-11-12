**Fonte**: security_ddl.sql 
**Dataset referência**: Microsoft Security Incident Prediction (Kaggle)

---

## Tabela: silver.microsoft_security_incident
**Chave primária**: id (BIGINT)

| Campo | Tipo (Postgres) | Nulidade | Descrição |
|------:|-----------------|:--------:|----------|
| id | BIGINT | NOT NULL PRIMARY KEY | Identificador único sequencial do registro. |
| org_id | INT | NOT NULL | Identificador da organização (OrgId). |
| incident_id | INT | NOT NULL | Identificador do incidente (agrupa evidências/alerts num incidente). |
| alert_id | INT | NOT NULL | Identificador do alerta (origem do evento). |
| timestamp | TIMESTAMP | NOT NULL | Data/hora do evento/registro. |
| year | INT | NOT NULL (GENERATED) | Ano extraído de `timestamp`. |
| month | INT | NOT NULL (GENERATED) | Mês extraído de `timestamp`. |
| day | INT | NOT NULL (GENERATED) | Dia extraído de `timestamp`. |
| hour | INT | NOT NULL (GENERATED) | Hora extraída de `timestamp`. |
| day_of_week | INT | NOT NULL (GENERATED) | Dia da semana extraído de `timestamp` (0..6). |
| detector_id | INT | NOT NULL | Identificador do detector (DetectorId). |
| alert_title | INT | NOT NULL | Código/título categorizado do alerta (label encoding). |
| category | INT | NOT NULL | Categoria do incidente (label encoding). |
| mitre_techniques | INT | NOT NULL | Código(s) de técnica MITRE ATT&CK (label encoding conforme etapa de ingestão). |
| incident_grade | INT | NOT NULL | Grau do incidente (0=FP,1=TP,2=BP). |
| entity_type | INT | NOT NULL | Tipo de entidade que originou a evidência (encoded). |
| evidence_role | INT | NOT NULL | Papel da evidência no incidente (encoded). |
| device_id | BIGINT | NULLABLE | Identificador do dispositivo (quando disponível). |
| sha256 | BIGINT | NULLABLE | Identificador numérico resultante do hash SHA-256 (representação label encoded). |
| ip_address | BIGINT | NULLABLE | Identificador numérico do endereço IP pós-transformação (ex.: hash/inteiro). |
| url | BIGINT | NULLABLE | Identificador numérico da URL (label encoding). |
| account_sid | BIGINT | NULLABLE | SID da conta (quando numérico). |
| account_upn | BIGINT | NULLABLE | Identificador numérico do UPN (label encoding). |
| os_family | INT | NOT NULL | Família do sistema operacional (encoded). |
| os_version | INT | NOT NULL | Versão do OS (encoded). |
| country_code | INT | NOT NULL | Código do país (encoded). |
| state | INT | NOT NULL | Estado/Província (encoded). |
| city | INT | NOT NULL | Cidade (encoded). |
| last_verdict | INT | NOT NULL | Último veredito (encoded). |

---

## Mapeamentos importantes
- **incident_grade**: 0 → FalsePositive (FP), 1 → TruePositive (TP), 2 → BenignPositive (BP).
- **alert_title / mitre_techniques / ip_address / url / account_upn**: Colunas codificadas numericamente (label encoding) para compatibilidade com o DDL; manter dicionários de referência na camada semântica.
- **sha256**: Valor codificado em inteiro a partir do hash; manter rastreabilidade para o valor original quando necessário.

---