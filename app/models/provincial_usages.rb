class ProvincialUsages
  attr_accessor :provincial_usages

  def initialize(provincial_usages)
    @provincial_usages = provincial_usages
  end

  def sort attr, dir
    return default_sort unless attr.present?

    @provincial_usages.sort do |left, right|
      left, right = [right, left] if desc?(dir)
      left.send(attr.to_sym) <=> right.send(attr.to_sym)
    rescue NoMethodError => e
      raise Exception.new err_with_suggestion(e)
    end
  end

  private

  def err_with_suggestion e
    "Available sortable attributes: #{e.receiver.class.instance_methods(false)}"
  end

  def desc?(dir)
    dir.to_sym == :desc
  end

  def default_sort
    sort(ProvincialUsage::DEFAULT_SORT_ATTR, ProvincialUsage::DEFAULT_SORT_DIR)
  end
end
