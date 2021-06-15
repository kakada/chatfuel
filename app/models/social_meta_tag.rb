class SocialMetaTag
  def self.to_meta_tags
    {
      og: {
        title:  I18n.t('meta_tags.title').html_safe,
        type: "website",
        url:  "#{ENV['ENDPOINT_URL']}#{I18n.locale}",
        image:  "#{ helper.image_url("fb-sample-share-photo.png", host: ENV['ENDPOINT_URL']) }",
        description: I18n.t('meta_tags.description').html_safe,
        site_name: I18n.t('meta_tags.site').html_safe
      },
      twitter: {
        card: "summary",
        site: I18n.t('meta_tags.twitter.site').html_safe,
        title: I18n.t('meta_tags.title').html_safe,
        description: I18n.t('meta_tags.description').html_safe,
        creator: I18n.t('meta_tags.site').html_safe,
        image: "#{ helper.image_url("fb-sample-share-photo.png", host: ENV['ENDPOINT_URL']) }",
      },
    }
  end

  private
    def self.helper
      ActionController::Base.helpers
    end
end
