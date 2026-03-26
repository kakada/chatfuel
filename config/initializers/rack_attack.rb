class Rack::Attack
  safelist('allow from localhost') do |req|
    %w(127.0.0.1 ::1).include? req.ip
  end

  # limit: 5, period: 60(seconds) = 5 reqs/minute
  throttle('req/ip', limit: ENV.fetch('RACK_ATTACK_LIMIT', 5).to_i, period: ENV.fetch('RACK_ATTACK_PERIOD_IN_SECONDS', 60 ).to_i) do |req|
    req.ip
  end

  throttled_response = lambda do |env|
    # Using 503 because it may make attacker think that they have successfully
    # DOSed the site. Rack::Attack returns 429 for throttling by default
    [ 503, {}, ['Internal Server Error']]
  end
end
