Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins   '*'
    resource  '*',
              headers: :any,
              methods: [:get, :options],
              expose: ['Access-Control-Allow-Origin']
  end

  allow do
    origins   '*'
    resource  '/api/*',
              headers: :any,
              methods: [:get, :post, :patch, :put, :head],
              if: proc { |env| env['BASE_URL'].match?(/ow4c\.ilabsea\.orgs/) }
  end
end
