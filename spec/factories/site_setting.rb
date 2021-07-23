FactoryBot.define do
  factory :site_setting do
    enable_notification  { true }
    message_template     {"Here is client's feedback {{feedback_message}}"}
    digest_message_template   {"Here is client's feedback {{feedback_count}}"}
    message_frequency    { 'immediately' }
    type { 'SiteFeedbackSetting' }
    site

    trait :do_report do
      type { 'SiteDoReportSetting' }
    end
  end
end
