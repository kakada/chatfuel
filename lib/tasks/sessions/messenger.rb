require_relative 'platform'

module Sessions
  class Messenger < Platform
    def platform_name
      "Messenger"
    end

    def session_id
      rand(10 ** 16)
    end

    def source_id
      session_id
    end
  end
end
