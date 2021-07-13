class DoReportNotificationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # broadcast pdf
    SiteSetting.find_each do |setting|
      setting.telegram_chat_groups.each do |group|
        puts "******** DO report notification for #{setting.site.code} at [#{DateTime.current}] **********"
        client = Telegram.bots[:do_report]
        client.send_message(chat_id: group.chat_id, text: "DO report for #{setting.site.code}")
      end
    end
  end
end
