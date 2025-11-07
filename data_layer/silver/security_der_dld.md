## DER – Diagrama Entidade-Relacionamento (Descrição)

- Entidade principal: `silver.microsoft_security_incident`
- Descrição: Registra incidentes/alertas de segurança, com informações de origem, classificação, carimbos de tempo e atributos associados a dispositivo, conta e localização.
- Identificador primário: `id` (PK)
- Relacionamentos: Nesta versão lógica, não há chaves estrangeiras explícitas declaradas; os atributos como `org_id`, `incident_id`, `alert_id`, `device_id`, `account_*`, etc., podem futuramente se relacionar a dimensões/tabelas de referência (fora do escopo deste DDL).

Atributos (visão de alto nível):
- Identificadores do evento (id, org_id, incident_id, alert_id, detector_id)
- Carimbo de tempo e derivadas (timestamp, year, month, day, hour, day_of_week)
- Classificação e contexto (alert_title, category, mitre_techniques, incident_grade, entity_type, evidence_role, last_verdict)
- Entidades associadas (device_id, sha256, ip_address, url, account_sid, account_upn)
- Sistema/OS (os_family, os_version)
- Localização (country_code, state, city)


## DLD – Dicionário de Dados Lógico

- Schema: `silver`
- Tabela: `microsoft_security_incident`
- Descrição: Tabela de fatos de incidentes/alertas de segurança Microsoft.

### Colunas

1. `id` BIGINT NOT NULL PRIMARY KEY
   - Descrição: Identificador único do registro de incidente.

2. `org_id` INT NOT NULL
   - Descrição: Identificador da organização (tenant) do evento.

3. `incident_id` INT NOT NULL
   - Descrição: Identificador lógico do incidente agrupador de alertas.

4. `alert_id` INT NOT NULL
   - Descrição: Identificador do alerta específico dentro do incidente.

5. `timestamp` TIMESTAMP NOT NULL
   - Descrição: Data e hora do evento de segurança.

6. `year` INT GENERATED ALWAYS AS (EXTRACT(YEAR FROM timestamp)::INT) STORED
   - Descrição: Ano derivado de `timestamp`.

7. `month` INT GENERATED ALWAYS AS (EXTRACT(MONTH FROM timestamp)::INT) STORED
   - Descrição: Mês derivado de `timestamp`.

8. `day` INT GENERATED ALWAYS AS (EXTRACT(DAY FROM timestamp)::INT) STORED
   - Descrição: Dia derivado de `timestamp`.

9. `hour` INT GENERATED ALWAYS AS (EXTRACT(HOUR FROM timestamp)::INT) STORED
   - Descrição: Hora derivada de `timestamp`.

10. `day_of_week` INT GENERATED ALWAYS AS (EXTRACT(DOW FROM timestamp)::INT) STORED
    - Descrição: Dia da semana derivado de `timestamp` (0–6, conforme SGBD).

11. `detector_id` INT NOT NULL
    - Descrição: Código do mecanismo/sensor que detectou o evento.

12. `alert_title` INT NOT NULL
    - Descrição: Código/título categórico do alerta.

13. `category` INT NOT NULL
    - Descrição: Categoria do evento (ex.: InitialAccess, Execution, etc.).

14. `mitre_techniques` INT NOT NULL
    - Descrição: Código(s) de técnica MITRE ATT&CK associados ao evento.

15. `incident_grade` INT NOT NULL
    - Descrição: Classificação/gravidade do incidente (ex.: TruePositive, FalsePositive, etc.).

16. `entity_type` INT NOT NULL
    - Descrição: Tipo de entidade envolvida (ex.: User, Ip, Url).

17. `evidence_role` INT NOT NULL
    - Descrição: Papel da evidência no incidente (ex.: Related, Impacted).

18. `device_id` BIGINT NULL
    - Descrição: Identificador do dispositivo associado.

19. `sha256` BIGINT NULL
    - Descrição: Identificador/hash (sha256) associado ao arquivo/artefato.

20. `ip_address` BIGINT NULL
    - Descrição: Identificador numérico de endereço IP associado.

21. `url` BIGINT NULL
    - Descrição: Identificador/código de URL associado.

22. `account_sid` BIGINT NULL
    - Descrição: Identificador SID da conta.

23. `account_upn` BIGINT NULL
    - Descrição: UPN (User Principal Name) da conta.

24. `os_family` INT NOT NULL
    - Descrição: Família do sistema operacional.

25. `os_version` INT NOT NULL
    - Descrição: Versão do sistema operacional.

26. `country_code` INT NOT NULL
    - Descrição: Código do país.

27. `state` INT NOT NULL
    - Descrição: Código/identificador de estado/região.

28. `city` INT NOT NULL
    - Descrição: Código/identificador de cidade.

29. `last_verdict` INT NOT NULL
    - Descrição: Último veredito atribuído ao evento/alerta (ex.: Suspicious, Benign, etc.).


### Observações
- Colunas `year`, `month`, `day`, `hour` e `day_of_week` são geradas automaticamente pelo SGBD a partir de `timestamp` e armazenadas (STORED).
- Não há definições de índices adicionais, chaves estrangeiras ou views neste escopo; este documento cobre apenas o DER (descrição) e o DLD da tabela conforme o DDL fornecido.

