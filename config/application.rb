# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require "openid"
require "openid/extensions/sreg"
require "openid/extensions/pape"
require "openid/store/filesystem"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Chatfuel
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults "6.0"

    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.i18n.default_locale = :en
    config.i18n.fallbacks = [:en]
    config.i18n.available_locales = %w(en km)
    config.middleware.use I18n::JS::Middleware

    config.generators do |generate|
      generate.test_framework :rspec, fixtures: false, helper_specs: false, routing_specs: false
      generate.fixture_replacement :factory_bot
      generate.factory_bot dir: "spec/factories"
      generate.helper false
      generate.assets false
      generate.view_spec false
    end

    console do
      ActiveRecord::Base.connection
    end

    config.active_job.queue_adapter = :sidekiq
    config.filter_parameters << :password
    config.to_prepare do
      Devise::SessionsController.layout "devise"
    end

    config.time_zone = 'Bangkok'
    config.action_dispatch.rescue_responses["OmniauthCallbacksController::Forbidden"] = :forbidden

    # incompatible issue between wicked_pdf and view_component gems
    # https://github.com/github/view_component/issues/288
    # https://github.com/github/view_component/pull/358
    # 1. add this option
    config.view_component.render_monkey_patch_enabled = false
    # 2. views: change `render` to `render_component`

    # Rotate Logstasher's log for 3 files with 1Mb each
    config.logstasher.logger = Logger.new(Rails.root.join('log', "logstash_#{Rails.env}.log"), 3, 1.megabyte)
  end
end

Raven.configure do |config|
  config.dsn = ENV["SENTRY_DSN"]
  config.environments = ["staging", "production"]
end
