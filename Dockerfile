# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

# Define o ambiente de desenvolvimento
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle"

# Instalar pacotes necessários para o sistema
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libvips \
    pkg-config \
    libpq-dev \
    postgresql-client \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    curl \
    ruby-dev && \
    rm -rf /var/lib/apt/lists/*

# Instalar o Bundler
RUN gem install bundler -v 2.5.14

# Copiar Gemfile e instalar gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copiar código da aplicação
COPY . .

# Pré-compilar o código bootsnap para inicialização rápida
RUN bundle exec bootsnap precompile app/ lib/

# Estágio final da aplicação
FROM ruby:$RUBY_VERSION-slim as app

WORKDIR /rails

# Define as variáveis de ambiente
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle" \
    PATH="/rails/bin:$PATH"

# Instalar apenas pacotes necessários para runtime
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    libpq-dev \
    libvips && \
    rm -rf /var/lib/apt/lists/*

# Copiar artefatos do estágio base
COPY --from=base /usr/local/bundle /usr/local/bundle
COPY --from=base /rails /rails

# Configurar permissões e criar usuário não-root
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails

# Expor portas
EXPOSE 3000 1234

# Comando padrão para iniciar o servidor Rails
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]