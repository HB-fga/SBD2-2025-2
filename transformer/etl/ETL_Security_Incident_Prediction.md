# Processo ETL - Microsoft Security Incident Prediction

## Visão Geral

Este documento descreve o processo ETL (Extract, Transform, Load) implementado para o dataset Microsoft Security Incident Prediction. O processo transforma dados brutos da camada Raw em dados limpos e estruturados na camada Silver, preparando-os para análise e modelagem de machine learning.

## Arquitetura de Dados

### Camadas de Dados
- **Raw Layer (Bronze)**: Dados brutos extraídos da fonte original
- **Silver Layer**: Dados limpos e transformados, prontos para análise
- **Gold Layer**: Dados agregados e enriquecidos para consumo final

### Estrutura de Pastas
```
sbd2/
├── raw/                           # Camada Raw (Bronze)
│   ├── train.csv                  # Dataset original
│   └── Dicionario_Dados_Security_Incident.md
├── silver/                        # Camada Silver
│   └── security_incident_prediction_silver.csv
└── transformer/etl/               # Processos ETL
    ├── raw_to_silver_security.ipynb
    └── ETL_Security_Incident_Prediction.pdf
```

## Processo ETL Detalhado

### 1. EXTRACT (Extração)

#### Objetivo
Extrair dados do arquivo CSV da camada Raw e carregá-los em memória para processamento.

#### Implementação
- Carregamento do arquivo `train.csv` usando pandas
- Configuração de `low_memory=False` para arquivos grandes
- Verificação inicial das dimensões do dataset

#### Código
```python
import pandas as pd
import numpy as np

# Carregamento do dataset
df = pd.read_csv('../../raw/train.csv', low_memory=False)
print(f"Dimensões do dataset: {df.shape}")
```

### 2. TRANSFORM (Transformação)

#### 2.1 Padronização dos Nomes das Colunas
- **Objetivo**: Padronizar nomes de colunas para facilitar processamento
- **Padrão**: Minúsculas com underscores separando palavras
- **Implementação**: Transformação automática de todos os nomes de colunas

#### 2.2 Análise de Valores Ausentes
- **Objetivo**: Identificar e quantificar valores ausentes
- **Métricas**: Contagem e percentual de valores nulos por coluna
- **Threshold**: 80% de valores ausentes para remoção de colunas

#### 2.3 Remoção de Colunas com Muitos Valores Ausentes
- **Critério**: Colunas com >80% de valores ausentes
- **Justificativa**: Colunas com muitos valores ausentes não agregam valor significativo
- **Impacto**: Redução da dimensionalidade do dataset

#### 2.4 Análise da Variável Target
- **Variável**: `HasDetections` (0 = Sem incidente, 1 = Com incidente)
- **Métricas**: Distribuição de classes e razão de balanceamento
- **Identificação**: Classes desbalanceadas para estratégias de modelagem

#### 2.5 Encoding de Variáveis Categóricas
- **Técnica**: Label Encoding
- **Aplicação**: Todas as colunas do tipo object
- **Benefício**: Conversão para formato numérico para algoritmos de ML

#### 2.6 Tratamento de Valores Ausentes
- **Estratégia Numérica**: Imputação com mediana
- **Estratégia Categórica**: Imputação com moda
- **Resultado**: Dataset sem valores ausentes

#### 2.7 Engenharia de Features
- **Feature 1**: `completeness_score` - Número de campos preenchidos
- **Feature 2**: `categorical_completeness` - Completude de features categóricas
- **Feature 3**: `completeness_ratio` - Razão de completude do registro

### 3. LOAD (Carregamento)

#### 3.1 Salvamento em CSV
- **Formato**: CSV sem índice
- **Localização**: Camada Silver
- **Nome**: `security_incident_prediction_silver.csv`

#### 3.2 Verificação de Qualidade
- **Métricas**: Dimensões, memória, valores ausentes, tipos de dados
- **Validação**: Ausência de valores infinitos e nulos
- **Documentação**: Metadados do processamento

## Transformações Aplicadas

### Tipos de Dados
- **Antes**: Mistura de object, float64, int64
- **Depois**: Principalmente int64 e float64 (após encoding)
- **Benefício**: Consistência para algoritmos de ML

### Dimensionalidade
- **Redução**: Remoção de colunas com muitos valores ausentes
- **Otimização**: Redução do uso de memória
- **Qualidade**: Manutenção da informação relevante

### Qualidade dos Dados
- **Valores Ausentes**: 0 após tratamento
- **Duplicatas**: Identificação e remoção
- **Consistência**: Padronização de formatos

## Métricas de Qualidade

### Antes do Processamento
- Dimensões: Variável (depende do dataset original)
- Valores Ausentes: Presentes em múltiplas colunas
- Tipos de Dados: Inconsistentes
- Encoding: Necessário para variáveis categóricas

### Após o Processamento
- Valores Ausentes: 0
- Tipos Consistentes: Numéricos e categóricos encoded
- Memória Otimizada: Redução do uso de RAM
- Pronto para ML: Formato adequado para algoritmos

## Benefícios do Processo ETL

### 1. Qualidade dos Dados
- Eliminação de valores ausentes
- Padronização de formatos
- Consistência de tipos de dados

### 2. Performance
- Redução da dimensionalidade
- Otimização do uso de memória
- Formato adequado para processamento

### 3. Preparação para ML
- Encoding de variáveis categóricas
- Features derivadas relevantes
- Dataset balanceado (se necessário)

### 4. Rastreabilidade
- Metadados do processamento
- Logs de transformações
- Versionamento dos dados

## Próximos Passos

### 1. Análise Exploratória
- Estatísticas descritivas
- Visualizações de distribuições
- Análise de correlações

### 2. Modelagem
- Seleção de algoritmos
- Treinamento de modelos
- Validação cruzada

### 3. Avaliação
- Métricas de performance
- Análise de importância de features
- Otimização de hiperparâmetros

### 4. Deploy
- Modelo em produção
- Monitoramento contínuo
- Retreinamento automático

## Considerações Técnicas

### Requisitos de Sistema
- **RAM**: Mínimo 8GB recomendado
- **Python**: 3.13
- **Bibliotecas**: pandas, numpy, scikit-learn

### Otimizações
- **Chunking**: Para datasets muito grandes
- **Paralelização**: Para transformações complexas
- **Cache**: Para reprocessamento

### Monitoramento
- **Logs**: Rastreamento de transformações
- **Métricas**: Qualidade dos dados
- **Alertas**: Falhas no processo

## Conclusão

O processo ETL implementado transforma com sucesso dados brutos de segurança em um dataset limpo e estruturado, adequado para análise e modelagem de machine learning. As transformações aplicadas garantem qualidade, consistência e performance, preparando os dados para as próximas etapas do pipeline de dados.

O resultado é um dataset Silver otimizado que mantém a informação relevante enquanto elimina problemas de qualidade, facilitando o desenvolvimento de modelos preditivos robustos para detecção de incidentes de segurança.
