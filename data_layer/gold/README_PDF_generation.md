# Geração de PDFs a partir dos arquivos Markdown

Este arquivo descreve como gerar PDFs reais (binários) a partir dos arquivos Markdown presentes em `docs/` e `sql/`.

Pré-requisitos (Windows):
- Pandoc (https://pandoc.org/)
- Um engine de PDF:
  - MiKTeX (https://miktex.org/) ou TeX Live — recomendado para saída PDF via LaTeX
  - Alternativa: wkhtmltopdf e usar `--pdf-engine=wkhtmltopdf` com pandoc
- Opcional: Chocolatey para instalação rápida

Instalação (PowerShell como Administrador) — exemplo com Chocolatey:

```powershell
choco install pandoc -y; choco install miktex -y
```

Usando o script fornecido:

1. Abra PowerShell na raiz do repositório (`C:\Users\igort\OneDrive\Área de Trabalho\SBD\SBD2-2025-2`).
2. Execute:

```powershell
\.\scripts\generate_pdfs.ps1
```

O script tentará converter os seguintes arquivos e colocá-los em `data_layer/gold/`:
- `docs/modeling/MER_DER_DLD.md` -> `data_layer/gold/mer-der-dld.pdf`
- `docs/mnemonicos.md` -> `data_layer/gold/mnemonicos.pdf`
- `sql/queries_and_analysis.md` -> `data_layer/gold/consultas.pdf`

Se preferir usar outro engine de PDF (por exemplo, `wkhtmltopdf`), abra o `scripts/generate_pdfs.ps1` e substitua `--pdf-engine=pdflatex` por `--pdf-engine=wkhtmltopdf`.

Observações:
- Se o pandoc reclamar sobre falta de pacote LaTeX ao gerar o PDF, instale os componentes LaTeX (MiKTeX/TeX Live) e reexecute.
- O script é idempotente: sobrescreve os PDFs se já existirem.
