<#
Script: generate_pdfs.ps1
Descrição: converte arquivos Markdown (.md) do diretório `docs/` para PDFs
e salva os PDFs em `data_layer/gold/`.
Requisitos: pandoc instalado + um engine PDF (MiKTeX, TeX Live, ou usar --pdf-engine wkhtmltopdf).
#>

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
$docsDir = Join-Path $repoRoot 'docs'
$targetDir = Join-Path $repoRoot 'data_layer\gold'

# Cria target se não existir
if (-not (Test-Path $targetDir)) {
    Write-Host "Criando diretório: $targetDir"
    New-Item -ItemType Directory -Path $targetDir | Out-Null
}

# Verifica se pandoc está disponível
try {
    $pandoc = Get-Command pandoc -ErrorAction Stop
} catch {
    Write-Host "pandoc não encontrado. Instale pandoc e um engine LaTeX (MiKTeX/TeXLive) ou wkhtmltopdf para produção de PDF." -ForegroundColor Yellow
    Write-Host "Sugestão de instalação (PowerShell como Administrador):`n  choco install pandoc -y; choco install miktex -y" -ForegroundColor Gray
    exit 1
}

# Lista os arquivos Markdown a converter (pode ajustar conforme necessário)
$filesToConvert = @(
    @{src = Join-Path $docsDir 'modeling\MER_DER_DLD.md'; out = Join-Path $targetDir 'mer-der-dld.pdf'},
    @{src = Join-Path $docsDir 'mnemonicos.md'; out = Join-Path $targetDir 'mnemonicos.pdf'},
    @{src = Join-Path $repoRoot 'sql\queries_and_analysis.md'; out = Join-Path $targetDir 'consultas.pdf'}
)

# Convertendo
foreach ($f in $filesToConvert) {
    if (Test-Path $f.src) {
        Write-Host "Convertendo $($f.src) -> $($f.out)"
        # Usa pdflatex como engine padrão; se não houver, o pandoc pedirá o engine
        & pandoc $f.src -o $f.out --pdf-engine=pdflatex
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Erro ao converter $($f.src). Código: $LASTEXITCODE" -ForegroundColor Red
        } else {
            Write-Host "Gerado: $($f.out)" -ForegroundColor Green
        }
    } else {
        Write-Host "Arquivo fonte inexistente: $($f.src)" -ForegroundColor Yellow
    }
}

Write-Host "Conversão finalizada. PDFs salvos em: $targetDir"
