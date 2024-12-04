# Use uma imagem base do Ruby
FROM ruby:3.2.2-slim

# Instale dependências do sistema
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
  build-essential \
  libpq-dev \
  nodejs \
  && rm -rf /var/lib/apt/lists/*

# Definir o diretório de trabalho no contêiner
WORKDIR /app

# Copiar arquivos do projeto para o contêiner
COPY Gemfile Gemfile.lock ./

# Instalar gems
RUN gem install bundler && bundle install

# Copiar o restante do código para o contêiner
COPY . .

# Expõe a porta para acessar o Rails
EXPOSE 3000

# Comando para iniciar o servidor Rails
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]