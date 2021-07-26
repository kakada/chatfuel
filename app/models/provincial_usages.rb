class ProvincialUsages
  def initialize(provincial_usages)
    @provincial_usages = provincial_usages
  end

  def sort_by_code dir = :asc
    @provincial_usages.sort do |a, b|
      dir == :asc ? a.code <=> b.code : b.code <=> a.code
    end
  end
end
