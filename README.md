# Projeto de Engenharia de Dados: Microsoft Malware Prediction

## 1. Contexto do Projeto

Este projeto, desenvolvido para a disciplina **Sistemas de Banco de Dados 2 da Universidade de Brasília (UnB)**, implementa uma arquitetura **Lakehouse** baseada no padrão **Medallion** para processar o *dataset* de Previsão de Malware da Microsoft (Kaggle). O objetivo é construir um pipeline de dados robusto, desde a ingestão (Raw) até a camada de consumo (Gold), para suportar análises de Business Intelligence (BI) e Data Science.

### 1.1. Fonte de Dados

* **Dataset:** Microsoft Malware Prediction (Kaggle)
* **Objetivo:** Prever a probabilidade de uma máquina Windows ser infectada por malware (`HasDetections`).

### 1.2. Arquitetura e Tecnologia

| Camada | Pasta | Descrição |
| :--- | :--- | :--- |
| **Bronze (Raw)** | `/raw` | Dados brutos (`train.csv`, `test.csv`) em seu formato original. |
| **Silver (Lakehouse)** | `/silver` | Dados limpos, padronizados e estruturados (base para o Lakehouse). |
| **Gold (Data Warehouse)** | `/gold` | Modelos de dados otimizados (Star Schema) para consumo e BI. |

**Tecnologias Core da Infraestrutura:**
* **Orquestração/Ambiente:** Docker e Docker Compose.
* **Processamento/ETL:** PySpark (para escalabilidade).
* **Lakehouse:** PostgreSQL.

### 1.3. Equipe do Projeto

O projeto está sendo desenvolvido pelos seguintes colaboradores:

* [**Hugo Bezerra**](https://github.com/HB-fga)
* [**Fabio Araujo**](https://github.com/fabiofonteles1)
* [**Igor Thiago**](https://github.com/Igor-thiago)
* [**Breno Yuri**](https://github.com/YuriBre)

---

## 2. Ponto de Controle 1 (PC1) - Escopo

O PC1 cobre a **Infraestrutura**, a **Modelagem Silver** e a primeira fase do pipeline de dados (**Raw $\rightarrow$ Silver**).

### 2.1. Entregáveis Chave

* **Infraestrutura:** Ambiente Docker/PySpark funcional e script de automação (`jobETL/run.sh`).
* **Modelagem Silver:** **MER**, **DER** e **DDL** (scripts de criação de tabelas).
* **Pipeline ETL:** **Job ETL** que popula a camada Silver (`jobETL/pipeline_raw_to_silver.py`).
* **Documentação:** **Dicionário de Dados** (Bronze) e **Notebook de Análise** exploratória.

### 2.2. Como Inicializar o Ambiente

Certifique-se de que os arquivos do *dataset* estejam na pasta `/raw`.

1.  **Construir e Iniciar o Pipeline:**
    ```bash
    docker compose up --build
    ```
    *Este comando automatiza: 1) Subida do PostgreSQL. 2) Construção e execução do container ETL/PySpark. 3) Execução do DDL para criar tabelas e rodar o Job ETL.*

---

## 3. Guia de Commits

Para manter o histórico do Git limpo e rastreável, utilizaremos a convenção **Conventional Commits**: `[tipo](escopo): [descrição concisa]`.

| Tipo | Uso | Exemplo de Mensagem |
| :--- | :--- | :--- |
| **feat** | Adição de nova funcionalidade (criação do ETL ou Star Schema). | `feat(etl): Implementa a lógica de limpeza Raw para Silver.` |
| **build** | Mudanças em arquivos de configuração de ambiente (Docker, dependências). | `build(infra): Atualiza Dockerfile para incluir a imagem PySpark.` |
| **fix** | Correção de um bug ou erro. | `fix(etl): Corrige erro de tipo de dados na coluna 'SmartScreen'.` |
| **docs** | Alterações em documentação (README, Dicionário, DLD). | `docs(dd): Cria o Dicionário de Dados da camada Bronze.` |
| **model** | Mudanças na modelagem de dados (MER, DER, DDL). | `model(silver): Adiciona DDL da tabela 'dim_maquina'.` |