class QueryFilter
  def self.before(controller)
    controller.send(:set_daterange)
    controller.send(:t_gon)
    controller.send(:set_query)
    controller.send(:visitor_count)
    controller.send(:check_dirty_form)
    if controller.request.xhr?
      controller.send(:set_gon)
      controller.send(:set_active_tab_nav)
    end
  end
end
