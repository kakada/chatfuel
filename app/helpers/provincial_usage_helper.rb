module ProvincialUsageHelper
  def sortable_attributes
    {
      'visit': 'visits_count',
      'unique': 'unique_users_count',
      'delivered': 'service_delivered_count',
    }.with_indifferent_access
  end

  def sort_url_for(attr, dir)
    url_for(params.permit!.merge(sort_attr: attr, sort_dir: dir))
  end

  def active_sort(attr, dir)
    @sort_attr == attr && @sort_dir == dir ? 'sort__active' : ''
  end
end
