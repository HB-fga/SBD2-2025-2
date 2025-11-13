<#
scripts/run_in_docker.ps1
Orquestra Docker Compose (Postgres + pgAdmin), copia arquivos SQL/CSV para o container e executa DDL, carga e ETL.
Uso: executar na raiz do repositório (PowerShell)
#>

$ErrorActionPreference = 'Stop'
$containerName = 'microsoft-security-prediction-database'
$composeFile = 'docker-compose.yml'
Write-Host "Subindo containers via docker-compose..."
Write-Host "Pipeline concluído. Acesse pgAdmin em http://localhost:8080 (user: admin@admin.com / admin) se desejar visualizar os dados." -ForegroundColor Green

Write-Host "Aguardando Postgres iniciar (pg_isready)..."
# aguarda até o Postgres estar pronto
for ($i=0; $i -lt 60; $i++) {
    # executar pg_isready dentro do container e capturar código de saída
    docker exec $containerName pg_isready -U postgres >$null 2>&1
    if ($LASTEXITCODE -eq 0) { break }
    Start-Sleep -Seconds 1
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "Postgres não respondeu dentro do timeout." -ForegroundColor Red
    exit 1
}

Write-Host "Copiando arquivos SQL e CSV para o container..."
# Caminhos relativos esperados
$filesToCopy = @(
    'sql/ddl_create_star_schema.sql',
    'sql/staging_ddl.sql',
    'sql/ddl_migrations.sql',
    'sql/etl_silver_to_gold.sql'
)

foreach ($f in $filesToCopy) {
    if (Test-Path $f) {
        $dest = "${containerName}:/tmp/$((Split-Path $f -Leaf))"
        docker cp $f $dest
        Write-Host "Copiado: $f -> $dest"
    } else {
        Write-Host "Arquivo não encontrado: $f" -ForegroundColor Yellow
    }
}

$csvPath = 'data_layer/gold/security_incident_prediction_gold.csv'
if (Test-Path $csvPath) {
    $csvDest = "${containerName}:/tmp/security_incident_prediction_gold.csv"
    docker cp $csvPath $csvDest
    Write-Host "CSV copiado: $csvPath -> $csvDest"
} else {
    Write-Host "CSV não encontrado em: $csvPath" -ForegroundColor Yellow
}

# Executar DDLs
Write-Host "Executando DDL do star schema..."
docker exec -u postgres $containerName psql -U postgres -d microsoft-security -f /tmp/ddl_create_star_schema.sql
Write-Host "Executando DDL da staging..."
docker exec -u postgres $containerName psql -U postgres -d microsoft-security -f /tmp/staging_ddl.sql
Write-Host "Aplicando migrações DDL (se necessário)..."
docker exec -u postgres $containerName psql -U postgres -d microsoft-security -f /tmp/ddl_migrations.sql

# Carregar CSV para staging com COPY do servidor
Write-Host "Carregando CSV para stg_security_incident via COPY (server-side)..."
$copyCmd = "COPY stg_security_incident (timestamp, orgid, detectorid, alerttitle, category, mitretechniques, incidentgrade, entitytype, evidencerole, osfamily, osversion, lastverdict, countrycode, state, city) FROM '/tmp/security_incident_prediction_gold.csv' CSV HEADER;"
Write-Host "Removendo coluna 'raw_event_id' da staging se existir..."
docker exec -u postgres $containerName psql -U postgres -d microsoft-security -c "ALTER TABLE stg_security_incident DROP COLUMN IF EXISTS raw_event_id;"
docker exec -u postgres $containerName psql -U postgres -d microsoft-security -c "$copyCmd"

# Executar ETL
Write-Host "Executando script ETL (silver->gold)..."
docker exec -u postgres $containerName psql -U postgres -d microsoft-security -f /tmp/etl_silver_to_gold.sql

# Validações rápidas
Write-Host "Rodando verificações de integridade e contagens..."
$queries = @(
    "SELECT 'staging_total' as label, COUNT(*) FROM stg_security_incident WHERE timestamp IS NOT NULL AND orgid IS NOT NULL;",
    "SELECT 'fact_total' as label, COUNT(*) FROM f_incident;",
    "SELECT 'fact_null_fk' as label, COUNT(*) FROM f_incident WHERE time_key IS NULL OR org_key IS NULL;"
)

foreach ($q in $queries) {
    Write-Host "Query: $q"
    docker exec -u postgres $containerName psql -U postgres -d microsoft-security -c "$q"
}

Write-Host "Pipeline concluído. Acesse pgAdmin em http://localhost:8080 (user: admin@admin.com / admin) se desejar visualizar os dados." -ForegroundColor Green
