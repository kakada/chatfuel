# https://stackoverflow.com/questions/3773605/how-can-i-make-cookies-secure-https-only-by-default-in-rails

Chatfuel::Application.config.session_store( 
  :cookie_store, 
  key: '_chatfuel_session',
  secure: Rails.env.production?
)
