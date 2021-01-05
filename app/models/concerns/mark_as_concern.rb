# frozen_string_literal: rue

module MarkAsConcern
  extend ActiveSupport::Concern

  MARK_AS_FEEDBACK = Array.wrap(Variable::FEEDBACK)
  MARK_AS_MOST_REQUEST = Array.wrap(Variable::MOST_REQUEST)
  MARK_AS_LIST = %w(gender user_visit location ticket_tracking service_accessed)
  WHITELIST_MARK_AS = MARK_AS_FEEDBACK + MARK_AS_MOST_REQUEST + MARK_AS_LIST

  define_method :feedback? do self.mark_as == Variable::FEEDBACK end
  define_method :mark_as_feedback! do update(mark_as: Variable::FEEDBACK) end
  define_method :most_request? do self.is_most_request == true end
  define_method :mark_as_most_request! do update(is_most_request: true) end

  MARK_AS_LIST.each do |item|
    define_method "#{item}?".to_sym do self.mark_as == item end
    define_method "mark_as_#{item}!".to_sym do update(mark_as: item) end
  end

  module ClassMethods
    define_method :feedback do find_by(mark_as: Variable::FEEDBACK) end
    define_method :most_request do find_by(is_most_request: true) end

    MARK_AS_LIST.each do |item|
      define_method "#{item}".to_sym do find_by(mark_as: item) end
    end
  end
end
