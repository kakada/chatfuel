class SitesController < PrivateAccessController
  before_action :ensure_file_exits, only: [:import]
  before_action :set_site, only: [:show, :edit, :update, :destroy]

  def index
    authorize Site

    @pagy, @provinces = pagy_array(SiteService.new(params).provinces)
  end

  def new
    @site = Site.new(status: :enable)

    authorize @site
  end

  def edit
    authorize @site
  end

  def show
    authorize @site

    @pagy, @tracks = pagy(Track.filter(params).where(site_id: @site.id))
  end

  def create
    @site = Site.new(site_params)
    authorize @site

    respond_to do |format|
      if @site.save
        format.js { redirect_to @site, notice: t("created.success") }
      else
        format.js
      end
    end
  end

  def import
    tempfile = file_params[:file]
    ::SiteService.import(tempfile.path)
    redirect_to sites_path, status: :moved_permanently, notice: t("imported.success")
  rescue
    redirect_to sites_path, status: :moved_permanently, alert: t("imported.fail")
  end

  def update
    authorize @site

    respond_to do |format|
      if @site.update(site_params)
        format.js { redirect_to @site, notice: t("updated.success") }
      else
        format.js
      end
    end
  end

  def destroy
    authorize @site
    @site.destroy
    redirect_to sites_path, status: :moved_permanently, notice: t("deleted.success")
  end

  def download
    csv = Rails.root.join("db", "seed", "assets", "site.csv")
    send_file csv, filename: "sample.csv", disposition: "attachment", type: "text/csv"
  end

  private
    def set_site
      @site ||= Site.find(params[:id])
    end

    def ensure_file_exits
      begin
        file_params
      rescue
        redirect_to(sites_path, status: :moved_permanently, alert: t("required.file")) && return
      end
    end

    def file_params
      params.require(:site).permit(:file)
    end

    def site_params
      params.require(:site).permit(:name_en, :name_km, :code, :lat, :lng).merge(status: params[:site][:status].to_i)
    end
end
