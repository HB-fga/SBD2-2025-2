# Mnemônicos e Convenções de Nomenclatura

Objetivo: definir mnemônicos para tabelas e colunas para manter consistência.

- Prefixos:
  - f_ : tabela fato (ex: `f_incident`)
  - d_ : tabela dimensão (ex: `d_organization`)
  - stg_ : tabela staging (dados crus vindos da camada Silver)

Tabelas (mnemônicos):
- F_INCIDENT -> `f_incident` (tabela fato que registra cada incidente/alerta)
- D_ORGANIZATION -> `d_organization` (dimensão org_id / organização)
- D_DETECTOR -> `d_detector` (dimensão de detectores)
- D_TIME -> `d_time` (dimensão tempo: date, year, month, day, hour, weekday)
- D_ALERT -> `d_alert` (dimensão para alerttitle, category, mitretechniques)

Colunas chave e convenções:
- `<table>_key` : chave surrogate (bigint) PRIMARY KEY
- `<table>_external_id` : id original do sistema (quando aplicável), ex: `organization_external_id`
- Nomes em snake_case
- Campos text: usar `varchar(...)` ou `text` conforme necessidade. Para nomes e categorias `varchar(255)`.

Exemplo: `d_organization` campos principais:
- org_key (PK)
- organization_external_id (valor orgid original)
- organization_name
- created_at, updated_at (timestamp)

Chave única nas dimensões: combinação do external_id ou de campos que caracterizam a entidade para permitir UPSERT.
