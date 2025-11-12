# Consultas SQL e Análise

Arquivo com 3 consultas SQL analíticas e interpretações.

1) Top 10 organizações por número de incidentes (últimos 30 dias)

SQL:
```sql
SELECT o.organization_external_id, COUNT(*) AS incidents
FROM f_incident f
JOIN d_organization o ON f.org_key = o.org_key
JOIN d_time t ON f.time_key = t.time_key
WHERE t.event_date >= (CURRENT_DATE - INTERVAL '30 days')
GROUP BY o.organization_external_id
ORDER BY incidents DESC
LIMIT 10;
```
Interpretação: lista as organizações com maior quantidade de incidentes recentes — útil para priorização de atendimento e alocação de recursos.

2) Distribuição de incidentes por categoria e severidade

SQL:
```sql
SELECT a.category, f.incident_grade, COUNT(*) AS incidents
FROM f_incident f
JOIN d_alert a ON f.alert_key = a.alert_key
GROUP BY a.category, f.incident_grade
ORDER BY incidents DESC;
```
Interpretação: permite identificar categorias com mais incidentes e sua severidade (incident_grade), ajudando a entender riscos principais.

3) Séries temporais: incidentes por dia (últimos 90 dias)

SQL:
```sql
SELECT t.event_date, COUNT(*) AS incidents
FROM f_incident f
JOIN d_time t ON f.time_key = t.time_key
WHERE t.event_date >= (CURRENT_DATE - INTERVAL '90 days')
GROUP BY t.event_date
ORDER BY t.event_date;
```
Interpretação: visualização de tendência — picos podem indicar campanhas de ataque, mudanças em detecções, ou falsos positivos em massa.

Consultas adicionais sugeridas:
- Top técnicas MITRE por número de incidentes
- Incidentes por os_family (para identificar plataformas mais afetadas)
- Heatmap por country_code / city (mapas no Power BI)

Validação de resultados: comparar contagens entre staging e fato, além de amostragem de linhas para confirmar mapeamento de chaves.

Conclusões exemplo (modelo):
- Se uma organização aparece consistentemente no topo, investigue postura de segurança e regras de detecção.
- Categorias com alta severidade requerem playbooks e SLA reduzido.
- Picos temporais podem coincidir com atualizações de produtos, campanhas maliciosas ou alterações no detector — correlacione com eventos externos.

Próximo passo: integrar estas tabelas ao Power BI usando `f_incident` como fonte principal, com `d_time` para o eixo temporal e `d_organization`/`d_alert` como slicers/dimensões.
