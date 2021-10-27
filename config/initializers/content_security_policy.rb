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
end
