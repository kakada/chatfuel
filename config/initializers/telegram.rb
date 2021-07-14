Rails.application.config.telegram_updates_controller.session_store = :file_store, Rails.root.join("tmp", "session_store")

Telegram.bots_config = {
  default: nil,
  do_report: {
    token: ENV['TG_DO_REPORT_TOKEN'],
    username: ENV['TG_DO_REPORT_USERNAME']
  }
}
