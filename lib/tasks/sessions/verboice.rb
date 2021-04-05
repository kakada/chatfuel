require_relative 'platform'

module Sessions
  class Verboice < Platform
    def platform_name
      "Verboice"
    end

    def session_id
      FFaker::PhoneNumber.phone_number
    end
    
    def source_id
      rand(10 ** 6)
    end
  end
end
