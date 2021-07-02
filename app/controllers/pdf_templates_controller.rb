class PdfTemplatesController < ApplicationController
  def index
    @pagy, @pdf_templates = pagy(PdfTemplate.order(created_at: :desc))
  end

  def new
    @pdf_template = PdfTemplate.new
  end

  def show
    @pdf_template = PdfTemplate.find params[:id]
  end

  def create
    @pdf_template = PdfTemplate.new(pdf_template_params)
    if @pdf_template.save
      redirect_to @pdf_template
    else
      render :new
    end
  end

  def edit
    @pdf_template = PdfTemplate.find params[:id]
  end

  def update
    @pdf_template = PdfTemplate.find params[:id]
    if @pdf_template.update(pdf_template_params)
      redirect_to @pdf_template
    else
      render :edit
    end
  end

  def destroy
    @pdf_template = PdfTemplate.find params[:id]
    @pdf_template.destroy
    redirect_to action: :index
  end

  private

  def pdf_template_params
    params.require(:pdf_template).permit(:name, :content, :lang_code)
  end
end
