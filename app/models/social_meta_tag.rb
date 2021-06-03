class SocialMetaTag
  def self.to_meta_tags
    {
      og: {
        title:    I18n.t('meta_tags.title'),
        type:     'website',
        url:      "#{ENV['ENDPOINT_URL']}#{I18n.locale}",
        image:    "#{ helper.image_url("fb-sample-share-photo.png", host: ENV['ENDPOINT_URL']) }",
        description: I18n.t('meta_tags.description'),
        site_name: 'InSTEDD iLab Southeast Asia'
      },
      twitter: {
        card: "summary",
        site: I18n.t('meta_tags.twitter.site'),
        title: I18n.t('meta_tags.title'),
        description: I18n.t('meta_tags.description'),
        creator: "InSTEDD iLab Southeast Asia",
        image: "#{ helper.image_url("fb-sample-share-photo.png", host: ENV['ENDPOINT_URL']) }",
      },
      site: I18n.t('meta_tags.site')
    }
  end

  private
    def self.helper
      ActionController::Base.helpers
    end
end
