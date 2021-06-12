class SocialMetaTag
  def self.to_meta_tags
    {
      og: {
        title:  I18n.t('meta_tags.title'),
        type: "website",
        url:  "#{ENV['ENDPOINT_URL']}#{I18n.locale}",
        image:  "#{ helper.image_url("fb-sample-share-photo.png", host: ENV['ENDPOINT_URL']) }",
        description: I18n.t('meta_tags.description'),
        site_name: I18n.t('meta_tags.site')
      },
      twitter: {
        card: "summary",
        site: I18n.t('meta_tags.twitter.site'),
        title: I18n.t('meta_tags.title'),
        description: I18n.t('meta_tags.description'),
        creator: I18n.t('meta_tags.site'),
        image: "#{ helper.image_url("fb-sample-share-photo.png", host: ENV['ENDPOINT_URL']) }",
      },
    }
  end

  private
    def self.helper
      ActionController::Base.helpers
    end
end
