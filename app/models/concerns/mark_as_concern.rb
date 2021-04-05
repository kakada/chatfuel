# frozen_string_literal: rue

module MarkAsConcern
  extend ActiveSupport::Concern

  included do
    before_save :ensure_unique_mark_as, if: :mark_as_changed?
    before_save :ensure_unique_most_request, if: :is_most_request?
  end

  MARK_AS_LIST = %w(gender user_visit ticket_tracking service_accessed province district feedback_like feedback_dislike feedback_rating feedback_province feedback_district)
  WHITELIST_MARK_AS = [Variable::FEEDBACK, Variable::MOST_REQUEST] + MARK_AS_LIST

  define_method :feedback? do self.mark_as == Variable::FEEDBACK end
  define_method :mark_as_feedback! do update(mark_as: Variable::FEEDBACK) end
  define_method :most_request? do self.is_most_request == true end
  define_method :mark_as_most_request! do update(is_most_request: true) end

  MARK_AS_LIST.each do |item|
    define_method "#{item}?".to_sym do self.mark_as == item end
    define_method "mark_as_#{item}!".to_sym do update(mark_as: item) end
  end

  def reset_mark_as!
    update_attribute(:mark_as, nil)
  end

  module ClassMethods
    define_method :feedback do find_by(mark_as: Variable::FEEDBACK) end
    define_method :most_request do find_by(is_most_request: true) end

    MARK_AS_LIST.each do |item|
      define_method "#{item}".to_sym do find_by(mark_as: item) end
    end
  end
end
