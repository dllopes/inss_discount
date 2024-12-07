# README

Este README documenta os passos necessários para configurar e iniciar o aplicativo de cálculo de descontos de INSS.

## Descrição

Este projeto é uma aplicação para calcular os descontos do INSS a partir de valores inseridos. Ele auxilia usuários a
visualizarem e entenderem os valores deduzidos de seus salários como contribuição ao INSS.

## Configuração

Este projeto depende do Docker e do Docker Compose para construir e executar os serviços necessários.

## Instruções para configuração

1. **Ruby version**: Certifique-se de ter o Docker instalado no seu sistema.

2. **System dependencies**: Todas as dependências do sistema são gerenciadas pelo Docker.

3. **Database creation**: Assegure-se de que as configurações do banco de dados estejam corretas e definidas em seus
   arquivos `docker-compose.yml`.

4. **Database initialization**: O banco de dados é inicializado automaticamente ao executar os comandos Docker listados
   abaixo.

## Como executar

Para construir as imagens Docker e iniciar os serviços necessários, execute o seguinte comando na linha de comando:

```bash
docker-compose up --build