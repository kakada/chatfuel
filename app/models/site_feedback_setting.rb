class SiteFeedbackSetting < SiteSetting
  validates :message_template, presence: true, if: -> { immediately? }
  validates :digest_message_template, presence: true, unless: -> { immediately? }

  enum message_frequency: {
    immediately: 1,
    daily: 2,
    weekly: 3
  }

  FEEDBACK_MESSAGE = "{{feedback_message}}"
  FEEDBACK_COUNT = "{{feedback_count}}"


  def message_variables
    [FEEDBACK_MESSAGE]
  end

  def digest_message_variables
    [FEEDBACK_COUNT]
  end

  def notification_message(value)
    message_template.gsub(/#{FEEDBACK_MESSAGE}/, "<b>#{value}</b>")
  end

  def notification_digest_message(value)
    digest_message_template.to_s.gsub(/#{FEEDBACK_COUNT}/, "<b>#{value}</b>")
  end

  def message_frequency=(value)
    value = value.to_i if value.is_a? String
    super(value)
  end

  def self.policy_class
    SiteSettingPolicy
  end
end
