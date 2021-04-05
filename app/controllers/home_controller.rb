class HomeController < PrivateAccessController
  include Filterable
  
  before_action :default_start_date
  before_action :set_daterange
  before_action :set_gon

  def index
    authorize Session
    collection = Session.filter(filter_options).reorder(last_interaction_at: :desc)

    if current_user.system_admin?
      @variables = Variable.all
      @collection = collection.includes(:step_values)
    else
      @variables = current_user.role.variables
      @collection = collection.where(id: StepValue.select('session_id').where('variable_id in (?)', @variables.ids)).includes(:step_values)
    end

    @pagy, @sessions = pagy(@collection)
    respond_to do |format|
      format.html
      format.csv do
        if @collection.count < Setting.max_download_size
          send_data Session.to_csv(@collection, @variables), filename: "sessions-#{Date.current.strftime}.csv", type: 'text/csv'
        else
          redirect_to root_path, alert: I18n.t("max_download_size")
        end
      end
    end
  end

  def set_gon
    gon.push({
      locale: I18n.locale,
      start_date: @start_date,
      end_date: @end_date
    })
  end

  private

    def default_start_date
      Setting.homepage_start_date.strftime('%Y/%m/%d')
    end
end
