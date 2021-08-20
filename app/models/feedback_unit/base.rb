module FeedbackUnit
  class Base
    attr_reader :province_id, :district_id

    def initialize(province_id:, district_id:)
      @province_id = province_id
      @district_id = district_id
    end
  end
end
