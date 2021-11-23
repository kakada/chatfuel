class Ahoy::Store < Ahoy::DatabaseStore
end

Ahoy.visit_duration = Setting.visit_duration
# set to true for JavaScript tracking
Ahoy.api = false

# https://github.com/ankane/ahoy/issues/436
domains = Setting.ahoy_whitelist_cookie_domains
domains += [ ENV['LOCAL_DOMAIN'] ] if Rails.env.development?
Ahoy.cookie_options = {
  domain: domains,
  same_site: :lax,
  secure: true,
  httponly: true
}
