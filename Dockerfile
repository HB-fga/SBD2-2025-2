# Imagem base que será usada para criar o container
FROM bitnami/spark:3.5.0

# Define o nome da imagem
WORKDIR /app

# Instalação das dependências do projeto
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia todo o conteúdo do diretório atual para o diretório /app no container
COPY . .

# Executa o comando que será executado no container
CMD ["sh", "jobETL/run.sh"]