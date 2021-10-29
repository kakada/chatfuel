class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :set_roles, only: [:index, :new, :create]

  def index
    @pagy, @users = pagy(User.filter(params).order(updated_at: :desc))
    authorize @users

    respond_to do |format|
      format.html
      format.json { render json: policy(User).roles }
    end
  end

  def show
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user
    if @user.save
      redirect_to users_path, notice: t("created.success")
    else
      render :new, status: :unprocessable_entity, alert: t("created.fail")
    end
  end

  def update
    authorize @user

    if @user.update(user_params)
      flash[:notice] = t("updated.success")
    else
      flash[:alert] = t("updated.fail")
    end

    redirect_to users_url
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to users_path, status: :moved_permanently, notice: t("deleted.success")
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def set_roles
      @roles = Role.distinct
    end

    def user_params
      params.require(:user).permit(:role_id, :email, :actived, :avatar, :remove_avatar)
    end
end
