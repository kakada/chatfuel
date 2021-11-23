class Rack::Attack
  # limit: 5, period: 60(seconds) = 5 reqs/minute
  throttle('req/ip', limit: ENV['RACK_ATTACK_LIMIT'].to_i, period: ENV['RACK_ATTACK_PERIOD_IN_SECONDS'].to_i) do |req|
    req.ip
  end
end
