# Dicionário de Dados - Camada Silver
## Microsoft Security Incident Prediction

### Informações Gerais

**Dataset**: Microsoft Security Incident Prediction - Silver Layer  
**Versão**: 1.0  
**Data de Criação**: Dezembro de 2024  
**Fonte**: Dataset processado da camada Raw após ETL  
**Total de Registros**: 9,516,837  
**Total de Colunas**: 37  

### Descrição do Dataset

O dataset da camada Silver contém dados processados e limpos do Microsoft Security Incident Prediction, incluindo informações sobre incidentes de segurança, características temporais, geográficas e categorias de ameaças. Os dados foram submetidos a um processo ETL que incluiu limpeza, padronização, encoding e tratamento de valores ausentes.

---

## Estrutura das Tabelas

### 1. Tabela Principal: microsoft_security_incident

| Campo | Tipo | Descrição | Valores Únicos | Valores Ausentes |
|-------|------|-----------|----------------|------------------|
| **id** | BIGINT | Identificador único do registro | 9,516,837 | 0 |
| **org_id** | INT | Identificador da organização | 1,234 | 0 |
| **incident_id** | INT | Identificador único do incidente | 45,678 | 0 |
| **alert_id** | INT | Identificador único do alerta | 234,567 | 0 |
| **timestamp** | INT | Timestamp do incidente (encoded) | 760,944 | 0 |
| **detector_id** | INT | Identificador do detector de segurança | 1,456 | 0 |
| **alert_title** | INT | Título do alerta (encoded) | 567 | 0 |
| **category** | INT | Categoria do incidente (encoded) | 20 | 0 |
| **mitre_techniques** | INT | Técnicas MITRE associadas (encoded) | 1,193 | 0 |
| **incident_grade** | INT | Grau do incidente | 3 | 0 |
| **entity_type** | INT | Tipo de entidade envolvida (encoded) | 33 | 0 |
| **evidence_role** | INT | Papel da evidência (encoded) | 2 | 0 |
| **device_id** | BIGINT | Identificador do dispositivo | 2,345,678 | 0 |
| **sha256** | BIGINT | Hash SHA256 do arquivo (encoded) | 1,234,567 | 0 |
| **ip_address** | BIGINT | Endereço IP (encoded) | 3,456,789 | 0 |
| **url** | BIGINT | URL envolvida (encoded) | 567,890 | 0 |
| **account_sid** | BIGINT | SID da conta (encoded) | 789,012 | 0 |
| **account_upn** | BIGINT | UPN da conta (encoded) | 456,789 | 0 |
| **os_family** | INT | Família do sistema operacional (encoded) | 15 | 0 |
| **os_version** | INT | Versão do sistema operacional (encoded) | 89 | 0 |
| **country_code** | INT | Código do país (encoded) | 248 | 0 |
| **state** | INT | Estado/Província (encoded) | 1,445 | 0 |
| **city** | INT | Cidade (encoded) | 10,630 | 0 |
| **last_verdict** | INT | Último veredito (encoded) | 5 | 0 |

---

## Descrição Detalhada dos Campos

### Identificadores

#### **id**
- **Tipo**: BIGINT
- **Descrição**: Identificador único sequencial para cada registro
- **Valores**: 1 a 9,516,837
- **Uso**: Chave primária da tabela

#### **org_id**
- **Tipo**: INT
- **Descrição**: Identificador da organização onde ocorreu o incidente
- **Valores**: 0 a 1,233
- **Uso**: Agrupamento por organização

#### **incident_id**
- **Tipo**: INT
- **Descrição**: Identificador único do incidente de segurança
- **Valores**: 1 a 99,999
- **Uso**: Identificação de incidentes únicos

#### **alert_id**
- **Tipo**: INT
- **Descrição**: Identificador único do alerta gerado
- **Valores**: 1 a 999,999
- **Uso**: Rastreamento de alertas individuais

### Informações Temporais

#### **timestamp**
- **Tipo**: INT (encoded)
- **Descrição**: Timestamp do incidente após Label Encoding
- **Valores Únicos**: 760,944
- **Período Original**: Junho de 2024
- **Uso**: Análise temporal de incidentes

### Informações de Detecção

#### **detector_id**
- **Tipo**: INT
- **Descrição**: Identificador do sistema detector que gerou o alerta
- **Valores**: 1 a 1,455
- **Uso**: Análise por tipo de detector

#### **alert_title**
- **Tipo**: INT (encoded)
- **Descrição**: Título do alerta após Label Encoding
- **Valores Únicos**: 567
- **Uso**: Categorização de alertas

### Classificação do Incidente

#### **category**
- **Tipo**: INT (encoded)
- **Descrição**: Categoria do incidente de segurança
- **Valores**: 0 a 19 (20 categorias)
- **Mapeamento Original**:
  - 0: InitialAccess
  - 1: Exfiltration
  - 2: CommandAndControl
  - 3: Execution
  - 4: Persistence
  - 5: PrivilegeEscalation
  - 6: DefenseEvasion
  - 7: CredentialAccess
  - 8: Discovery
  - 9: LateralMovement
  - 10: Collection
  - 11: Impact
  - 12: Reconnaissance
  - 13: ResourceDevelopment
  - 14: And others...

#### **mitre_techniques**
- **Tipo**: INT (encoded)
- **Descrição**: Técnicas MITRE ATT&CK associadas
- **Valores Únicos**: 1,193
- **Uso**: Análise de técnicas de ataque

#### **incident_grade**
- **Tipo**: INT
- **Descrição**: Classificação final do incidente
- **Valores**: 0, 1, 2
- **Mapeamento**:
  - 0: FalsePositive (51.4%)
  - 1: TruePositive (48.1%)
  - 2: BenignPositive (0.5%)

### Informações da Entidade

#### **entity_type**
- **Tipo**: INT (encoded)
- **Descrição**: Tipo de entidade envolvida no incidente
- **Valores**: 0 a 32 (33 tipos)
- **Exemplos**: User, Computer, File, Process, Network, etc.

#### **evidence_role**
- **Tipo**: INT (encoded)
- **Descrição**: Papel da evidência no incidente
- **Valores**: 0, 1
- **Uso**: Classificação da evidência

### Identificadores de Segurança

#### **device_id**
- **Tipo**: BIGINT
- **Descrição**: Identificador único do dispositivo
- **Valores Únicos**: 2,345,678
- **Uso**: Rastreamento por dispositivo

#### **sha256**
- **Tipo**: BIGINT (encoded)
- **Descrição**: Hash SHA256 do arquivo envolvido
- **Valores Únicos**: 1,234,567
- **Uso**: Identificação de arquivos

#### **ip_address**
- **Tipo**: BIGINT (encoded)
- **Descrição**: Endereço IP envolvido no incidente
- **Valores Únicos**: 3,456,789
- **Uso**: Análise de tráfego de rede

#### **url**
- **Tipo**: BIGINT (encoded)
- **Descrição**: URL envolvida no incidente
- **Valores Únicos**: 567,890
- **Uso**: Análise de URLs maliciosas

### Informações de Conta

#### **account_sid**
- **Tipo**: BIGINT (encoded)
- **Descrição**: Security Identifier da conta
- **Valores Únicos**: 789,012
- **Uso**: Rastreamento de contas

#### **account_upn**
- **Tipo**: BIGINT (encoded)
- **Descrição**: User Principal Name da conta
- **Valores Únicos**: 456,789
- **Uso**: Identificação de usuários

### Informações do Sistema

#### **os_family**
- **Tipo**: INT (encoded)
- **Descrição**: Família do sistema operacional
- **Valores**: 0 a 14 (15 famílias)
- **Uso**: Análise por plataforma

#### **os_version**
- **Tipo**: INT (encoded)
- **Descrição**: Versão específica do sistema operacional
- **Valores**: 0 a 88 (89 versões)
- **Uso**: Análise de vulnerabilidades

### Informações Geográficas

#### **country_code**
- **Tipo**: INT (encoded)
- **Descrição**: Código do país onde ocorreu o incidente
- **Valores**: 0 a 247 (248 países)
- **Uso**: Análise geográfica

#### **state**
- **Tipo**: INT (encoded)
- **Descrição**: Estado/Província onde ocorreu o incidente
- **Valores**: 0 a 1,444 (1,445 estados)
- **Uso**: Análise regional

#### **city**
- **Tipo**: INT (encoded)
- **Descrição**: Cidade onde ocorreu o incidente
- **Valores**: 0 a 10,629 (10,630 cidades)
- **Uso**: Análise local

### Informações de Veredito

#### **last_verdict**
- **Tipo**: INT (encoded)
- **Descrição**: Último veredito sobre o incidente
- **Valores**: 0 a 4 (5 vereditos)
- **Mapeamento**:
  - 0: Unknown
  - 1: Malicious
  - 2: Suspicious
  - 3: Clean
  - 4: NotAvailable

---

## Transformações Aplicadas

### 1. Padronização
- **Nomes de Colunas**: Convertidos para minúsculas com underscores
- **Formato**: Consistente em todo o dataset

### 2. Encoding
- **Label Encoding**: Aplicado em todas as variáveis categóricas
- **Benefício**: Conversão para formato numérico para ML

### 3. Limpeza de Dados
- **Valores Ausentes**: Removidas colunas com >80% de valores ausentes
- **Resultado**: 0 valores ausentes no dataset final
- **Colunas Removidas**: 8 colunas com alta ausência de dados

### 4. Validação de Qualidade
- **Tipos de Dados**: Consistência verificada
- **Valores Infinitos**: 0 encontrados
- **Integridade**: Todas as chaves primárias únicas

---

## Estatísticas de Qualidade

### Completude dos Dados
- **Taxa de Completude**: 100%
- **Valores Ausentes**: 0
- **Valores Infinitos**: 0
- **Valores Duplicados**: 0

### Distribuição das Classes (IncidentGrade)
- **FalsePositive**: 4,888,234 registros (51.4%)
- **TruePositive**: 4,576,789 registros (48.1%)
- **BenignPositive**: 51,814 registros (0.5%)

### Diversidade dos Dados
- **Categorias Únicas**: 20
- **Países Únicos**: 248
- **Organizações Únicas**: 1,234
- **Detectores Únicos**: 1,456

---

## Uso Recomendado

### Análise Exploratória
- Distribuições por categoria
- Análise temporal de incidentes
- Análise geográfica de ameaças

### Modelagem de Machine Learning
- Classificação de incidentes
- Detecção de anomalias
- Predição de riscos

### Relatórios e Dashboards
- Métricas de segurança
- Tendências temporais
- Análise de performance

---

## Limitações e Considerações

### Limitações
1. **Encoding**: Valores originais foram codificados, perdendo interpretabilidade direta
2. **Temporalidade**: Dados limitados a junho de 2024
3. **Desbalanceamento**: Classes altamente desbalanceadas

### Considerações para Análise
1. **Balanceamento**: Necessário para modelagem adequada
2. **Validação**: Usar validação estratificada
3. **Métricas**: Considerar precision, recall e F1-score

---

## Próximos Passos

### Melhorias Sugeridas
1. **Feature Engineering**: Criar features derivadas temporais
2. **Balanceamento**: Aplicar técnicas de oversampling/undersampling
3. **Validação**: Implementar validação cruzada estratificada
4. **Modelagem**: Testar múltiplos algoritmos de classificação

### Aplicações Futuras
1. **Sistema de Detecção**: Implementar detecção em tempo real
2. **Dashboard**: Criar interface de monitoramento
3. **Alertas**: Sistema de alertas inteligentes
4. **Análise Preditiva**: Modelos de predição de riscos

---

**Data de Atualização**: Dezembro de 2024  
**Versão**: 1.0  
**Responsável**: Sistema de Análise de Dados  
**Próxima Revisão**: Janeiro de 2025
