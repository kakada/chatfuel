# == Schema Information
#
# Table name: settings
#
#  id         :bigint(8)        not null, primary key
#  value      :text
#  var        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_settings_on_var  (var) UNIQUE
#
class Setting < RailsSettings::Base
  cache_prefix { "v1" }

  # Define your fields
  field :default_locale, default: "en", type: :string
  # field :confirmable_enable, default: "0", type: :boolean
  # field :admin_emails, default: "admin@rubyonrails.org", type: :array
  # field :omniauth_google_client_id, default: (ENV["OMNIAUTH_GOOGLE_CLIENT_ID"] || ""), type: :string, readonly: true
  # field :omniauth_google_client_secret, default: (ENV["OMNIAUTH_GOOGLE_CLIENT_SECRET"] || ""), type: :string, readonly: true

  ENABLED_OPTIONS = %w(1 enable enabled true on yes)
  def self.messenger_notification_enabled?
    return false if ENV['FB_NOTIFY_ENABLED'].nil?

    ENABLED_OPTIONS.include?(ENV['FB_NOTIFY_ENABLED'].downcase)
  end

  def self.telegram_enabled?
    return false if ENV['TELEGRAM_ENABLED'].nil?

    ENABLED_OPTIONS.include?(ENV['TELEGRAM_ENABLED'].downcase)
  end

  def self.max_download_size
    (ENV['MAX_CSV_DOWNLOAD_SIZE'] || 1000).to_i
  end

  def self.dashboard_start_date
    Date.parse(ENV['DASHBOARD_START_DATE'])
  rescue
    default_start_date
  end

  def self.homepage_start_date
    Date.parse(ENV['HOMEPAGE_START_DATE'])
  rescue
    default_start_date
  end

  def self.default_start_date
    7.days.ago
  end

  def self.fb_reachable_period
    (ENV["FB_REACHABLE_DAY"] || 1).to_i
  end

  def self.pilot_province_codes
    ENV["PILOT_PROVINCE_CODES"].to_s.split(",")
  end

  def self.visit_duration
    (ENV["VISIT_DURATION_MINUTE"].to_i || 30).minutes
  end
end
