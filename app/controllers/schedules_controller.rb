class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:edit, :update, :destroy]

  def index
    @pagy, @schedules = pagy(Schedule.order(updated_at: :desc))
  end

  def new
    @schedule = Schedule.new
    @pdf_template = @schedule.build_pdf_template
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @pdf_template = @schedule.pdf_template
    if @schedule.save
      redirect_to schedules_path
    else
      render :new
    end
  end

  def edit
    @pdf_template = @schedule.pdf_template
  end

  def update
    if @schedule.update(schedule_params)
      redirect_to schedules_path
    else
      render :edit
    end
  end

  def destroy
    @schedule.destroy
    redirect_to schedules_path
  end

  private

  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(:name, :enabled, :day, :time, pdf_template_attributes: [:id, :name, :lang_code, :content, :_destroy])
  end
end
