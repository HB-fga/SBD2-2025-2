-- Consultas analíticas empacotadas em `consultas.sql`

-- 1) Top 10 organizações por número de incidentes (últimos 30 dias)
SELECT o.organization_external_id, COUNT(*) AS incidents
FROM f_incident f
JOIN d_organization o ON f.org_key = o.org_key
JOIN d_time t ON f.time_key = t.time_key
WHERE t.event_date >= (CURRENT_DATE - INTERVAL '30 days')
GROUP BY o.organization_external_id
ORDER BY incidents DESC
LIMIT 10;

-- 2) Distribuição de incidentes por categoria e severidade
SELECT a.category, f.incident_grade, COUNT(*) AS incidents
FROM f_incident f
JOIN d_alert a ON f.alert_key = a.alert_key
GROUP BY a.category, f.incident_grade
ORDER BY incidents DESC;

-- 3) Séries temporais: incidentes por dia (últimos 90 dias)
SELECT t.event_date, COUNT(*) AS incidents
FROM f_incident f
JOIN d_time t ON f.time_key = t.time_key
WHERE t.event_date >= (CURRENT_DATE - INTERVAL '90 days')
GROUP BY t.event_date
ORDER BY t.event_date;
