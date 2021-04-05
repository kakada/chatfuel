class UsersController < PrivateAccessController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @pagy, @users = pagy(User.filter(params).order(updated_at: :desc))
    authorize @users
    @roles = Role.distinct

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

    def user_params
      params.require(:user).permit(:role_id, :site_id, :email, :password, :password_confirmation, :avatar, :remove_avatar, :role_id, :actived)
    end
end
