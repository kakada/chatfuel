class ReportsController < WelcomesController
  layout 'welcome'
  content_security_policy_report_only only: :index
end
