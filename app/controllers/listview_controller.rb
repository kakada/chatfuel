class ListviewController < WelcomesController
  layout 'welcome'

  def index
  end

  def developer
    respond_to do |format|
      format.html { render layout: false }
    end
  end
end
