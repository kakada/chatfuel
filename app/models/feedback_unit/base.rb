module FeedbackUnit
  class Base
    attr_reader :province_id, :district_id

    def initialize(**args)
      @province_id = args[:province_id]
      @district_id = args[:district_id]
    end
  end
end
