module FeedbackUnit
  class District < Base
    def feedback_province_id
      feedback_district_id.to_s[0..1]
    end

    def feedback_district_id
      mapping_districts[district_id.to_sym]
    end

    private

    def mapping_districts
      { 
        'bavel': '0204',
        'komrieng': '0212',
        'krong battambong': '0203',
        'mong russei': '0206',
        'other': '0200',
        'tmor kol': '0202'
      }
    end
  end
end
