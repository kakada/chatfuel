class WelcomesController < PublicAccessController
  include Filterable
  before_action QueryFilter,  except: :filter
  before_action :visitor_count, :set_context, :check_dirty_form

  def index
    respond_to do |format|
      format.html { render layout: "welcome" }
      format.js
    end
  end

  def filter
    render json: { display_name: @location_filter.display_name, described_name: @location_filter.described_name }
  end

  def access_info
    render json: @query.access_info, status: :ok
  end

  def service_tracked
    render json: @query.most_tracked_periodic, status: :ok
  end

  def feedback_trend
    render json: @query.feedback_trend, status: :ok
  end

  private
    def set_active_tab_nav
      @active_tab = params[:q][:active_tab] if params[:q]
    end

    def set_query
      @query = DashboardQuery.new(filter_options)
    end

    def set_gon
      @gon_data = {}
      gon.push(@gon_data, true)
      @gon_data = gon.all_variables
    end

    def default_start_date
      Setting.dashboard_start_date.strftime(default_date_format)
    end

    def t_gon
      gon.push({
        all: I18n.t("all"),
        no_data: I18n.t("no_data"),
        locale: I18n.locale,
        cookiePolicyPath: cookie_policy_path,
        not_available: I18n.t(:not_available),
        most_tracked_label: I18n.t("welcomes.most_service_tracked_by_periodic"),
        most_requested_label: I18n.t("welcomes.most_requested_services"),
        start_date: @start_date,
        end_date: @end_date,
        params: params
      })
    end

    def visitor_count
      @fragment_count, @all_count = Ahoy::Visit.count_with_fragment(@start_date, @end_date)
    end

    def check_dirty_form
      @dirty = params[:dirty] == 'true' || helpers.embed
    end

    def set_context
      @context ||=  [ 
                      { dom: '#article', path: 'welcomes', template: 'article', action: 'replaceWith' },
                      { dom: '.switch-lang', path: 'welcomes', template: 'switch_lang', action: 'replaceWith' },
                      { dom: 'footer', path: 'welcomes', template: 'footer', action: 'replaceWith' },
                      { dom: '.sidebar-left', path: 'welcomes', template: 'sidebar', action: 'replaceWith' },
                      { dom: '#piloting-header', path: 'welcomes', template: 'header', action: 'replaceWith' },
                      { dom: '#form-query', path: 'welcomes', template: 'form', action: 'replaceWith' },
                      { dom: '.visitor-counter', path: 'shared/sidebar', template: 'visitor_count', action: 'replaceWith' },
      ]
    end
end