class SummaryComponent < ViewComponent::Base
  with_content_areas :fa_icon, :title, :desc, :config

  def initialize(style: , count:, css_class_name: '')
    @style = style
    @count = count
    @css_class_name = css_class_name
  end
end
