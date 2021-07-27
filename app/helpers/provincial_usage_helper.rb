module ProvincialUsageHelper
  def sort_url_for(attr, dir)
    url_for(params.permit!.merge(sort_attr: attr, sort_dir: dir))
  end

  def active_sort(attr, dir)
    @sort_attr == attr && @sort_dir == dir ? 'sort__active' : ''
  end
end
