class SocialMetaTag
  def self.to_meta_tags
    {
      og: {
        title:    'ទិន្នន័យការិយាល័យច្រកចេញចូលតែមួយ',
        type:     'website',
        url:      ENV['ENDPOINT_URL'],
        image:    "#{ helper.image_url("fb-sample-share-photo.png", host: ENV['ENDPOINT_URL']) }",
        description: 'ដោយមានការអញ្ជើញចូលរួម ដោយលោក បួន ហេង ប្រធាននាយកដ្ឋានមុខងារ និងធនធាន នៃអគ្គនាយកដ្ឋានរដ្ឋបាលក្រសួងមហាផ្ទៃ និងលោក សុខ ថុល នាយករដ្ឋបាលសាលាខេត្តសៀមរាប។វគ្គបណ្តុះបណ្តាលនេះ មានរយៈពេលពេញមួយថ្ងៃ ដោយមានការចួលរួមពីអស់លោក លោកស្រី ប្រធាន អនុប្រធានអង្គ',
        site_name: 'InSTEDD iLab Southeast Asia'
      },
      twitter: {
        card: "summary",
        site: "OW4C Public dashboard",
        title: "ទិន្នន័យការិយាល័យច្រកចេញចូលតែមួយ",
        description: 'ដោយមានការអញ្ជើញចូលរួម ដោយលោក បួន ហេង ប្រធាននាយកដ្ឋានមុខងារ និងធនធាន នៃអគ្គនាយកដ្ឋានរដ្ឋបាលក្រសួងមហាផ្ទៃ និងលោក សុខ ថុល នាយករដ្ឋបាលសាលាខេត្តសៀមរាប។វគ្គបណ្តុះបណ្តាលនេះ មានរយៈពេលពេញមួយថ្ងៃ ដោយមានការចួលរួមពីអស់លោក លោកស្រី ប្រធាន អនុប្រធានអង្គ',
        creator: "InSTEDD iLab Southeast Asia",
        image: "#{ helper.image_url("fb-sample-share-photo.png", host: ENV['ENDPOINT_URL']) }",
      },
      site: 'Welcome to OW4C InSTEDD iLab Southeast Asia'
    }
  end

  private
    def self.helper
      ActionController::Base.helpers
    end
end
