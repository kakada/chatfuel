# frozen_string_literal: true

class SettingsController < PrivateAccessController
  before_action :authorize_setting

  def index
    @telegram_bot = TelegramBot.first || TelegramBot.new
  end

  def telegram_bot
    @telegram_bot = TelegramBot.find_or_initialize_by(id: telegram_bot_params[:id])

    if @telegram_bot.update(telegram_bot_params)
      flash[:notice] = I18n.t("settings.successful_update_bot")
    else
      flash[:alert] = @telegram_bot.errors.full_messages
    end

    redirect_to settings_path
  end

  def help; end

  private
    def authorize_setting
      authorize Setting
    end

    def telegram_bot_params
      params.require(:telegram_bot).permit(:id, :username, :token)
    end
end
