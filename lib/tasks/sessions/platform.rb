module Sessions
  class Platform
    def random
      [platform_name, session_id, source_id]
    end
  end
end
