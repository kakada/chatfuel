require 'sidekiq'
require 'sidekiq-scheduler'

Sidekiq.configure_server do |config|
  config.on(:startup) do
    if Setting.enabled_telegram_do_report?
      Schedule.find_each do |schedule|
        schedule.set_schedule
      end
    end
  end
end
