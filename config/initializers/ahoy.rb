class Ahoy::Store < Ahoy::DatabaseStore
end

Ahoy.visit_duration = Setting.visit_duration
# set to true for JavaScript tracking
Ahoy.api = false
