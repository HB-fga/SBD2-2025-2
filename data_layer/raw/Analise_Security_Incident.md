# Dicionário de Dados - Microsoft Security Incident Prediction

## Camada Bronze - Raw Data

**Dataset:** Microsoft Security Incident Prediction (GUIDE Dataset)  
**Fonte:** Kaggle - Microsoft Security Incident Prediction  
**Período dos Dados:** Junho 2024  
**Total de Registros:** ~9.5 milhões de registros brutos (antes de limpeza)  
**Total de Colunas:** 45 colunas (44 features + 1 target)  

---

## 1. Informações Gerais sobre o Dataset

### 1.1 Descrição Geral

O dataset **GUIDE (Microsoft Security Incident Prediction)** contém dados reais de incidentes de segurança coletados pela Microsoft para identificar padrões de ameaças cibernéticas. Os dados estão estruturados em três níveis hierárquicos:

- **Evidence (Evidência):** Unidade atômica mais básica (IP, Email, User, Machine, File, etc.)
- **Alerts (Alertas):** Consolidação de múltiplas evidências indicando potenciais ameaças
- **Incidents (Incidentes):** Agrupamento coerente de um ou mais alertas representando eventos de segurança

### 1.2 Objetivo do Dataset

Predizer a **classificação (trilagem) de incidentes de segurança** em três categorias:
- **TruePositive (TP):** Incidentes confirmados como ameaças reais
- **FalsePositive (FP):** Falsos alarmes
- **BenignPositive (BP):** Incidentes benignos ou de baixo risco

### 1.3 Características do Dataset

- **Total de Registros:** 9,516,837 (na camada Bronze)
- **Total de Colunas:** 45
- **Período Observado:** Junho 2024
- **Países Únicos:** 236
- **Organizações Únicas:** 5,300+
- **Detectores Únicos:** 7,800+
- **Tipos de Entidades:** 33 tipos diferentes
- **Categorias de Alertas:** 20 categorias diferentes

---

## 2. Estrutura de Colunas

### 2.1 Identificadores (7 colunas)

| # | Coluna | Tipo | Descrição | Cardinalidade | Valores Ausentes |
|---|--------|------|-----------|---------------|------------------|
| 1 | **Id** | Integer/String | Identificador único do par (OrgId, IncidentId, AlertId, Evidence). Identificador global do registro. | Alta | 0% |
| 2 | **OrgId** | Integer | Identificador da organização cliente da Microsoft. Identifica qual organização o incidente pertence. | 5,300+ | 0% |
| 3 | **IncidentId** | Integer | Identificador único do incidente dentro da organização. Agrupa múltiplos alertas relacionados. | Alta | 0% |
| 4 | **AlertId** | Integer | Identificador único do alerta. Cada alerta é gerado por um detector específico. | Alta | 0% |
| 5 | **DetectorId** | Integer | Identificador único do detector que gerou o alerta. Pode ser built-in ou custom. | 7,800+ | 0% |
| 6 | **DeviceId** | Integer | Identificador único do dispositivo/máquina envolvida no incidente. Identifica a máquina comprometida. | Alta | Baixo |
| 7 | **ApplicationId** | String | Identificador único da aplicação envolvida na ameaça. UUID ou GUID. | Alta | Alto |

### 2.2 Informações Temporais (1 coluna)

| # | Coluna | Tipo | Descrição | Exemplo | Valores Ausentes |
|---|--------|------|-----------|---------|------------------|
| 1 | **Timestamp** | DateTime | Data e hora em que o alerta foi criado (formato ISO 8601 com timezone UTC). | 2024-06-04 06:05:15+00:00 | 0% |

### 2.3 Classificações e Categorias (6 colunas)

| # | Coluna | Tipo | Descrição | Valores Possíveis | Valores Ausentes |
|---|--------|------|-----------|-------------------|------------------|
| 1 | **Category** | String | Categoria MITRE ATT&CK do alerta. Fase do ataque. | InitialAccess, Exfiltration, Execution, CommandAndControl, Impact, etc. | 0% |
| 2 | **MitreTechniques** | String | Técnicas MITRE ATT&CK específicas (ex: T1078, T1566, T1189). Pode conter múltiplas técnicas separadas por delimitador. | T1078, T1566, T1189, T1133, etc. | 57.46% |
| 3 | **IncidentGrade** | Categorical | **VARIÁVEL TARGET**. Classificação SOC do incidente. | TruePositive, FalsePositive, BenignPositive | 0.54% (removidos) |
| 4 | **AlertTitle** | String | Título descritivo do alerta gerado pelo detector. | "Suspicious Process Execution", "Anomalous Login" | 0% |
| 5 | **ActionGrouped** | String | Ação de remediação agrupada (alto nível). Recomendação de ação. | Recomendações categorizadas | 99.41% |
| 6 | **ActionGranular** | String | Ação de remediação granular (detalhada/específica). Ação técnica específica recomendada. | Instruções técnicas detalhadas | 99.41% |

### 2.4 Entidades e Evidências (8 colunas)

| # | Coluna | Tipo | Descrição | Exemplos de Valores | Valores Ausentes |
|---|--------|------|-----------|-------------------|------------------|
| 1 | **EntityType** | Categorical | Tipo de entidade/evidência envolvida no incidente. | Ip, User, MailMessage, Machine, File, Url, etc. | 0% |
| 2 | **EvidenceRole** | Categorical | Papel da evidência na investigação do incidente. | Impacted, Related, Source | Baixo |
| 3 | **Sha256** | String | Hash SHA-256 do arquivo envolvido. Identifica arquivos únicos. | 64 caracteres hexadecimais | Alto |
| 4 | **IpAddress** | String | Endereço IP envolvido (origem ou destino). IPv4 ou IPv6. | 192.168.1.1, 2001:db8::1 | Alto |
| 5 | **Url** | String | URL/URI envolvida na ameaça. Pode ser maliciosa ou suspeita. | http://example.com | Alto |
| 6 | **FileName** | String | Nome do arquivo executável ou suspeito. | malware.exe, script.ps1 | Alto |
| 7 | **FolderPath** | String | Caminho da pasta do arquivo no sistema de arquivos. | C:\Windows\System32 | Alto |
| 8 | **DeviceName** | String | Nome legível do dispositivo/máquina. | "USER-LAPTOP-01", "SERVER-01" | Baixo |

### 2.5 Informações de Conta (4 colunas)

| # | Coluna | Tipo | Descrição | Exemplo | Valores Ausentes |
|---|--------|------|-----------|---------|------------------|
| 1 | **AccountSid** | String | Security Identifier (SID) da conta em sistemas on-premises. Identifica contas locais. | S-1-5-21-... | Alto |
| 2 | **AccountUpn** | String | User Principal Name (UPN) - email da conta. Formato: usuario@dominio.com | user@microsoft.com | Alto |
| 3 | **AccountObjectId** | String | Identificador de objeto da conta no Azure AD/Entra ID. UUID/GUID. | 550e8400-e29b-41d4-a716-446655440000 | Alto |
| 4 | **AccountName** | String | Nome da conta em sistemas on-premises. | Administrator, Guest, ServiceAccount | Alto |

### 2.6 Informações de Aplicação (3 colunas)

| # | Coluna | Tipo | Descrição | Exemplo | Valores Ausentes |
|---|--------|------|-----------|---------|------------------|
| 1 | **ApplicationId** | String | Identificador único da aplicação/software. | UUID/GUID | Alto |
| 2 | **ApplicationName** | String | Nome legível da aplicação. | Windows Defender, Outlook, Chrome | Alto |
| 3 | **OAuthApplicationId** | String | Identificador da aplicação OAuth (para integrações). | ID específico de aplicação OAuth registrada | Alto |

### 2.7 Informações de Email (2 colunas)

| # | Coluna | Tipo | Descrição | Exemplo | Valores Ausentes |
|---|--------|------|-----------|---------|------------------|
| 1 | **NetworkMessageId** | String | Identificador único da mensagem de email (nível organizacional). Identifica emails em M365. | UUID único por organização | Alto |
| 2 | **EmailClusterId** | String | Identificador do cluster de emails similares. Agrupa emails do mesmo phishing/ataque. | ID que agrupa emails similares | 98.98% |

### 2.8 Informações de Registro (3 colunas)

| # | Coluna | Tipo | Descrição | Exemplo | Valores Ausentes |
|---|--------|------|-----------|---------|------------------|
| 1 | **RegistryKey** | String | Chave do registro do Windows envolvida. Chave do Registro que foi acessada/modificada. | HKEY_LOCAL_MACHINE\SOFTWARE\... | Alto |
| 2 | **RegistryValueName** | String | Nome do valor dentro da chave do registro. | "ImagePath", "Start", "DisplayName" | Alto |
| 3 | **RegistryValueData** | String | Dados/conteúdo do valor do registro. | Valor específico armazenado | Alto |

### 2.9 Informações de Recursos Azure (2 colunas)

| # | Coluna | Tipo | Descrição | Exemplo | Valores Ausentes |
|---|--------|------|-----------|---------|------------------|
| 1 | **ResourceIdName** | String | Nome do recurso Azure envolvido. | Nome do recurso em Azure | Muito Alto |
| 2 | **ResourceType** | String | Tipo do recurso Azure (Storage, VM, Function, etc.). | "Microsoft.Storage/storageAccounts" | 99.93% |

### 2.10 Metadados (2 colunas)

| # | Coluna | Tipo | Descrição | Exemplo | Valores Ausentes |
|---|--------|------|-----------|---------|------------------|
| 1 | **ThreatFamily** | String | Família de malware associada a um arquivo. Classificação de malware. | Trojan.Win32, Ransom.Conti, etc. | 99.21% |
| 2 | **Roles** | String | Metadados adicionais sobre o papel da evidência no alerta. Contexto adicional da investigação. | Informações de contexto | 97.71% |

### 2.11 Informações do Sistema (2 colunas)

| # | Coluna | Tipo | Descrição | Exemplo | Valores Ausentes |
|---|--------|------|-----------|---------|------------------|
| 1 | **OSFamily** | Categorical | Família do sistema operacional. | Windows, Linux, macOS, Android | Baixo |
| 2 | **OSVersion** | String | Versão específica do sistema operacional. | Windows 10 (Build 19042), Ubuntu 20.04 | Baixo |

### 2.12 Informações de Segurança (3 colunas)

| # | Coluna | Tipo | Descrição | Valores Possíveis | Valores Ausentes |
|---|--------|------|-----------|-------------------|------------------|
| 1 | **AntispamDirection** | Categorical | Direção do filtro antispam (Inbound/Outbound). | Inbound, Outbound, Intra-org | 98.14% |
| 2 | **SuspicionLevel** | Categorical | Nível de suspeita/confiança da ameaça. | Low, Medium, High, Critical | 84.83% |
| 3 | **LastVerdict** | String | Veredito final da análise de ameaça/malware. | Suspicious, Malware, Clean, Unknown | 76.52% |

### 2.13 Informações Geográficas (3 colunas)

| # | Coluna | Tipo | Descrição | Exemplo | Valores Ausentes |
|---|--------|------|-----------|---------|------------------|
| 1 | **CountryCode** | String | Código ISO 3166-1 alpha-2 do país onde a evidência aparece. | US, BR, GB, JP | Baixo |
| 2 | **State** | String | Estado/Provincia onde a evidência aparece. | California, São Paulo, London | Médio |
| 3 | **City** | String | Cidade onde a evidência aparece (baseada em geolocalização de IP ou registro). | San Francisco, São Paulo, Tokyo | Médio |

---

## 3. Variável Target (IncidentGrade)

### 3.1 Distribuição da Classe Target

A variável **IncidentGrade** possui três classes com as seguintes proporções (conforme observado nos dados):

| Classe | Proporção | Descrição |
|--------|-----------|-----------|
| **BenignPositive (BP)** | ~42-46% | Incidentes informativos, alertas legítimos de baixo risco, atividades normais flagueadas incorretamente |
| **TruePositive (TP)** | ~19-35% | Incidentes confirmados como ameaças reais, eventos de segurança confirmados |
| **FalsePositive (FP)** | ~21-35% | Falsos alarmes, detecções incorretas, atividades legítimas flagueadas como suspeitas |

**Nota Importante:** A distribuição varia significativamente entre regiões e organizações. Não há uma proporção fixa global.

### 3.2 Desbalanceamento de Classes

- **Desbalanceamento Moderado:** As classes não estão extremamente desbalanceadas
- **Maioria:** BenignPositive representa aproximadamente metade dos dados em média
- **Minoria:** Dependendo da região, pode ser TP ou FP
- **Implicações:** Requer técnicas de balanceamento (SMOTE, class weights, stratified sampling)

---

## 4. Análise de Valores Ausentes (Missing Values)

### 4.1 Colunas com Altíssimas Proporções de Valores Ausentes (>95%)

Estas colunas apresentam mais de 95% de valores faltantes e são **recomendadas para remoção** na camada Bronze ou Silver:

| Coluna | % Ausentes | Motivo | Recomendação |
|--------|-----------|--------|--------------|
| ResourceType | 99.93% | Raramente aplicável (apenas recursos Azure) | **REMOVER** |
| ActionGrouped | 99.41% | Recomendações de ação raramente preenchidas | **REMOVER** |
| ActionGranular | 99.41% | Ações granulares raramente preenchidas | **REMOVER** |
| ThreatFamily | 99.21% | Apenas preenchido para malware conhecido | **REMOVER** |
| EmailClusterId | 98.98% | Apenas para incidentes de email | **REMOVER** |
| AntispamDirection | 98.14% | Apenas para incidentes de email/antispam | **REMOVER** |
| Roles | 97.71% | Metadados raramente preenchidos | **REMOVER** |

### 4.2 Colunas com Altas Proporções de Valores Ausentes (50-95%)

| Coluna | % Ausentes | Motivo | Recomendação |
|--------|-----------|--------|--------------|
| SuspicionLevel | 84.83% | Nem sempre calculado | **CONSIDERAR REMOÇÃO** |
| LastVerdict | 76.52% | Veredito nem sempre disponível | **CONSIDERAR REMOÇÃO** |
| MitreTechniques | 57.46% | Nem todos os alertas têm técnica MITRE mapeada | **MANTER COM CUIDADO** |

### 4.3 Colunas com Valores Ausentes Baixos (<50%)

Estas colunas apresentam baixo volume de dados faltantes e devem ser mantidas:

- **Entidades (EntityType, IpAddress, Url, FileName, etc.):** Variam conforme o tipo de alerta
- **Contatos (AccountSid, AccountUpn, etc.):** Variam conforme o tipo de incidente
- **Identificadores (DeviceId, ApplicationId, etc.):** Geralmente presentes

### 4.4 Colunas sem Valores Ausentes (0%)

Estas colunas são **completas e sempre preenchidas**:
- Id, OrgId, IncidentId, AlertId, Timestamp, DetectorId, AlertTitle
- Category, IncidentGrade, EntityType, EvidenceRole, CountryCode, OSFamily, OSVersion

---

## 5. Tipos de Dados e Cardinalidade

### 5.1 Resumo de Tipos de Dados

| Tipo | Contagem | Exemplos |
|------|----------|----------|
| **String/Varchar** | 20 | Id, AlertTitle, Sha256, IpAddress, Url, etc. |
| **Integer** | 10 | OrgId, IncidentId, AlertId, DetectorId, DeviceId, etc. |
| **DateTime** | 1 | Timestamp |
| **Categorical/Enum** | 8 | Category, IncidentGrade, EntityType, EvidenceRole, OSFamily, etc. |
| **Boolean** | 0 | (Nenhuma coluna booleana confirmada) |

### 5.2 Cardinalidade de Colunas Chave

| Coluna | Cardinalidade Estimada | Tipo |
|--------|------------------------|------|
| OrgId | ~5,300 | Alta (dimensão de cliente) |
| DetectorId | ~7,800 | Alta (muitos detectores) |
| IncidentId | Muito Alta | Alta (único por organização) |
| AlertId | Muito Alta | Alta (único por incidente) |
| EntityType | 33 | Baixa (categorias fixas) |
| Category | 20 | Baixa (categorias MITRE) |
| CountryCode | 236 | Média-Alta (geográfico) |
| IncidentGrade | 3 | Muito Baixa (3 classes) |

---

## 6. Observações Importantes sobre a Qualidade dos Dados

### 6.1 Desafios Identificados

1. **Alta Dimensionalidade:** 45 colunas com muitas potencialmente irrelevantes ou redundantes
2. **Dados Altamente Esparsos:** Muitos campos são específicos de certos tipos de incidentes
3. **Desbalanceamento de Classes:** Embora moderado, requer tratamento
4. **Valores Ausentes Estruturais:** A ausência não é aleatória, mas relacionada ao tipo de incidente
5. **Cardinalidade Variável:** Algumas colunas têm altíssima cardinalidade, outras muito baixa
6. **Hierarquia de Dados:** Estrutura aninhada (Evidence → Alerts → Incidents) complexa
7. **Período Limitado:** Dados de apenas ~2 semanas (meados de junho 2024)

### 6.2 Duplicatas

Conforme mencionado no notebook original:
- ~9.3 milhões de registros duplicados identificados
- Necessário deduplicar antes de análises exploratórias

### 6.3 Recomendações para Limpeza (Bronze → Silver)

1. **Remover colunas com >95% valores ausentes:**
   - ResourceType, ActionGrouped, ActionGranular, ThreatFamily, EmailClusterId, AntispamDirection, Roles

2. **Considerar remover:**
   - SuspicionLevel (84.83% ausentes)
   - LastVerdict (76.52% ausentes)

3. **Tratar valores ausentes:**
   - Preencher com "Unknown" ou "Not Applicable" para categóricas
   - Remover registros com IncidentGrade ausente (0.54%)

4. **Deduplicação:**
   - Remover duplicatas exatas antes de análise

5. **Tratamento de Tipos de Dados:**
   - Converter string timestamps para datetime
   - Categorizar variáveis categóricas explicitamente

---

## 7. Análise de Categorias e Técnicas

### 7.1 Categorias de Alertas Identificadas

As 20 categorias principais baseadas no MITRE ATT&CK framework:
- InitialAccess (42% dos incidentes)
- Exfiltration (17%)
- Execution
- Persistence
- Privilege Escalation
- SuspiciousActivity (11%)
- CommandAndControl (~5%)
- Impact (~4%)
- E outras 12 categorias

### 7.2 Técnicas MITRE ATT&CK

O dataset cobre **441 técnicas MITRE ATT&CK** diferentes, incluindo:
- T1078 (Valid Accounts) - 1,351,196 ocorrências
- T1566 (Phishing) - Múltiplas sub-técnicas
- T1133 (External Remote Services) - 145,579 ocorrências
- T1110 (Brute Force) - 88,661 ocorrências
- T1087 (Account Discovery) - 54,564 ocorrências
- E 436 outras técnicas

### 7.3 Tipos de Entidades (EntityType)

Os 33 tipos de entidades incluem:
- **Ip:** 24.38% dos incidentes
- **User:** 21.06% dos incidentes
- **MailMessage:** 11.26% dos incidentes
- **Machine:** ~8% dos incidentes
- **File:** ~7% dos incidentes
- E 28 outros tipos

---

## 8. Fluxo de Processamento Recomendado (Bronze → Silver)

### 8.1 Etapas de Limpeza

1. **Carregamento e Validação** → Verificar integridade dos dados
2. **Deduplicação** → Remover 9.3M registros duplicados
3. **Remoção de Colunas** → Remover colunas com >95% ausentes
4. **Tratamento de Missing** → Imputar ou remover conforme apropriado
5. **Validação de Tipos** → Garantir tipos de dados corretos
6. **Tratamento de Outliers** → Identificar e tratar anomalias
7. **Validação de Domínio** → Verificar regras de negócio

### 8.2 Técnicas de Tratamento de Desbalanceamento

- **Oversampling (SMOTE):** Para aumentar minoria
- **Undersampling:** Para reduzir maioria
- **Class Weights:** Ponderar penalidades no modelo
- **Stratified Split:** Manter proporções em train/val/test

---

## 9. Referências e Fontes

- Dataset Oficial: https://www.kaggle.com/datasets/Microsoft/microsoft-security-incident-prediction
- MITRE ATT&CK Framework: https://attack.mitre.org/
- Documentação Microsoft Security: https://docs.microsoft.com/en-us/security/
- Paper GUIDE: AI-Driven Guided Response for Security Operation Centers

---
