class LocationModalComponent < ViewComponent::Base
  with_content_areas :select_input

  def initialize(component:)
    @component = component
  end
end
