module Sortable
  extend ActiveSupport::Concern

  included do
    before_action :set_sort
  end

  private

  def set_sort
    raise Exception.new('has to implement #set_sort')
  end
end
