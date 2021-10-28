# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = ENV["BASE_URL"]

SitemapGenerator::Sitemap.create do
  add cookie_policy_path, priority: 0.5, changefreq: "monthly"
  add privacy_policy_path, priority: 0.5, changefreq: "monthly"
  add reports_path, priority: 0.8, changefreq: "daily"
end
