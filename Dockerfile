# ---------------------------
# Builder Stage
# ---------------------------
FROM ruby:2.6-bullseye AS builder

# Install dependencies
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  nodejs npm \
  python2 \
  make \
  g++ \
  vim postgresql-client \
  && ln -s /usr/bin/python2 /usr/bin/python \
  && npm install -g yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Set environment for bundler
ENV RAILS_ENV=production \
    RACK_ENV=production \
    BUNDLE_WITHOUT=development:test \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# Copy gem/package definitions
COPY Gemfile* package.json yarn.lock ./

# Install gems
RUN gem install bundler -v 2.1.4 && \
    bundle install --jobs 20 --retry 5

# Copy the full app
COPY . .

# Precompile Rails assets (optional for API-only you can skip)
RUN bundle exec rails assets:precompile

# ---------------------------
# Production Stage
# ---------------------------
FROM ruby:2.6-bullseye

# Install runtime dependencies only
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  nodejs npm \
  libpq5 \
  && npm install -g yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Runtime environment
ENV RAILS_ENV=production \
    RACK_ENV=production \
    BUNDLE_PATH=/usr/local/bundle \
    GEM_HOME=/usr/local/bundle \
    GEM_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test \
    RAILS_LOG_TO_STDOUT=true

# Copy gems and app from builder
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

# Copy database config
COPY docker/database.yml /app/config/database.yml

# Symlink fonts
RUN if [ -d /app/vendor/assets/fonts ]; then \
      mkdir -p /usr/share/fonts && \
      cp -r /app/vendor/assets/fonts/* /usr/share/fonts/; \
    fi

# Expose port (optional, depending on how you run Rails)
EXPOSE 3000

# Set entrypoint
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
