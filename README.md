# INSS Discount Calculator

Este README documenta os passos necessários para configurar e iniciar o aplicativo de cálculo de descontos de INSS.

## Descrição

Este projeto é uma aplicação para calcular os descontos do INSS a partir de valores inseridos. Ele auxilia usuários a visualizarem e entenderem os valores deduzidos de seus salários como contribuição ao INSS.

A aplicação foi construída utilizando **Ruby 3.2.2** e **Rails 7.1.5**.

## Pré-requisitos

Certifique-se de que você tem as ferramentas necessárias instaladas:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

## Estrutura do Projeto

A estrutura do projeto segue práticas típicas de aplicações Rails com a integração de Docker para facilitar o gerenciamento dos ambientes de desenvolvimento e produção.

### Estrutura dos serviços

O ambiente do projeto é composto pelos seguintes serviços:

- **App**: O servidor principal da aplicação Rails.
- **Test**: Serviço dedicado à execução dos testes da aplicação.
- **Sidekiq**: Gerenciador de jobs em background.
- **Redis**: Cache e fila de mensagens para Sidekiq.
- **DB**: Banco de dados PostgreSQL.

## Configuração

### Instruções para configuração

1. **Versão do Ruby**: Certifique-se de ter o Docker instalado no seu sistema.

2. **Dependências do sistema**: Todas as dependências do sistema são gerenciadas pelo Docker.

3. **Criação do banco de dados**: Assegure-se de que as configurações do banco de dados estejam corretas e definidas em seus arquivos `docker-compose.yml`.

4. **Inicialização do banco de dados**: O banco de dados é inicializado automaticamente ao executar os comandos Docker listados abaixo.

## Como executar

Para construir as imagens Docker e iniciar os serviços necessários, execute o seguinte comando na linha de comando:

```bash
docker-compose up --build
```

## Executando Testes

Para executar os testes disponíveis, você pode rodar o seguinte comando:

```bash
docker-compose run test
```

Isso irá iniciar o ambiente de teste e executar o conjunto de testes.