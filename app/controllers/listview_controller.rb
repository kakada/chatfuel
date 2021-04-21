class ListviewController < WelcomesController
  layout 'welcome'

  def index
  end

  def showcase
    respond_to do |format|
      format.html { render layout: false }
    end
  end
end
