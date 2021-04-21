class QueryFilter
  def self.before(controller)
    controller.send(:set_daterange)
    if controller.request.xhr?
      controller.send(:set_query)
      controller.send(:set_gon)
      controller.send(:set_active_tab_nav)
    end
  end
end
