# frozen_string_literal: true
# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, "localhost", "ilabsea.org"
  policy.font_src    :self, "localhost", "ilabsea.org", "fonts.gstatic.com", :data
  policy.img_src     :self, "localhost", "ilabsea.org", "www.facebook.com", :data
  policy.script_src  :self, :unsafe_inline, "*.fontawesome.com", "ilabsea.org", "https://dashboard.ow4c.info", "https://www.google-analytics.com", "connect.facebook.net", "https://web.facebook.com", "https://www.facebook.com", "localhost"
  policy.style_src   :self, :unsafe_inline, "*.fontawesome.com", "fonts.googleapis.com", "ilabsea.org", "https://dashboard.ow4c.info", 'localhost'
  policy.connect_src :self, :unsafe_inline, "localhost", "https://web.facebook.com", "https://www.facebook.com", "https://www.google-analytics.com"
  policy.frame_src   :self, :unsafe_inline, "localhost", "https://web.facebook.com", "https://www.facebook.com"
  # policy.object_src  :none
  # If you are using webpack-dev-server then specify webpack-dev-server host
  # policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035" if Rails.env.development?

  # Specify URI for violation reports
  # policy.report_uri "/csp-violation-report-endpoint"
end

# If you are using UJS then enable automatic nonce generation
# Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }

# Set the nonce only to specific directives
# Rails.application.config.content_security_policy_nonce_directives = %w(script-src)

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
