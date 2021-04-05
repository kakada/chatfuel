require_relative 'messenger'
require_relative 'verboice'

module Sessions
  class Fake
    attr_reader :platform_name, :session_id, :source_id

    Provinces = {
      # Banteay Meanchey
      "01": %w(0102 0103 0104 0105 0106 0107 0108 0109 0110),
      # Kompong Chhnang
      "04": %w(0401 0402 0403 0404 0405 0406 0407 0408)
    }

    def initialize
      @platform_name, @session_id, @source_id = platform.random
    end

    def gender
      %w(male female other).sample
    end

    def repeated
      [true, false].sample
    end

    def province_id
      @province_id = Provinces.keys.sample
    end

    def district_id
      Provinces[@province_id].sample
    end

    def status
      %w(incomplete completed).sample
    end

    def most_request_raw_value
      most_request_raw_values.sample
    end

    def like_raw_value
      like_raw_values.sample
    end

    def dislike_raw_value
      dislike_raw_values.sample
    end

    def feedback_raw_value
      feedback_raw_values.sample
    end

    private
      def platform
        platform = %w(Sessions::Messenger Sessions::Verboice).sample
        platform.constantize.new
      end

      def most_request_raw_values
        Variable.most_request.values.map &:raw_value
      end

      def like_raw_values
        Variable.feedback_like.values.map &:raw_value
      end

      def dislike_raw_values
        Variable.feedback_dislike.values.map &:raw_value
      end

      def feedback_raw_values
        Variable.feedback.values.map &:raw_value
      end
  end
end