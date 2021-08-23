module FeedbackUnit
  class District < Base
    def feedback_province_id
      feedback_district_id.to_s[0..1]
    end

    delegate :id, to: :district, allow_nil: true, prefix: 'feedback_district'

    private

    def district
      Pumi::District.where(attribute => district_id).first
    end

    def attribute
      district_id.match?(/^\d+$/) ? 'id' : 'name_en'
    end
  end
end
