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



CREATE TABLE dw.Dim_tmp (
    srk_tmp INT PRIMARY KEY,
    tsp VARCHAR(30) NOT NULL
);

-- ============================
-- DIMENSÃO ORGANIZAÇÃO
-- ============================
CREATE TABLE dw.Dim_org (
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
CREATE TABLE dw.Dim_sis (
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
CREATE TABLE dw.Fat_inc (
    srk_inc INT PRIMARY KEY,
    srk_tmp REFERENCES Dim_tmp(srk_tmp),
    srk_org REFERENCES Dim_org(srk_org),
    srk_sis REFERENCES Dim_sis(srk_sis),
    alt_id INT,
    cat VARCHAR(30),
    mtr_tcn VARCHAR(100),
    inc_gde VARCHAR(20),
    evd_rol ENUM('Related','Impacted'),
    lst_vrd VARCHAR(20),


    CONSTRAINT fk_tmp FOREIGN KEY (srk_tmp) REFERENCES DimTempo(srk_tmp),
    CONSTRAINT fk_org FOREIGN KEY (srk_org) REFERENCES DimOrganizacao(srk_org),
    CONSTRAINT fk_sis FOREIGN KEY (srk_sis) REFERENCES DimSistema(srk_sis)
);
