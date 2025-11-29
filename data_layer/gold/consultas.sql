-- consultas para camada GOLD - Microsoft Security Incident Prediction
-- Arquivo gerado: queries.sql
-- Observações:
--  - A tabela fato é `dw.fat_inc` e dimensões: `dw.dim_tmp`, `dw.dim_org`, `dw.dim_sis`.
--  - A coluna de tempo em `dw.dim_tmp.tsp` é armazenada como string 'YYYY-MM-DD HH24:MI:SS'.
--    Usamos to_timestamp(tsp, 'YYYY-MM-DD HH24:MI:SS') para convertê-la quando necessário.
--  - Ajuste os limites/parametros conforme necessário no seu dashboard.

-- =====================================================
-- Q1 - Incidentes por período (evolução diária)
-- Resultado: data, total_incidentes
-- Parâmetros sugeridos: período via WHERE em to_timestamp(tsp,...)
-- =====================================================
-- Exemplo de uso: remover o filtro para ver todo o histórico
-- ou usar BETWEEN '2025-01-01' AND '2025-01-31'
SELECT
  date_trunc('day', to_timestamp(t.tsp, 'YYYY-MM-DD HH24:MI:SS'))::date AS dia,
  COUNT(*) AS total_incidentes
FROM dw.fat_inc f
JOIN dw.dim_tmp t ON f.srk_tmp = t.srk_tmp
GROUP BY 1
ORDER BY 1;

-- =====================================================
-- Q2 - Análise temporal por dia (incidentes médios por dia)
-- Resultado: média diária de incidentes no período disponível
-- =====================================================
WITH daily AS (
  SELECT date_trunc('day', to_timestamp(t.tsp, 'YYYY-MM-DD HH24:MI:SS'))::date AS dia, COUNT(*) AS cnt
  FROM dw.fat_inc f
  JOIN dw.dim_tmp t ON f.srk_tmp = t.srk_tmp
  GROUP BY 1
)
SELECT
  COUNT(*) AS dias_reportados,
  AVG(cnt)::numeric(10,2) AS media_incidentes_por_dia,
  SUM(cnt) AS total_incidentes
FROM daily;

-- =====================================================
-- Q3 - Análise temporal por hora (média por hora)
-- Resultado: hora (0-23), média de incidentes naquela hora ao longo dos dias
-- =====================================================
WITH per_day_hour AS (
  SELECT
    date_trunc('day', to_timestamp(t.tsp, 'YYYY-MM-DD HH24:MI:SS'))::date AS dia,
    EXTRACT(hour FROM to_timestamp(t.tsp, 'YYYY-MM-DD HH24:MI:SS'))::int AS hora,
    COUNT(*) AS cnt
  FROM dw.fat_inc f
  JOIN dw.dim_tmp t ON f.srk_tmp = t.srk_tmp
  GROUP BY 1,2
)
SELECT
  hora,
  AVG(cnt)::numeric(8,2) AS media_incidentes_por_hora
FROM per_day_hour
GROUP BY hora
ORDER BY hora;

-- =====================================================
-- Q4 - Top 5 Organizações com mais incidentes
-- Resultado: org_id (acc_upn/acc_sid), contagem
-- =====================================================
SELECT
  COALESCE(o.acc_upn::text, o.acc_sid::text, 'unknown') AS organizacao,
  COUNT(*) AS total_incidentes
FROM dw.fat_inc f
LEFT JOIN dw.dim_org o ON f.srk_org = o.srk_org
GROUP BY 1
ORDER BY total_incidentes DESC
LIMIT 5;

-- =====================================================
-- Q5 - Incidentes por estado (Top 5)
-- Resultado: state, contagem
-- =====================================================
SELECT
  COALESCE(o.sta::text, 'unknown') AS state,
  COUNT(*) AS total_incidentes
FROM dw.fat_inc f
LEFT JOIN dw.dim_org o ON f.srk_org = o.srk_org
GROUP BY 1
ORDER BY total_incidentes DESC
LIMIT 5;

-- =====================================================
-- Q6 - Incidentes por cidade (Top 10)
-- Resultado: city, contagem
-- Observação: agora usamos dim_org para obter a cidade
-- =====================================================
SELECT
  COALESCE(o.cty::text, 'unknown') AS city,
  COUNT(*) AS total_incidentes
FROM dw.fat_inc f
LEFT JOIN dw.dim_org o ON f.srk_org = o.srk_org
GROUP BY 1
ORDER BY total_incidentes DESC
LIMIT 10;

-- =====================================================
-- Q7 - Veredito dos incidentes (porcentagens)
-- Resultado: verdict, count, percent
-- =====================================================
SELECT
  COALESCE(f.lst_vrd, 'unknown') AS verdict,
  COUNT(*) AS count,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percent
FROM dw.fat_inc f
GROUP BY 1
ORDER BY count DESC;

-- =====================================================
-- Q8 - MITRE Techniques mais frequentes
-- Observação: mtr_tcn pode conter múltiplas técnicas separadas por ',', '|' ou ';'
-- Resultado: technique, contagem (top 20)
-- =====================================================
SELECT
  TRIM(mt) AS technique,
  COUNT(*) AS total_occurrences
FROM dw.fat_inc f,
LATERAL (
  SELECT regexp_split_to_table(coalesce(f.mtr_tcn, ''), '[,|;]') AS mt
) split
WHERE coalesce(f.mtr_tcn, '') <> ''
GROUP BY 1
ORDER BY total_occurrences DESC
LIMIT 20;

-- =====================================================
-- Q9 - Análise de Categoria do ataque (Top categorias)
-- Resultado: category, contagem
-- =====================================================
SELECT
  COALESCE(f.cat, 'unknown') AS category,
  COUNT(*) AS total_incidentes
FROM dw.fat_inc f
GROUP BY 1
ORDER BY total_incidentes DESC
LIMIT 20;

-- =====================================================
-- Q10 - Análise das entidades envolvidas (Top entity types)
-- Resultado: entity_type, contagem
-- =====================================================
SELECT
  COALESCE(s.ent_typ, 'unknown') AS entity_type,
  COUNT(*) AS total_incidentes
FROM dw.fat_inc f
LEFT JOIN dw.dim_sis s ON f.srk_sis = s.srk_sis
GROUP BY 1
ORDER BY total_incidentes DESC
LIMIT 20;

-- =========================
-- FIM - Ajustes/Notas
-- - Se `dw.dim_tmp.tsp` já for do tipo timestamp no banco, substitua
--   to_timestamp(t.tsp, 'YYYY-MM-DD HH24:MI:SS') por t.tsp.
-- - Para dashboards, adicione filtros (WHERE) por intervalo de datas,
--   organização, país, severidade, etc.
-- - Para performance em grandes volumes, considere criar views materializadas
--   ou índices em `dw.dim_tmp(tsp)`, `dw.dim_org(ctr_cod)`, `dw.dim_sis(osf)`.
-- =========================
