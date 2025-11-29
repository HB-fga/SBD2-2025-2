CREATE SCHEMA IF NOT EXISTS dw;

DROP TABLE IF EXISTS dw.fat_inc;
DROP TABLE IF EXISTS dw.dim_tmp;
DROP TABLE IF EXISTS dw.dim_org;
DROP TABLE IF EXISTS dw.dim_sis;

<<<<<<< HEAD
-- DIMENSÃO TEMPO
CREATE TABLE dw.dim_tmp (
    srk_tmp SERIAL PRIMARY KEY,
    tsp TIMESTAMP NOT NULL
=======
-- ============================
-- DIMENSÃO TEMPO
-- ============================
CREATE TABLE dw.dim_tmp (
    srk_tmp INT PRIMARY KEY,
    tsp VARCHAR(30) NOT NULL
>>>>>>> 5eb941c3eb73c0c34e9b52251bf0ede977d600fb
);

-- DIMENSÃO ORGANIZAÇÃO
<<<<<<< HEAD
CREATE TABLE dw.dim_org (
    srk_org SERIAL PRIMARY KEY,
    acc_sid VARCHAR(255),
    acc_upn VARCHAR(255),
    ctr_cod VARCHAR(10),
    sta VARCHAR(100),
    cty VARCHAR(100)
=======
-- ============================
CREATE TABLE dw.dim_org (
    srk_org INT PRIMARY KEY,
    acc_sid INT,
    acc_upn INT,
    ctr_cod INT,
    sta INT,
    cty INT
>>>>>>> 5eb941c3eb73c0c34e9b52251bf0ede977d600fb
);

-- DIMENSÃO SISTEMA/ENTIDADE
<<<<<<< HEAD
CREATE TABLE dw.dim_sis (
    srk_sis SERIAL PRIMARY KEY,
    dev_id VARCHAR(255),
    sha VARCHAR(255),
    url TEXT,
    osf VARCHAR(100),
    osv VARCHAR(100),
    dtc_id VARCHAR(255),
    alt_ttl VARCHAR(255),
    ent_typ VARCHAR(100)
);

-- TABELA FATO
CREATE TABLE dw.fat_inc (
    srk_inc BIGINT PRIMARY KEY,
    srk_tmp INTEGER,
    srk_org INTEGER,
    srk_sis INTEGER,
    alt_id BIGINT,
    cat VARCHAR(255),
    mtr_tcn VARCHAR(255),
    inc_gde VARCHAR(50),
    evd_rol VARCHAR(255),
    lst_vrd VARCHAR(255),
    FOREIGN KEY (srk_tmp) REFERENCES dw.dim_tmp(srk_tmp),
    FOREIGN KEY (srk_org) REFERENCES dw.dim_org(srk_org),
    FOREIGN KEY (srk_sis) REFERENCES dw.dim_sis(srk_sis)
);
=======
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
>>>>>>> 5eb941c3eb73c0c34e9b52251bf0ede977d600fb
