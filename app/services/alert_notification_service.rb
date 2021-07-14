# frozen_string_literal: true

class AlertNotificationService
  CHANNEL_NAMES = ["Notification::Telegram"]

  def initialize(setting_id = nil, message = nil)
    @setting_id = setting_id
    @message = message
  end

  def notify_immediately
    setting = SiteFeedbackSetting.find_by(id: @setting_id, message_frequency: SiteFeedbackSetting.message_frequencies[:immediately])
    return if setting.nil? || !setting.enable_notification?

    send_message(setting, @message)
  end

  def send_daily_notification
    SiteFeedbackSetting.daily.enable_notification.each do |setting|
      site = setting.site
      feedbacks = StepValue.joins(variable_value: :variable).where(variables: { mark_as: Variable::FEEDBACK }).where(site_id: site.id).where("DATE(step_values.created_at) = ?", Date.today - 1)

      next if feedbacks.size.zero?

      message = setting.notification_digest_message(feedbacks.size)
      send_message(setting, message)
    end
  end

  def send_weekly_notification
    SiteFeedbackSetting.weekly.enable_notification.each do |setting|
      site = setting.site
      feedbacks = StepValue.joins(variable_value: :variable).where(variables: { mark_as: Variable::FEEDBACK }).where(site_id: site.id).where("DATE(step_values.created_at) >= ?", 1.week.ago)

      next if feedbacks.size.zero?

      message = setting.notification_digest_message(feedbacks.size)
      send_message(setting, message)
    end
  end

  private
    def channel_factory(channel_name)
      channel_name.constantize.new
    end

    def send_message(setting, message)
      CHANNEL_NAMES.each do |channel_name|
        channel_factory(channel_name).notify_now(setting.id, message)
      end
    end
end
