-- Migração para ajustar d_time em bancos já existentes
BEGIN;

-- adicionar coluna natural key se não existir
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'public' AND table_name = 'd_time' AND column_name = 'time_natural_key'
    ) THEN
        ALTER TABLE d_time ADD COLUMN time_natural_key BIGINT;
    END IF;
END$$;

-- tornar event_timestamp nullable (caso esteja como NOT NULL)
ALTER TABLE d_time ALTER COLUMN event_timestamp DROP NOT NULL;
ALTER TABLE d_time ALTER COLUMN event_date DROP NOT NULL;

-- criar índice único na chave natural (se não existir)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relkind = 'i' AND c.relname = 'ux_d_time_time_natural_key'
    ) THEN
        CREATE UNIQUE INDEX ux_d_time_time_natural_key ON d_time(time_natural_key);
    END IF;
END$$;

COMMIT;
