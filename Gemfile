# frozen_string_literal: true

source "https://rubygems.org"
ruby "2.6.5"

gem "rails", "~> 6.0.1"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 4.3"
gem "sass-rails", ">= 6"
gem "webpacker", "~> 4.0"
gem "turbolinks", "~> 5"
gem "jbuilder", "~> 2.7"
gem "alto_guisso", github: "instedd/alto_guisso", branch: "master"
gem "alto_guisso_rails", github: "instedd/alto_guisso_rails", branch: "rails-5.1"
gem "bootsnap", ">= 1.4.2", require: false
gem "devise", "~> 4.7.1"
gem "jquery-rails", "~> 4.3.5"
gem "verboice", "~> 0.7.0"
gem "pagy", "~> 3.5"
gem "haml", "~> 5.1.2"
gem "haml-rails", "~> 2.0"
gem "font-awesome-rails", "~> 4.7.0.5"
gem "simple_form", "~> 5.0.2"
gem "sidekiq", "6.0.5"
gem "dotenv-rails", "~> 2.7.5"
gem "chartkick", "~> 3.3.1"
gem "groupdate", "~> 5.0.0"
gem "momentjs-rails", "~> 2.20.1"
gem "pundit", "~> 1.1.0"
gem "active_storage_validations", "~> 0.8.7"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "i18n-js", "~> 3.5.1"
gem "liquid", "~> 4.0", ">= 4.0.3"
gem "tilt", "~> 2.0", ">= 2.0.10"
gem "sentry-raven", "~> 3.0"

gem "active_storage_validations", "~> 0.8.7"

gem "telegram-bot", "~> 0.14.3"
gem "sidekiq-scheduler", "~> 3.0.1"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails", "~> 4.0.0.rc1"
  gem "ffaker", "~> 2.13.0"
  gem "coderay", "~> 1.1", ">= 1.1.2"
  gem "rubocop-rails", "~> 2.4.2"
  gem "rubocop-performance", "~> 1.5.2"
  gem "guard-rspec", require: false
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "web-console", ">= 3.3.0"
  gem "spring", "~> 2.1.0"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "annotate", "~> 3.1.0"
  gem "solargraph", "~> 0.38.5"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "shoulda-matchers", "~> 4.3.0"
  gem "factory_bot_rails", "~> 5.1.1"
  gem "database_cleaner-active_record", "~> 1.8.0"
  gem "rails-controller-testing", "~> 1.0.4"
  gem "selenium-webdriver", "~> 3.142.7"
  gem "webdrivers", "~> 4.2.0"
  gem "rspec-sidekiq", "~> 3.0.3"
  gem "pundit-matchers", "~> 1.6.0"
end
