Rails.application.config.telegram_updates_controller.session_store = :file_store, Rails.root.join("tmp", "session_store")

Telegram.bots_config = {
  default: nil,
  do_report: {
    token: ENV['TG_DO_REPORT_TOKEN'],
    username: ENV['TG_DO_REPORT_USERNAME'], # to support commands with mentions (/help@ChatBot)
    # server: 'https://860db6b208d2.ngrok.io/telegram'
    # Telegram.bots[:do_report].get_webhook_info
    # {"ok"=>true, "result"=>{"url"=>"https://860db6b208d2.ngrok.io/telegram/LcGzqVMO60Mr0kdmvUCXDTFBaIo", "has_custom_certificate"=>false, "pending_update_count"=>0, "last_error_date"=>1625641049, "last_error_message"=>"Wrong response from the webhook: 500 Internal Server Error", "max_connections"=>40, "ip_address"=>"3.22.30.40"}}
  }
}
