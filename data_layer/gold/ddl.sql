-- ============================
-- DIMENSÃO TEMPO
-- ============================

-- Criar schema se não existir
CREATE SCHEMA IF NOT EXISTS dw;

-- Remover tabelas existentes (ordem correta: fato antes das dimensões)
DROP TABLE IF EXISTS dw.fat_inc;
DROP TABLE IF EXISTS dw.dim_tmp;
DROP TABLE IF EXISTS dw.dim_org;
DROP TABLE IF EXISTS dw.dim_sis;

-- ============================
-- DIMENSÃO TEMPO
-- ============================
CREATE TABLE dw.dim_tmp (
    srk_tmp INT PRIMARY KEY,
    tsp VARCHAR(30) NOT NULL
);

-- ============================
-- DIMENSÃO ORGANIZAÇÃO
-- ============================
CREATE TABLE dw.dim_org (
    srk_org INT PRIMARY KEY,
    acc_sid INT,
    acc_upn INT,
    ctr_cod INT,
    sta INT,
    cty INT
);

-- ============================
-- DIMENSÃO SISTEMA/ENTIDADE
-- ============================
CREATE TABLE dw.dim_sis (
    srk_sis INT PRIMARY KEY,
    dev_id INT,
    sha INT,
    url INT,
    osf INT,
    osv INT,
    dtc_id INT,
    alt_ttl INT,
    ent_typ VARCHAR(40)
);

-- ============================
-- TABELA FATO: INCIDENTES
-- ============================
CREATE TABLE dw.fat_inc (
    srk_inc INT PRIMARY KEY,
    srk_tmp INT REFERENCES dw.dim_tmp(srk_tmp),
    srk_org INT REFERENCES dw.dim_org(srk_org),
    srk_sis INT REFERENCES dw.dim_sis(srk_sis),
    alt_id INT,
    cat VARCHAR(30),
    mtr_tcn VARCHAR(100),
    inc_gde VARCHAR(20),
    evd_rol VARCHAR(20),
    lst_vrd VARCHAR(20),
    CONSTRAINT fk_tmp FOREIGN KEY (srk_tmp) REFERENCES dw.dim_tmp(srk_tmp),
    CONSTRAINT fk_org FOREIGN KEY (srk_org) REFERENCES dw.dim_org(srk_org),
    CONSTRAINT fk_sis FOREIGN KEY (srk_sis) REFERENCES dw.dim_sis(srk_sis)
);
