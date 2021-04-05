class TemplatesController < PrivateAccessController
  before_action :set_template, only: [:edit, :update, :destroy]

  def index
    @templates = Template.order(type: :asc).includes(audio_attachment: :blob, image_attachment: :blob)

    authorize @templates
  end

  def new
    @template = Template.new

    authorize @template
  end

  def edit
  end

  def update
    respond_to do |format|
      if @template.update(template_params)
        @template.image.purge if params[:purge_image].present?

        format.js { redirect_to templates_path, notice: t("templates.updated_success") }
      else
        format.js
      end
    end
  end

  def create
    @template = Template.new(template_params)

    respond_to do |format|
      if @template.save
        format.js { redirect_to templates_path, notice: t("templates.created_success") }
      else
        format.js
      end
    end
  end

  def destroy
    @template.destroy

    redirect_to templates_path, status: :moved_permanently, notice: t("templates.destroy_success")
  end

  private
    def set_template
      @template ||= Template.find(params[:id])
      authorize(@template) && @template
    end

    def template_params
      params.require(:template).permit(:content, :type, :audio, :image, :status)
    end
end
