# frozen_string_literal: true
# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, ENV["LOCAL_DOMAIN"].to_s, ENV["PRODUCTION_DOMAIN"].to_s
  policy.font_src    :self, ENV["LOCAL_DOMAIN"].to_s, ENV["PRODUCTION_DOMAIN"].to_s, "fonts.gstatic.com", :data
  policy.img_src     :self, ENV["LOCAL_DOMAIN"].to_s, ENV["PRODUCTION_DOMAIN"].to_s, "https://www.facebook.com", :data
  policy.script_src  :self, :unsafe_inline, ENV["LOCAL_DOMAIN"].to_s, ENV["PRODUCTION_DOMAIN"].to_s, "*.fontawesome.com", "https://www.google-analytics.com", "connect.facebook.net", "https://web.facebook.com", "https://www.facebook.com"
  policy.style_src   :self, :unsafe_inline, ENV["LOCAL_DOMAIN"].to_s, ENV["PRODUCTION_DOMAIN"].to_s, "*.fontawesome.com", "fonts.googleapis.com"
  policy.connect_src :self, :unsafe_inline, ENV["LOCAL_DOMAIN"].to_s, "https://web.facebook.com", "https://www.facebook.com", "https://www.google-analytics.com"
  policy.frame_src   :self, :unsafe_inline, ENV["LOCAL_DOMAIN"].to_s, "https://web.facebook.com", "https://www.facebook.com"
end
