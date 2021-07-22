module TelegramBot::CoreApi
  def send_document pdf_path, chat_id, after_send:
    cmd = "curl -H \"Cache-Control: no-cache\" -F document=@\"#{pdf_path}\" https://api.telegram.org/bot#{token}/sendDocument?chat_id=#{chat_id}"
    system(cmd, exception: true)
    send(after_send, pdf_path) if after_send.present?
  end

  private

  def remove_file pdf_path
    `rm #{pdf_path}`
  end
end
