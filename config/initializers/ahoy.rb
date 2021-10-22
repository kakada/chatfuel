class Ahoy::Store < Ahoy::DatabaseStore
end

Ahoy.visit_duration = Setting.visit_duration
# set to true for JavaScript tracking
Ahoy.api = false

# https://github.com/ankane/ahoy/issues/436
Ahoy.cookie_options = {domain: ENV['BASE_URL'], secure: true, httponly: true }
