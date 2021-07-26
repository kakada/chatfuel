class ProvincialUsages
  def initialize(provincial_usages)
    @provincial_usages = provincial_usages
  end

  def sort attr, dir
    return default_sort unless attr.present?

    @provincial_usages.sort do |a, b|
      (dir.nil? or dir.to_sym == :asc) ? a.send(attr.to_sym).to_i <=> b.send(attr.to_sym).to_i : b.send(attr.to_sym).to_i <=> a.send(attr.to_sym).to_i
    end
  end

  private

  def default_sort
    sort(:unique_users_count, :desc)
  end
end
